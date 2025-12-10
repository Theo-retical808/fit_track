import 'package:flutter/material.dart';

class AppConstants {
  // Colors
  static const Color primaryColor = Color.fromARGB(255, 62, 83, 100);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color backgroundColor = Color(0xFF121212);
  static const Color surfaceColor = Color(0xFF1E1E1E);
  static const Color errorColor = Color(0xFFCF6679);
  static const Color textPrimaryColor = Color(0xFFFFFFFF);
  static const Color textSecondaryColor = Color(0xFFB3B3B3);

  // Exercise types
  static const List<String> exerciseTypes = [
    'Running',
    'Walking',
    'Cycling',
    'Swimming',
    'Gym',
  ];

  // MET values (Metabolic Equivalent of Task)
  static const Map<String, double> metValues = {
    'Running': 9.8,
    'Walking': 3.5,
    'Cycling': 7.5,
    'Swimming': 8.0,
    'Gym': 5.0,
  };

  // App strings
  static const String appName = 'Thenix Fitness';
  static const String appQuote = 'Transform Your Body, Transform Your Life';
}
