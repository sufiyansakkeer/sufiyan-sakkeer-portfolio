import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/config/design_system.dart';

class AppTheme {
  // Modern color palette
  // Light theme colors
  static const Color primaryColorLight = Color(0xFF2563EB); // Modern blue
  static const Color secondaryColorLight = Color(0xFF10B981); // Emerald green
  static const Color accentColorLight = Color(0xFFF59E0B); // Amber
  static const Color backgroundColorLight = Color(0xFFF9FAFB); // Off-white
  static const Color surfaceColorLight = Colors.white;
  static const Color textPrimaryLight = Color(0xFF111827); // Near black
  static const Color textSecondaryLight = Color(0xFF4B5563); // Dark gray

  // Dark theme colors
  static const Color primaryColorDark = Color(0xFF3B82F6); // Lighter blue
  static const Color secondaryColorDark = Color(0xFF34D399); // Lighter green
  static const Color accentColorDark = Color(0xFFFBBF24); // Lighter amber
  static const Color backgroundColorDark = Color(0xFF111827); // Dark blue-gray
  static const Color surfaceColorDark = Color(
    0xFF1F2937,
  ); // Lighter dark blue-gray
  static const Color textPrimaryDark = Color(0xFFF9FAFB); // Off-white
  static const Color textSecondaryDark = Color(0xFFD1D5DB); // Light gray

  static const Color errorColor = Color(0xFFEF4444); // Red

  // Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: primaryColorLight,
      secondary: secondaryColorLight,
      tertiary: accentColorLight,
      surface: surfaceColorLight,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textPrimaryLight,
    ),
    scaffoldBackgroundColor: backgroundColorLight,
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceColorLight,
      foregroundColor: textPrimaryLight,
      elevation: 0,
      centerTitle: true,
      shadowColor: Colors.black.withAlpha(13), // 0.05 opacity
      titleTextStyle: GoogleFonts.poppins(
        color: textPrimaryLight,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimaryLight,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimaryLight,
        letterSpacing: -0.5,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textPrimaryLight,
        letterSpacing: -0.25,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        color: textSecondaryLight,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        color: textSecondaryLight,
        height: 1.5,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColorLight,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: DesignSystem.spacingMd,
          vertical: DesignSystem.spacingSm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignSystem.radiusSm),
        ),
        elevation: DesignSystem.elevationSm,
      ).copyWith(
        elevation: WidgetStateProperty.resolveWith<double>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.hovered)) {
            return DesignSystem.elevationMd;
          }
          return DesignSystem.elevationSm;
        }),
        backgroundColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.disabled)) {
            return primaryColorLight.withAlpha(128); // 0.5 opacity
          }
          return primaryColorLight;
        }),
        overlayColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.hovered)) {
            return Colors.white.withAlpha(26); // 0.1 opacity
          }
          return null;
        }),
      ),
    ),
    cardTheme: DesignSystem.cardTheme(
      ColorScheme.light(surface: surfaceColorLight),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColorLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignSystem.radiusSm),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignSystem.radiusSm),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignSystem.radiusSm),
        borderSide: BorderSide(color: primaryColorLight, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacingSm,
        vertical: DesignSystem.spacingSm,
      ),
    ),
  );

  // Dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: primaryColorDark,
      secondary: secondaryColorDark,
      tertiary: accentColorDark,
      surface: surfaceColorDark,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: textPrimaryDark,
    ),
    scaffoldBackgroundColor: backgroundColorDark,
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceColorDark,
      foregroundColor: textPrimaryDark,
      elevation: 0,
      centerTitle: true,
      shadowColor: Colors.black.withAlpha(51), // 0.2 opacity
      titleTextStyle: GoogleFonts.poppins(
        color: textPrimaryDark,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimaryDark,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimaryDark,
        letterSpacing: -0.5,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textPrimaryDark,
        letterSpacing: -0.25,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        color: textSecondaryDark,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        color: textSecondaryDark,
        height: 1.5,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColorDark,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: DesignSystem.spacingMd,
          vertical: DesignSystem.spacingSm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignSystem.radiusSm),
        ),
        elevation: DesignSystem.elevationSm,
      ).copyWith(
        elevation: WidgetStateProperty.resolveWith<double>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.hovered)) {
            return DesignSystem.elevationMd;
          }
          return DesignSystem.elevationSm;
        }),
        backgroundColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.disabled)) {
            return primaryColorDark.withAlpha(128); // 0.5 opacity
          }
          return primaryColorDark;
        }),
        overlayColor: WidgetStateProperty.resolveWith<Color?>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.hovered)) {
            return Colors.white.withAlpha(26); // 0.1 opacity
          }
          return null;
        }),
      ),
    ),
    cardTheme: DesignSystem.cardTheme(
      ColorScheme.dark(surface: surfaceColorDark),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColorDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignSystem.radiusSm),
        borderSide: BorderSide(color: Colors.grey.shade800),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignSystem.radiusSm),
        borderSide: BorderSide(color: Colors.grey.shade800),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignSystem.radiusSm),
        borderSide: BorderSide(color: primaryColorDark, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacingSm,
        vertical: DesignSystem.spacingSm,
      ),
    ),
  );
}
