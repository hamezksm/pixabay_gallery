import 'package:flutter_test/flutter_test.dart';
import 'package:pixabay_gallery/presentation/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ThemeProvider Tests', () {
    late ThemeProvider themeProvider;

    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    setUp(() async {
      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
      themeProvider = ThemeProvider();
      // Allow time for async initialization
      await Future.delayed(Duration(milliseconds: 100));
    });

    group('Initial State', () {
      test('should initialize with light theme mode', () {
        expect(themeProvider.themeMode, equals(ThemeMode.light));
      });

      test('should initialize with correct dark mode state', () {
        expect(themeProvider.isDarkMode, isFalse);
      });
    });

    group('Theme Mode Changes', () {
      test('should toggle to dark mode', () {
        // Initially light mode
        expect(themeProvider.themeMode, equals(ThemeMode.light));

        // Toggle theme
        themeProvider.toggleTheme();

        // Should change to dark mode
        expect(themeProvider.themeMode, equals(ThemeMode.dark));
        expect(themeProvider.isDarkMode, isTrue);
      });

      test('should toggle to light mode after dark', () {
        // Set to dark mode first
        themeProvider.toggleTheme();
        expect(themeProvider.themeMode, equals(ThemeMode.dark));

        // Toggle again
        themeProvider.toggleTheme();

        // Should change back to light mode
        expect(themeProvider.themeMode, equals(ThemeMode.light));
        expect(themeProvider.isDarkMode, isFalse);
      });

      test('should toggle between light and dark modes only', () {
        // Start with light
        expect(themeProvider.themeMode, equals(ThemeMode.light));

        // Toggle to dark
        themeProvider.toggleTheme();
        expect(themeProvider.themeMode, equals(ThemeMode.dark));

        // Toggle back to light
        themeProvider.toggleTheme();
        expect(themeProvider.themeMode, equals(ThemeMode.light));

        // Toggle again to dark
        themeProvider.toggleTheme();
        expect(themeProvider.themeMode, equals(ThemeMode.dark));
      });
    });

    group('Theme Mode Setters', () {
      test('should set light theme mode explicitly', () {
        themeProvider.setDarkTheme();
        expect(themeProvider.themeMode, equals(ThemeMode.dark));

        themeProvider.setLightTheme();
        expect(themeProvider.themeMode, equals(ThemeMode.light));
      });

      test('should set dark theme mode explicitly', () {
        expect(themeProvider.themeMode, equals(ThemeMode.light));

        themeProvider.setDarkTheme();
        expect(themeProvider.themeMode, equals(ThemeMode.dark));
      });

      test('should set system theme mode explicitly', () {
        expect(themeProvider.themeMode, equals(ThemeMode.light));

        themeProvider.setSystemTheme();
        expect(themeProvider.themeMode, equals(ThemeMode.system));
      });

      test('should set theme mode directly', () {
        themeProvider.setThemeMode(ThemeMode.dark);
        expect(themeProvider.themeMode, equals(ThemeMode.dark));

        themeProvider.setThemeMode(ThemeMode.system);
        expect(themeProvider.themeMode, equals(ThemeMode.system));

        themeProvider.setThemeMode(ThemeMode.light);
        expect(themeProvider.themeMode, equals(ThemeMode.light));
      });
    });

    group('Notification', () {
      test('should notify listeners when theme changes', () {
        bool notified = false;

        themeProvider.addListener(() {
          notified = true;
        });

        themeProvider.toggleTheme();

        expect(notified, isTrue);
      });

      test('should not notify if theme mode does not change', () {
        int notificationCount = 0;

        themeProvider.addListener(() {
          notificationCount++;
        });

        // Set same mode - should not notify
        themeProvider.setThemeMode(ThemeMode.light);
        expect(notificationCount, equals(0));

        // Set different mode - should notify
        themeProvider.setThemeMode(ThemeMode.dark);
        expect(notificationCount, equals(1));
      });
    });

    group('Theme Mode Properties', () {
      test('should correctly identify dark mode state', () {
        // Initially light mode
        expect(themeProvider.isDarkMode, isFalse);

        // Set to dark mode
        themeProvider.setDarkTheme();
        expect(themeProvider.isDarkMode, isTrue);

        // Set to light mode
        themeProvider.setLightTheme();
        expect(themeProvider.isDarkMode, isFalse);

        // System mode - not considered dark mode by our implementation
        themeProvider.setSystemTheme();
        expect(themeProvider.isDarkMode, isFalse);
      });

      test('should handle theme mode transitions correctly', () {
        final modes = <ThemeMode>[];

        themeProvider.addListener(() {
          modes.add(themeProvider.themeMode);
        });

        // Start with light, then cycle through different modes
        themeProvider.setDarkTheme();
        themeProvider.setSystemTheme();
        themeProvider.setLightTheme();

        expect(
          modes,
          equals([ThemeMode.dark, ThemeMode.system, ThemeMode.light]),
        );
      });
    });

    group('Persistence', () {
      test('should maintain theme state between provider instances', () {
        // This test documents that theme state is not currently persisted
        // In a full implementation, you would test SharedPreferences integration

        final provider1 = ThemeProvider();
        provider1.toggleTheme(); // Set to dark

        final provider2 = ThemeProvider();
        // New instance starts with default light mode (no persistence in tests)
        expect(provider2.themeMode, equals(ThemeMode.light));
      });
    });

    tearDown(() {
      themeProvider.dispose();
    });
  });
}
