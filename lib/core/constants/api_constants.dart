// API Configuration
class ApiConstants {
  // Pixabay API
  static const String pixabayBaseUrl = 'https://pixabay.com/api/';
  static const String pixabayApiKey =
      '52455857-6bcd913718b5b6cfa21c3f410'; // Replace with actual API key

  // JSONPlaceholder API
  static const String jsonPlaceholderBaseUrl =
      'https://jsonplaceholder.typicode.com/';
  static const String postsEndpoint = 'posts';

  // API Parameters
  static const int defaultPerPage = 20;
  static const String defaultImageType = 'photo';
  static const String defaultCategory = 'all';
  static const String defaultOrientation = 'all';
  static const int minImageWidth = 0;
  static const int minImageHeight = 0;
  static const bool safesearch = true;

  // Popular categories for dropdown
  static const List<String> categories = [
    'all',
    'backgrounds',
    'fashion',
    'nature',
    'science',
    'education',
    'feelings',
    'health',
    'people',
    'religion',
    'places',
    'animals',
    'industry',
    'computer',
    'food',
    'sports',
    'transportation',
    'travel',
    'buildings',
    'business',
    'music',
  ];
}
