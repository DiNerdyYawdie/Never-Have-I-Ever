//
//  SoundManager.swift
//  Never Have I Ever
//
//  Created by Claude Code on 3/11/26.
//

import AVFoundation
import SwiftUI
import Combine

/// Manages sound effects for the app
class SoundManager: ObservableObject {
    @Published var isSoundEnabled: Bool = true
    
    static let shared = SoundManager()
    
    private init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    /// Play a system sound effect
    func playSound(_ soundType: SoundType) {
        guard isSoundEnabled else { return }
        
        switch soundType {
        case .buttonTap:
            playSystemSound(1104) // Tock sound
        case .cardSwipe:
            playSystemSound(1106) // Swish sound
        case .success:
            playSystemSound(1057) // Success sound
        case .celebration:
            playSystemSound(1111) // Pop sound
        case .warning:
            playSystemSound(1053) // Alert sound
        }
    }
    
    private func playSystemSound(_ soundID: SystemSoundID) {
        AudioServicesPlaySystemSound(soundID)
    }
    
    enum SoundType {
        case buttonTap
        case cardSwipe
        case success
        case celebration
        case warning
    }
}
