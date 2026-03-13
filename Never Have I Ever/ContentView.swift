//
//  ContentView.swift
//  Never Have I Ever
//
//  Created by Nerdy Yawdie on 3/11/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var gameManager = GameManager()
    @StateObject private var achievementManager = AchievementManager()
    
    var body: some View {
        MainMenuView()
            .environmentObject(gameManager)
            .environmentObject(achievementManager)
            .onAppear {
                gameManager.achievementManager = achievementManager
            }
    }
}

#Preview {
    ContentView()
}
