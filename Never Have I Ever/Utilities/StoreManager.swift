//
//  StoreManager.swift
//  Never Have I Ever
//

import StoreKit
import SwiftUI

// MARK: - StoreManager

@Observable
@MainActor
final class StoreManager {
    static let shared = StoreManager()

    // MARK: - Properties

    var hasFullAccess: Bool = false

    static let productID = "fullaccess.nhie"

    private init() {}
}
