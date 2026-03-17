//
//  ContentView.swift
//  Never Have I Ever
//
//  Created by Nerdy Yawdie on 3/11/26.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    @State private var gameManager = GameManager()
    @State private var achievementManager = AchievementManager()

    var body: some View {
        MainMenuView()
            .environment(gameManager)
            .environment(achievementManager)
            .onAppear {
                gameManager.achievementManager = achievementManager
            }
            .currentEntitlementTask(for: StoreManager.productID) { taskState in
                // transaction is non-nil only when the user has a valid entitlement
                gameManager.storeManager.hasFullAccess = taskState.transaction != nil
            }
    }
}

#Preview {
    ContentView()
}
