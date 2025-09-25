import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pixabay_gallery/presentation/widgets/main_layout.dart';
import 'package:pixabay_gallery/presentation/providers/theme_provider.dart';
import 'package:pixabay_gallery/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('MainLayout Navigation Widget Tests', () {
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

    // Helper to create testable widget
    Widget createTestWidget(Widget child, {double screenWidth = 800}) {
      return MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: Size(screenWidth, 600)),
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
            ],
            child: child,
          ),
        ),
      );
    }

    group('Responsive Navigation', () {
      testWidgets('should show sidebar on desktop', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            MainLayout(
              currentRoute: AppConstants.dashboardRoute,
              child: Text('Dashboard Content'),
            ),
            screenWidth: 1400, // Desktop width
          ),
        );

        // Should show sidebar (no drawer)
        expect(find.byType(Drawer), findsNothing);

        // Should show navigation items in sidebar - look for ListTile widgets
        expect(find.widgetWithText(ListTile, 'Dashboard'), findsOneWidget);
        expect(find.widgetWithText(ListTile, 'Gallery'), findsOneWidget);
        expect(find.widgetWithText(ListTile, 'Profile'), findsOneWidget);
      });

      testWidgets('should show sidebar on tablet', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            MainLayout(
              currentRoute: AppConstants.galleryRoute,
              child: Text('Gallery Content'),
            ),
            screenWidth: 900, // Tablet width
          ),
        );

        // Should show sidebar (no drawer)
        expect(find.byType(Drawer), findsNothing);

        // Should show navigation items - look for ListTile widgets
        expect(find.widgetWithText(ListTile, 'Dashboard'), findsOneWidget);
        expect(find.widgetWithText(ListTile, 'Gallery'), findsOneWidget);
        expect(find.widgetWithText(ListTile, 'Profile'), findsOneWidget);
      });

      testWidgets('should show drawer on mobile', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            Scaffold(
              body: MainLayout(
                currentRoute: AppConstants.profileRoute,
                child: Text('Profile Content'),
              ),
            ),
            screenWidth: 600, // Mobile width
          ),
        );

        // Should have app bar with menu icon for mobile
        expect(find.byIcon(Icons.menu), findsOneWidget);

        // The drawer should be available (but not visible until opened)
        final scaffolds = tester.widgetList<Scaffold>(find.byType(Scaffold));
        final mainScaffold = scaffolds.firstWhere(
          (scaffold) => scaffold.drawer != null,
          orElse: () => scaffolds.first,
        );
        expect(
          mainScaffold.drawer,
          isNotNull,
          reason: 'Mobile layout should have drawer available',
        );
      });
    });

    group('Navigation Items', () {
      testWidgets('should highlight current route', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            MainLayout(
              currentRoute: AppConstants.dashboardRoute,
              child: Text('Dashboard Content'),
            ),
            screenWidth: 1200, // Desktop width
          ),
        );

        // Find navigation items
        final dashboardTile = find.ancestor(
          of: find.text('Dashboard'),
          matching: find.byType(ListTile),
        );

        expect(dashboardTile, findsOneWidget);

        // The current route should be highlighted (this would need actual implementation checking)
        final listTile = tester.widget<ListTile>(dashboardTile);
        expect(
          listTile.selected,
          true,
          reason: 'Current route should be highlighted',
        );
      });

      testWidgets('should show all navigation items', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            MainLayout(
              currentRoute: AppConstants.dashboardRoute,
              child: Text('Content'),
            ),
            screenWidth: 1200,
          ),
        );

        // Should show all three navigation items - look for ListTile widgets
        expect(find.widgetWithText(ListTile, 'Dashboard'), findsOneWidget);
        expect(find.widgetWithText(ListTile, 'Gallery'), findsOneWidget);
        expect(find.widgetWithText(ListTile, 'Profile'), findsOneWidget);

        // Should show appropriate icons
        expect(find.byIcon(Icons.dashboard), findsOneWidget);
        expect(find.byIcon(Icons.photo_library_outlined), findsOneWidget);
        expect(find.byIcon(Icons.person_outline), findsOneWidget);
      });
    });

    group('Theme Toggle', () {
      testWidgets('should show theme toggle button', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            MainLayout(
              currentRoute: AppConstants.dashboardRoute,
              child: Text('Content'),
            ),
          ),
        );

        // Should show theme toggle icon (either light_mode or dark_mode)
        final hasLightMode = find
            .byIcon(Icons.light_mode)
            .evaluate()
            .isNotEmpty;
        final hasDarkMode = find.byIcon(Icons.dark_mode).evaluate().isNotEmpty;
        expect(
          hasLightMode || hasDarkMode,
          isTrue,
          reason: 'Should show either light_mode or dark_mode icon',
        );
      });

      testWidgets('should toggle theme when pressed', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            MainLayout(
              currentRoute: AppConstants.dashboardRoute,
              child: Text('Content'),
            ),
          ),
        );

        // Initial theme mode
        final initialThemeMode = themeProvider.themeMode;

        // Tap theme toggle - find the IconButton that contains theme toggle icons
        final themeToggleFinder = find.byWidgetPredicate((widget) {
          return widget is IconButton &&
              (widget.icon is Icon) &&
              ((widget.icon as Icon).icon == Icons.light_mode ||
                  (widget.icon as Icon).icon == Icons.dark_mode);
        });

        expect(themeToggleFinder, findsWidgets);
        await tester.tap(themeToggleFinder.first);
        await tester.pump();

        // Theme should have changed
        expect(themeProvider.themeMode, isNot(equals(initialThemeMode)));
      });
    });

    group('App Bar', () {
      testWidgets('should show app bar with title', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            MainLayout(
              currentRoute: AppConstants.dashboardRoute,
              child: Text('Content'),
            ),
          ),
        );

        // Should show app bar
        expect(find.byType(AppBar), findsOneWidget);

        // Should show app title
        expect(find.text('Pixabay Gallery'), findsOneWidget);
      });

      testWidgets('should show menu button on mobile', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            Scaffold(
              body: MainLayout(
                currentRoute: AppConstants.dashboardRoute,
                child: Text('Content'),
              ),
            ),
            screenWidth: 600, // Mobile width
          ),
        );

        // Should show menu icon on mobile
        expect(find.byIcon(Icons.menu), findsOneWidget);
      });

      testWidgets('should not show menu button on desktop', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            MainLayout(
              currentRoute: AppConstants.dashboardRoute,
              child: Text('Content'),
            ),
            screenWidth: 1400, // Desktop width
          ),
        );

        // Should not show menu icon on desktop
        expect(find.byIcon(Icons.menu), findsNothing);
      });
    });

    group('Content Area', () {
      testWidgets('should display child content', (WidgetTester tester) async {
        const testContent = 'Test Content Widget';

        await tester.pumpWidget(
          createTestWidget(
            MainLayout(
              currentRoute: AppConstants.dashboardRoute,
              child: Text(testContent),
            ),
          ),
        );

        // Should display the child content
        expect(find.text(testContent), findsOneWidget);
      });

      testWidgets('should have proper layout structure', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            MainLayout(
              currentRoute: AppConstants.dashboardRoute,
              child: Text('Content'),
            ),
            screenWidth: 1200, // Desktop width
          ),
        );

        // Should have scaffold structure
        expect(find.byType(Scaffold), findsOneWidget);

        // Should have row for sidebar layout
        expect(find.byType(Row), findsAtLeastNWidgets(1));

        // Should have expanded widget for content area
        expect(find.byType(Expanded), findsAtLeastNWidgets(1));
      });
    });

    group('Drawer Functionality', () {
      testWidgets('should open drawer on mobile when menu tapped', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            Scaffold(
              body: MainLayout(
                currentRoute: AppConstants.dashboardRoute,
                child: Text('Content'),
              ),
            ),
            screenWidth: 600, // Mobile width
          ),
        );

        // Initially drawer should be closed - page title still shows
        expect(find.widgetWithText(ListTile, 'Dashboard'), findsNothing);

        // Tap menu button to open drawer
        await tester.tap(find.byIcon(Icons.menu));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300)); // Animation

        // Now navigation items should be visible in drawer - look for ListTile widgets
        expect(find.widgetWithText(ListTile, 'Dashboard'), findsOneWidget);
        expect(find.widgetWithText(ListTile, 'Gallery'), findsOneWidget);
        expect(find.widgetWithText(ListTile, 'Profile'), findsOneWidget);
      });

      testWidgets('should contain same navigation items as sidebar', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            Scaffold(
              body: MainLayout(
                currentRoute: AppConstants.dashboardRoute,
                child: Text('Content'),
              ),
            ),
            screenWidth: 600, // Mobile width
          ),
        );

        // Open drawer
        await tester.tap(find.byIcon(Icons.menu));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Should show all navigation items with icons - look for ListTile widgets
        expect(find.widgetWithText(ListTile, 'Dashboard'), findsOneWidget);
        expect(find.widgetWithText(ListTile, 'Gallery'), findsOneWidget);
        expect(find.widgetWithText(ListTile, 'Profile'), findsOneWidget);
        expect(find.byIcon(Icons.dashboard), findsOneWidget);
        expect(find.byIcon(Icons.photo_library_outlined), findsOneWidget);
        expect(find.byIcon(Icons.person_outline), findsOneWidget);
      });
    });

    group('Responsive Breakpoints', () {
      testWidgets('should switch layout at mobile breakpoint', (
        WidgetTester tester,
      ) async {
        // Test just above mobile breakpoint (tablet)
        await tester.pumpWidget(
          createTestWidget(
            MainLayout(
              currentRoute: AppConstants.dashboardRoute,
              child: Text('Content'),
            ),
            screenWidth: AppConstants.mobileBreakpoint.toDouble() + 1,
          ),
        );

        // Should show sidebar (no drawer)
        expect(find.byType(Drawer), findsNothing);
        expect(find.widgetWithText(ListTile, 'Dashboard'), findsOneWidget);

        // Test just below mobile breakpoint
        await tester.pumpWidget(
          createTestWidget(
            Scaffold(
              body: MainLayout(
                currentRoute: AppConstants.dashboardRoute,
                child: Text('Content'),
              ),
            ),
            screenWidth: AppConstants.mobileBreakpoint.toDouble() - 1,
          ),
        );

        await tester.pump();

        // Should show menu icon and drawer should be available
        expect(find.byIcon(Icons.menu), findsOneWidget);
        final scaffolds = tester.widgetList<Scaffold>(find.byType(Scaffold));
        final mainScaffold = scaffolds.firstWhere(
          (scaffold) => scaffold.drawer != null,
          orElse: () => scaffolds.first,
        );
        expect(
          mainScaffold.drawer,
          isNotNull,
          reason: 'Mobile layout should have drawer available',
        );
      });
    });
  });
}
