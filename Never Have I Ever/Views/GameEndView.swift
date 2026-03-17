//
//  GameEndView.swift
//  Never Have I Ever
//
//  Created by Claude Code on 3/11/26.
//

import SwiftUI

/// End screen shown when all statements are completed
struct GameEndView: View {
    @Environment(GameManager.self) private var gameManager
    @Environment(AchievementManager.self) private var achievementManager
    @Environment(\.dismiss) private var dismiss
    let wasCustomOnly: Bool
    let totalPlayed: Int
    
    @State private var celebrationScale: CGFloat = 0.5
    @State private var celebrationRotation: Double = 0
    @State private var showingAddCustom = false
    
    var body: some View {
        ZStack {
            // Background
            Color.black
                .ignoresSafeArea()
            
            LinearGradient(
                colors: [.purple.opacity(0.5), .pink.opacity(0.5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 50) {
                Spacer()
                
                // Celebration icon with animation
                Image(systemName: "party.popper.fill")
                    .font(.system(size: 120))
                    .foregroundStyle(.yellow)
                    .shadow(color: .yellow.opacity(0.5), radius: 20)
                    .scaleEffect(celebrationScale)
                    .rotationEffect(.degrees(celebrationRotation))
                
                // Title
                Text("Game Complete!")
                    .font(.system(size: 70, weight: .bold))
                    .foregroundStyle(.white)
                
                // Stats
                VStack(spacing: 20) {
                    if wasCustomOnly {
                        Text("You've played through all")
                            .font(.system(size: 40))
                            .foregroundStyle(.white.opacity(0.8))
                        
                        HStack(spacing: 15) {
                            Text("\(totalPlayed)")
                                .font(.system(size: 80, weight: .black))
                                .foregroundStyle(.green)
                            Text("custom statements!")
                                .font(.system(size: 40, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                    } else {
                        Text("You've played through all")
                            .font(.system(size: 40))
                            .foregroundStyle(.white.opacity(0.8))
                        
                        HStack(spacing: 15) {
                            Text("\(totalPlayed)")
                                .font(.system(size: 80, weight: .black))
                                .foregroundStyle(.blue)
                            Text("statements!")
                                .font(.system(size: 40, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                    }
                }
                .padding(.vertical, 30)
                
                // Message
                Text(wasCustomOnly ? "Add more custom statements or try the preloaded ones!" : "Great job! Want to play again?")
                    .font(.title)
                    .foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 100)
                
                Spacer()
                
                // Action buttons
                VStack(spacing: 30) {
                    // Primary actions
                    HStack(spacing: 40) {
                        Button {
                            gameManager.soundManager.playSound(.success)
                            dismiss()
                            Task {
                                try? await Task.sleep(for: .milliseconds(100))
                                gameManager.startGame()
                            }
                        } label: {
                            HStack(spacing: 15) {
                                Image(systemName: "arrow.clockwise")
                                    .font(.system(size: 40))
                                Text("Play Again")
                                    .font(.system(size: 40, weight: .bold))
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 50)
                            .padding(.vertical, 25)
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.green.gradient)
                            }
                        }
                        .buttonStyle(.plain)
                        
                        Button {
                            gameManager.soundManager.playSound(.buttonTap)
                            showingAddCustom = true
                        } label: {
                            HStack(spacing: 15) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 40))
                                Text("Add Custom")
                                    .font(.system(size: 40, weight: .bold))
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 50)
                            .padding(.vertical, 25)
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.orange.gradient)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    
                    // Secondary action
                    Button {
                        gameManager.soundManager.playSound(.buttonTap)
                        dismiss()
                    } label: {
                        HStack(spacing: 15) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 35))
                            Text("Close")
                                .font(.system(size: 35, weight: .semibold))
                        }
                        .foregroundStyle(.white.opacity(0.8))
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.white.opacity(0.1))
                        }
                    }
                    .buttonStyle(.plain)
                }
                .padding(.bottom, 80)
            }
        }
        .fullScreenCover(isPresented: $showingAddCustom) {
            CustomStatementsView()
                .environment(gameManager)
        }
        .onAppear {
            gameManager.soundManager.playSound(.celebration)
            
            // Celebration animation
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                celebrationScale = 1.0
            }
            
            withAnimation(.linear(duration: 0.5).repeatForever(autoreverses: true)) {
                celebrationRotation = 15
            }
            
            // Track game completion
            gameManager.gamesCompleted += 1
            
            // Check for custom only achievement
            if wasCustomOnly {
                achievementManager.unlockAchievement("custom_only_game")
            }
            
            // Track category completionist
            achievementManager.unlockAchievement("gameplay_complete_category")
        }
    }
}

#Preview {
    GameEndView(wasCustomOnly: false, totalPlayed: 70)
        .environment(GameManager())
        .environment(AchievementManager())
}
