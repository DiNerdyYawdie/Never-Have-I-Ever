//
//  MainMenuView.swift
//  Never Have I Ever
//
//  Created by Claude Code on 3/11/26.
//

import SwiftUI

/// Main menu view with Liquid Glass design
struct MainMenuView: View {
    @Environment(GameManager.self) private var gameManager
    @Environment(AchievementManager.self) private var achievementManager
    @State private var showingSettings = false
    @State private var showingCustomStatements = false
    @State private var showingAchievements = false
    @State private var showingPremiumView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color.black
                    .ignoresSafeArea()
                
                LinearGradient(
                    colors: [.purple.opacity(0.4), .blue.opacity(0.4)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack {
                    // Title
                    VStack(spacing: 20) {
                        Text("Never Have I Ever")
                            .font(.title)
                        
                        Text("The Ultimate Party Game")
                            .font(.title2)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .padding(.top, 40)

                    
                    // Menu buttons
                    VStack(spacing: 30) {
                        NavigationLink {
                            GamePlayView()
                                .environment(gameManager)
                                .environment(achievementManager)
                        } label: {
                            MenuButton(title: "Start Game", icon: "play.fill", color: .green)
                        }
                        .buttonStyle(.card)
                        
                        Button {
                            gameManager.soundManager.playSound(.buttonTap)
                            showingSettings = true
                        } label: {
                            MenuButton(title: "Categories", icon: "slider.horizontal.3", color: .blue)
                        }
                        .buttonStyle(.card)
                        
                        Button {
                            gameManager.soundManager.playSound(.buttonTap)
                            showingCustomStatements = true
                        } label: {
                            MenuButton(title: "Custom Statements", icon: "pencil.circle.fill", color: .orange)
                        }
                        .buttonStyle(.card)
                        
                        Button {
                            gameManager.soundManager.playSound(.buttonTap)
                            showingAchievements = true
                        } label: {
                            HStack(spacing: 20) {
                                Image(systemName: "trophy.fill")
                                    .font(.system(size: 40))
                                
                                Text("Achievements")
                                    .font(.system(size: 44, weight: .semibold))
                                
                                // Badge showing unlocked count
                                Text("\(achievementManager.unlockedCount)/\(achievementManager.totalCount)")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 8)
                                    .background {
                                        Capsule()
                                            .fill(.yellow.opacity(0.3))
                                    }
                            }
                            .foregroundStyle(.white)
                            .frame(width: 600, height: 120)
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.yellow.gradient)
                                    .opacity(0.7)
                            }
                        }
                        .buttonStyle(.card)
                        
                        // Premium unlock button (only if not premium)
                        if !gameManager.storeManager.hasFullAccess {
                            Button {
                                gameManager.soundManager.playSound(.buttonTap)
                                showingPremiumView = true
                            } label: {
                                HStack(spacing: 20) {
                                    Image(systemName: "crown.fill")
                                        .font(.system(size: 40))
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("Unlock Full Access")
                                            .font(.system(size: 40, weight: .bold))
                                        
                                        Text("Unlimited custom statements + Spicy category")
                                            .font(.system(size: 20))
                                    }
                                }
                                .foregroundStyle(.white)
                                .frame(width: 600, height: 120)
                                .background {
                                    LinearGradient(
                                        colors: [.pink, .purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                            .buttonStyle(.card)
                        }
                    }
                    
                    Spacer()
                    
                    // Mode indicator
                    if gameManager.useCustomOnly {
                        HStack(spacing: 15) {
                            Image(systemName: "sparkles")
                                .font(.title2)
                            Text("Custom Mode: \(gameManager.customStatements.count) statements")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Image(systemName: "sparkles")
                                .font(.title2)
                        }
                        .foregroundStyle(.green)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                        .background {
                            Capsule()
                                .fill(.green.opacity(0.2))
                                .overlay {
                                    Capsule()
                                        .stroke(.green, lineWidth: 2)
                                }
                        }
                        .padding(.bottom, 20)
                    }
                    
                    // Info text
                    Text(gameManager.useCustomOnly ? "Playing with your custom statements!" : "Gather your friends and have fun!")
                        .font(.title3)
                        .foregroundStyle(.white.opacity(0.6))
                        .padding(.bottom, 40)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .fullScreenCover(isPresented: $showingSettings) {
                CategorySelectionView()
                    .environment(gameManager)
            }
            .fullScreenCover(isPresented: $showingCustomStatements) {
                CustomStatementsView()
                    .environment(gameManager)
            }
            .fullScreenCover(isPresented: $showingAchievements) {
                AchievementsView()
                    .environment(achievementManager)
            }
            .fullScreenCover(isPresented: $showingPremiumView) {
                PremiumPurchaseView()
            }
        }
    }
}

/// Menu button component with Liquid Glass effect
struct MenuButton: View {
    let title: String
    let icon: String
    let color: Color
    @Environment(\.isFocused) private var isFocused
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 40))
            
            Text(title)
                .font(.system(size: 44, weight: .semibold))
        }
        .foregroundStyle(.white)
        .frame(width: 600, height: 120)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(color.gradient)
                .opacity(isFocused ? 1.0 : 0.7)
        }
        .scaleEffect(isFocused ? 1.05 : 1.0)
        .shadow(color: .black.opacity(0.3), radius: isFocused ? 20 : 10)
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

#Preview {
    MainMenuView()
        .environment(GameManager())
        .environment(AchievementManager())
}
