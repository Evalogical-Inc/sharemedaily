import 'package:flutter/material.dart';
import 'package:quotify/config/constants/colors.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    fontFamily: 'Figtree',
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    indicatorColor: Colors.black,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Color(0xff232242),
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.8,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        color: Color(0xff494949),
        letterSpacing: 1,
      ),
      bodyMedium: TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.black),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    fontFamily: 'Figtree',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color.fromARGB(255, 7, 7, 7),
    indicatorColor: Colors.white,
    textTheme: TextTheme(
      titleLarge: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Color(0xffffffff),
      ),
      titleMedium: const TextStyle(
        fontSize: 20,
        color: AppColors.white,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.8,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        color: AppColors.white.withOpacity(0.8),
        letterSpacing: 1,
      ),
      bodyMedium: const TextStyle(
        color: AppColors.white,
        fontSize: 16,
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  );
}
