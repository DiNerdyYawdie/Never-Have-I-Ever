//
//  GamePlayView.swift
//  Never Have I Ever
//
//  Created by Claude Code on 3/11/26.
//

import SwiftUI

/// Main game play view with card interface
struct GamePlayView: View {
    @EnvironmentObject private var gameManager: GameManager
    @EnvironmentObject private var achievementManager: AchievementManager
    @Environment(\.dismiss) private var dismiss
    @State private var cardOffset: CGFloat = 0
    @State private var cardRotation: Double = 0
    @State private var showingEndGameAlert = false
    @State private var showingGameEndView = false
    @State private var showingAchievement: Achievement?
    @Namespace private var namespace
    
    var body: some View {
        ZStack {
            // Background
            Color.black
                .ignoresSafeArea()
            
            LinearGradient(
                colors: [.indigo.opacity(0.4), .purple.opacity(0.4)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with counter
                HStack {
                    Text("Never Have I Ever")
                        .font(.system(size: 44, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    // Statement counter
                    HStack(spacing: 15) {
                        Text("\(gameManager.usedStatements.count) / \(gameManager.usedStatements.count + gameManager.availableStatements.count)")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundStyle(.white)
                        
                        Text("played")
                            .font(.title2)
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    .padding(.horizontal, 25)
                    .padding(.vertical, 12)
                    .background {
                        Capsule()
                            .fill(.white.opacity(0.2))
                    }
                }
                .padding(.horizontal, 60)
                .padding(.top, 60)
                .padding(.bottom, 40)
                
                Spacer()
                
                // Statement card
                if let statement = gameManager.currentStatement {
                    StatementCard(statement: statement)
                        .offset(x: cardOffset)
                        .rotationEffect(.degrees(cardRotation))
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: cardOffset)
                } else {
                    EmptyStateCard()
                }
                
                Spacer()
                
                // Bottom buttons - horizontal layout for better focus navigation
                HStack(spacing: 60) {
                    Button {
                        showingEndGameAlert = true
                    } label: {
                        HStack(spacing: 15) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 40))
                            Text("End Game")
                                .font(.system(size: 40, weight: .semibold))
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 25)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.red.opacity(0.3))
                        }
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        nextStatement()
                    } label: {
                        HStack(spacing: 20) {
                            Text("Next Statement")
                                .font(.system(size: 48, weight: .bold))
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 48))
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 60)
                        .padding(.vertical, 30)
                        .background {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(.green.gradient)
                        }
                    }
                    .buttonStyle(.plain)
                }
                .padding(.bottom, 60)
            }
            
            // Achievement unlock notification
            if let achievement = showingAchievement {
                VStack {
                    Spacer()
                    AchievementUnlockView(achievement: achievement)
                        .padding(.horizontal, 100)
                        .padding(.bottom, 100)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .onChange(of: achievementManager.newlyUnlockedAchievements) { oldValue, newValue in
            if let latest = newValue.last {
                showingAchievement = latest
                
                // Auto-dismiss after 5 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    withAnimation {
                        showingAchievement = nil
                    }
                    achievementManager.clearNewlyUnlocked()
                }
            }
        }
        .onAppear {
            // Always reload statements based on current category selection
            gameManager.startGame()
            
            // Track first game achievement
            achievementManager.unlockAchievement("gameplay_first_game")
            
            // Track sound achievement
            if gameManager.soundManager.isSoundEnabled {
                achievementManager.unlockAchievement("social_sound_enabled")
            }
            
            // Track games completed
            achievementManager.updateProgress(for: "social_10_games", progress: gameManager.gamesCompleted + 1)
        }
        .alert("End Game", isPresented: $showingEndGameAlert) {
            Button("Cancel", role: .cancel) { }
            Button("End Game", role: .destructive) {
                gameManager.endGame()
                dismiss()
            }
        } message: {
            Text("Are you sure you want to end the game?")
        }
        .fullScreenCover(isPresented: $showingGameEndView) {
            GameEndView(
                wasCustomOnly: gameManager.useCustomOnly,
                totalPlayed: gameManager.usedStatements.count
            )
            .environmentObject(gameManager)
            .environmentObject(achievementManager)
        }
    }
    
    private func nextStatement() {
        // Play card swipe sound
        gameManager.soundManager.playSound(.cardSwipe)
        
        // Check if there are more statements available
        if gameManager.availableStatements.isEmpty {
            // No more statements - show end screen
            gameManager.soundManager.playSound(.celebration)
            showingGameEndView = true
            return
        }
        
        // Animate card exit
        withAnimation {
            cardOffset = -1500
            cardRotation = -15
        }
        
        // Get next statement after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            gameManager.nextStatement()
            
            // Check again if we've run out after getting the statement
            if gameManager.currentStatement == nil && gameManager.availableStatements.isEmpty {
                gameManager.soundManager.playSound(.celebration)
                showingGameEndView = true
            } else {
                cardOffset = 1500
                cardRotation = 15
                
                withAnimation {
                    cardOffset = 0
                    cardRotation = 0
                }
            }
        }
    }
}

/// Statement card component
struct StatementCard: View {
    let statement: Statement
    
    var body: some View {
        VStack(spacing: 40) {
            // Category badge
            HStack(spacing: 12) {
                Text(statement.category.emoji)
                    .font(.system(size: 40))
                Text(statement.category.rawValue)
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .foregroundStyle(.white.opacity(0.9))
            .padding(.horizontal, 30)
            .padding(.vertical, 15)
            .background {
                Capsule()
                    .fill(.white.opacity(0.2))
            }
            
            // Statement text
            Text(statement.text)
                .font(.system(size: 50, weight: .bold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 60)
        }
        .frame(width: 1200, height: 600)
        .background {
            RoundedRectangle(cornerRadius: 40)
                .fill(.ultraThinMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(.white.opacity(0.3), lineWidth: 2)
                }
        }
        .shadow(color: .black.opacity(0.3), radius: 30, y: 20)
    }
}

/// Empty state when no statements available
struct EmptyStateCard: View {
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.yellow)
            
            Text("No statements available")
                .font(.system(size: 44, weight: .semibold))
                .foregroundStyle(.white)
            
            Text("Please select at least one category")
                .font(.title2)
                .foregroundStyle(.white.opacity(0.7))
        }
        .frame(width: 1200, height: 600)
        .background {
            RoundedRectangle(cornerRadius: 40)
                .fill(.ultraThinMaterial)
        }
    }
}

#Preview {
    GamePlayView()
        .environmentObject(GameManager())
}
