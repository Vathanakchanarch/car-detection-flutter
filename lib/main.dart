import 'package:flutter/material.dart';

import 'l10n/generated/app_localizations.dart';
import 'theme/app_theme.dart';

import 'UI/onboarding_screen.dart';
import 'UI/sign_in_screen.dart';
import 'UI/widgets/app_components.dart';
import 'data/demo_store.dart';
import 'data/local/local_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localStorage = await LocalStorageService.create();
  await demoStore.initialize(localStorage);
  runApp(const SmartTrafficApp());
}

class SmartTrafficApp extends StatelessWidget {
  const SmartTrafficApp({super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: demoStore,
    builder: (context, _) => MaterialApp(
      title: 'Cambodia Smart Traffic',
      navigatorObservers: [ClearMessagesOnNavigation()],
      builder: (context, child) => Center(
        child: SizedBox(width: mobileContentWidth, child: child),
      ),
      debugShowCheckedModeBanner: false,
      locale: Locale(demoStore.languageCode),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: demoStore.darkMode ? ThemeMode.dark : ThemeMode.light,
      home: demoStore.hasCompletedOnboarding
          ? const SignInScreen()
          : const OnboardingScreen(),
    ),
  );
}
