//
//  CategorySelectionView.swift
//  Never Have I Ever
//
//  Created by Claude Code on 3/11/26.
//

import SwiftUI

/// View for selecting statement categories
struct CategorySelectionView: View {
    @EnvironmentObject private var gameManager: GameManager
    @Environment(\.dismiss) private var dismiss
    @State private var showingPremiumView = false
    
    var body: some View {
        ZStack {
            // Background - solid color first, then gradient on top
            Color.black
                .ignoresSafeArea()
            
            LinearGradient(
                colors: [.blue.opacity(0.4), .cyan.opacity(0.4)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                            Text("Back")
                                .font(.title2)
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 15)
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.white.opacity(0.2))
                        }
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    Text("Select Categories")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    // Placeholder for symmetry
                    Color.clear
                        .frame(width: 140, height: 50)
                }
                .padding(.horizontal, 60)
                .padding(.top, 60)
                .padding(.bottom, 20)
                
                VStack(spacing: 15) {
                    Text("Choose which categories to include in the game")
                        .font(.title2)
                        .foregroundStyle(.white.opacity(0.8))
                    
                    // Sound toggle
                    Button {
                        gameManager.soundManager.isSoundEnabled.toggle()
                        if gameManager.soundManager.isSoundEnabled {
                            gameManager.soundManager.playSound(.success)
                        }
                    } label: {
                        HStack(spacing: 15) {
                            Image(systemName: gameManager.soundManager.isSoundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                                .font(.title2)
                                .foregroundStyle(gameManager.soundManager.isSoundEnabled ? .green : .red)
                            Text(gameManager.soundManager.isSoundEnabled ? "Sound: ON" : "Sound: OFF")
                                .font(.title3)
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .background {
                            Capsule()
                                .fill(.white.opacity(0.2))
                        }
                    }
                    .buttonStyle(.plain)
                }
                .padding(.bottom, 20)
                
                // Custom Only Toggle
                Button {
                    gameManager.useCustomOnly.toggle()
                    // Save preference
                    UserDefaults.standard.set(gameManager.useCustomOnly, forKey: "useCustomOnly")
                } label: {
                    HStack(spacing: 30) {
                        Image(systemName: gameManager.useCustomOnly ? "checkmark.square.fill" : "square")
                            .font(.system(size: 50))
                            .foregroundStyle(gameManager.useCustomOnly ? .green : .white.opacity(0.5))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Custom Statements Only")
                                .font(.system(size: 36, weight: .semibold))
                                .foregroundStyle(.white)
                            
                            Text("Play with only your custom statements (\(gameManager.customStatements.count) available)")
                                .font(.title3)
                                .foregroundStyle(.white.opacity(0.7))
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 25)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(gameManager.useCustomOnly ? .green.opacity(0.2) : .white.opacity(0.1))
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(gameManager.useCustomOnly ? .green : .clear, lineWidth: 3)
                            }
                    }
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 150)
                .padding(.bottom, 30)
                
                if !gameManager.useCustomOnly {
                    // Category list - only show if not in custom-only mode
                    ScrollView {
                        VStack(spacing: 25) {
                            ForEach(Statement.Category.allCases.filter { $0 != .custom }, id: \.self) { category in
                                CategoryButton(category: category)
                            }
                            
                            // Age warning for spicy category
                            Text("🌶️ Spicy category contains romantic/suggestive content")
                                .font(.callout)
                                .foregroundStyle(.orange.opacity(0.8))
                                .padding(.top, 10)
                        }
                        .padding(.horizontal, 150)
                        .padding(.vertical, 20)
                    }
                    
                    // Info text
                    Text("\(gameManager.selectedCategories.count) categories selected")
                        .font(.title)
                        .foregroundStyle(.white.opacity(0.7))
                        .padding(.vertical, 40)
                } else {
                    // Custom only message
                    Spacer()
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 100))
                            .foregroundStyle(.green)
                        
                        Text("Custom Mode Enabled")
                            .font(.system(size: 44, weight: .bold))
                            .foregroundStyle(.white)
                        
                        Text("The game will use only your \(gameManager.customStatements.count) custom statements")
                            .font(.title2)
                            .foregroundStyle(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 100)
                    }
                    Spacer()
                }
            }
        }
    }
}

/// Category button component
struct CategoryButton: View {
    let category: Statement.Category
    @EnvironmentObject private var gameManager: GameManager
    @Environment(\.isFocused) private var isFocused
    @State private var showingPremiumView = false
    
    private var isSelected: Bool {
        gameManager.selectedCategories.contains(category)
    }
    
    private var isLocked: Bool {
        category == .spicy && !gameManager.isSpicyCategoryUnlocked()
    }
    
    private var categoryColor: Color {
        switch category {
        case .general: return .gray
        case .wild: return .red
        case .funny: return .yellow
        case .adventure: return .green
        case .food: return .orange
        case .travel: return .blue
        case .spicy: return .pink
        case .custom: return .purple
        }
    }
    
    var body: some View {
        Button {
            gameManager.soundManager.playSound(.buttonTap)
            if isLocked {
                showingPremiumView = true
            } else {
                gameManager.toggleCategory(category)
            }
        } label: {
            HStack(spacing: 30) {
                // Emoji or Lock icon
                if isLocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.white.opacity(0.5))
                } else {
                    Text(category.emoji)
                        .font(.system(size: 60))
                }
                
                // Category name
                VStack(alignment: .leading, spacing: 5) {
                    Text(category.rawValue)
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundStyle(.white)
                    
                    if isLocked {
                        HStack(spacing: 5) {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 18))
                            Text("Premium Required")
                                .font(.system(size: 20))
                        }
                        .foregroundStyle(.yellow)
                    }
                }
                
                Spacer()
                
                // Selection indicator or unlock badge
                if isLocked {
                    Image(systemName: "lock.circle.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.yellow)
                } else if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.green)
                } else {
                    Image(systemName: "circle")
                        .font(.system(size: 40))
                        .foregroundStyle(.white.opacity(0.3))
                }
            }
            .padding(.horizontal, 40)
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(isLocked ? .yellow.opacity(0.2) : (isSelected ? categoryColor.opacity(0.4) : .white.opacity(0.1)))
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(isLocked ? .yellow : (isSelected ? categoryColor : .clear), lineWidth: 3)
                    }
            }
            .scaleEffect(isFocused ? 1.05 : 1.0)
            .shadow(color: .black.opacity(0.3), radius: isFocused ? 20 : 10)
            .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
        .buttonStyle(.card)
        .fullScreenCover(isPresented: $showingPremiumView) {
            PremiumPurchaseView()
        }
    }
}

#Preview {
    CategorySelectionView()
        .environmentObject(GameManager())
}
