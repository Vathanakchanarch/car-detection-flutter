import 'package:flutter/material.dart';

import 'app_colors.dart';

ThemeData buildLightTheme() => ThemeData(
  useMaterial3: true,
  fontFamily: aicaFontFamily,
  fontFamilyFallback: khmerFontFallback,
  scaffoldBackgroundColor: const Color(0xFFF8FAFC),
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
  textTheme: const TextTheme(
    headlineMedium: TextStyle(
      fontFamily: aicaFontFamily,
      fontFamilyFallback: khmerFontFallback,
      color: Color(0xFF102A43),
      fontSize: 28,
      fontWeight: FontWeight.w800,
    ),
    bodyLarge: TextStyle(
      fontFamily: aicaFontFamily,
      fontFamilyFallback: khmerFontFallback,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textStyle: const TextStyle(
        fontFamily: aicaFontFamily,
        fontFamilyFallback: khmerFontFallback,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
);

ThemeData buildDarkTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF2563EB),
    brightness: Brightness.dark,
    surface: const Color(0xFF172536),
  );
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    fontFamily: aicaFontFamily,
    fontFamilyFallback: khmerFontFallback,
  ).copyWith(
    filledButtonTheme: buildLightTheme().filledButtonTheme,
    colorScheme: scheme,
    scaffoldBackgroundColor: const Color(0xFF0E1928),
    textTheme: buildLightTheme().textTheme.apply(
      bodyColor: const Color(0xFFE6EDF5),
      displayColor: const Color(0xFFE6EDF5),
    ),
    dividerTheme: const DividerThemeData(color: Color(0xFF3B4D63)),
    inputDecorationTheme: buildLightTheme().inputDecorationTheme.copyWith(
      fillColor: const Color(0xFF172536),
      hintStyle: const TextStyle(
        fontFamily: aicaFontFamily,
        fontFamilyFallback: khmerFontFallback,
        color: Color(0xFFAFBED0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF3B4D63)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: scheme.surface,
      titleTextStyle: const TextStyle(
        fontFamily: aicaFontFamily,
        fontFamilyFallback: khmerFontFallback,
        color: Color(0xFFE6EDF5),
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
      contentTextStyle: const TextStyle(
        fontFamily: aicaFontFamily,
        fontFamilyFallback: khmerFontFallback,
        color: Color(0xFFAFBED0),
        fontSize: 14,
        height: 1.5,
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: scheme.surface),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: scheme.primary),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(foregroundColor: scheme.primary),
    ),
  );
}
