// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppTheme {
  // Colores principales - Diseño moderno deportivo
  static const Color primaryGreen = Color(0xFF1B5E3F); // Verde oscuro deportivo
  static const Color accentOrange = Color(0xFFFF6B35); // Naranja vibrante
  static const Color accentBlue = Color(0xFF004E89); // Azul profundo
  static const Color lightAccent = Color(0xFF00D4FF); // Cyan claro
  static const Color goldAccent = Color(0xFFFFA500); // Dorado deportivo
  static const Color blackAccent = Color(0xFF0A0E27); // Negro profundo
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGrey = Color(0xFFF0F2F5);
  static const Color darkGrey = Color(0xFF6C757D);
  static const Color successGreen = Color(0xFF00C896);
  static const Color errorRed = Color(0xFFE74C3C);

  static Color withOpacity(Color color, double opacity) =>
      color.withAlpha((opacity * 255).round());

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        brightness: Brightness.light,
        primary: primaryGreen,
        secondary: accentOrange,
        tertiary: accentBlue,
        surface: white,
      ),
      scaffoldBackgroundColor: lightGrey,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryGreen,
        foregroundColor: white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: white,
          letterSpacing: 0.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentOrange,
          foregroundColor: white,
          elevation: 8,
          shadowColor: withOpacity(accentOrange, 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 8,
        shadowColor: withOpacity(blackAccent, 0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: white,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: lightGrey, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: lightGrey, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: accentOrange, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: errorRed, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        hintStyle: TextStyle(color: darkGrey.withOpacity(0.6)),
        labelStyle: const TextStyle(
          color: blackAccent,
          fontWeight: FontWeight.w500,
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: blackAccent,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: blackAccent,
          letterSpacing: -0.3,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: blackAccent,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: blackAccent,
          letterSpacing: 0.2,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: blackAccent,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: blackAccent,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: darkGrey,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: darkGrey,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: darkGrey,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
