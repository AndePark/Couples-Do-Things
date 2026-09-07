# Couples Do Things

A native iOS app (iOS 17+) where a couple shares one list of things to do together. Optional address, price, and dates. Home-screen widgets with a photo you pick on your own iPhone.

## What you get

- Sign in with Apple
- Create a couple space or join with a 6-character invite code
- Add / edit items (title required; address, price, and a date or date range optional)
- Mark done → **Memories**, or delete without completing
- Small, medium, and large widgets: upcoming + recently added, tap opens the item
- Widget background photo is **per device**

## Open the project (Mac)

This project is generated with [XcodeGen](https://github.com/yonaskolb/XcodeGen). On a Mac:

```bash
brew install xcodegen
cd "path/to/Couples Do Things"
xcodegen generate
open CouplesDoThings.xcodeproj
```

Select your Apple Developer **Team** on both the app and widget targets.

Bundle IDs:

- App: `com.couplesdothings.app`
- Widget: `com.couplesdothings.app.widget`
- App Group: `group.com.couplesdothings.app`
- URL scheme: `couplesdothings://`

In the Apple Developer portal, register those App IDs, enable **Sign In with Apple** and **App Groups**, and attach `group.com.couplesdothings.app` to both IDs.

## Firebase

1. Create a Firebase project.
2. Add an iOS app with bundle ID `com.couplesdothings.app`.
3. Download `GoogleService-Info.plist` and replace `CouplesDoThings/GoogleService-Info.plist`.
4. Authentication → Sign-in method → enable **Apple**.
5. Create a Firestore database (production mode is fine once rules are deployed).
6. Deploy rules:

```bash
firebase deploy --only firestore:rules
```

The placeholder plist will not talk to a real project until you replace it.

### Sign in with Apple + Firebase

In the Firebase console Apple provider settings, add your app’s Services ID / Team ID / key as documented by Firebase. For a single iOS app, the bundle ID is usually enough once the capability is on the App ID.

## Run and verify

- Sign in with Apple works most reliably on a **physical iPhone**.
- Create a couple, copy the invite code, join from the second Apple ID.
- Add an at-home item (title only) and an outing (address, price, dates).
- Complete one item (Memories) and delete another.
- Settings → choose a widget photo.
- On the Home Screen, add the **Couples Do Things** widget (small / medium / large) and tap an item.

This Windows workspace cannot compile or run the iOS app. Use Xcode on a Mac.

## Layout

- `CouplesDoThings/` — SwiftUI app
- `CouplesDoThingsWidget/` — WidgetKit extension
- `Shared/` — App Group snapshot, deep links
- `firestore.rules` — member-only couple data
- `project.yml` — XcodeGen spec
