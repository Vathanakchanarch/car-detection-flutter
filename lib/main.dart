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
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: Color(0xFF102A43),
          fontSize: 28,
          fontWeight: FontWeight.w800,
        ),
        bodyLarge: TextStyle(
          color: Color(0xFF526579),
          fontSize: 15,
          height: 1.55,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0x732563EB),
          disabledForegroundColor: const Color(0xBFFFFFFF),
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFC9D5E2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFC9D5E2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
        ),
      ),
      dividerTheme: const DividerThemeData(color: Color(0xFFC9D5E2)),
    ),
    home: const OnboardingScreen(),
  );
}
