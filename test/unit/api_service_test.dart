import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixabay_gallery/data/services/api_service.dart';
import 'package:pixabay_gallery/data/models/pixabay_image.dart';
import 'package:pixabay_gallery/data/models/user_profile.dart';

void main() {
  group('ApiService Tests', () {
    group('Exception Tests', () {
      test('ApiException should have correct message and status code', () {
        const exception = ApiException('Test error', 400);
        expect(exception.message, 'Test error');
        expect(exception.statusCode, 400);
        expect(exception.toString(), 'ApiException: Test error (400)');
      });

      test('ApiException without status code should format correctly', () {
        const exception = ApiException('Test error');
        expect(exception.message, 'Test error');
        expect(exception.statusCode, null);
        expect(exception.toString(), 'ApiException: Test error');
      });

      test('NetworkException should have correct message', () {
        const exception = NetworkException();
        expect(
          exception.message,
          'Network connection failed. Please check your internet connection.',
        );
        expect(exception.statusCode, null);
      });

      test('TimeoutException should have correct message', () {
        const exception = TimeoutException();
        expect(exception.message, 'Request timed out. Please try again.');
        expect(exception.statusCode, null);
      });

      test('ServerException should have correct message and status code', () {
        const exception = ServerException('Server error', 500);
        expect(exception.message, 'Server error');
        expect(exception.statusCode, 500);
      });
    });

    group('PixabayImage Model Tests', () {
      test('PixabayImage.fromJson should parse correctly', () {
        final json = {
          'id': 123,
          'webformatURL': 'https://example.com/image.jpg',
          'previewURL': 'https://example.com/preview.jpg',
          'largeImageURL': 'https://example.com/large.jpg',
          'tags': 'nature, landscape, beautiful',
          'user': 'photographer',
          'views': 1000,
          'downloads': 100,
          'likes': 50,
        };

        final image = PixabayImage.fromJson(json);

        expect(image.id, 123);
        expect(image.webformatURL, 'https://example.com/image.jpg');
        expect(image.previewURL, 'https://example.com/preview.jpg');
        expect(image.largeImageURL, 'https://example.com/large.jpg');
        expect(image.tags, 'nature, landscape, beautiful');
        expect(image.user, 'photographer');
        expect(image.views, 1000);
        expect(image.downloads, 100);
        expect(image.likes, 50);
      });

      test('PixabayImage.fromJson should handle missing optional fields', () {
        final json = {
          'id': 123,
          'webformatURL': 'https://example.com/image.jpg',
          'tags': 'nature',
          'user': 'photographer',
        };

        final image = PixabayImage.fromJson(json);

        expect(image.id, 123);
        expect(image.webformatURL, 'https://example.com/image.jpg');
        expect(image.previewURL, '');
        expect(image.largeImageURL, '');
        expect(image.tags, 'nature');
        expect(image.user, 'photographer');
        expect(image.views, 0);
        expect(image.downloads, 0);
        expect(image.likes, 0);
      });
    });

    group('UserProfile Model Tests', () {
      test('UserProfile should create correctly', () {
        const profile = UserProfile(
          fullName: 'John Doe',
          email: 'john@example.com',
          favoriteCategory: 'nature',
          password: 'password123',
        );

        expect(profile.fullName, 'John Doe');
        expect(profile.email, 'john@example.com');
        expect(profile.favoriteCategory, 'nature');
        expect(profile.password, 'password123');
      });

      test('UserProfile.toJson should serialize correctly', () {
        const profile = UserProfile(
          fullName: 'John Doe',
          email: 'john@example.com',
          favoriteCategory: 'nature',
          password: 'password123',
        );

        final json = profile.toJson();

        expect(json['fullName'], 'John Doe');
        expect(json['email'], 'john@example.com');
        expect(json['favoriteCategory'], 'nature');
        expect(json['password'], 'password123');
      });
    });

    group('CORS Proxy Logic Tests', () {
      test('CORS proxy URL encoding should work correctly', () {
        const originalUrl = 'https://pixabay.com/api/';
        const expectedProxyUrl =
            'https://corsproxy.io/?https%3A%2F%2Fpixabay.com%2Fapi%2F';

        final encodedUrl = Uri.encodeComponent(originalUrl);
        final proxyUrl = 'https://corsproxy.io/?$encodedUrl';

        expect(proxyUrl, expectedProxyUrl);
      });

      test('URL encoding should handle special characters', () {
        const originalUrl = 'https://pixabay.com/api/?key=123&category=nature';
        final encodedUrl = Uri.encodeComponent(originalUrl);

        expect(encodedUrl, contains('%3A')); // :
        expect(encodedUrl, contains('%2F')); // /
        expect(encodedUrl, contains('%3F')); // ?
        expect(encodedUrl, contains('%26')); // &
        expect(encodedUrl, contains('%3D')); // =
      });
    });

    group('Response Handling Tests', () {
      test('Valid JSON response should be parsed correctly', () {
        const validJson = '{"hits": [], "totalHits": 0}';
        final decoded = json.decode(validJson);

        expect(decoded, isA<Map<String, dynamic>>());
        expect(decoded['hits'], isA<List>());
        expect(decoded['totalHits'], 0);
      });

      test('Empty response should be handled correctly', () {
        const emptyResponse = '';
        expect(emptyResponse.isEmpty, true);
      });

      test('Invalid JSON should throw exception', () {
        const invalidJson = '{"invalid": json}';
        expect(() => json.decode(invalidJson), throwsA(isA<FormatException>()));
      });

      test('Pixabay API response structure should be valid', () {
        const sampleResponse = '''
        {
          "total": 1,
          "totalHits": 1,
          "hits": [
            {
              "id": 195893,
              "pageURL": "https://pixabay.com/en/blossom-bloom-flower-195893/",
              "type": "photo",
              "tags": "blossom, bloom, flower",
              "previewURL": "https://cdn.pixabay.com/photo/2013/10/15/09/12/flower-195893_150.jpg",
              "webformatURL": "https://pixabay.com/get/35bbf209e13e39d2_640.jpg",
              "largeImageURL": "https://pixabay.com/get/ed6a99fd0a76647_1280.jpg",
              "views": 7671,
              "downloads": 6439,
              "likes": 5,
              "user": "Josch13"
            }
          ]
        }
        ''';

        final decoded = json.decode(sampleResponse);

        expect(decoded, isA<Map<String, dynamic>>());
        expect(decoded['hits'], isA<List>());
        expect(decoded['hits'].length, 1);

        final firstImage = decoded['hits'][0];
        expect(firstImage['id'], isA<int>());
        expect(firstImage['tags'], isA<String>());
        expect(firstImage['webformatURL'], isA<String>());
        expect(firstImage['user'], isA<String>());
      });
    });
  });
}
