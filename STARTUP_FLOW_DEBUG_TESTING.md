# AICA startup flow on Linux

The app now shows a brief AICA splash while its existing local preferences load. It then opens Onboarding when completion is absent, or Sign In when completion was saved.

To retest the first launch in a **debug** Linux build:

```sh
flutter run -d linux --dart-define=AICA_RESET_ONBOARDING=true
```

That launch removes only the saved onboarding completion key. Language, dark mode, and read notification IDs remain saved. Complete onboarding with **Get Started** (or **Skip**) to save completion again. Quit the app completely, then run without the flag:

```sh
flutter run -d linux
```

The returning launch should show Splash, then Sign In. To repeat the first-launch test, run the first command again. The reset flag is ignored outside debug builds, and there is no reset control in the app UI.
