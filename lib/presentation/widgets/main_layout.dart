import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/responsive_helper.dart';
import '../providers/theme_provider.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final String currentRoute;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveHelper.isDesktop(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: isMobile ? _buildDrawer(context) : null,
      body: Row(
        children: [
          // Left sidebar for desktop and tablet
          if (isDesktop || isTablet) _buildSidebar(context),

          // Main content area
          Expanded(
            child: Column(
              children: [
                // App bar
                _buildAppBar(context),

                // Page content
                Expanded(child: widget.child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          // Mobile menu button
          if (isMobile) ...[
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            const SizedBox(width: AppConstants.spacingS),
          ],

          // Page title
          Text(
            _getPageTitle(widget.currentRoute),
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        // Theme toggle button
        _buildThemeToggle(context),
        const SizedBox(width: AppConstants.spacingM),
      ],
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: AppConstants.navigationWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App logo/title
          _buildAppHeader(context),

          // Navigation items
          Expanded(child: _buildNavigationItems(context)),

          // Footer with theme toggle
          _buildSidebarFooter(context),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer header
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.photo_library,
                  size: 40,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                const SizedBox(height: AppConstants.spacingM),
                Text(
                  AppConstants.appName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Navigation items
          Expanded(child: _buildNavigationItems(context)),

          // Footer
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'v${AppConstants.appVersion}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                _buildThemeToggle(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingL),
      child: Row(
        children: [
          Icon(
            Icons.photo_library,
            size: 32,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: AppConstants.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppConstants.appName,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Gallery Explorer',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItems(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingM,
        vertical: AppConstants.spacingS,
      ),
      children: [
        _buildNavigationItem(
          context,
          icon: Icons.dashboard,
          title: 'Dashboard',
          route: AppConstants.dashboardRoute,
          isSelected: widget.currentRoute == AppConstants.dashboardRoute,
        ),
        const SizedBox(height: AppConstants.spacingXS),
        _buildNavigationItem(
          context,
          icon: Icons.photo_library_outlined,
          title: 'Gallery',
          route: AppConstants.galleryRoute,
          isSelected: widget.currentRoute == AppConstants.galleryRoute,
        ),
        const SizedBox(height: AppConstants.spacingXS),
        _buildNavigationItem(
          context,
          icon: Icons.person_outline,
          title: 'Profile',
          route: AppConstants.profileRoute,
          isSelected: widget.currentRoute == AppConstants.profileRoute,
        ),
      ],
    );
  }

  Widget _buildNavigationItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
    required bool isSelected,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
      ),
      onTap: () {
        if (route != widget.currentRoute) {
          context.go(route);

          // Close drawer if mobile
          if (ResponsiveHelper.isMobile(context)) {
            Navigator.of(context).pop();
          }
        }
      },
    );
  }

  Widget _buildSidebarFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingL),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'v${AppConstants.appVersion}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          _buildThemeToggle(context),
        ],
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return IconButton(
          icon: Icon(
            themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
          ),
          tooltip: themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
          onPressed: () => themeProvider.toggleTheme(),
        );
      },
    );
  }

  String _getPageTitle(String route) {
    switch (route) {
      case AppConstants.dashboardRoute:
        return 'Dashboard';
      case AppConstants.galleryRoute:
        return 'Gallery';
      case AppConstants.profileRoute:
        return 'Profile';
      default:
        return AppConstants.appName;
    }
  }
}
