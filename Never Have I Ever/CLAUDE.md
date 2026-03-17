# [APP NAME] — iOS App
## CLAUDE.md — Di Nerd Apps LLC

---

## Project Overview

**App Name:** [APP NAME]
**Bundle ID:** com.dinerdapps.[bundleid]
**Developer:** Di Nerd Apps LLC
**Platform:** iOS 26+
**Deployment Target:** iOS 26.0
**Swift Version:** 6.0
**Architecture:** MVVM

[Brief 1-2 sentence description of what the app does.]

---

## Monetization

- **Free tier:** [What's included for free]
- **IAP Types (pick what applies, delete the rest):**

### Subscriptions (Auto-Renewable)
- Subscription Group ID: `com.dinerdapps.[bundleid].subscriptionGroup`
- Use `SubscriptionStoreView(groupID:)` for the paywall
- Check status with `.subscriptionStatusTask(for:)` — no custom Transaction logic
- Product IDs:
  - `com.dinerdapps.[bundleid].monthly`
  - `com.dinerdapps.[bundleid].yearly`

### Non-Consumable (One-Time Unlock)
- Product ID: `com.dinerdapps.[bundleid].pro`
- Use `StoreView(ids:)` for the purchase screen
- Check entitlement with `.currentEntitlementTask(for:)` — no custom Transaction logic
- Unlocks: [List pro features]

### Consumable (Tips / Tokens)
- Use `StoreView(ids:)` for the tip jar / token store
- Product IDs:
  - `com.dinerdapps.[bundleid].smallTip`
  - `com.dinerdapps.[bundleid].mediumTip`
  - `com.dinerdapps.[bundleid].largeTip`

---

## Tech Stack

- **UI:** SwiftUI only — no UIKit, no storyboards
- **Data:** [CoreData / SwiftData / JSON API / None]
- **Networking:** [URLSession / None]
- **Purchases:** StoreKit 2 — native views only (`SubscriptionStoreView`, `StoreView`)
- **AI:** [Apple Intelligence / None]
- **Dependencies:** Zero third-party dependencies

---

## Di Nerd Apps Global Standards

### SwiftUI API
- `foregroundStyle()` not `foregroundColor()`
- `clipShape(.rect(cornerRadius:))` not `.cornerRadius()`
- Use `Tab` API not `.tabItem()`
- Avoid `GeometryReader` — prefer `containerRelativeFrame()`
- Use `@Entry` macro for EnvironmentValues
- `.topBarLeading` / `.topBarTrailing` not `.navigationBarLeading`
- `.scrollIndicators(.hidden)`
- Never concatenate `Text` views with `+`
- iOS 26 has native WebView

### SwiftUI Data Flow
- `@Observable` classes must be `@MainActor`
- Use `@Observable` with `@State` for ownership, `@Bindable` / `@Environment` for passing
- Never use `ObservableObject` / `@Published` / `@StateObject` / `@ObservedObject`
- `@State` should be `private`
- Avoid `Binding(get:set:)` in view body — use `onChange()` instead
- Never use `@AppStorage` inside `@Observable` class

### SwiftUI Navigation
- `NavigationStack` or `NavigationSplitView` — never `NavigationView`
- Prefer `navigationDestination(for:)` over `NavigationLink(destination:)`
- Never mix both in same hierarchy
- `sheet(item:)` over `sheet(isPresented:)` for optional data
- Attach `confirmationDialog()` to the UI element that triggers it

### SwiftUI Performance
- Prefer ternary over if/else view branching
- Avoid `AnyView` — use `@ViewBuilder` or generics
- Break views into dedicated structs not computed properties
- Keep view initializers small — move work into `task()`
- Prefer `task()` over `onAppear()` for async work
- Use `LazyVStack` / `LazyHStack` for large data sets
- Store `@ViewBuilder let content` not `() -> Content` closures

### SwiftUI Views
- Each type in its own file
- Never break up `body` with computed properties — extract into View structs
- Extract button actions into methods
- Use `#Preview` not `PreviewProvider`
- Use `@Animatable` macro not manual `animatableData`
- Never use `animation()` without a value to watch
- Chain animations using `withAnimation` completion closure

### SwiftUI Accessibility
- Never force specific font sizes — use Dynamic Type
- Icon-only buttons must include text label for VoiceOver
- Never use `onTapGesture()` for tappable elements — use `Button`
- `accessibilityHidden()` for decorative images
- Respect Reduce Motion with opacity instead of animations
- `accessibilityDifferentiateWithoutColor` for color-dependent UI

### Swift Best Practices
- Never use GCD — always use `async/await` and actors
- Never `Task.sleep(nanoseconds:)` — use `Task.sleep(for:)`
- Avoid force unwraps
- Use `count(where:)` not `filter().count`
- Prefer `Date.now` over `Date()`
- Use `if let value` shorthand not `if let value = value`
- Prefer `Double` over `CGFloat`
- Never use C-style `String(format:)` — use `FormatStyle`
- Use `localizedStandardContains()` for user text filtering

### StoreKit 2
- **Never use StoreKit 1 APIs**
- **Always use native StoreKit 2 views** — no unnecessary custom Transaction/Product logic
- **Always include `.storeButton(.visible, for: .restorePurchases)`**
- **Always include `.storeButton(.hidden, for: .cancellation)`**
- Handle purchase results with `.onInAppPurchaseCompletion { product, result in }`

#### Subscriptions
- Use `SubscriptionStoreView(groupID: .subscriptionGroupID)` with marketing content in the trailing closure
- Use `.subscriptionStoreButtonLabel(.singleLine)`
- Check subscription status with:
  ```swift
  .subscriptionStatusTask(for: .subscriptionGroupID) { taskStatus in
      if let status = taskStatus.value?.first {
          viewModel.isSubscribed = status.state == .subscribed || status.state == .inGracePeriod
      }
  }
  ```
- Define the group ID as a static extension on `PassthroughSubject` or use a `String` constant

#### Non-Consumable (One-Time Unlock)
- Use `StoreView(ids: ["com.dinerdapps.[bundleid].pro"])` for the purchase screen
- Use `.productViewStyle(.large)` or `.productViewStyle(.compact)`
- Check entitlement with `.currentEntitlementTask(for: "com.dinerdapps.[bundleid].pro")`
- The entitlement persists automatically — no manual tracking needed

#### Consumable (Tips / Tokens)
- Use `StoreView(ids:)` with an array of product IDs
- Use `.productViewStyle(.compact)` for tip jar style
- No entitlement checking needed — consumables are one-time use
- Handle success/failure in `.onInAppPurchaseCompletion`

---

## Design

- **Aesthetic:** Liquid Glass, clean, minimalist
- **Light + Dark mode:** Both supported
- **Colors:** [Describe color palette / accent color]
- **Typography:** SF Pro Rounded for display, SF Pro for body
- **Icons:** SF Symbols only — no custom icon assets
- **Animations:** Subtle, smooth — respect Reduce Motion

---

## Features

1. **[Feature 1]** — [Description]
2. **[Feature 2]** — [Description]
3. **[Feature 3]** — [Description]

---

## File Structure

```
[APP NAME]/
├── [AppName]App.swift
├── CLAUDE.md
├── Models/
│   └── [Model].swift
├── ViewModels/
│   └── [ViewModel].swift
├── Views/
│   ├── ContentView.swift
│   └── [View].swift
├── Services/
│   └── [Service].swift
└── Resources/
    └── [AppName].storekit
```

---

## Key Implementation Notes

1. [Note 1]
2. [Note 2]
3. [Note 3]

---

## // MARK: - Section Comments Required

All Swift files must use `// MARK: -` section comments:
- `// MARK: - Properties`
- `// MARK: - Body`
- `// MARK: - Methods`
- `// MARK: - Private`
