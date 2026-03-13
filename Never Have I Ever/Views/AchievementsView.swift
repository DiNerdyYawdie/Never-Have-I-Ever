//
//  AchievementsView.swift
//  Never Have I Ever
//
//  Created by Claude Code on 3/11/26.
//

import SwiftUI

/// View displaying all achievements
struct AchievementsView: View {
    @EnvironmentObject private var achievementManager: AchievementManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
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
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        SoundManager.shared.playSound(.buttonTap)
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
                    
                    VStack(spacing: 5) {
                        Text("Achievements")
                            .font(.system(size: 50, weight: .bold))
                            .foregroundStyle(.white)
                        
                        Text("\(achievementManager.unlockedCount) / \(achievementManager.totalCount) Unlocked")
                            .font(.title2)
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    // Progress indicator
                    ZStack {
                        Circle()
                            .stroke(.white.opacity(0.2), lineWidth: 8)
                            .frame(width: 80, height: 80)
                        
                        Circle()
                            .trim(from: 0, to: achievementManager.completionPercentage)
                            .stroke(.green, lineWidth: 8)
                            .frame(width: 80, height: 80)
                            .rotationEffect(.degrees(-90))
                        
                        Text("\(Int(achievementManager.completionPercentage * 100))%")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal, 60)
                .padding(.top, 60)
                .padding(.bottom, 30)
                
                // Achievements list
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(achievementManager.achievements) { achievement in
                            AchievementRow(achievement: achievement)
                        }
                    }
                    .padding(.horizontal, 100)
                    .padding(.vertical, 20)
                }
            }
        }
    }
}

/// Row component for an achievement
struct AchievementRow: View {
    let achievement: Achievement
    @Environment(\.isFocused) private var isFocused
    
    var body: some View {
        Button {
            // Just for focusability, doesn't do anything when clicked
        } label: {
            achievementContent
        }
        .buttonStyle(.plain)
    }
    
    private var achievementContent: some View {
        HStack(spacing: 30) {
            // Icon
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? achievement.iconColor.opacity(0.3) : .white.opacity(0.1))
                    .frame(width: 100, height: 100)
                
                Image(systemName: achievement.iconName)
                    .font(.system(size: 45))
                    .foregroundStyle(achievement.isUnlocked ? achievement.iconColor : .white.opacity(0.3))
            }
            
            // Info
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(achievement.title)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(achievement.isUnlocked ? .white : .white.opacity(0.5))
                    
                    if achievement.isUnlocked {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.title2)
                            .foregroundStyle(.green)
                    }
                }
                
                Text(achievement.description)
                    .font(.title3)
                    .foregroundStyle(.white.opacity(0.7))
                
                // Progress bar
                if !achievement.isUnlocked {
                    VStack(alignment: .leading, spacing: 5) {
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.white.opacity(0.2))
                                    .frame(height: 16)
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(achievement.iconColor)
                                    .frame(width: geometry.size.width * achievement.progressPercentage, height: 16)
                            }
                        }
                        .frame(height: 16)
                        
                        Text("\(achievement.progress) / \(achievement.requirement)")
                            .font(.callout)
                            .foregroundStyle(.white.opacity(0.6))
                    }
                } else if let unlockedDate = achievement.unlockedDate {
                    Text("Unlocked \(unlockedDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.callout)
                        .foregroundStyle(.green)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 25)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(achievement.isUnlocked ? achievement.iconColor.opacity(0.1) : .white.opacity(0.05))
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isFocused ? .white : (achievement.isUnlocked ? achievement.iconColor.opacity(0.5) : .clear), lineWidth: isFocused ? 3 : 2)
                }
        }
        .scaleEffect(isFocused ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

#Preview {
    AchievementsView()
        .environmentObject(AchievementManager())
}
