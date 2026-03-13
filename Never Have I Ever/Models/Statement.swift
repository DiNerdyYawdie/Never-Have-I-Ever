//
//  Statement.swift
//  Never Have I Ever
//
//  Created by Claude Code on 3/11/26.
//

import Foundation

/// Represents a "Never Have I Ever" statement
struct Statement: Identifiable, Codable, Hashable {
    let id: UUID
    var text: String
    var category: Category
    var isCustom: Bool
    
    init(id: UUID = UUID(), text: String, category: Category, isCustom: Bool = false) {
        self.id = id
        self.text = text
        self.category = category
        self.isCustom = isCustom
    }
    
    enum Category: String, Codable, CaseIterable {
        case general = "General"
        case wild = "Wild"
        case funny = "Funny"
        case adventure = "Adventure"
        case food = "Food"
        case travel = "Travel"
        case spicy = "Spicy"
        case custom = "Custom"
        
        var emoji: String {
            switch self {
            case .general: return "💬"
            case .wild: return "🔥"
            case .funny: return "😂"
            case .adventure: return "🏔️"
            case .food: return "🍕"
            case .travel: return "✈️"
            case .spicy: return "🌶️"
            case .custom: return "✏️"
            }
        }
    }
}
