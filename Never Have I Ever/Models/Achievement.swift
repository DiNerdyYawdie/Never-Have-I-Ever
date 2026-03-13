//
//  Achievement.swift
//  Never Have I Ever
//
//  Created by Claude Code on 3/11/26.
//

import Foundation
import SwiftUI
import Combine

/// Represents an achievement that can be unlocked
struct Achievement: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let description: String
    let iconName: String
    let requirement: Int
    var isUnlocked: Bool = false
    var progress: Int = 0
    var unlockedDate: Date?
    
    var progressPercentage: Double {
        guard requirement > 0 else { return 0 }
        return Double(progress) / Double(requirement)
    }
    
    var iconColor: Color {
        switch category {
        case .gameplay: return .blue
        case .custom: return .orange
        case .social: return .green
        case .special: return .purple
        }
    }
    
    var category: AchievementCategory {
        AchievementCategory(rawValue: id.components(separatedBy: "_").first ?? "gameplay") ?? .gameplay
    }
    
    enum AchievementCategory: String, Codable {
        case gameplay
        case custom
        case social
        case special
    }
}

/// Manages achievements and progress
class AchievementManager: ObservableObject {
    @Published var achievements: [Achievement] = []
    @Published var newlyUnlockedAchievements: [Achievement] = []
    
    private let userDefaultsKey = "unlockedAchievements"
    
    init() {
        setupAchievements()
        loadProgress()
    }
    
    private func setupAchievements() {
        achievements = [
            // Gameplay Achievements
            Achievement(
                id: "gameplay_first_game",
                title: "First Steps",
                description: "Complete your first game",
                iconName: "flag.fill",
                requirement: 1
            ),
            Achievement(
                id: "gameplay_10_statements",
                title: "Getting Started",
                description: "Play 10 statements",
                iconName: "10.circle.fill",
                requirement: 10
            ),
            Achievement(
                id: "gameplay_50_statements",
                title: "Party Starter",
                description: "Play 50 statements",
                iconName: "50.circle.fill",
                requirement: 50
            ),
            Achievement(
                id: "gameplay_100_statements",
                title: "Century Club",
                description: "Play 100 statements",
                iconName: "100.circle.fill",
                requirement: 100
            ),
            Achievement(
                id: "gameplay_marathon",
                title: "Marathon Player",
                description: "Play 500 statements",
                iconName: "figure.run",
                requirement: 500
            ),
            Achievement(
                id: "gameplay_legend",
                title: "Living Legend",
                description: "Play 1000 statements",
                iconName: "crown.fill",
                requirement: 1000
            ),
            
            // Custom Statement Achievements
            Achievement(
                id: "custom_first",
                title: "Creative Thinker",
                description: "Add your first custom statement",
                iconName: "lightbulb.fill",
                requirement: 1
            ),
            Achievement(
                id: "custom_10",
                title: "Question Master",
                description: "Create 10 custom statements",
                iconName: "pencil.circle.fill",
                requirement: 10
            ),
            Achievement(
                id: "custom_50",
                title: "Content Creator",
                description: "Create 50 custom statements",
                iconName: "sparkles",
                requirement: 50
            ),
            Achievement(
                id: "custom_only_game",
                title: "DIY Champion",
                description: "Complete a game using only custom statements",
                iconName: "hammer.fill",
                requirement: 1
            ),
            
            // Category Achievements
            Achievement(
                id: "gameplay_all_categories",
                title: "Category Master",
                description: "Play statements from all categories",
                iconName: "square.grid.3x3.fill",
                requirement: 6
            ),
            Achievement(
                id: "gameplay_complete_category",
                title: "Category Completionist",
                description: "Complete all statements in one category",
                iconName: "checkmark.seal.fill",
                requirement: 1
            ),
            
            // Social Achievements
            Achievement(
                id: "social_10_games",
                title: "Party Host",
                description: "Host 10 game sessions",
                iconName: "person.3.fill",
                requirement: 10
            ),
            Achievement(
                id: "social_sound_enabled",
                title: "Sound Enthusiast",
                description: "Play a game with sounds enabled",
                iconName: "speaker.wave.2.fill",
                requirement: 1
            ),
            
            // Special Achievements
            Achievement(
                id: "special_night_owl",
                title: "Night Owl",
                description: "Play a game after midnight",
                iconName: "moon.stars.fill",
                requirement: 1
            ),
            Achievement(
                id: "special_early_bird",
                title: "Early Bird",
                description: "Play a game before 6 AM",
                iconName: "sunrise.fill",
                requirement: 1
            )
        ]
    }
    
    // MARK: - Progress Tracking
    
    func updateProgress(for achievementId: String, progress: Int) {
        guard let index = achievements.firstIndex(where: { $0.id == achievementId }) else { return }
        
        if !achievements[index].isUnlocked {
            achievements[index].progress = progress
            
            if progress >= achievements[index].requirement {
                unlockAchievement(achievementId)
            }
        }
    }
    
    func incrementProgress(for achievementId: String, by amount: Int = 1) {
        guard let index = achievements.firstIndex(where: { $0.id == achievementId }) else { return }
        
        if !achievements[index].isUnlocked {
            achievements[index].progress += amount
            
            if achievements[index].progress >= achievements[index].requirement {
                unlockAchievement(achievementId)
            }
        }
    }
    
    func unlockAchievement(_ achievementId: String) {
        guard let index = achievements.firstIndex(where: { $0.id == achievementId }) else { return }
        
        if !achievements[index].isUnlocked {
            achievements[index].isUnlocked = true
            achievements[index].unlockedDate = Date()
            achievements[index].progress = achievements[index].requirement
            
            newlyUnlockedAchievements.append(achievements[index])
            
            saveProgress()
            SoundManager.shared.playSound(.celebration)
        }
    }
    
    func clearNewlyUnlocked() {
        newlyUnlockedAchievements.removeAll()
    }
    
    // MARK: - Stats
    
    var unlockedCount: Int {
        achievements.filter { $0.isUnlocked }.count
    }
    
    var totalCount: Int {
        achievements.count
    }
    
    var completionPercentage: Double {
        guard totalCount > 0 else { return 0 }
        return Double(unlockedCount) / Double(totalCount)
    }
    
    // MARK: - Persistence
    
    private func saveProgress() {
        if let encoded = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadProgress() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([Achievement].self, from: data) {
            // Merge saved progress with current achievements
            for savedAchievement in decoded {
                if let index = achievements.firstIndex(where: { $0.id == savedAchievement.id }) {
                    achievements[index].isUnlocked = savedAchievement.isUnlocked
                    achievements[index].progress = savedAchievement.progress
                    achievements[index].unlockedDate = savedAchievement.unlockedDate
                }
            }
        }
    }
}
