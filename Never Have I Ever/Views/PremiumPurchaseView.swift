//
//  PremiumPurchaseView.swift
//  Never Have I Ever
//
//  Created by Claude Code
//

import SwiftUI
import StoreKit

struct PremiumPurchaseView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var storeManager = StoreManager.shared
    @State private var isPurchasing = false
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var animateFeatures = false
    @State private var pulseAnimation = false
    
    var body: some View {
        ZStack {
            // Solid black background first
            Color.black
                .ignoresSafeArea()
            
            // Background gradient on top
            LinearGradient(
                colors: [
                    Color.pink.opacity(0.4),
                    Color.purple.opacity(0.4),
                    Color.black.opacity(0.8)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 50) {
                // Close button
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.trailing, 60)
                .padding(.top, 40)
                
                // Header
                VStack(spacing: 20) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.yellow, .orange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulseAnimation)
                    
                    Text("Unlock Full Access")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Text("One-time purchase • $4.99 • Lifetime access")
                        .font(.system(size: 24))
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                
                // Simplified features - just 2 main ones
                HStack(spacing: 40) {
                    VStack(spacing: 15) {
                        Text("🌶️")
                            .font(.system(size: 70))
                        Text("Unlock Spicy\nCategory")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: 300, height: 180)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.pink.opacity(0.3))
                    )
                    .opacity(animateFeatures ? 1 : 0)
                    .offset(y: animateFeatures ? 0 : 20)
                    
                    VStack(spacing: 15) {
                        Text("✏️")
                            .font(.system(size: 70))
                        Text("Unlimited\nCustom Cards")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: 300, height: 180)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.purple.opacity(0.3))
                    )
                    .opacity(animateFeatures ? 1 : 0)
                    .offset(y: animateFeatures ? 0 : 20)
                }
                
                Spacer()
                
                // Purchase buttons
                if let product = storeManager.products.first {
                    VStack(spacing: 20) {
                        // Custom purchase button
                        Button {
                            Task {
                                do {
                                    try await storeManager.purchase(product)
                                } catch {
                                    errorMessage = error.localizedDescription
                                    showingError = true
                                }
                            }
                        } label: {
                            HStack(spacing: 15) {
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 32))
                                
                                Text("Unlock for \(product.displayPrice)")
                                    .font(.system(size: 38, weight: .bold))
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: 700)
                            .padding(.vertical, 30)
                            .background(
                                LinearGradient(
                                    colors: [.pink, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: .pink.opacity(0.5), radius: 20)
                        }
                        .buttonStyle(.card)
                        .disabled(isPurchasing)
                        
                        // Restore purchases button
                        Button {
                            Task {
                                await storeManager.restorePurchases()
                            }
                        } label: {
                            Text("Restore Purchases")
                                .font(.system(size: 22))
                                .foregroundStyle(.white.opacity(0.6))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.bottom, 60)
                } else {
                    ProgressView()
                        .scaleEffect(2)
                        .tint(.white)
                        .padding(.bottom, 60)
                }
            }
        }
        .onAppear {
            pulseAnimation = true
            withAnimation(.easeOut(duration: 0.8)) {
                animateFeatures = true
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
}

#Preview {
    PremiumPurchaseView()
}
