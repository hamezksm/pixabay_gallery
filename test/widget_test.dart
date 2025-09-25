// Basic app integration test for Pixabay Gallery

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pixabay_gallery/main.dart';

void main() {
  testWidgets('App loads and shows initial content', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Wait for the app to load
    await tester.pumpAndSettle();

    // Verify that the app has loaded with expected content
    // The app should show the dashboard page initially
    expect(find.text('Pixabay Gallery'), findsWidgets);

    // Should have navigation elements
    final hasNavigation = find.byType(Scaffold).evaluate().isNotEmpty;
    expect(
      hasNavigation,
      isTrue,
      reason: 'App should have navigation structure',
    );
  });
}
