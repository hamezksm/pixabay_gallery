import 'package:equatable/equatable.dart';

// User Profile Model for the form
class UserProfile extends Equatable {
  final String fullName;
  final String email;
  final String favoriteCategory;
  final String password;
  final String? id; // From JSONPlaceholder response

  const UserProfile({
    required this.fullName,
    required this.email,
    required this.favoriteCategory,
    required this.password,
    this.id,
  });

  // Factory constructor from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      fullName: json['fullName'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      favoriteCategory: json['favoriteCategory'] ?? json['category'] ?? '',
      password: json['password'] ?? '',
      id: json['id']?.toString(),
    );
  }

  // Convert to JSON for API submission
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'favoriteCategory': favoriteCategory,
      'password': password,
      if (id != null) 'id': id,
    };
  }

  // Convert to form data for JSONPlaceholder
  Map<String, dynamic> toFormData() {
    return {
      'title': 'User Profile',
      'body':
          'Full Name: $fullName\nEmail: $email\nFavorite Category: $favoriteCategory',
      'userId': 1,
    };
  }

  // Get first name from full name
  String get firstName {
    final parts = fullName.trim().split(' ');
    return parts.isNotEmpty ? parts.first : '';
  }

  // Get last name from full name
  String get lastName {
    final parts = fullName.trim().split(' ');
    if (parts.length > 1) {
      return parts.sublist(1).join(' ');
    }
    return '';
  }

  // Get initials for avatar display
  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.isEmpty) return '';

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  // Validation methods
  bool get isValid {
    return fullName.isNotEmpty &&
        email.isNotEmpty &&
        favoriteCategory.isNotEmpty &&
        password.isNotEmpty &&
        isValidEmail(email) &&
        isValidPassword(password);
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      caseSensitive: false,
    );
    return emailRegex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    // At least 8 characters, 1 uppercase, 1 lowercase, 1 number, 1 special char
    return password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password) &&
        RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
  }

  @override
  List<Object?> get props => [fullName, email, favoriteCategory, password, id];

  @override
  String toString() {
    return 'UserProfile(fullName: $fullName, email: $email, category: $favoriteCategory, id: $id)';
  }

  // Copy with method for updates
  UserProfile copyWith({
    String? fullName,
    String? email,
    String? favoriteCategory,
    String? password,
    String? id,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      favoriteCategory: favoriteCategory ?? this.favoriteCategory,
      password: password ?? this.password,
      id: id ?? this.id,
    );
  }

  // Create empty profile for initial form state
  static const UserProfile empty = UserProfile(
    fullName: '',
    email: '',
    favoriteCategory: '',
    password: '',
  );
}

// API Response Model for JSONPlaceholder
class ApiResponse extends Equatable {
  final String id;
  final String title;
  final String body;
  final String userId;

  const ApiResponse({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      userId: json['userId']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'body': body, 'userId': userId};
  }

  @override
  List<Object?> get props => [id, title, body, userId];

  @override
  String toString() {
    return 'ApiResponse(id: $id, title: $title, userId: $userId)';
  }
}

// Form State Model
enum FormStatus { initial, loading, success, error }

class FormState extends Equatable {
  final FormStatus status;
  final UserProfile profile;
  final String? errorMessage;
  final ApiResponse? response;

  const FormState({
    required this.status,
    required this.profile,
    this.errorMessage,
    this.response,
  });

  factory FormState.initial() {
    return const FormState(
      status: FormStatus.initial,
      profile: UserProfile.empty,
    );
  }

  FormState copyWith({
    FormStatus? status,
    UserProfile? profile,
    String? errorMessage,
    ApiResponse? response,
  }) {
    return FormState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage,
      response: response ?? this.response,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage, response];

  @override
  String toString() {
    return 'FormState(status: $status, profile: $profile, error: $errorMessage)';
  }
}
