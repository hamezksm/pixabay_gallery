import 'package:flutter/material.dart';
import '../../data/models/pixabay_image.dart';
import '../../data/models/user_profile.dart' as models;
import '../../data/services/api_service.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/app_constants.dart';

// Image data provider
class GalleryProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<PixabayImage> _trendingImages = [];
  List<PixabayImage> _searchResults = [];
  bool _isLoadingTrending = false;
  bool _isLoadingSearch = false;
  String? _errorMessage;
  String _currentSearchQuery = '';
  int _currentPage = 1;
  bool _hasMoreImages = true;

  // Getters
  List<PixabayImage> get trendingImages => _trendingImages;
  List<PixabayImage> get searchResults => _searchResults;
  bool get isLoadingTrending => _isLoadingTrending;
  bool get isLoadingSearch => _isLoadingSearch;
  bool get isLoading => _isLoadingTrending || _isLoadingSearch;
  String? get errorMessage => _errorMessage;
  String get currentSearchQuery => _currentSearchQuery;
  bool get hasMoreImages => _hasMoreImages;

  // Load trending images for dashboard
  Future<void> loadTrendingImages({bool refresh = false}) async {
    if (_isLoadingTrending) return;

    if (refresh) {
      _trendingImages.clear();
    }

    _isLoadingTrending = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getTrendingImages(
        page: refresh ? 1 : _currentPage,
        perPage: ApiConstants.defaultPerPage,
      );

      if (refresh) {
        _trendingImages = response.hits;
      } else {
        _trendingImages.addAll(response.hits);
      }

      _hasMoreImages = response.hits.isNotEmpty;
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
    } finally {
      _isLoadingTrending = false;
      notifyListeners();
    }
  }

  // Search for images
  Future<void> searchImages(String query, {bool refresh = false}) async {
    if (_isLoadingSearch) return;

    if (query.trim().isEmpty) {
      clearSearchResults();
      return;
    }

    if (refresh || query != _currentSearchQuery) {
      _searchResults.clear();
      _currentPage = 1;
      _currentSearchQuery = query;
    }

    _isLoadingSearch = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.searchImages(
        query: query,
        page: _currentPage,
        perPage: ApiConstants.defaultPerPage,
      );

      if (refresh || query != _currentSearchQuery) {
        _searchResults = response.hits;
      } else {
        _searchResults.addAll(response.hits);
      }

      _hasMoreImages = response.hits.isNotEmpty;
      _currentPage++;
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
    } finally {
      _isLoadingSearch = false;
      notifyListeners();
    }
  }

  // Load more search results
  Future<void> loadMoreSearchResults() async {
    if (_currentSearchQuery.isNotEmpty && _hasMoreImages && !_isLoadingSearch) {
      await searchImages(_currentSearchQuery);
    }
  }

  // Clear search results
  void clearSearchResults() {
    _searchResults.clear();
    _currentSearchQuery = '';
    _currentPage = 1;
    _hasMoreImages = true;
    _errorMessage = null;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Get human-readable error message
  String _getErrorMessage(dynamic error) {
    if (error is ApiException) {
      return error.message;
    } else if (error is NetworkException) {
      return AppConstants.networkErrorMessage;
    } else {
      return AppConstants.unknownErrorMessage;
    }
  }

  // Refresh all data
  Future<void> refreshAll() async {
    await Future.wait([
      loadTrendingImages(refresh: true),
      if (_currentSearchQuery.isNotEmpty)
        searchImages(_currentSearchQuery, refresh: true),
    ]);
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}

// Profile form provider
class ProfileProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  models.FormState _formState = models.FormState.initial();

  models.FormState get formState => _formState;
  bool get isLoading => _formState.status == models.FormStatus.loading;
  bool get hasError => _formState.status == models.FormStatus.error;
  bool get isSuccess => _formState.status == models.FormStatus.success;

  // Submit user profile
  Future<void> submitProfile(models.UserProfile profile) async {
    _formState = _formState.copyWith(status: models.FormStatus.loading);
    notifyListeners();

    try {
      final response = await _apiService.submitUserProfile(profile);

      _formState = _formState.copyWith(
        status: models.FormStatus.success,
        profile: profile.copyWith(id: response.id),
        response: response,
      );
    } catch (e) {
      _formState = _formState.copyWith(
        status: models.FormStatus.error,
        errorMessage: e is ApiException
            ? e.message
            : AppConstants.unknownErrorMessage,
      );
    }

    notifyListeners();
  }

  // Update profile data
  void updateProfile(models.UserProfile profile) {
    _formState = _formState.copyWith(profile: profile);
    notifyListeners();
  }

  // Reset form
  void resetForm() {
    _formState = models.FormState.initial();
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _formState = _formState.copyWith(
      status: models.FormStatus.initial,
      errorMessage: null,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}
