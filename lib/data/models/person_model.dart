import 'package:Celes/data/models/media_model.dart';

/// Model cho Person (Director/Actor)
class Person {
  final int id;
  final String name;
  final Media? avatar;
  final String? movieId;
  final String createdAt;
  final String updatedAt;

  Person({
    required this.id,
    required this.name,
    this.avatar,
    this.movieId,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Parse từ JSON
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] as int,
      name: json['name'] as String,
      avatar: json['avatar'] != null
          ? Media.fromJson(json['avatar'] as Map<String, dynamic>)
          : null,
      movieId: json['movie_id']?.toString(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  /// Convert sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar?.toJson(),
      'movie_id': movieId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Get avatar URL
  String? get avatarUrl => avatar?.url;

  /// Parse name into first name and last name
  String get firstName {
    final parts = name.split(' ');
    return parts.isNotEmpty ? parts.first : name;
  }

  String get lastName {
    final parts = name.split(' ');
    return parts.length > 1 ? parts.sublist(1).join(' ') : '';
  }
}
