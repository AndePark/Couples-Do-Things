# Couples Do Things

A native iOS app (iOS 16+) where you and your partner share one list of things to do together. Optional address, price, and dates. Built to run **for free** on two iPhones with Xcode — no Apple Developer Program ($99) and no App Store.

## What you get

- Email + password accounts (Firebase free plan)
- Create a couple space or join with a 6-character invite code
- Add / edit items (title required; address, price, and a date or date range optional)
- Mark done → **Memories**, or delete without completing
- Home-screen widgets (small / medium / large) if your Mac/Xcode will sign them; the in-app list works either way
- Widget background photo is **per device**

## Install on your two iPhones (free)

You need a Mac with Xcode and a free Apple ID (the same one you use for the App Store is fine). You do **not** enroll in the paid Apple Developer Program.

1. On a Mac: install Xcode from the Mac App Store (free).
2. Open `CouplesDoThings.xcodeproj` (or run `xcodegen generate` first if you prefer regenerating the project from `project.yml`).
3. Signing: select the **CouplesDoThings** target → Signing & Capabilities → Team → **Add an Account…** with your free Apple ID → choose **Personal Team**. Do the same for **CouplesDoThingsWidget** if that target is enabled.
4. Plug in your iPhone, unlock it, tap Trust This Computer. In Xcode’s device menu, pick that iPhone. You may need Settings → Privacy & Security → Developer Mode **On**.
5. Press Run. The first time, on the phone go to Settings → General → VPN & Device Management and trust your developer certificate.
6. Repeat on your girlfriend’s iPhone (same Mac, same Xcode project, plug her phone in and Run).

**Catch:** free “Personal Team” installs expire about **every 7 days**. Open Xcode, plug the phone in, and Run again to refresh. That is the tradeoff for not paying Apple.

If Xcode errors on **App Groups** (common on a free team), the shared list in the app still works. Remove the widget target from the scheme or ignore the widget; you can add widgets later if you ever enroll.

## Firebase (also free)

Use the Spark (no-cost) plan.

1. Create a Firebase project.
2. Add an iOS app. Bundle ID starts as `com.couplesdothings.app` — if Xcode changes it to include your personal team prefix, use **that** exact ID in Firebase.
3. Download `GoogleService-Info.plist` and replace `CouplesDoThings/GoogleService-Info.plist`.
4. Authentication → Sign-in method → enable **Email/Password**.
5. Create a Firestore database, then deploy rules:

```bash
firebase deploy --only firestore:rules
```

The placeholder plist will not talk to a real project until you replace it.

## How the two of you use it

1. Each of you creates an account in the app (name, email, password).
2. One person taps **Create couple space** and copies the invite code.
3. The other joins with that code.
4. Add movies, dinners, trips — extra fields are optional.

## Layout

- `CouplesDoThings/` — SwiftUI app
- `CouplesDoThingsWidget/` — WidgetKit extension
- `Shared/` — App Group snapshot, deep links
- `firestore.rules` — member-only couple data
- `project.yml` — XcodeGen spec

This Windows folder cannot compile iOS. Use Xcode on a Mac.
