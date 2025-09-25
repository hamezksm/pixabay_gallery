import '../constants/app_constants.dart';

// Form validation utilities
class Validators {
  // Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    if (value.length > AppConstants.maxEmailLength) {
      return 'Email must be less than ${AppConstants.maxEmailLength} characters';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      caseSensitive: false,
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters long';
    }

    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check for at least one number
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    // Check for at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  // Confirm password validation
  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != originalPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  // Full name validation
  static String? fullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }

    if (value.trim().length < 2) {
      return 'Full name must be at least 2 characters long';
    }

    if (value.length > AppConstants.maxNameLength) {
      return 'Full name must be less than ${AppConstants.maxNameLength} characters';
    }

    // Check for valid characters (letters, spaces, hyphens, dots)
    final nameRegex = RegExp(r'^[a-zA-Z\s\-\.]+$');
    if (!nameRegex.hasMatch(value)) {
      return 'Full name can only contain letters, spaces, hyphens, and dots';
    }

    // Check for at least two words (first and last name)
    final words = value.trim().split(RegExp(r'\s+'));
    if (words.length < 2) {
      return 'Please enter both first and last name';
    }

    return null;
  }

  // Required field validation
  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Search query validation
  static String? searchQuery(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a search term';
    }

    if (value.trim().length < 2) {
      return 'Search term must be at least 2 characters long';
    }

    if (value.length > 100) {
      return 'Search term must be less than 100 characters';
    }

    return null;
  }

  // Multiple validators combiner
  static String? combine(
    String? value,
    List<String? Function(String?)> validators,
  ) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) {
        return error;
      }
    }
    return null;
  }
}

// Commonly used validator combinations
class ValidatorCombinations {
  static String? requiredEmail(String? value) {
    return Validators.combine(value, [
      (val) => Validators.required(val, fieldName: 'Email'),
      Validators.email,
    ]);
  }

  static String? requiredFullName(String? value) {
    return Validators.combine(value, [
      (val) => Validators.required(val, fieldName: 'Full name'),
      Validators.fullName,
    ]);
  }

  static String? requiredPassword(String? value) {
    return Validators.combine(value, [
      (val) => Validators.required(val, fieldName: 'Password'),
      Validators.password,
    ]);
  }

  static String? requiredSearchQuery(String? value) {
    return Validators.combine(value, [
      (val) => Validators.required(val, fieldName: 'Search term'),
      Validators.searchQuery,
    ]);
  }
}
