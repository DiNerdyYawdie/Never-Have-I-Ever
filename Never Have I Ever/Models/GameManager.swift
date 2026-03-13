//
//  GameManager.swift
//  Never Have I Ever
//
//  Created by Claude Code on 3/11/26.
//

import Foundation
import SwiftUI
import Combine

/// Manages the game state and flow
class GameManager: ObservableObject {
    @Published var availableStatements: [Statement] = []
    @Published var usedStatements: [Statement] = []
    @Published var customStatements: [Statement] = []
    @Published var currentStatement: Statement?
    @Published var selectedCategories: Set<Statement.Category> = Set(Statement.Category.allCases.filter { $0 != .custom && $0 != .spicy })
    @Published var isGameActive: Bool = false
    @Published var useCustomOnly: Bool = false
    @Published var totalStatementsPlayed: Int = 0
    @Published var gamesCompleted: Int = 0
    @Published var categoriesPlayed: Set<Statement.Category> = []
    
    let soundManager = SoundManager.shared
    let storeManager = StoreManager.shared
    weak var achievementManager: AchievementManager?
    
    // Free tier limit for custom statements
    private let freeCustomStatementsLimit = 5
    
    init() {
        loadCustomStatements()
        loadStats()
        loadCategoryPreferences()
    }
    
    /// Load all available statements from database and custom ones
    func loadStatements() {
        if useCustomOnly {
            // Use only custom statements (ignore category filter)
            availableStatements = customStatements.shuffled()
        } else {
            let preloaded = StatementsDatabase.preloadedStatements
            let custom = customStatements
            
            // Combine all statements and filter by selected categories
            let allStatements = preloaded + custom
            let filteredStatements = allStatements.filter { statement in
                selectedCategories.contains(statement.category)
            }
            
            availableStatements = filteredStatements.shuffled()
        }
    }
    
    /// Start a new game
    func startGame() {
        usedStatements.removeAll()
        availableStatements.removeAll()
        currentStatement = nil
        loadStatements()
        isGameActive = true
        nextStatement()
    }
    
    /// Get the next statement
    func nextStatement() {
        if availableStatements.isEmpty {
            // If we've used all statements, reload them
            loadStatements()
            if availableStatements.isEmpty {
                currentStatement = nil
                return
            }
        }
        
        currentStatement = availableStatements.removeFirst()
        if let current = currentStatement {
            usedStatements.append(current)
            categoriesPlayed.insert(current.category)
            totalStatementsPlayed += 1
            
            // Track achievements
            achievementManager?.incrementProgress(for: "gameplay_10_statements")
            achievementManager?.incrementProgress(for: "gameplay_50_statements")
            achievementManager?.incrementProgress(for: "gameplay_100_statements")
            achievementManager?.incrementProgress(for: "gameplay_marathon")
            achievementManager?.incrementProgress(for: "gameplay_legend")
            
            // Update categories achievement
            achievementManager?.updateProgress(for: "gameplay_all_categories", progress: categoriesPlayed.count)
            
            // Check for night owl / early bird
            let hour = Calendar.current.component(.hour, from: Date())
            if hour >= 0 && hour < 6 {
                achievementManager?.unlockAchievement("special_early_bird")
            } else if hour == 0 {
                achievementManager?.unlockAchievement("special_night_owl")
            }
            
            saveStats()
        }
    }
    
    /// Add a custom statement
    func addCustomStatement(text: String) {
        let statement = Statement(text: text, category: .custom, isCustom: true)
        customStatements.append(statement)
        saveCustomStatements()
        
        // Track achievements
        achievementManager?.updateProgress(for: "custom_first", progress: customStatements.count)
        achievementManager?.updateProgress(for: "custom_10", progress: customStatements.count)
        achievementManager?.updateProgress(for: "custom_50", progress: customStatements.count)
    }
    
    /// Check if user can add more custom statements
    func canAddCustomStatement() -> Bool {
        if storeManager.hasFullAccess {
            return true
        }
        return customStatements.count < freeCustomStatementsLimit
    }
    
    /// Get remaining custom statements for free users
    func remainingCustomStatements() -> Int {
        if storeManager.hasFullAccess {
            return Int.max
        }
        return max(0, freeCustomStatementsLimit - customStatements.count)
    }
    
    /// Check if Spicy category is unlocked
    func isSpicyCategoryUnlocked() -> Bool {
        return storeManager.hasFullAccess
    }
    
    /// Remove a custom statement
    func removeCustomStatement(_ statement: Statement) {
        customStatements.removeAll { $0.id == statement.id }
        saveCustomStatements()
    }
    
    /// Toggle category selection
    func toggleCategory(_ category: Statement.Category) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
        saveCategoryPreferences()
    }
    
    /// End the current game
    func endGame() {
        isGameActive = false
        currentStatement = nil
    }
    
    // MARK: - Persistence
    
    private func saveCustomStatements() {
        if let encoded = try? JSONEncoder().encode(customStatements) {
            UserDefaults.standard.set(encoded, forKey: "customStatements")
        }
    }
    
    private func loadCustomStatements() {
        if let data = UserDefaults.standard.data(forKey: "customStatements"),
           let decoded = try? JSONDecoder().decode([Statement].self, from: data) {
            customStatements = decoded
        }
    }
    
    private func saveStats() {
        UserDefaults.standard.set(totalStatementsPlayed, forKey: "totalStatementsPlayed")
        UserDefaults.standard.set(gamesCompleted, forKey: "gamesCompleted")
        if let encoded = try? JSONEncoder().encode(categoriesPlayed) {
            UserDefaults.standard.set(encoded, forKey: "categoriesPlayed")
        }
    }
    
    private func loadStats() {
        totalStatementsPlayed = UserDefaults.standard.integer(forKey: "totalStatementsPlayed")
        gamesCompleted = UserDefaults.standard.integer(forKey: "gamesCompleted")
        if let data = UserDefaults.standard.data(forKey: "categoriesPlayed"),
           let decoded = try? JSONDecoder().decode(Set<Statement.Category>.self, from: data) {
            categoriesPlayed = decoded
        }
    }
    
    private func saveCategoryPreferences() {
        if let encoded = try? JSONEncoder().encode(selectedCategories) {
            UserDefaults.standard.set(encoded, forKey: "selectedCategories")
        }
        UserDefaults.standard.set(useCustomOnly, forKey: "useCustomOnly")
    }
    
    private func loadCategoryPreferences() {
        if let data = UserDefaults.standard.data(forKey: "selectedCategories"),
           let decoded = try? JSONDecoder().decode(Set<Statement.Category>.self, from: data) {
            selectedCategories = decoded
        }
        useCustomOnly = UserDefaults.standard.bool(forKey: "useCustomOnly")
    }
}
