import 'package:equatable/equatable.dart';

// Pixabay Image Model
class PixabayImage extends Equatable {
  final int id;
  final String pageURL;
  final String type;
  final String tags;
  final String previewURL;
  final int previewWidth;
  final int previewHeight;
  final String webformatURL;
  final int webformatWidth;
  final int webformatHeight;
  final String largeImageURL;
  final int imageWidth;
  final int imageHeight;
  final int imageSize;
  final int views;
  final int downloads;
  final int collections;
  final int likes;
  final int comments;
  final int userId;
  final String user;
  final String userImageURL;

  const PixabayImage({
    required this.id,
    required this.pageURL,
    required this.type,
    required this.tags,
    required this.previewURL,
    required this.previewWidth,
    required this.previewHeight,
    required this.webformatURL,
    required this.webformatWidth,
    required this.webformatHeight,
    required this.largeImageURL,
    required this.imageWidth,
    required this.imageHeight,
    required this.imageSize,
    required this.views,
    required this.downloads,
    required this.collections,
    required this.likes,
    required this.comments,
    required this.userId,
    required this.user,
    required this.userImageURL,
  });

  // Factory constructor from JSON
  factory PixabayImage.fromJson(Map<String, dynamic> json) {
    return PixabayImage(
      id: json['id'] ?? 0,
      pageURL: json['pageURL'] ?? '',
      type: json['type'] ?? '',
      tags: json['tags'] ?? '',
      previewURL: json['previewURL'] ?? '',
      previewWidth: json['previewWidth'] ?? 0,
      previewHeight: json['previewHeight'] ?? 0,
      webformatURL: json['webformatURL'] ?? '',
      webformatWidth: json['webformatWidth'] ?? 0,
      webformatHeight: json['webformatHeight'] ?? 0,
      largeImageURL: json['largeImageURL'] ?? '',
      imageWidth: json['imageWidth'] ?? 0,
      imageHeight: json['imageHeight'] ?? 0,
      imageSize: json['imageSize'] ?? 0,
      views: json['views'] ?? 0,
      downloads: json['downloads'] ?? 0,
      collections: json['collections'] ?? 0,
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      userId: json['user_id'] ?? 0,
      user: json['user'] ?? '',
      userImageURL: json['userImageURL'] ?? '',
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pageURL': pageURL,
      'type': type,
      'tags': tags,
      'previewURL': previewURL,
      'previewWidth': previewWidth,
      'previewHeight': previewHeight,
      'webformatURL': webformatURL,
      'webformatWidth': webformatWidth,
      'webformatHeight': webformatHeight,
      'largeImageURL': largeImageURL,
      'imageWidth': imageWidth,
      'imageHeight': imageHeight,
      'imageSize': imageSize,
      'views': views,
      'downloads': downloads,
      'collections': collections,
      'likes': likes,
      'comments': comments,
      'user_id': userId,
      'user': user,
      'userImageURL': userImageURL,
    };
  }

  // Get formatted tags as a list
  List<String> get tagList {
    if (tags.isEmpty) return [];
    return tags.split(', ').map((tag) => tag.trim()).toList();
  }

  // Get formatted file size
  String get formattedSize {
    if (imageSize == 0) return 'Unknown';

    if (imageSize < 1024) return '${imageSize}B';
    if (imageSize < 1024 * 1024) {
      return '${(imageSize / 1024).toStringAsFixed(1)}KB';
    }
    return '${(imageSize / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  // Get formatted download count
  String get formattedDownloads {
    if (downloads < 1000) return downloads.toString();
    if (downloads < 1000000) {
      return '${(downloads / 1000).toStringAsFixed(1)}K';
    }
    return '${(downloads / 1000000).toStringAsFixed(1)}M';
  }

  // Get formatted view count
  String get formattedViews {
    if (views < 1000) return views.toString();
    if (views < 1000000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    }
    return '${(views / 1000000).toStringAsFixed(1)}M';
  }

  // Get aspect ratio for responsive display
  double get aspectRatio {
    if (imageHeight == 0) return 1.0;
    return imageWidth / imageHeight;
  }

  // Get best quality URL based on screen size
  String getBestImageUrl({required bool isHighRes}) {
    if (isHighRes && largeImageURL.isNotEmpty) {
      return largeImageURL;
    }
    return webformatURL.isNotEmpty ? webformatURL : previewURL;
  }

  @override
  List<Object?> get props => [
    id,
    pageURL,
    type,
    tags,
    previewURL,
    previewWidth,
    previewHeight,
    webformatURL,
    webformatWidth,
    webformatHeight,
    largeImageURL,
    imageWidth,
    imageHeight,
    imageSize,
    views,
    downloads,
    collections,
    likes,
    comments,
    userId,
    user,
    userImageURL,
  ];

  @override
  String toString() {
    return 'PixabayImage(id: $id, user: $user, tags: $tags, views: $views)';
  }

  // Copy with method for updates
  PixabayImage copyWith({
    int? id,
    String? pageURL,
    String? type,
    String? tags,
    String? previewURL,
    int? previewWidth,
    int? previewHeight,
    String? webformatURL,
    int? webformatWidth,
    int? webformatHeight,
    String? largeImageURL,
    int? imageWidth,
    int? imageHeight,
    int? imageSize,
    int? views,
    int? downloads,
    int? collections,
    int? likes,
    int? comments,
    int? userId,
    String? user,
    String? userImageURL,
  }) {
    return PixabayImage(
      id: id ?? this.id,
      pageURL: pageURL ?? this.pageURL,
      type: type ?? this.type,
      tags: tags ?? this.tags,
      previewURL: previewURL ?? this.previewURL,
      previewWidth: previewWidth ?? this.previewWidth,
      previewHeight: previewHeight ?? this.previewHeight,
      webformatURL: webformatURL ?? this.webformatURL,
      webformatWidth: webformatWidth ?? this.webformatWidth,
      webformatHeight: webformatHeight ?? this.webformatHeight,
      largeImageURL: largeImageURL ?? this.largeImageURL,
      imageWidth: imageWidth ?? this.imageWidth,
      imageHeight: imageHeight ?? this.imageHeight,
      imageSize: imageSize ?? this.imageSize,
      views: views ?? this.views,
      downloads: downloads ?? this.downloads,
      collections: collections ?? this.collections,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      userImageURL: userImageURL ?? this.userImageURL,
    );
  }
}

// Pixabay API Response Model
class PixabayResponse extends Equatable {
  final int total;
  final int totalHits;
  final List<PixabayImage> hits;

  const PixabayResponse({
    required this.total,
    required this.totalHits,
    required this.hits,
  });

  factory PixabayResponse.fromJson(Map<String, dynamic> json) {
    final hitsList = json['hits'] as List? ?? [];

    return PixabayResponse(
      total: json['total'] ?? 0,
      totalHits: json['totalHits'] ?? 0,
      hits: hitsList.map((hit) => PixabayImage.fromJson(hit)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'totalHits': totalHits,
      'hits': hits.map((hit) => hit.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [total, totalHits, hits];

  @override
  String toString() {
    return 'PixabayResponse(total: $total, totalHits: $totalHits, images: ${hits.length})';
  }
}
