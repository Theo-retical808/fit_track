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

  // Distance-based exercises (tracked by GPS)
  static const List<String> distanceExercises = [
    'Running',
    'Walking',
    'Cycling',
    'Swimming',
  ];

  // Time-based exercises (tracked by repetitions/time)
  static const List<String> timeExercises = [
    'Push Ups',
    'Curl Ups',
    'Pull Ups',
    'Squats',
    'Planks',
  ];

  // All exercise types
  static List<String> get exerciseTypes => [...distanceExercises, ...timeExercises];

  // MET values (Metabolic Equivalent of Task)
  static const Map<String, double> metValues = {
    'Running': 9.8,
    'Walking': 3.5,
    'Cycling': 7.5,
    'Swimming': 8.0,
    'Push Ups': 6.0,
    'Curl Ups': 4.5,
    'Pull Ups': 8.0,
    'Squats': 5.0,
    'Planks': 3.5,
  };

  // Check if exercise is distance-based
  static bool isDistanceExercise(String exerciseType) {
    return distanceExercises.contains(exerciseType);
  }

  // Check if exercise is time-based
  static bool isTimeExercise(String exerciseType) {
    return timeExercises.contains(exerciseType);
  }

  // App strings
  static const String appName = 'Thenix Fitness';
  static const String appQuote = 'Transform Your Body, Transform Your Life';
}
