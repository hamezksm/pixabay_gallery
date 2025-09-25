import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

// Responsive helper utilities
class ResponsiveHelper {
  // Check device type based on width
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < AppConstants.mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= AppConstants.mobileBreakpoint &&
        width < AppConstants.desktopBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppConstants.desktopBreakpoint;
  }

  static bool isWeb(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppConstants.tabletBreakpoint;
  }

  // Get screen size information
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Responsive values based on screen size
  static T responsive<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }

  // Get responsive padding
  static EdgeInsets responsivePadding(BuildContext context) {
    return responsive(
      context: context,
      mobile: const EdgeInsets.all(AppConstants.spacingM),
      tablet: const EdgeInsets.all(AppConstants.spacingL),
      desktop: const EdgeInsets.all(AppConstants.spacingXL),
    );
  }

  // Get responsive margin
  static EdgeInsets responsiveMargin(BuildContext context) {
    return responsive(
      context: context,
      mobile: const EdgeInsets.all(AppConstants.spacingS),
      tablet: const EdgeInsets.all(AppConstants.spacingM),
      desktop: const EdgeInsets.all(AppConstants.spacingL),
    );
  }

  // Get grid column count
  static int getGridColumns(BuildContext context) {
    return responsive(
      context: context,
      mobile: AppConstants.mobileGridColumns,
      tablet: AppConstants.tabletGridColumns,
      desktop: AppConstants.desktopGridColumns,
    );
  }

  // Get responsive font size
  static double getResponsiveFontSize(
    BuildContext context, {
    required double baseFontSize,
    double? tabletMultiplier,
    double? desktopMultiplier,
  }) {
    return responsive(
      context: context,
      mobile: baseFontSize,
      tablet: baseFontSize * (tabletMultiplier ?? 1.1),
      desktop: baseFontSize * (desktopMultiplier ?? 1.2),
    );
  }

  // Get responsive spacing
  static double getResponsiveSpacing(
    BuildContext context, {
    required double baseSpacing,
    double? tabletMultiplier,
    double? desktopMultiplier,
  }) {
    return responsive(
      context: context,
      mobile: baseSpacing,
      tablet: baseSpacing * (tabletMultiplier ?? 1.2),
      desktop: baseSpacing * (desktopMultiplier ?? 1.5),
    );
  }

  // Check if should show navigation drawer (mobile)
  static bool shouldShowDrawer(BuildContext context) {
    return isMobile(context);
  }

  // Check if should show navigation rail (desktop/tablet)
  static bool shouldShowNavigationRail(BuildContext context) {
    return !isMobile(context);
  }

  // Get responsive image dimensions
  static double getImageCardHeight(BuildContext context) {
    return responsive(
      context: context,
      mobile: 150.0,
      tablet: 200.0,
      desktop: 250.0,
    );
  }

  static double getImageCardWidth(BuildContext context) {
    final screenWidth = getScreenWidth(context);
    final columns = getGridColumns(context);
    final padding = responsivePadding(context);
    final spacing = AppConstants.spacingM;

    return (screenWidth - padding.horizontal - (spacing * (columns - 1))) /
        columns;
  }

  // Get responsive gap for grids
  static double getGridGap(BuildContext context) {
    return responsive(
      context: context,
      mobile: AppConstants.spacingS,
      tablet: AppConstants.spacingM,
      desktop: AppConstants.spacingL,
    );
  }

  // Get responsive border radius
  static double getResponsiveBorderRadius(BuildContext context) {
    return responsive(
      context: context,
      mobile: AppConstants.cardBorderRadius * 0.8,
      tablet: AppConstants.cardBorderRadius,
      desktop: AppConstants.cardBorderRadius * 1.2,
    );
  }

  // Get responsive app bar height
  static double getAppBarHeight(BuildContext context) {
    return responsive(
      context: context,
      mobile: kToolbarHeight,
      tablet: kToolbarHeight + 8,
      desktop: kToolbarHeight + 16,
    );
  }

  // Get responsive list tile content padding
  static EdgeInsets getListTilePadding(BuildContext context) {
    return responsive(
      context: context,
      mobile: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingM,
        vertical: AppConstants.spacingS,
      ),
      tablet: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingL,
        vertical: AppConstants.spacingM,
      ),
      desktop: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingXL,
        vertical: AppConstants.spacingM,
      ),
    );
  }

  // Get responsive button size
  static Size getButtonSize(BuildContext context) {
    return responsive(
      context: context,
      mobile: const Size(double.infinity, 44),
      tablet: const Size(double.infinity, 48),
      desktop: const Size(double.infinity, 52),
    );
  }

  // Get responsive input field height
  static double getInputHeight(BuildContext context) {
    return responsive(
      context: context,
      mobile: 48.0,
      tablet: 52.0,
      desktop: 56.0,
    );
  }
}

// Extension for easier responsive access
extension ResponsiveExtension on BuildContext {
  bool get isMobile => ResponsiveHelper.isMobile(this);
  bool get isTablet => ResponsiveHelper.isTablet(this);
  bool get isDesktop => ResponsiveHelper.isDesktop(this);
  bool get isWeb => ResponsiveHelper.isWeb(this);

  Size get screenSize => ResponsiveHelper.getScreenSize(this);
  double get screenWidth => ResponsiveHelper.getScreenWidth(this);
  double get screenHeight => ResponsiveHelper.getScreenHeight(this);

  EdgeInsets get responsivePadding => ResponsiveHelper.responsivePadding(this);
  EdgeInsets get responsiveMargin => ResponsiveHelper.responsiveMargin(this);

  int get gridColumns => ResponsiveHelper.getGridColumns(this);
  double get gridGap => ResponsiveHelper.getGridGap(this);

  bool get shouldShowDrawer => ResponsiveHelper.shouldShowDrawer(this);
  bool get shouldShowNavigationRail =>
      ResponsiveHelper.shouldShowNavigationRail(this);
}
