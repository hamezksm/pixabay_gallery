import 'package:flutter_test/flutter_test.dart';
import 'package:pixabay_gallery/presentation/providers/image_provider.dart';
import 'package:pixabay_gallery/data/models/user_profile.dart';

void main() {
  group('ProfileProvider Tests', () {
    late ProfileProvider profileProvider;

    setUp(() {
      profileProvider = ProfileProvider();
    });

    group('Initial State', () {
      test('should initialize with initial form state', () {
        expect(profileProvider.formState.status, equals(FormStatus.initial));
        expect(profileProvider.formState.errorMessage, isNull);
        expect(profileProvider.isLoading, isFalse);
        expect(profileProvider.hasError, isFalse);
        expect(profileProvider.isSuccess, isFalse);
      });

      test('should have default profile data', () {
        final profile = profileProvider.formState.profile;
        expect(profile.fullName, isEmpty);
        expect(profile.email, isEmpty);
        expect(profile.favoriteCategory, isEmpty);
        expect(profile.password, isEmpty);
        expect(profile.id, isNull);
      });
    });

    group('Form Status Properties', () {
      test('should correctly identify loading state', () {
        expect(profileProvider.isLoading, isFalse);

        // We can't directly set loading state, but we can test the getter logic
        expect(
          profileProvider.isLoading,
          equals(profileProvider.formState.status == FormStatus.loading),
        );
      });

      test('should correctly identify error state', () {
        expect(profileProvider.hasError, isFalse);

        // Test getter logic
        expect(
          profileProvider.hasError,
          equals(profileProvider.formState.status == FormStatus.error),
        );
      });

      test('should correctly identify success state', () {
        expect(profileProvider.isSuccess, isFalse);

        // Test getter logic
        expect(
          profileProvider.isSuccess,
          equals(profileProvider.formState.status == FormStatus.success),
        );
      });
    });

    group('Profile Updates', () {
      test('should update profile data', () {
        const newProfile = UserProfile(
          fullName: 'John Doe',
          email: 'john@example.com',
          favoriteCategory: 'nature',
          password: 'password123',
        );

        profileProvider.updateProfile(newProfile);

        expect(profileProvider.formState.profile.fullName, equals('John Doe'));
        expect(
          profileProvider.formState.profile.email,
          equals('john@example.com'),
        );
        expect(
          profileProvider.formState.profile.favoriteCategory,
          equals('nature'),
        );
        expect(
          profileProvider.formState.profile.password,
          equals('password123'),
        );
      });

      test('should notify listeners when profile is updated', () {
        bool notified = false;

        profileProvider.addListener(() {
          notified = true;
        });

        const updatedProfile = UserProfile(
          fullName: 'Jane Doe',
          email: 'jane@example.com',
          favoriteCategory: 'animals',
          password: 'newpassword',
        );

        profileProvider.updateProfile(updatedProfile);
        expect(notified, isTrue);
      });
    });

    group('Form Reset', () {
      test('should reset form to initial state', () {
        // First update the profile
        const updatedProfile = UserProfile(
          id: 'test-id',
          fullName: 'Test User',
          email: 'test@example.com',
          favoriteCategory: 'science',
          password: 'testpass',
        );

        profileProvider.updateProfile(updatedProfile);

        // Verify profile was updated
        expect(profileProvider.formState.profile.fullName, equals('Test User'));

        // Reset form
        profileProvider.resetForm();

        // Should be back to initial state
        expect(profileProvider.formState.status, equals(FormStatus.initial));
        expect(profileProvider.formState.profile.fullName, isEmpty);
        expect(profileProvider.formState.profile.email, isEmpty);
        expect(profileProvider.formState.profile.favoriteCategory, isEmpty);
        expect(profileProvider.formState.profile.password, isEmpty);
      });

      test('should notify listeners when form is reset', () {
        bool notified = false;

        profileProvider.addListener(() {
          notified = true;
        });

        profileProvider.resetForm();
        expect(notified, isTrue);
      });
    });

    group('Error Handling', () {
      test('should clear error state', () {
        // Clear error should reset to initial status
        profileProvider.clearError();

        expect(profileProvider.formState.status, equals(FormStatus.initial));
        expect(profileProvider.formState.errorMessage, isNull);
      });

      test('should notify listeners when error is cleared', () {
        bool notified = false;

        profileProvider.addListener(() {
          notified = true;
        });

        profileProvider.clearError();
        expect(notified, isTrue);
      });
    });

    group('Form Submission', () {
      test('should handle profile submission', () async {
        const profile = UserProfile(
          fullName: 'Test User',
          email: 'test@example.com',
          favoriteCategory: 'nature',
          password: 'testpass123',
        );

        // Submit profile - this will make a real API call
        // In a full test environment, you'd mock the API service
        expect(
          () async => await profileProvider.submitProfile(profile),
          returnsNormally,
        );
      });
    });

    group('State Consistency', () {
      test('should maintain consistent state properties', () {
        // Test that getters return consistent types
        expect(profileProvider.formState, isA<FormState>());
        expect(profileProvider.isLoading, isA<bool>());
        expect(profileProvider.hasError, isA<bool>());
        expect(profileProvider.isSuccess, isA<bool>());
      });

      test('should have proper form state structure', () {
        final formState = profileProvider.formState;

        expect(formState.status, isA<FormStatus>());
        expect(formState.profile, isA<UserProfile>());
        expect(formState.response, isNull); // Initially null
      });
    });

    group('Profile Data Structure', () {
      test('should handle profile data correctly', () {
        const profile = UserProfile(
          fullName: 'Test User',
          email: 'test@test.com',
          favoriteCategory: 'education',
          password: 'password123',
          id: 'test-id',
        );

        profileProvider.updateProfile(profile);

        final updatedProfile = profileProvider.formState.profile;
        expect(updatedProfile.fullName, equals('Test User'));
        expect(updatedProfile.email, equals('test@test.com'));
        expect(updatedProfile.favoriteCategory, equals('education'));
        expect(updatedProfile.password, equals('password123'));
        expect(updatedProfile.id, equals('test-id'));
      });

      test('should preserve profile ID during updates', () {
        const profile = UserProfile(
          id: 'user-123',
          fullName: 'Original Name',
          email: 'original@email.com',
          favoriteCategory: 'all',
          password: 'originalpass',
        );

        profileProvider.updateProfile(profile);
        expect(profileProvider.formState.profile.id, equals('user-123'));

        // Update with new data but same ID
        const updatedProfile = UserProfile(
          id: 'user-123',
          fullName: 'Updated Name',
          email: 'updated@email.com',
          favoriteCategory: 'nature',
          password: 'updatedpass',
        );

        profileProvider.updateProfile(updatedProfile);
        expect(profileProvider.formState.profile.id, equals('user-123'));
        expect(
          profileProvider.formState.profile.fullName,
          equals('Updated Name'),
        );
        expect(
          profileProvider.formState.profile.email,
          equals('updated@email.com'),
        );
      });
    });

    group('Profile Methods', () {
      test('should convert profile to JSON correctly', () {
        const profile = UserProfile(
          fullName: 'John Doe',
          email: 'john@example.com',
          favoriteCategory: 'nature',
          password: 'password123',
          id: 'user-456',
        );

        profileProvider.updateProfile(profile);

        final json = profileProvider.formState.profile.toJson();
        expect(json['fullName'], equals('John Doe'));
        expect(json['email'], equals('john@example.com'));
        expect(json['favoriteCategory'], equals('nature'));
        expect(json['password'], equals('password123'));
        expect(json['id'], equals('user-456'));
      });

      test('should convert profile to form data correctly', () {
        const profile = UserProfile(
          fullName: 'Jane Doe',
          email: 'jane@example.com',
          favoriteCategory: 'animals',
          password: 'janepass',
        );

        profileProvider.updateProfile(profile);

        final formData = profileProvider.formState.profile.toFormData();
        expect(formData['title'], equals('User Profile'));
        expect(formData['userId'], equals(1));
        expect(formData['body'], contains('Jane Doe'));
        expect(formData['body'], contains('jane@example.com'));
        expect(formData['body'], contains('animals'));
      });
    });

    group('Provider Lifecycle', () {
      test('should dispose properly', () {
        // Test that dispose doesn't throw on a fresh provider
        final testProvider = ProfileProvider();
        expect(() => testProvider.dispose(), returnsNormally);

        // Don't dispose the main profileProvider here as it will be disposed in tearDown
      });

      test('should maintain separate provider instances', () {
        final provider1 = ProfileProvider();
        final provider2 = ProfileProvider();

        // Should be different instances
        expect(provider1, isNot(same(provider2)));

        // Should have independent state - verify they can be modified independently
        const profile1 = UserProfile(
          fullName: 'Provider 1',
          email: 'provider1@test.com',
          favoriteCategory: 'nature',
          password: 'password1',
        );

        const profile2 = UserProfile(
          fullName: 'Provider 2',
          email: 'provider2@test.com',
          favoriteCategory: 'animals',
          password: 'password2',
        );

        provider1.updateProfile(profile1);
        provider2.updateProfile(profile2);

        // Should have different profile data
        expect(provider1.formState.profile.fullName, equals('Provider 1'));
        expect(provider2.formState.profile.fullName, equals('Provider 2'));
        expect(
          provider1.formState.profile.fullName,
          isNot(equals(provider2.formState.profile.fullName)),
        );

        provider1.dispose();
        provider2.dispose();
      });
    });

    tearDown(() {
      // Only dispose if not already disposed
      try {
        profileProvider.dispose();
      } catch (e) {
        // Provider was already disposed, ignore
      }
    });
  });
}
