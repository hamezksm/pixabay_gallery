import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pixabay_image.dart';
import '../models/user_profile.dart';
import '../../core/constants/api_constants.dart';

// Exception classes for better error handling
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, [this.statusCode]);

  @override
  String toString() =>
      'ApiException: $message${statusCode != null ? ' ($statusCode)' : ''}';
}

class NetworkException extends ApiException {
  const NetworkException()
    : super(
        'Network connection failed. Please check your internet connection.',
      );
}

class TimeoutException extends ApiException {
  const TimeoutException() : super('Request timed out. Please try again.');
}

class ServerException extends ApiException {
  const ServerException(String message, int statusCode)
    : super(message, statusCode);
}

// API Service for handling HTTP requests
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final http.Client _client = http.Client();
  static const Duration _timeout = Duration(seconds: 30);

  // Check if running in development mode (localhost)
  bool get _isDevMode {
    // Check if we're running on localhost or 127.0.0.1
    final host = Uri.base.host;
    final isLocalhost =
        host == 'localhost' ||
        host == '127.0.0.1' ||
        host.isEmpty; // Flutter web-server often has empty host

    // Also check for development ports
    final port = Uri.base.port;
    final isDevPort = port >= 3000 && port <= 9999; // Common dev ports

    // In development, we're usually not served from https
    final isHttps = Uri.base.scheme == 'https';

    return isLocalhost && (isDevPort || port == 0) && !isHttps;
  }

  // CORS proxy for development
  String _getCorsProxyUrl(String originalUrl) {
    if (_isDevMode) {
      // Using a reliable CORS proxy for development
      return 'https://corsproxy.io/?${Uri.encodeComponent(originalUrl)}';
    }
    return originalUrl;
  }

  // Generic GET request handler
  Future<Map<String, dynamic>> _get(
    String url, {
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) async {
    try {
      final originalUri = Uri.parse(
        url,
      ).replace(queryParameters: queryParameters);
      final finalUrl = _getCorsProxyUrl(originalUri.toString());

      final response = await _client
          .get(
            Uri.parse(finalUrl),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              ...?headers,
            },
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Generic POST request handler
  Future<Map<String, dynamic>> _post(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              ...?headers,
            },
            body: body != null ? json.encode(body) : null,
          )
          .timeout(_timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Handle HTTP response
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }

      try {
        final jsonResponse = json.decode(response.body);

        // corsproxy.io returns the response directly, no need to extract
        // Only allorigins.win needs the 'contents' extraction
        if (_isDevMode &&
            jsonResponse is Map &&
            jsonResponse.containsKey('contents')) {
          return json.decode(jsonResponse['contents']);
        }

        return jsonResponse;
      } catch (e) {
        throw const ApiException('Invalid JSON response from server');
      }
    } else {
      String errorMessage = 'Request failed';
      try {
        final errorJson = json.decode(response.body);
        errorMessage =
            errorJson['message'] ?? errorJson['error'] ?? errorMessage;
      } catch (_) {
        // Use default error message if JSON parsing fails
      }

      throw ServerException(errorMessage, response.statusCode);
    }
  }

  // Handle errors and convert to appropriate exception types
  Exception _handleError(dynamic error) {
    if (error is ApiException) return error;

    if (error.toString().contains('SocketException') ||
        error.toString().contains('ClientException')) {
      return const NetworkException();
    }

    if (error.toString().contains('TimeoutException')) {
      return const TimeoutException();
    }

    return ApiException(error.toString());
  }

  // Retry mechanism with exponential backoff
  Future<T> _retryRequest<T>(
    Future<T> Function() request, {
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 1),
  }) async {
    int retryCount = 0;
    Duration delay = initialDelay;

    while (retryCount < maxRetries) {
      try {
        return await request();
      } catch (e) {
        retryCount++;

        // Don't retry for certain types of errors
        if (e is ServerException &&
            e.statusCode! >= 400 &&
            e.statusCode! < 500) {
          rethrow;
        }

        if (retryCount >= maxRetries) {
          rethrow;
        }

        // Wait before retrying with exponential backoff
        await Future.delayed(delay);
        delay *= 2; // Double the delay for next retry
      }
    }

    throw ApiException('Max retries exceeded');
  }

  // Pixabay API methods
  Future<PixabayResponse> searchImages({
    String query = 'popular',
    int page = 1,
    int perPage = ApiConstants.defaultPerPage,
    String category = ApiConstants.defaultCategory,
    String imageType = ApiConstants.defaultImageType,
    String orientation = ApiConstants.defaultOrientation,
    bool safeSearch = ApiConstants.safesearch,
  }) async {
    return await _retryRequest(() async {
      final queryParameters = {
        'key': ApiConstants.pixabayApiKey,
        'q': query,
        'image_type': imageType,
        'orientation': orientation,
        'category': category == 'all' ? '' : category,
        'safesearch': safeSearch.toString(),
        'page': page.toString(),
        'per_page': perPage.toString(),
        'min_width': ApiConstants.minImageWidth.toString(),
        'min_height': ApiConstants.minImageHeight.toString(),
        'order': 'popular',
        'pretty': 'true',
      };

      final response = await _get(
        ApiConstants.pixabayBaseUrl,
        queryParameters: queryParameters,
      );

      return PixabayResponse.fromJson(response);
    });
  }

  Future<PixabayResponse> getTrendingImages({
    int page = 1,
    int perPage = ApiConstants.defaultPerPage,
  }) async {
    return searchImages(query: 'popular', page: page, perPage: perPage);
  }

  Future<PixabayResponse> getImagesByCategory({
    required String category,
    int page = 1,
    int perPage = ApiConstants.defaultPerPage,
  }) async {
    return searchImages(
      query: '',
      category: category,
      page: page,
      perPage: perPage,
    );
  }

  // JSONPlaceholder API methods
  Future<ApiResponse> submitUserProfile(UserProfile profile) async {
    return await _retryRequest(() async {
      const url =
          '${ApiConstants.jsonPlaceholderBaseUrl}${ApiConstants.postsEndpoint}';

      final response = await _post(url, body: profile.toFormData());

      return ApiResponse.fromJson(response);
    });
  }

  // Health check methods
  Future<bool> isPixabayApiHealthy() async {
    try {
      await searchImages(perPage: 3);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isJsonPlaceholderHealthy() async {
    try {
      const url =
          '${ApiConstants.jsonPlaceholderBaseUrl}${ApiConstants.postsEndpoint}/1';
      await _get(url);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Cleanup
  void dispose() {
    _client.close();
  }
}
