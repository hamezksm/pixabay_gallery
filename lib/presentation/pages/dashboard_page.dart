import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/responsive_helper.dart';
import '../providers/image_provider.dart';
import '../widgets/main_layout.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GalleryProvider>().loadTrendingImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentRoute: AppConstants.dashboardRoute,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Consumer<GalleryProvider>(
      builder: (context, galleryProvider, child) {
        if (galleryProvider.isLoadingTrending &&
            galleryProvider.trendingImages.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (galleryProvider.errorMessage != null &&
            galleryProvider.trendingImages.isEmpty) {
          return _buildErrorWidget(context, galleryProvider);
        }

        return RefreshIndicator(
          onRefresh: () => galleryProvider.loadTrendingImages(refresh: true),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section
                _buildHeader(context),
                const SizedBox(height: AppConstants.spacingXL),

                // Trending images grid
                _buildTrendingImagesGrid(context, galleryProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trending Images',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: ResponsiveHelper.responsive<double>(
              context: context,
              mobile: 24,
              tablet: 28,
              desktop: 32,
            ),
          ),
        ),
        const SizedBox(height: AppConstants.spacingS),
        Text(
          'Discover the most popular images on Pixabay',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
            fontSize: ResponsiveHelper.responsive<double>(
              context: context,
              mobile: 14,
              tablet: 16,
              desktop: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingImagesGrid(
    BuildContext context,
    GalleryProvider provider,
  ) {
    if (provider.trendingImages.isEmpty) {
      return const Center(child: Text('No trending images available'));
    }

    final crossAxisCount = ResponsiveHelper.getGridColumns(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: ResponsiveHelper.responsive<double>(
          context: context,
          mobile: 0.75,
          tablet: 0.8,
          desktop: 0.85,
        ),
        crossAxisSpacing: ResponsiveHelper.responsive<double>(
          context: context,
          mobile: AppConstants.spacingS,
          tablet: AppConstants.spacingM,
          desktop: AppConstants.spacingL,
        ),
        mainAxisSpacing: ResponsiveHelper.responsive<double>(
          context: context,
          mobile: AppConstants.spacingS,
          tablet: AppConstants.spacingM,
          desktop: AppConstants.spacingL,
        ),
      ),
      itemCount: provider.trendingImages.length,
      itemBuilder: (context, index) {
        final image = provider.trendingImages[index];
        return _buildImageCard(context, image);
      },
    );
  }

  Widget _buildImageCard(BuildContext context, dynamic image) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image thumbnail
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              child: Image.network(
                image.webformatURL,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.broken_image, size: 48),
                  );
                },
              ),
            ),
          ),

          // Image info
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(
                ResponsiveHelper.responsive<double>(
                  context: context,
                  mobile: AppConstants.spacingS,
                  tablet: AppConstants.spacingM,
                  desktop: AppConstants.spacingM,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photographer name
                  Text(
                    'By ${image.user}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppConstants.spacingXS),

                  // Tags
                  if (image.tags.isNotEmpty) ...[
                    Expanded(
                      child: Wrap(
                        spacing: AppConstants.spacingXS,
                        runSpacing: AppConstants.spacingXS,
                        children: image.tags.split(',').take(3).map<Widget>((
                          tag,
                        ) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.spacingS,
                              vertical: AppConstants.spacingXS,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                AppConstants.inputBorderRadius,
                              ),
                            ),
                            child: Text(
                              tag.trim(),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontSize: 10,
                                  ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],

                  // Stats row
                  Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        size: 16,
                        color: Colors.red.shade400,
                      ),
                      const SizedBox(width: AppConstants.spacingXS),
                      Text(
                        '${image.likes}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: AppConstants.spacingM),
                      Icon(
                        Icons.visibility,
                        size: 16,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: AppConstants.spacingXS),
                      Text(
                        '${image.views}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, GalleryProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: AppConstants.spacingL),
          Text(
            'Error loading trending images',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppConstants.spacingM),
          Text(
            provider.errorMessage ?? 'Unknown error occurred',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingXL),
          ElevatedButton.icon(
            onPressed: () => provider.loadTrendingImages(refresh: true),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
