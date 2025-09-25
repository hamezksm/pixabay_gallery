// App-wide constants
class AppConstants {
  // App Info
  static const String appName = 'Pixabay Gallery';
  static const String appVersion = '1.0.0';

  // Navigation
  static const String dashboardRoute = '/dashboard';
  static const String galleryRoute = '/gallery';
  static const String profileRoute = '/profile';

  // Responsive Breakpoints
  static const double mobileBreakpoint = 768;
  static const double tabletBreakpoint = 1200;
  static const double desktopBreakpoint = 1200;

  // UI Constants
  static const double navigationWidth = 280;
  static const double cardBorderRadius = 12.0;
  static const double buttonBorderRadius = 8.0;
  static const double inputBorderRadius = 8.0;

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Animation Durations
  static const int shortAnimationDuration = 200;
  static const int mediumAnimationDuration = 300;
  static const int longAnimationDuration = 500;

  // Image Sizes
  static const double imageCardHeight = 200;
  static const double thumbnailSize = 150;
  static const double profileImageSize = 120;

  // Grid Settings
  static const int mobileGridColumns = 1;
  static const int tabletGridColumns = 3;
  static const int desktopGridColumns = 4;

  // Form Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const int maxEmailLength = 100;

  // Storage Keys
  static const String themeKey = 'theme_mode';
  static const String userPreferencesKey = 'user_preferences';
  static const String searchHistoryKey = 'search_history';

  // Error Messages
  static const String networkErrorMessage =
      'Network error. Please check your connection and try again.';
  static const String unknownErrorMessage =
      'An unexpected error occurred. Please try again.';
  static const String noResultsMessage =
      'No images found. Try a different search term.';
  static const String loadingMessage = 'Loading...';

  // Success Messages
  static const String profileSavedMessage = 'Profile saved successfully!';
  static const String searchCompletedMessage = 'Search completed';
}
