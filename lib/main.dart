import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/app_provider.dart';
import 'presentation/providers/image_provider.dart';
import 'presentation/pages/dashboard_page.dart';
import 'presentation/pages/gallery_page.dart';
import 'presentation/pages/profile_page.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => GalleryProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}

// Router configuration
final GoRouter _router = GoRouter(
  initialLocation: AppConstants.dashboardRoute,
  routes: [
    GoRoute(
      path: AppConstants.dashboardRoute,
      name: 'dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: AppConstants.galleryRoute,
      name: 'gallery',
      builder: (context, state) => const GalleryPage(),
    ),
    GoRoute(
      path: AppConstants.profileRoute,
      name: 'profile',
      builder: (context, state) => const ProfilePage(),
    ),
  ],
);
