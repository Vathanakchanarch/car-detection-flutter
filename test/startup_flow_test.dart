import 'dart:async';

import 'package:car_detection/UI/onboarding_screen.dart';
import 'package:car_detection/UI/sign_in_screen.dart';
import 'package:car_detection/UI/splash_screen.dart';
import 'package:car_detection/data/demo_store.dart';
import 'package:car_detection/data/local/local_storage_service.dart';
import 'package:car_detection/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    demoStore.reset();
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('fresh startup shows splash, then onboarding, then sign in', (
    tester,
  ) async {
    final storage = await LocalStorageService.create();
    await tester.pumpWidget(
      SmartTrafficApp(storageFactory: () async => storage),
    );

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byType(OnboardingScreen), findsNothing);
    expect(find.byType(SignInScreen), findsNothing);

    await tester.pumpAndSettle();
    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.byType(SignInScreen), findsNothing);

    for (var i = 0; i < 2; i++) {
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(storage.isOnboardingCompleted(), isTrue);
    expect(find.byType(SignInScreen), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    demoStore.reset();
    await tester.pumpWidget(
      SmartTrafficApp(storageFactory: () async => storage),
    );
    expect(find.byType(SplashScreen), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byType(SignInScreen), findsOneWidget);
    expect(find.byType(OnboardingScreen), findsNothing);
  });

  testWidgets('returning startup shows splash and skips onboarding', (
    tester,
  ) async {
    final storage = await LocalStorageService.create();
    await storage.setOnboardingCompleted(true);
    await tester.pumpWidget(
      SmartTrafficApp(storageFactory: () async => storage),
    );

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byType(OnboardingScreen), findsNothing);
    await tester.pumpAndSettle();
    expect(find.byType(SignInScreen), findsOneWidget);
    expect(find.byType(OnboardingScreen), findsNothing);
  });

  testWidgets('startup never shows a destination before preferences load', (
    tester,
  ) async {
    final pendingStorage = Completer<LocalStorageService>();
    await tester.pumpWidget(
      SmartTrafficApp(storageFactory: () => pendingStorage.future),
    );

    await tester.pump(const Duration(seconds: 2));
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byType(OnboardingScreen), findsNothing);
    expect(find.byType(SignInScreen), findsNothing);

    final storage = await LocalStorageService.create();
    await storage.setOnboardingCompleted(true);
    pendingStorage.complete(storage);
    await tester.pumpAndSettle();
    expect(find.byType(SignInScreen), findsOneWidget);
  });

  testWidgets('debug reset makes onboarding reappear on next startup', (
    tester,
  ) async {
    final storage = await LocalStorageService.create();
    await storage.setOnboardingCompleted(true);
    await tester.pumpWidget(
      SmartTrafficApp(storageFactory: () async => storage),
    );
    await tester.pumpAndSettle();
    expect(find.byType(SignInScreen), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await storage.resetOnboardingForDebug();
    demoStore.reset();
    await tester.pumpWidget(
      SmartTrafficApp(storageFactory: () async => storage),
    );
    expect(find.byType(SplashScreen), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byType(OnboardingScreen), findsOneWidget);
  });

  for (final language in ['en', 'km']) {
    for (final dark in [false, true]) {
      testWidgets('splash fits 320px in $language ${dark ? 'dark' : 'light'}', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(const Size(320, 640));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final storage = await LocalStorageService.create();
        await storage.setLanguage(language);
        await storage.setDarkMode(dark);
        await tester.pumpWidget(
          SmartTrafficApp(storageFactory: () async => storage),
        );
        await tester.pump(const Duration(milliseconds: 200));

        expect(find.text('AICA'), findsOneWidget);
        expect(
          find.text(
            language == 'km'
                ? 'ចរាចរណ៍ឆ្លាតវៃកម្ពុជា'
                : 'Cambodia Smart Traffic',
          ),
          findsOneWidget,
        );
        expect(
          tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
          dark ? ThemeMode.dark : ThemeMode.light,
        );
        expect(tester.takeException(), isNull);

        await tester.pumpAndSettle();
        expect(find.byType(OnboardingScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
