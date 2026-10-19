# Cambodia Smart Traffic Flutter demo

A Flutter implementation of the screens and flows visible in the supplied Figma Make prototype.

## Run

```sh
flutter pub get
flutter run
```

Sign in with demo phone number `12345678` and verification code `123456`. No SMS is sent.

## Structure

```text
lib/
├── UI/                  # Screens, navigation and reusable widgets
│   └── widgets/
├── data/                # Figma sample records and local demo state
├── model/               # Violation, vehicle, notification and onboarding types
└── main.dart            # App entry point and theme
```

The app includes onboarding, demo sign-in, dashboard, violation search and filters, detail pages, appeals, payment review and history, vehicles, licence, notifications, and profile/settings screens. Sample records come from `lib/data/demo_data.dart`.

This is a local prototype. Demo payment only marks records paid in memory after confirmation; it does not transfer money. Appeals and profile changes are also in memory and reset when the app restarts. SMS, real evidence video, evidence uploads, government payment and registry services, support, Khmer translations, and dark mode still need integrations or implementation. The licence points preview is explicitly labelled as demo data.

Run checks with `flutter analyze` and `flutter test`.
