import 'package:flutter/material.dart';

class AppTextTheme extends TextTheme {
  const AppTextTheme() : super(
            displayLarge: const TextStyle(),
            displayMedium: const TextStyle(),
            displaySmall: const TextStyle(),
            headlineLarge: const TextStyle(),
            headlineMedium: const TextStyle(),
            headlineSmall: const TextStyle(),
            titleLarge: const TextStyle(),
            titleMedium: const TextStyle(),
            titleSmall: const TextStyle(),
            bodyLarge: const TextStyle(),
            bodyMedium: const TextStyle(fontWeight: FontWeight.w600),
            bodySmall: const TextStyle(),
            labelLarge: const TextStyle(),
            labelMedium: const TextStyle(),
        );
}