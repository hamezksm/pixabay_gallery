import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

// Global app state provider
class AppProvider extends ChangeNotifier {
  String _currentRoute = AppConstants.dashboardRoute;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String get currentRoute => _currentRoute;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Navigation state
  void setCurrentRoute(String route) {
    if (_currentRoute != route) {
      _currentRoute = route;
      notifyListeners();
    }
  }

  bool isCurrentRoute(String route) {
    return _currentRoute == route;
  }

  // Loading state
  void setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  // Error handling
  void setError(String? error) {
    if (_errorMessage != error) {
      _errorMessage = error;
      notifyListeners();
    }
  }

  void clearError() {
    setError(null);
  }

  // Combined loading and error handling
  void setLoadingState({bool loading = false, String? error}) {
    _isLoading = loading;
    _errorMessage = error;
    notifyListeners();
  }

  // Reset app state
  void reset() {
    _currentRoute = AppConstants.dashboardRoute;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
