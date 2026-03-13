//
//  CustomStatementsView.swift
//  Never Have I Ever
//
//  Created by Claude Code on 3/11/26.
//

import SwiftUI

/// View for managing custom statements
struct CustomStatementsView: View {
    @EnvironmentObject private var gameManager: GameManager
    @Environment(\.dismiss) private var dismiss
    @State private var newStatementText = ""
    @State private var showingAddAlert = false
    @State private var showingPremiumView = false
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ZStack {
            // Background - solid color first, then gradient on top
            Color.black
                .ignoresSafeArea()
            
            LinearGradient(
                colors: [.orange.opacity(0.4), .red.opacity(0.4)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                // Header
                HStack {
                    Button {
                        gameManager.soundManager.playSound(.buttonTap)
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
                    
                    Text("Custom Statements")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 5) {
                        Button {
                            gameManager.soundManager.playSound(.buttonTap)
                            if gameManager.canAddCustomStatement() {
                                showingAddAlert = true
                            } else {
                                showingPremiumView = true
                            }
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                Text("Add")
                                    .font(.title2)
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 15)
                            .background {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.green.opacity(0.3))
                            }
                        }
                        .buttonStyle(.plain)
                        
                        if !gameManager.storeManager.hasFullAccess {
                            Text("\(gameManager.remainingCustomStatements()) / 5 remaining")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.6))
                                .padding(.trailing, 10)
                        }
                    }
                }
                .padding(.horizontal, 60)
                .padding(.top, 60)
                    
                // List of custom statements
                if gameManager.customStatements.isEmpty {
                    Spacer()
                    VStack(spacing: 30) {
                        Image(systemName: "pencil.circle")
                            .font(.system(size: 120))
                            .foregroundStyle(.white.opacity(0.5))
                        
                        Text("No custom statements yet")
                            .font(.system(size: 40))
                            .foregroundStyle(.white.opacity(0.7))
                        
                        Text("Press Add to create your own")
                            .font(.title2)
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 25) {
                            ForEach(gameManager.customStatements) { statement in
                                CustomStatementRow(statement: statement)
                            }
                        }
                        .padding(.horizontal, 150)
                        .padding(.vertical, 20)
                    }
                }
            }
        }
        .alert("Add Custom Statement", isPresented: $showingAddAlert) {
                TextField("Never have I ever...", text: $newStatementText)
                    .focused($isTextFieldFocused)
                
                Button("Cancel", role: .cancel) {
                    newStatementText = ""
                }
                
                Button("Add") {
                    if !newStatementText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        gameManager.soundManager.playSound(.success)
                        gameManager.addCustomStatement(text: newStatementText)
                        newStatementText = ""
                    }
                }
        } message: {
            Text("Enter your custom 'Never Have I Ever' statement")
        }
        .fullScreenCover(isPresented: $showingPremiumView) {
            PremiumPurchaseView()
        }
    }
}

/// Row component for custom statement
struct CustomStatementRow: View {
    let statement: Statement
    @EnvironmentObject private var gameManager: GameManager
    @Environment(\.isFocused) private var isFocused
    @State private var showingDeleteAlert = false
    
    var body: some View {
        HStack(spacing: 30) {
            Text(statement.text)
                .font(.system(size: 32))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                showingDeleteAlert = true
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "trash.circle.fill")
                        .font(.title2)
                    Text("Delete")
                        .font(.title3)
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 25)
                .padding(.vertical, 12)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.red.opacity(0.3))
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 25)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white.opacity(isFocused ? 0.2 : 0.1))
        }
        .scaleEffect(isFocused ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isFocused)
        .alert("Delete Statement", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                gameManager.removeCustomStatement(statement)
            }
        } message: {
            Text("Are you sure you want to delete this statement?")
        }
    }
}

#Preview {
    CustomStatementsView()
        .environmentObject(GameManager())
}
