import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class ErrorWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;
  final bool showRetryButton;

  const ErrorWidget({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
    this.icon,
    this.showRetryButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: AppConstants.spacingL),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingM),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (showRetryButton && onRetry != null) ...[
              const SizedBox(height: AppConstants.spacingXL),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingL,
                    vertical: AppConstants.spacingM,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class NetworkErrorWidget extends ErrorWidget {
  const NetworkErrorWidget({super.key, required super.onRetry})
    : super(
        title: 'Network Error',
        message: AppConstants.networkErrorMessage,
        icon: Icons.wifi_off,
      );
}

class NoResultsWidget extends StatelessWidget {
  final String message;
  final IconData? icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  const NoResultsWidget({
    super.key,
    required this.message,
    this.icon,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(height: AppConstants.spacingL),
            Text(
              'No Results',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppConstants.spacingM),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: AppConstants.spacingXL),
              OutlinedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.refresh),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
