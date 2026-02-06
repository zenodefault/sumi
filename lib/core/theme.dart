import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class FitnessTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: LightColors.primary,
      onPrimary: LightColors.primaryForeground,
      secondary: LightColors.secondary,
      onSecondary: LightColors.secondaryForeground,
      background: LightColors.background,
      onBackground: LightColors.foreground,
      surface: LightColors.card,
      onSurface: LightColors.cardForeground,
      error: LightColors.destructive,
      onError: LightColors.destructiveForeground,
      outline: LightColors.border,
      shadow: LightColors.border,
    ),
    scaffoldBackgroundColor: LightColors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: LightColors.card,
      foregroundColor: LightColors.foreground,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.bricolageGrotesque(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: LightColors.foreground,
      ),
    ),
    cardTheme: CardThemeData(
      color: LightColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      elevation: 4,
    ),
    textTheme: GoogleFonts.bricolageGrotesqueTextTheme().apply(
      bodyColor: LightColors.foreground,
      displayColor: LightColors.foreground,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: LightColors.primary,
        foregroundColor: LightColors.primaryForeground,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.bricolageGrotesque(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: LightColors.primary),
        foregroundColor: LightColors.primary,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.bricolageGrotesque(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: DarkColors.primary,
      onPrimary: DarkColors.primaryForeground,
      secondary: DarkColors.secondary,
      onSecondary: DarkColors.secondaryForeground,
      background: DarkColors.background,
      onBackground: DarkColors.foreground,
      surface: DarkColors.card,
      onSurface: DarkColors.cardForeground,
      error: DarkColors.destructive,
      onError: DarkColors.destructiveForeground,
      outline: DarkColors.border,
      shadow: DarkColors.border,
    ),
    scaffoldBackgroundColor: DarkColors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: DarkColors.card,
      foregroundColor: DarkColors.foreground,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.bricolageGrotesque(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: DarkColors.foreground,
      ),
    ),
    cardTheme: CardThemeData(
      color: DarkColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      elevation: 4,
    ),
    textTheme: GoogleFonts.bricolageGrotesqueTextTheme().apply(
      bodyColor: DarkColors.foreground,
      displayColor: DarkColors.foreground,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: DarkColors.primary,
        foregroundColor: DarkColors.primaryForeground,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.bricolageGrotesque(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: DarkColors.primary),
        foregroundColor: DarkColors.primary,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.bricolageGrotesque(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
