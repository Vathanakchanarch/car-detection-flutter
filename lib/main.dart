import 'package:flutter/material.dart';

import 'UI/onboarding_screen.dart';

void main() => runApp(const SmartTrafficApp());

class SmartTrafficApp extends StatelessWidget {
  const SmartTrafficApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Cambodia Smart Traffic',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF8FAFD),
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2864E9)),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: Color(0xFF17324A),
          fontSize: 28,
          fontWeight: FontWeight.w800,
        ),
        bodyLarge: TextStyle(
          color: Color(0xFF647487),
          fontSize: 16,
          height: 1.5,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF2864E9),
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    ),
    home: const OnboardingScreen(),
  );
}
