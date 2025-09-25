import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixabay_gallery/core/utils/responsive_helper.dart';
import 'package:pixabay_gallery/core/constants/app_constants.dart';

void main() {
  group('ResponsiveHelper Tests', () {
    // Helper method to create a MediaQuery with specific width
    Widget createResponsiveTestWidget(double width, {Widget? child}) {
      return MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: Size(width, 800)),
          child: Scaffold(body: child ?? Container()),
        ),
      );
    }

    group('Device Type Detection', () {
      testWidgets('should detect mobile correctly', (
        WidgetTester tester,
      ) async {
        // Test various mobile widths
        final mobileWidths = [300.0, 500.0, AppConstants.mobileBreakpoint - 1];

        for (final width in mobileWidths) {
          await tester.pumpWidget(
            createResponsiveTestWidget(
              width,
              child: Builder(
                builder: (context) {
                  expect(
                    ResponsiveHelper.isMobile(context),
                    true,
                    reason: 'Width $width should be detected as mobile',
                  );
                  expect(
                    ResponsiveHelper.isTablet(context),
                    false,
                    reason: 'Width $width should not be detected as tablet',
                  );
                  expect(
                    ResponsiveHelper.isDesktop(context),
                    false,
                    reason: 'Width $width should not be detected as desktop',
                  );
                  return Container();
                },
              ),
            ),
          );
        }
      });

      testWidgets('should detect tablet correctly', (
        WidgetTester tester,
      ) async {
        // Test various tablet widths
        final tabletWidths = [
          AppConstants.mobileBreakpoint,
          900.0,
          AppConstants.desktopBreakpoint - 1,
        ];

        for (final width in tabletWidths) {
          await tester.pumpWidget(
            createResponsiveTestWidget(
              width,
              child: Builder(
                builder: (context) {
                  expect(
                    ResponsiveHelper.isMobile(context),
                    false,
                    reason: 'Width $width should not be detected as mobile',
                  );
                  expect(
                    ResponsiveHelper.isTablet(context),
                    true,
                    reason: 'Width $width should be detected as tablet',
                  );
                  expect(
                    ResponsiveHelper.isDesktop(context),
                    false,
                    reason: 'Width $width should not be detected as desktop',
                  );
                  return Container();
                },
              ),
            ),
          );
        }
      });

      testWidgets('should detect desktop correctly', (
        WidgetTester tester,
      ) async {
        // Test various desktop widths
        final desktopWidths = [AppConstants.desktopBreakpoint, 1400.0, 1920.0];

        for (final width in desktopWidths) {
          await tester.pumpWidget(
            createResponsiveTestWidget(
              width,
              child: Builder(
                builder: (context) {
                  expect(
                    ResponsiveHelper.isMobile(context),
                    false,
                    reason: 'Width $width should not be detected as mobile',
                  );
                  expect(
                    ResponsiveHelper.isTablet(context),
                    false,
                    reason: 'Width $width should not be detected as tablet',
                  );
                  expect(
                    ResponsiveHelper.isDesktop(context),
                    true,
                    reason: 'Width $width should be detected as desktop',
                  );
                  return Container();
                },
              ),
            ),
          );
        }
      });

      testWidgets('should detect web correctly', (WidgetTester tester) async {
        // Test web widths (should be >= tabletBreakpoint)
        final webWidths = [AppConstants.tabletBreakpoint, 1300.0, 1920.0];

        for (final width in webWidths) {
          await tester.pumpWidget(
            createResponsiveTestWidget(
              width,
              child: Builder(
                builder: (context) {
                  expect(
                    ResponsiveHelper.isWeb(context),
                    true,
                    reason: 'Width $width should be detected as web',
                  );
                  return Container();
                },
              ),
            ),
          );
        }

        // Test non-web widths
        final nonWebWidths = [300.0, 500.0, AppConstants.tabletBreakpoint - 1];

        for (final width in nonWebWidths) {
          await tester.pumpWidget(
            createResponsiveTestWidget(
              width,
              child: Builder(
                builder: (context) {
                  expect(
                    ResponsiveHelper.isWeb(context),
                    false,
                    reason: 'Width $width should not be detected as web',
                  );
                  return Container();
                },
              ),
            ),
          );
        }
      });
    });

    group('Screen Size Utilities', () {
      testWidgets('should return correct screen size', (
        WidgetTester tester,
      ) async {
        const testWidth = 1200.0;
        const testHeight = 800.0;

        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(size: Size(testWidth, testHeight)),
              child: Scaffold(
                body: Builder(
                  builder: (context) {
                    final size = ResponsiveHelper.getScreenSize(context);
                    expect(size.width, testWidth);
                    expect(size.height, testHeight);
                    return Container();
                  },
                ),
              ),
            ),
          ),
        );
      });

      testWidgets('should return correct screen width', (
        WidgetTester tester,
      ) async {
        const testWidth = 1200.0;

        await tester.pumpWidget(
          createResponsiveTestWidget(
            testWidth,
            child: Builder(
              builder: (context) {
                expect(ResponsiveHelper.getScreenWidth(context), testWidth);
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('should return correct screen height', (
        WidgetTester tester,
      ) async {
        const testHeight = 900.0;

        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(size: Size(1200, testHeight)),
              child: Scaffold(
                body: Builder(
                  builder: (context) {
                    expect(
                      ResponsiveHelper.getScreenHeight(context),
                      testHeight,
                    );
                    return Container();
                  },
                ),
              ),
            ),
          ),
        );
      });
    });

    group('Responsive Value Selection', () {
      testWidgets('should return correct value based on screen size', (
        WidgetTester tester,
      ) async {
        // Test mobile value selection
        await tester.pumpWidget(
          createResponsiveTestWidget(
            400,
            child: Builder(
              builder: (context) {
                final value = ResponsiveHelper.responsive<int>(
                  context: context,
                  mobile: 1,
                  tablet: 2,
                  desktop: 3,
                );
                expect(value, 1, reason: 'Should return mobile value');
                return Container();
              },
            ),
          ),
        );

        // Test tablet value selection
        await tester.pumpWidget(
          createResponsiveTestWidget(
            800,
            child: Builder(
              builder: (context) {
                final value = ResponsiveHelper.responsive<int>(
                  context: context,
                  mobile: 1,
                  tablet: 2,
                  desktop: 3,
                );
                expect(value, 2, reason: 'Should return tablet value');
                return Container();
              },
            ),
          ),
        );

        // Test desktop value selection
        await tester.pumpWidget(
          createResponsiveTestWidget(
            1400,
            child: Builder(
              builder: (context) {
                final value = ResponsiveHelper.responsive<int>(
                  context: context,
                  mobile: 1,
                  tablet: 2,
                  desktop: 3,
                );
                expect(value, 3, reason: 'Should return desktop value');
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('should fall back to mobile value when others not provided', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createResponsiveTestWidget(
            800,
            child: Builder(
              builder: (context) {
                final value = ResponsiveHelper.responsive<String>(
                  context: context,
                  mobile: 'mobile',
                  // No tablet or desktop values provided
                );
                expect(
                  value,
                  'mobile',
                  reason: 'Should fall back to mobile value',
                );
                return Container();
              },
            ),
          ),
        );
      });
    });

    group('Grid Column Calculation', () {
      testWidgets(
        'should calculate correct number of columns for different screen sizes',
        (WidgetTester tester) async {
          // Test mobile columns
          await tester.pumpWidget(
            createResponsiveTestWidget(
              400,
              child: Builder(
                builder: (context) {
                  final columns = ResponsiveHelper.getGridColumns(context);
                  expect(
                    columns,
                    AppConstants.mobileGridColumns,
                    reason: 'Mobile should have correct columns',
                  );
                  return Container();
                },
              ),
            ),
          );

          // Test tablet columns
          await tester.pumpWidget(
            createResponsiveTestWidget(
              800,
              child: Builder(
                builder: (context) {
                  final columns = ResponsiveHelper.getGridColumns(context);
                  expect(
                    columns,
                    AppConstants.tabletGridColumns,
                    reason: 'Tablet should have correct columns',
                  );
                  return Container();
                },
              ),
            ),
          );

          // Test desktop columns
          await tester.pumpWidget(
            createResponsiveTestWidget(
              1400,
              child: Builder(
                builder: (context) {
                  final columns = ResponsiveHelper.getGridColumns(context);
                  expect(
                    columns,
                    AppConstants.desktopGridColumns,
                    reason: 'Desktop should have correct columns',
                  );
                  return Container();
                },
              ),
            ),
          );
        },
      );
    });

    group('Padding and Margin', () {
      testWidgets('should return correct responsive padding', (
        WidgetTester tester,
      ) async {
        // Test mobile padding
        await tester.pumpWidget(
          createResponsiveTestWidget(
            400,
            child: Builder(
              builder: (context) {
                final padding = ResponsiveHelper.responsivePadding(context);
                expect(
                  padding,
                  const EdgeInsets.all(AppConstants.spacingM),
                  reason: 'Mobile should have medium padding',
                );
                return Container();
              },
            ),
          ),
        );

        // Test tablet padding
        await tester.pumpWidget(
          createResponsiveTestWidget(
            800,
            child: Builder(
              builder: (context) {
                final padding = ResponsiveHelper.responsivePadding(context);
                expect(
                  padding,
                  const EdgeInsets.all(AppConstants.spacingL),
                  reason: 'Tablet should have large padding',
                );
                return Container();
              },
            ),
          ),
        );

        // Test desktop padding
        await tester.pumpWidget(
          createResponsiveTestWidget(
            1400,
            child: Builder(
              builder: (context) {
                final padding = ResponsiveHelper.responsivePadding(context);
                expect(
                  padding,
                  const EdgeInsets.all(AppConstants.spacingXL),
                  reason: 'Desktop should have extra large padding',
                );
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('should return correct responsive margin', (
        WidgetTester tester,
      ) async {
        // Test mobile margin
        await tester.pumpWidget(
          createResponsiveTestWidget(
            400,
            child: Builder(
              builder: (context) {
                final margin = ResponsiveHelper.responsiveMargin(context);
                expect(
                  margin,
                  const EdgeInsets.all(AppConstants.spacingS),
                  reason: 'Mobile should have small margin',
                );
                return Container();
              },
            ),
          ),
        );

        // Test tablet margin
        await tester.pumpWidget(
          createResponsiveTestWidget(
            800,
            child: Builder(
              builder: (context) {
                final margin = ResponsiveHelper.responsiveMargin(context);
                expect(
                  margin,
                  const EdgeInsets.all(AppConstants.spacingM),
                  reason: 'Tablet should have medium margin',
                );
                return Container();
              },
            ),
          ),
        );

        // Test desktop margin
        await tester.pumpWidget(
          createResponsiveTestWidget(
            1400,
            child: Builder(
              builder: (context) {
                final margin = ResponsiveHelper.responsiveMargin(context);
                expect(
                  margin,
                  const EdgeInsets.all(AppConstants.spacingL),
                  reason: 'Desktop should have large margin',
                );
                return Container();
              },
            ),
          ),
        );
      });
    });

    group('Navigation Helpers', () {
      testWidgets('should correctly determine when to show drawer', (
        WidgetTester tester,
      ) async {
        // Mobile should show drawer
        await tester.pumpWidget(
          createResponsiveTestWidget(
            400,
            child: Builder(
              builder: (context) {
                expect(
                  ResponsiveHelper.shouldShowDrawer(context),
                  true,
                  reason: 'Mobile should show drawer',
                );
                return Container();
              },
            ),
          ),
        );

        // Tablet should not show drawer
        await tester.pumpWidget(
          createResponsiveTestWidget(
            800,
            child: Builder(
              builder: (context) {
                expect(
                  ResponsiveHelper.shouldShowDrawer(context),
                  false,
                  reason: 'Tablet should not show drawer',
                );
                return Container();
              },
            ),
          ),
        );

        // Desktop should not show drawer
        await tester.pumpWidget(
          createResponsiveTestWidget(
            1400,
            child: Builder(
              builder: (context) {
                expect(
                  ResponsiveHelper.shouldShowDrawer(context),
                  false,
                  reason: 'Desktop should not show drawer',
                );
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('should correctly determine when to show navigation rail', (
        WidgetTester tester,
      ) async {
        // Mobile should not show navigation rail
        await tester.pumpWidget(
          createResponsiveTestWidget(
            400,
            child: Builder(
              builder: (context) {
                expect(
                  ResponsiveHelper.shouldShowNavigationRail(context),
                  false,
                  reason: 'Mobile should not show navigation rail',
                );
                return Container();
              },
            ),
          ),
        );

        // Tablet should show navigation rail
        await tester.pumpWidget(
          createResponsiveTestWidget(
            800,
            child: Builder(
              builder: (context) {
                expect(
                  ResponsiveHelper.shouldShowNavigationRail(context),
                  true,
                  reason: 'Tablet should show navigation rail',
                );
                return Container();
              },
            ),
          ),
        );

        // Desktop should show navigation rail
        await tester.pumpWidget(
          createResponsiveTestWidget(
            1400,
            child: Builder(
              builder: (context) {
                expect(
                  ResponsiveHelper.shouldShowNavigationRail(context),
                  true,
                  reason: 'Desktop should show navigation rail',
                );
                return Container();
              },
            ),
          ),
        );
      });
    });

    group('Breakpoint Constants', () {
      test('should have correct breakpoint values', () {
        expect(AppConstants.mobileBreakpoint, 768);
        expect(AppConstants.desktopBreakpoint, 1200);
        expect(AppConstants.tabletBreakpoint, 1200);
      });

      test('breakpoint order should be logical', () {
        expect(
          AppConstants.mobileBreakpoint <= AppConstants.desktopBreakpoint,
          true,
          reason:
              'Mobile breakpoint should be less than or equal to desktop breakpoint',
        );
        expect(
          AppConstants.tabletBreakpoint <= AppConstants.desktopBreakpoint,
          true,
          reason:
              'Tablet breakpoint should be less than or equal to desktop breakpoint',
        );
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle very small screen sizes', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createResponsiveTestWidget(
            100,
            child: Builder(
              builder: (context) {
                expect(ResponsiveHelper.isMobile(context), true);
                final columns = ResponsiveHelper.getGridColumns(context);
                expect(
                  columns,
                  greaterThan(0),
                  reason: 'Should always return at least 1 column',
                );
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('should handle very large screen sizes', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createResponsiveTestWidget(
            3000,
            child: Builder(
              builder: (context) {
                expect(ResponsiveHelper.isDesktop(context), true);
                final columns = ResponsiveHelper.getGridColumns(context);
                expect(
                  columns,
                  greaterThan(0),
                  reason: 'Should return a reasonable number of columns',
                );
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('should handle boundary values correctly', (
        WidgetTester tester,
      ) async {
        // Test exact breakpoint values
        await tester.pumpWidget(
          createResponsiveTestWidget(
            AppConstants.mobileBreakpoint.toDouble(),
            child: Builder(
              builder: (context) {
                expect(ResponsiveHelper.isMobile(context), false);
                expect(ResponsiveHelper.isTablet(context), true);
                return Container();
              },
            ),
          ),
        );

        await tester.pumpWidget(
          createResponsiveTestWidget(
            AppConstants.desktopBreakpoint.toDouble(),
            child: Builder(
              builder: (context) {
                expect(ResponsiveHelper.isTablet(context), false);
                expect(ResponsiveHelper.isDesktop(context), true);
                return Container();
              },
            ),
          ),
        );
      });
    });
  });
}
