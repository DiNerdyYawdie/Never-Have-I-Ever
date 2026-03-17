//
//  PremiumPurchaseView.swift
//  Never Have I Ever
//

import SwiftUI
import StoreKit

// MARK: - PremiumPurchaseView

struct PremiumPurchaseView: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @State private var animateFeatures = false
    @State private var pulseAnimation = false

    // MARK: - Body

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

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
                            .accessibilityLabel("Close")
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

                    Text("One-time purchase • Lifetime access")
                        .font(.system(size: 24))
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }

                // Features
                HStack(spacing: 40) {
                    FeatureTile(emoji: "🌶️", title: "Unlock Spicy\nCategory", color: .pink)
                    FeatureTile(emoji: "✏️", title: "Unlimited\nCustom Cards", color: .purple)
                }
                .opacity(animateFeatures ? 1 : 0)
                .offset(y: animateFeatures ? 0 : 20)

                Spacer()

                // Native StoreKit purchase UI
                StoreView(ids: [StoreManager.productID])
                    .productViewStyle(.regular)
                    .storeButton(.visible, for: .restorePurchases)
                    .onInAppPurchaseCompletion { _, result in
                        if case .success = result {
                            dismiss()
                        }
                    }
                    .padding(.bottom, 60)
            }
        }
        .onAppear {
            pulseAnimation = true
            withAnimation(.easeOut(duration: 0.8)) {
                animateFeatures = true
            }
        }
    }
}

// MARK: - FeatureTile

private struct FeatureTile: View {

    // MARK: - Properties

    let emoji: String
    let title: String
    let color: Color

    // MARK: - Body

    var body: some View {
        VStack(spacing: 15) {
            Text(emoji)
                .font(.system(size: 70))
            Text(title)
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
        }
        .frame(width: 300, height: 180)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(color.opacity(0.3))
        )
    }
}

#Preview {
    PremiumPurchaseView()
}
