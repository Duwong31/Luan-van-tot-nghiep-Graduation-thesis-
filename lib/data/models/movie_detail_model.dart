import 'package:Celes/data/models/media_model.dart';
import 'package:Celes/data/models/person_model.dart';
import 'package:Celes/data/models/review_model.dart';
import 'package:Celes/data/models/showtime_model.dart';
 
class MovieDetail {
  final int id;
  final String title;
  final String? description;
  final int? duration;
  final String? releaseDate;
  final String? status;
  final String? computedStatus;
  final String? statusLabel;
  final String? genre;
  final String? ageClassification;
  final String? language;
  final Media? poster;
  final Media? trailer;
  final List<Showtime> showtimes;
  final List<Person> directors;
  final List<Person> actors;
  final List<Review> reviews;
  final bool isFavorited;
  final String? createdAt;
  final String? updatedAt;

  MovieDetail({
    required this.id,
    required this.title,
    this.description,
    this.duration,
    this.releaseDate,
    this.status,
    this.computedStatus,
    this.statusLabel,
    this.genre,
    this.ageClassification,
    this.language,
    this.poster,
    this.trailer,
    this.showtimes = const [],
    this.directors = const [],
    this.actors = const [],
    this.reviews = const [],
    this.isFavorited = false,
    this.createdAt,
    this.updatedAt,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      duration: json['duration'] as int?,
      releaseDate: json['release_date'] as String?,
      status: json['status'] as String?,
      computedStatus: json['computed_status'] as String?,
      statusLabel: json['status_label'] as String?,
      genre: json['genre'] as String?,
      ageClassification: json['age_classification'] as String?,
      language: json['language'] as String?,
      poster: json['poster'] != null
          ? Media.fromJson(json['poster'] as Map<String, dynamic>)
          : null,
      trailer: json['trailer'] != null
          ? Media.fromJson(json['trailer'] as Map<String, dynamic>)
          : null,
      showtimes: (json['showtimes'] as List<dynamic>?)
              ?.map((e) => Showtime.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      directors: (json['directors'] as List<dynamic>?)
              ?.map((e) => Person.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      actors: (json['actors'] as List<dynamic>?)
              ?.map((e) => Person.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isFavorited: json['is_favorited'] as bool? ?? false,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'duration': duration,
      'release_date': releaseDate,
      'status': status,
      'computed_status': computedStatus,
      'status_label': statusLabel,
      'genre': genre,
      'age_classification': ageClassification,
      'language': language,
      'poster': poster?.toJson(),
      'trailer': trailer?.toJson(),
      'showtimes': showtimes.map((e) => e.toJson()).toList(),
      'directors': directors.map((e) => e.toJson()).toList(),
      'actors': actors.map((e) => e.toJson()).toList(),
      'reviews': reviews.map((e) => e.toJson()).toList(),
      'is_favorited': isFavorited,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Format duration as "Xh Ym"
  String get formattedDuration {
    if (duration == null) return '';
    final hours = duration! ~/ 60;
    final minutes = duration! % 60;
    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    }
    return '${minutes}m';
  }

  /// Get genre list from genre string
  List<String> get genreList {
    if (genre != null && genre!.isNotEmpty) {
      return genre!.split(', ').map((e) => e.trim()).toList();
    }
    return [];
  }

  /// Check if movie is now showing
  bool get isNowShowing => computedStatus == 'NOW_SHOWING';

  /// Check if movie is coming soon
  bool get isComingSoon => computedStatus == 'COMING_SOON';

  /// Get poster URL
  String? get posterUrl => poster?.url;

  /// Get trailer URL
  String? get trailerUrl => trailer?.url;

  /// Get average rating from reviews
  double get averageRating {
    if (reviews.isEmpty) return 0;
    final total = reviews.fold<int>(0, (sum, review) => sum + review.rating);
    return total / reviews.length;
  }

  /// Check if trailer is available
  bool get hasTrailer => trailer != null;
}
