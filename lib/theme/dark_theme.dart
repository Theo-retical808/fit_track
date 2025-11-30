import 'package:flutter/material.dart';
import '../utils/constants.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppConstants.primaryColor,
  scaffoldBackgroundColor: AppConstants.backgroundColor,
  colorScheme: const ColorScheme.dark(
    primary: AppConstants.primaryColor,
    secondary: AppConstants.secondaryColor,
    surface: AppConstants.surfaceColor,
    error: AppConstants.errorColor,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppConstants.surfaceColor,
    elevation: 0,
  ),
  cardTheme: CardThemeData(
    color: AppConstants.surfaceColor,
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppConstants.primaryColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(color: AppConstants.textPrimaryColor, fontSize: 32, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(color: AppConstants.textPrimaryColor, fontSize: 24, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: AppConstants.textPrimaryColor, fontSize: 16),
    bodyMedium: TextStyle(color: AppConstants.textSecondaryColor, fontSize: 14),
  ),
);
