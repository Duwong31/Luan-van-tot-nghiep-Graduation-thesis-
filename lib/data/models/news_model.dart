import 'package:Celes/data/models/author_model.dart';
import 'package:Celes/data/models/media_model.dart';

/// Model cho News
class News {
  final int id;
  final String title;
  final String slug;
  final String summary;
  final String content;
  final String status;
  final Media? thumbnail;
  final Author? author;
  final String createdAt;
  final String updatedAt;

  News({
    required this.id,
    required this.title,
    required this.slug,
    required this.summary,
    required this.content,
    required this.status,
    this.thumbnail,
    this.author,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Parse từ JSON
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] as int,
      title: json['title'] as String,
      slug: json['slug'] as String,
      summary: json['summary'] as String,
      content: json['content'] as String,
      status: json['status'] as String,
      thumbnail: json['thumbnail'] != null
          ? Media.fromJson(json['thumbnail'] as Map<String, dynamic>)
          : null,
      author: json['author'] != null
          ? Author.fromJson(json['author'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  /// Convert sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'summary': summary,
      'content': content,
      'status': status,
      'thumbnail': thumbnail?.toJson(),
      'author': author?.toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
