---
title: "Mobile App Documentation"
type: "standard"
status: "approved"
owner: "@mobile-team"
classification: "public"
created: "2025-12-10"
last_updated: "2025-12-10"
version: "1.0.0"
---

# Mobile App Documentation

> **Goal:** Document mobile apps (iOS, Android, React Native, Flutter) so developers understand platform-specific behaviors, build processes, and app store requirements.

---

## 1. Mobile App README

### Required Structure

Every mobile app MUST have a comprehensive README:

```markdown
# [App Name] Mobile App

## Quick Start

| Platform | Command |
|----------|---------|
| iOS | `cd ios && pod install && npm run ios` |
| Android | `npm run android` |
| Both | `npm start` |

## Requirements

| Tool | Version | Installation |
|------|---------|--------------|
| Node.js | 20+ | `nvm install 20` |
| Xcode | 15+ | App Store |
| Android Studio | 2024.1+ | [Download](https://developer.android.com/studio) |
| CocoaPods | 1.14+ | `gem install cocoapods` |
| Java JDK | 17 | `brew install openjdk@17` |

## Environment Setup

1. Clone the repo
2. Copy `.env.example` to `.env`
3. Install dependencies: `npm install`
4. iOS: `cd ios && pod install`
5. Android: Open `android/` in Android Studio, sync Gradle

## Build & Deploy

| Environment | iOS | Android |
|-------------|-----|---------|
| Development | `npm run ios:dev` | `npm run android:dev` |
| Staging | `npm run ios:staging` | `npm run android:staging` |
| Production | Fastlane (CI) | Fastlane (CI) |

## App Store Links

| Store | Link |
|-------|------|
| App Store | [Download](https://apps.apple.com/app/id123456) |
| Play Store | [Download](https://play.google.com/store/apps/details?id=com.example) |
| TestFlight | [Beta](https://testflight.apple.com/join/xxxxx) |
```

---

## 2. Platform-Specific Documentation

### iOS Documentation

```markdown
# iOS-Specific Documentation

## Certificates & Provisioning

| Type | Expiry | Location |
|------|--------|----------|
| Distribution Certificate | 2026-01-15 | Apple Developer Portal |
| Push Notification Cert | 2025-06-01 | Apple Developer Portal |
| Provisioning Profile | 2025-12-01 | Fastlane Match |

## Keychain & Signing

- **Team ID:** ABC123DEF
- **Bundle ID:** com.example.app
- **Signing:** Automatic via Fastlane Match

## Required Capabilities

- [x] Push Notifications
- [x] Background Modes (fetch, remote-notification)
- [x] Associated Domains (for deep links)
- [x] Sign in with Apple

## Info.plist Keys

| Key | Value | Reason |
|-----|-------|--------|
| `NSCameraUsageDescription` | "Take profile photos" | Profile picture upload |
| `NSLocationWhenInUseUsageDescription` | "Find nearby stores" | Store locator feature |
| `NSPhotoLibraryUsageDescription` | "Select photos" | Profile picture upload |
```

### Android Documentation

```markdown
# Android-Specific Documentation

## Signing Keys

| Key | Location | Backup |
|-----|----------|--------|
| Debug Keystore | `~/.android/debug.keystore` | N/A |
| Release Keystore | 1Password Vault | AWS S3 (encrypted) |

## Gradle Configuration

| Property | Value |
|----------|-------|
| `minSdkVersion` | 24 (Android 7.0) |
| `targetSdkVersion` | 34 (Android 14) |
| `compileSdkVersion` | 34 |

## Permissions

| Permission | Reason | Runtime? |
|------------|--------|----------|
| `INTERNET` | API calls | No |
| `CAMERA` | Profile photos | Yes |
| `ACCESS_FINE_LOCATION` | Store locator | Yes |
| `POST_NOTIFICATIONS` | Push notifications | Yes (Android 13+) |

## ProGuard Rules

Custom rules in `android/app/proguard-rules.pro` for:
- Retrofit
- Gson
- React Native (if applicable)
```

---

## 3. React Native / Flutter Documentation

### React Native

```markdown
# React Native Documentation

## Architecture

| Layer | Technology |
|-------|------------|
| UI | React Native + React Navigation |
| State | Redux Toolkit + RTK Query |
| Storage | AsyncStorage + MMKV |
| Network | Axios + React Query |

## Native Modules

| Module | Purpose | Platforms |
|--------|---------|-----------|
| `RNBiometrics` | Face ID / Fingerprint | iOS, Android |
| `RNPushNotification` | Push handling | iOS, Android |
| `RNShare` | Native share sheet | iOS, Android |

## Metro Configuration

See `metro.config.js` for:
- Custom resolver paths
- Asset extensions
- Transformer settings

## Hermes Engine

Enabled for both platforms for improved performance.
```

### Flutter

```markdown
# Flutter Documentation

## Architecture

| Layer | Technology |
|-------|------------|
| UI | Flutter Widgets + Material 3 |
| State | BLoC + flutter_bloc |
| DI | GetIt + Injectable |
| Network | Dio + Retrofit |

## Platform Channels

| Channel | Purpose | Method |
|---------|---------|--------|
| `com.example/biometrics` | Local auth | Invoke |
| `com.example/share` | Native share | Invoke |

## Build Flavors

| Flavor | Bundle ID | API URL |
|--------|-----------|---------|
| dev | com.example.dev | api-dev.example.com |
| staging | com.example.staging | api-staging.example.com |
| prod | com.example.app | api.example.com |
```

---

## 4. Deep Linking Documentation

```markdown
# Deep Linking

## URL Schemes

| Platform | Scheme | Example |
|----------|--------|---------|
| iOS | `myapp://` | `myapp://product/123` |
| Android | `myapp://` | `myapp://product/123` |
| Universal | `https://app.example.com` | `https://app.example.com/product/123` |

## Supported Deep Links

| Path | Screen | Parameters |
|------|--------|------------|
| `/product/:id` | ProductDetail | `id` (required) |
| `/order/:id` | OrderDetail | `id` (required) |
| `/settings` | Settings | none |
| `/auth/reset` | PasswordReset | `token` (query) |

## Associated Domains (iOS)

File: `apple-app-site-association` on `https://app.example.com/.well-known/`

## App Links (Android)

File: `assetlinks.json` on `https://app.example.com/.well-known/`
```

---

## 5. Push Notification Documentation

```markdown
# Push Notifications

## Provider

Firebase Cloud Messaging (FCM) for both platforms.

## Notification Types

| Type | Trigger | Behavior |
|------|---------|----------|
| Order Update | Backend event | Show notification + badge |
| Marketing | Scheduled campaign | Show notification |
| Silent | Data sync | Background refresh |

## Payload Structure

```json
{
  "notification": {
    "title": "Order Shipped",
    "body": "Your order #123 is on the way"
  },
  "data": {
    "type": "order_update",
    "order_id": "123",
    "deep_link": "/order/123"
  }
}
```

## Testing

- iOS: Use Push Notification Console or `xcrun simctl push`
- Android: FCM Console or `adb shell am broadcast`

```

---

## 6. App Store Documentation

### App Store Connect (iOS)

```markdown
# App Store Metadata

## App Information

| Field | Value |
|-------|-------|
| App Name | My App |
| Subtitle | Do amazing things |
| Category | Shopping |
| Age Rating | 4+ |

## Screenshots Required

| Device | Sizes |
|--------|-------|
| iPhone 6.7" | 1290 x 2796 |
| iPhone 6.5" | 1284 x 2778 |
| iPad 12.9" | 2048 x 2732 |

## Release Notes Template

```

What's New in v2.3.0:

• New feature: Quick checkout
• Improved: Search performance
• Fixed: Login issues on iOS 17

```
```

---

## 7. Related Documents

| Document | Purpose |
|----------|---------|
| [CI/CD Pipelines](./22-CICD_PIPELINES.md) | Fastlane, app builds |
| [Testing](./30-TESTING.md) | Mobile testing strategies |
| [API Documentation](./18-API_DOCUMENTATION.md) | Backend APIs |

---

**Previous:** [27 - Postmortems](./27-POSTMORTEMS.md)
**Next:** [29 - ML Model Cards](./29-ML_MODEL_CARDS.md)
