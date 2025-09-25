import 'package:flutter_test/flutter_test.dart';
import 'package:pixabay_gallery/core/utils/validators.dart';

void main() {
  group('Validators Tests', () {
    group('Email Validation', () {
      test('should return null for valid email addresses', () {
        const validEmails = [
          'user@example.com',
          'test.email@domain.co.uk',
          'valid_email123@test.org',
          'user+tag@example.com',
          'user@sub.domain.com',
        ];

        for (final email in validEmails) {
          expect(
            Validators.email(email),
            null,
            reason: 'Email "$email" should be valid',
          );
        }
      });

      test('should return error message for invalid email addresses', () {
        const invalidEmails = [
          'notanemail',
          '@example.com',
          'user@',
          'user.domain.com',
          'user @example.com',
          'user@.com',
          'user@com',
          '.user@example.com',
          'user.@example.com',
        ];

        for (final email in invalidEmails) {
          expect(
            Validators.email(email),
            isNotNull,
            reason: 'Email "$email" should be invalid',
          );
        }
      });

      test('should return specific error message for empty email', () {
        expect(Validators.email(''), 'Email is required');
        expect(Validators.email(null), 'Email is required');
      });
    });

    group('Required Field Validation', () {
      test('should return null for non-empty values', () {
        const validValues = ['Some text', '123', 'a', '   text with spaces   '];

        for (final value in validValues) {
          expect(
            Validators.required(value, fieldName: 'Field'),
            null,
            reason: 'Value "$value" should be valid',
          );
        }
      });

      test('should return error message for empty or null values', () {
        const invalidValues = [null, '', '   ', '\t', '\n'];

        for (final value in invalidValues) {
          expect(
            Validators.required(value, fieldName: 'Field'),
            'Field is required',
            reason: 'Value "$value" should be invalid',
          );
        }
      });

      test('should use custom field name in error message', () {
        expect(
          Validators.required('', fieldName: 'Full Name'),
          'Full Name is required',
        );
        expect(
          Validators.required(null, fieldName: 'Email'),
          'Email is required',
        );
        expect(
          Validators.required('   ', fieldName: 'Password'),
          'Password is required',
        );
      });
    });

    group('Password Validation', () {
      test('should return null for valid passwords', () {
        const validPasswords = [
          'Password123!',
          'MyP@ssw0rd',
          'Secure123#',
          'Valid1Pass!',
        ];

        for (final password in validPasswords) {
          expect(
            Validators.password(password),
            null,
            reason: 'Password "$password" should be valid',
          );
        }
      });

      test('should return error message for passwords not meeting criteria', () {
        final invalidPasswords = {
          '': 'Password is required',
          'short': 'Password must be at least 8 characters long',
          'alllowercase123!':
              'Password must contain at least one uppercase letter',
          'ALLUPPERCASE123!':
              'Password must contain at least one lowercase letter',
          'NoNumbers!': 'Password must contain at least one number',
          'NoSpecial123':
              'Password must contain at least one special character',
        };

        invalidPasswords.forEach((password, expectedError) {
          expect(
            Validators.password(password),
            expectedError,
            reason:
                'Password "$password" should be invalid with error: "$expectedError"',
          );
        });
      });

      test('should return error message for null password', () {
        expect(Validators.password(null), 'Password is required');
      });
    });

    group('Password Confirmation Validation', () {
      test('should return null when passwords match', () {
        const matchingPairs = [
          ['Password123!', 'Password123!'],
          ['MyP@ssw0rd', 'MyP@ssw0rd'],
          ['Secure123#', 'Secure123#'],
        ];

        for (final pair in matchingPairs) {
          expect(
            Validators.confirmPassword(pair[1], pair[0]),
            null,
            reason: 'Passwords "${pair[0]}" and "${pair[1]}" should match',
          );
        }
      });

      test('should return error message when passwords do not match', () {
        const mismatchedPairs = [
          ['Password123!', 'Password124!'],
          ['MyP@ssw0rd', 'MyP@ssw0rd2'],
          ['Secure123#', 'secure123#'],
        ];

        for (final pair in mismatchedPairs) {
          expect(
            Validators.confirmPassword(pair[1], pair[0]),
            'Passwords do not match',
            reason: 'Passwords "${pair[0]}" and "${pair[1]}" should not match',
          );
        }
      });

      test('should handle empty confirmation password', () {
        expect(
          Validators.confirmPassword('', 'Password123!'),
          'Please confirm your password',
        );
        expect(
          Validators.confirmPassword(null, 'Password123!'),
          'Please confirm your password',
        );
      });
    });

    group('Full Name Validation', () {
      test('should return null for valid names', () {
        const validNames = [
          'John Doe',
          'Mary Jane Smith',
          'Jean-Claude Van Damme',
          'O\'Brien McCarthy',
          'Ana Maria Garcia',
        ];

        for (final name in validNames) {
          expect(
            Validators.fullName(name),
            null,
            reason: 'Name "$name" should be valid',
          );
        }
      });

      test('should return error message for invalid names', () {
        final invalidNames = {
          '': 'Full name is required',
          '   ': 'Full name must be at least 2 characters long',
          'John': 'Please enter both first and last name',
          'A': 'Full name must be at least 2 characters long',
          'John123':
              'Full name can only contain letters, spaces, hyphens, dots, and apostrophes',
          'John@Doe':
              'Full name can only contain letters, spaces, hyphens, dots, and apostrophes',
        };

        invalidNames.forEach((name, expectedError) {
          expect(
            Validators.fullName(name),
            expectedError,
            reason:
                'Name "$name" should be invalid with error: "$expectedError"',
          );
        });
      });
    });

    group('Search Query Validation', () {
      test('should return null for valid search queries', () {
        const validQueries = [
          'cats',
          'beautiful nature',
          'cars and motorcycles',
          'vacation photos',
        ];

        for (final query in validQueries) {
          expect(
            Validators.searchQuery(query),
            null,
            reason: 'Query "$query" should be valid',
          );
        }
      });

      test('should return error message for invalid search queries', () {
        final invalidQueries = {
          '': 'Please enter a search term',
          '   ': 'Please enter a search term',
          'a': 'Search term must be at least 2 characters long',
          'a' * 101: 'Search term must be less than 100 characters',
        };

        invalidQueries.forEach((query, expectedError) {
          expect(
            Validators.searchQuery(query),
            expectedError,
            reason:
                'Query "$query" should be invalid with error: "$expectedError"',
          );
        });
      });
    });

    group('Validator Combinations', () {
      test('should validate required email correctly', () {
        expect(ValidatorCombinations.requiredEmail('user@example.com'), null);
        expect(ValidatorCombinations.requiredEmail(''), 'Email is required');
        expect(
          ValidatorCombinations.requiredEmail('invalid'),
          'Please enter a valid email address',
        );
      });

      test('should validate required full name correctly', () {
        expect(ValidatorCombinations.requiredFullName('John Doe'), null);
        expect(
          ValidatorCombinations.requiredFullName(''),
          'Full name is required',
        );
        expect(
          ValidatorCombinations.requiredFullName('John'),
          'Please enter both first and last name',
        );
      });

      test('should validate required password correctly', () {
        expect(ValidatorCombinations.requiredPassword('Password123!'), null);
        expect(
          ValidatorCombinations.requiredPassword(''),
          'Password is required',
        );
        expect(
          ValidatorCombinations.requiredPassword('weak'),
          'Password must be at least 8 characters long',
        );
      });

      test('should validate required search query correctly', () {
        expect(ValidatorCombinations.requiredSearchQuery('cats'), null);
        expect(
          ValidatorCombinations.requiredSearchQuery(''),
          'Search term is required',
        );
        expect(
          ValidatorCombinations.requiredSearchQuery('a'),
          'Search term must be at least 2 characters long',
        );
      });
    });

    group('Edge Cases', () {
      test('should handle extremely long inputs', () {
        final longString = 'a' * 1000;

        // Long email should be invalid
        expect(
          Validators.email('$longString@example.com'),
          contains('must be less than'),
        );

        // Long name should be invalid
        expect(Validators.fullName(longString), contains('must be less than'));
      });

      test('should handle whitespace correctly', () {
        // Trimming behavior for names
        expect(Validators.fullName('  John Doe  '), null);

        // But pure whitespace should be invalid
        expect(
          Validators.required('   ', fieldName: 'Field'),
          'Field is required',
        );
        expect(
          Validators.fullName('   '),
          'Full name must be at least 2 characters long',
        );
      });

      test('should handle null values correctly', () {
        expect(Validators.email(null), 'Email is required');
        expect(Validators.password(null), 'Password is required');
        expect(Validators.fullName(null), 'Full name is required');
        expect(
          Validators.required(null, fieldName: 'Field'),
          'Field is required',
        );
        expect(Validators.searchQuery(null), 'Please enter a search term');
      });
    });
  });
}
