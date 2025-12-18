import 'package:flutter/material.dart';

class FitnessTheme {
 static const Color primary = Colors.white;
  static const Color backgroundLight = Color(0xFFF3F4F6); // Light grey for light mode background
  static const Color backgroundDark = Color(0xFF000000); // Black for dark mode background
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF1C1C1E);
  static const Color cardSecondaryLight = Color(0xFFE5E7EB);
  static const Color cardSecondaryDark = Color(0xFF2C2C2E);
  static const Color textPrimaryLight = Color(0xFF111827);
  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textSecondaryDark = Color(0xFF8E8E93);
  static const Color accentPurple = Color(0xFFBF5AF2);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: accentPurple,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: backgroundLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: cardLight,
      foregroundColor: textPrimaryLight,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: cardLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textPrimaryLight),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimaryLight),
      headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textPrimaryLight),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimaryLight),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textPrimaryLight),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: textPrimaryLight),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: textPrimaryLight),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: accentPurple,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: backgroundDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: cardDark,
      foregroundColor: textPrimaryDark,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: cardDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textPrimaryDark),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimaryDark),
      headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textPrimaryDark),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimaryDark),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textPrimaryDark),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: textPrimaryDark),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: textPrimaryDark),
    ),
  );
}