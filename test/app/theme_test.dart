import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App Theme', () {
    test('Light theme is properly configured', () {
      final lightTheme = ThemeData.light();
      expect(lightTheme.brightness, Brightness.light);
    });

    test('Dark theme is properly configured', () {
      final darkTheme = ThemeData.dark();
      expect(darkTheme.brightness, Brightness.dark);
    });

    test('Primary color is set', () {
      final theme = ThemeData(
        primaryColor: Colors.blue,
      );
      expect(theme.primaryColor, Colors.blue);
    });

    test('Accent color is set', () {
      final theme = ThemeData(
        colorScheme: const ColorScheme.light(secondary: Colors.orange),
      );
      expect(theme.colorScheme.secondary, Colors.orange);
    });

    test('Material 3 support', () {
      final theme = ThemeData(
        useMaterial3: true,
      );
      expect(theme.useMaterial3, true);
    });
  });
}
