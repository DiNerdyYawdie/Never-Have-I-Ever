//
//  AchievementUnlockView.swift
//  Never Have I Ever
//
//  Created by Claude Code on 3/11/26.
//

import SwiftUI

/// Notification view shown when an achievement is unlocked
struct AchievementUnlockView: View {
    let achievement: Achievement
    @State private var isVisible = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack(spacing: 15) {
                Image(systemName: "trophy.fill")
                    .font(.title)
                    .foregroundStyle(.yellow)
                
                Text("Achievement Unlocked!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            
            Divider()
                .background(.white.opacity(0.3))
            
            // Achievement info
            HStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(achievement.iconColor.opacity(0.3))
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: achievement.iconName)
                        .font(.system(size: 35))
                        .foregroundStyle(achievement.iconColor)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(achievement.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    Text(achievement.description)
                        .font(.title3)
                        .foregroundStyle(.white.opacity(0.8))
                }
                
                Spacer()
            }
        }
        .padding(30)
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(.ultraThinMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(achievement.iconColor, lineWidth: 3)
                }
        }
        .shadow(color: achievement.iconColor.opacity(0.5), radius: 20)
        .scaleEffect(isVisible ? 1.0 : 0.5)
        .opacity(isVisible ? 1.0 : 0.0)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                isVisible = true
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        AchievementUnlockView(
            achievement: Achievement(
                id: "test",
                title: "First Steps",
                description: "Complete your first game",
                iconName: "flag.fill",
                requirement: 1,
                isUnlocked: true
            )
        )
        .padding(100)
    }
}
