import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/responsive_helper.dart';
import '../providers/image_provider.dart';
import '../widgets/main_layout.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentRoute: AppConstants.galleryRoute,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        // Search section
        _buildSearchSection(context),

        // Results section
        Expanded(child: _buildResultsSection(context)),
      ],
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingL),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search Images',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveHelper.responsive<double>(
                context: context,
                mobile: 20,
                tablet: 24,
                desktop: 28,
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spacingS),
          Text(
            'Find beautiful images from Pixabay',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              fontSize: ResponsiveHelper.responsive<double>(
                context: context,
                mobile: 14,
                tablet: 15,
                desktop: 16,
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spacingL),
          _buildSearchBar(context),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Consumer<GalleryProvider>(
      builder: (context, provider, child) {
        return TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: InputDecoration(
            hintText: 'Search for images... (e.g., "cats", "nature", "cars")',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      provider.clearSearchResults();
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.inputBorderRadius,
              ),
            ),
          ),
          onChanged: (value) => setState(() {}),
          onSubmitted: (query) {
            if (query.trim().isNotEmpty) {
              provider.searchImages(query.trim(), refresh: true);
            }
          },
        );
      },
    );
  }

  Widget _buildResultsSection(BuildContext context) {
    return Consumer<GalleryProvider>(
      builder: (context, provider, child) {
        if (provider.currentSearchQuery.isEmpty) {
          return _buildEmptyState(context);
        }

        if (provider.isLoadingSearch && provider.searchResults.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.errorMessage != null && provider.searchResults.isEmpty) {
          return _buildErrorWidget(context, provider);
        }

        if (provider.searchResults.isEmpty) {
          return _buildNoResultsWidget(context, provider.currentSearchQuery);
        }

        return _buildImageResults(context, provider);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_search,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          ),
          const SizedBox(height: AppConstants.spacingL),
          Text(
            'Start your search',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: AppConstants.spacingM),
          Text(
            'Enter keywords in the search bar to find amazing images',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildImageResults(BuildContext context, GalleryProvider provider) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!provider.isLoadingSearch &&
            provider.hasMoreImages &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          provider.loadMoreSearchResults();
        }
        return false;
      },
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.spacingL),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Text(
                    'Search results for "${provider.currentSearchQuery}"',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingS),
                  Text(
                    '(${provider.searchResults.length} images)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Image grid/list
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingL,
            ),
            sliver: isMobile
                ? _buildImageList(context, provider)
                : _buildImageGrid(context, provider),
          ),

          // Loading indicator
          if (provider.isLoadingSearch)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(AppConstants.spacingL),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageGrid(BuildContext context, GalleryProvider provider) {
    final crossAxisCount = ResponsiveHelper.getGridColumns(context);

    return SliverGrid(
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
      delegate: SliverChildBuilderDelegate((context, index) {
        final image = provider.searchResults[index];
        return _buildImageCard(context, image);
      }, childCount: provider.searchResults.length),
    );
  }

  Widget _buildImageList(BuildContext context, GalleryProvider provider) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final image = provider.searchResults[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppConstants.spacingM),
          child: _buildImageListItem(context, image),
        );
      }, childCount: provider.searchResults.length),
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
                color: Theme.of(context).colorScheme.surfaceVariant,
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
              padding: const EdgeInsets.all(AppConstants.spacingM),
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
                      child: Text(
                        image.tags,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.7),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                        ).colorScheme.onSurface.withOpacity(0.6),
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

  Widget _buildImageListItem(BuildContext context, dynamic image) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: Row(
        children: [
          // Image thumbnail
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
            ),
            child: Image.network(
              image.webformatURL,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Icon(Icons.broken_image, size: 32));
              },
            ),
          ),

          // Image info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photographer name
                  Text(
                    'By ${image.user}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingS),

                  // Tags
                  if (image.tags.isNotEmpty) ...[
                    Text(
                      image.tags,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppConstants.spacingS),
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
                        ).colorScheme.onSurface.withOpacity(0.6),
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
            'Error loading images',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppConstants.spacingM),
          Text(
            provider.errorMessage ?? 'Unknown error occurred',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingXL),
          ElevatedButton.icon(
            onPressed: () {
              if (provider.currentSearchQuery.isNotEmpty) {
                provider.searchImages(
                  provider.currentSearchQuery,
                  refresh: true,
                );
              }
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsWidget(BuildContext context, String query) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          ),
          const SizedBox(height: AppConstants.spacingL),
          Text(
            'No results found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppConstants.spacingM),
          Text(
            'No images found for "$query".\nTry different keywords.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
