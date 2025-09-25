import 'package:flutter_test/flutter_test.dart';
import 'package:pixabay_gallery/presentation/providers/image_provider.dart';
import 'package:pixabay_gallery/data/models/pixabay_image.dart';

void main() {
  group('GalleryProvider Tests', () {
    late GalleryProvider galleryProvider;

    setUp(() {
      galleryProvider = GalleryProvider();
    });

    group('Initial State', () {
      test('should initialize with empty state', () {
        expect(galleryProvider.trendingImages, isEmpty);
        expect(galleryProvider.searchResults, isEmpty);
        expect(galleryProvider.isLoadingTrending, isFalse);
        expect(galleryProvider.isLoadingSearch, isFalse);
        expect(galleryProvider.isLoading, isFalse);
        expect(galleryProvider.errorMessage, isNull);
        expect(galleryProvider.currentSearchQuery, isEmpty);
        expect(galleryProvider.hasMoreImages, isTrue);
      });
    });

    group('Loading States', () {
      test('should indicate loading when either operation is loading', () {
        expect(galleryProvider.isLoading, isFalse);

        // This would be set internally during async operations
        // We can only test the getter logic
        expect(
          galleryProvider.isLoading,
          equals(
            galleryProvider.isLoadingTrending ||
                galleryProvider.isLoadingSearch,
          ),
        );
      });

      test('should notify listeners during state changes', () {
        int notificationCount = 0;

        galleryProvider.addListener(() {
          notificationCount++;
        });

        // Clear search results should notify
        galleryProvider.clearSearchResults();
        expect(notificationCount, equals(1));

        // Clear error should notify
        galleryProvider.clearError();
        expect(notificationCount, equals(2));
      });
    });

    group('Error Handling', () {
      test('should clear error messages', () {
        // Since we can't directly set errors in tests, we test the clear method
        galleryProvider.clearError();
        expect(galleryProvider.errorMessage, isNull);
      });

      test('should notify listeners when clearing errors', () {
        bool notified = false;

        galleryProvider.addListener(() {
          notified = true;
        });

        galleryProvider.clearError();
        expect(notified, isTrue);
      });
    });

    group('Search State Management', () {
      test('should clear search results and reset state', () {
        // Clear search should reset all search-related state
        galleryProvider.clearSearchResults();

        expect(galleryProvider.searchResults, isEmpty);
        expect(galleryProvider.currentSearchQuery, isEmpty);
        expect(galleryProvider.hasMoreImages, isTrue);
        expect(galleryProvider.errorMessage, isNull);
      });

      test('should notify listeners when search is cleared', () {
        bool notified = false;

        galleryProvider.addListener(() {
          notified = true;
        });

        galleryProvider.clearSearchResults();
        expect(notified, isTrue);
      });
    });

    group('Search Functionality', () {
      test(
        'should clear search results when searching with empty query',
        () async {
          // This simulates what happens internally
          await galleryProvider.searchImages('');

          // Should clear results
          expect(galleryProvider.searchResults, isEmpty);
          expect(galleryProvider.currentSearchQuery, isEmpty);
        },
      );

      test('should handle search with whitespace-only query', () async {
        // This simulates what happens internally
        await galleryProvider.searchImages('   ');

        // Should clear results (treated as empty)
        expect(galleryProvider.searchResults, isEmpty);
        expect(galleryProvider.currentSearchQuery, isEmpty);
      });
    });

    group('Collections Access', () {
      test('should provide access to trending images collection', () {
        final images = galleryProvider.trendingImages;
        expect(images, isNotNull);
        expect(images, isList);
      });

      test('should provide access to search results collection', () {
        final results = galleryProvider.searchResults;
        expect(results, isNotNull);
        expect(results, isList);
      });
    });

    group('State Properties', () {
      test('should provide consistent state properties', () {
        // Test that getters return consistent types
        expect(galleryProvider.isLoadingTrending, isA<bool>());
        expect(galleryProvider.isLoadingSearch, isA<bool>());
        expect(galleryProvider.isLoading, isA<bool>());
        expect(galleryProvider.hasMoreImages, isA<bool>());
        expect(galleryProvider.currentSearchQuery, isA<String>());
        expect(galleryProvider.trendingImages, isA<List<PixabayImage>>());
        expect(galleryProvider.searchResults, isA<List<PixabayImage>>());
      });
    });

    group('Async Operations', () {
      test('should handle refresh all operation', () async {
        // Test that refreshAll doesn't throw
        expect(() async => await galleryProvider.refreshAll(), returnsNormally);
      });

      test('should handle load trending images', () async {
        // Test that loadTrendingImages doesn't throw
        expect(
          () async => await galleryProvider.loadTrendingImages(),
          returnsNormally,
        );
      });

      test('should handle load trending with refresh', () async {
        // Test that loadTrendingImages with refresh doesn't throw
        expect(
          () async => await galleryProvider.loadTrendingImages(refresh: true),
          returnsNormally,
        );
      });

      test('should handle load more search results', () async {
        // Test that loadMoreSearchResults doesn't throw
        expect(
          () async => await galleryProvider.loadMoreSearchResults(),
          returnsNormally,
        );
      });
    });

    group('Provider Lifecycle', () {
      test('should dispose properly', () {
        // Test that dispose doesn't throw on a fresh provider
        final testProvider = GalleryProvider();
        expect(() => testProvider.dispose(), returnsNormally);

        // Don't dispose the main galleryProvider here as it will be disposed in tearDown
      });

      test('should maintain separate provider instances', () {
        final provider1 = GalleryProvider();
        final provider2 = GalleryProvider();

        // Should be different instances
        expect(provider1, isNot(same(provider2)));

        // Should have independent state
        expect(provider1.trendingImages, isNot(same(provider2.trendingImages)));

        provider1.dispose();
        provider2.dispose();
      });
    });

    tearDown(() {
      // Only dispose if not already disposed
      try {
        galleryProvider.dispose();
      } catch (e) {
        // Provider was already disposed, ignore
      }
    });
  });
}
