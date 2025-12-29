import 'package:Celes/data/models/media_model.dart';
import 'package:Celes/data/models/showtime_model.dart';

/// Model cho Movie
class Movie {
  final int id;
  final String title;
  final String? slug;
  final String? description;
  final int? duration;
  final String? releaseDate;
  final String? endDate;
  final String? director;
  final String? cast;
  final String? language;
  final String? subtitle;
  final String? ageRating;
  final String? ageClassification;
  final String? trailerUrl;
  final double? rating;
  final String? status;
  final String? computedStatus;
  final String? statusLabel;
  final String? genre;
  final Media? poster;
  final Media? banner;
  final List<String>? genres;
  final List<Showtime>? showtimes;
  final String? createdAt;
  final String? updatedAt;

  Movie({
    required this.id,
    required this.title,
    this.slug,
    this.description,
    this.duration,
    this.releaseDate,
    this.endDate,
    this.director,
    this.cast,
    this.language,
    this.subtitle,
    this.ageRating,
    this.ageClassification,
    this.trailerUrl,
    this.rating,
    this.status,
    this.computedStatus,
    this.statusLabel,
    this.genre,
    this.poster,
    this.banner,
    this.genres,
    this.showtimes,
    this.createdAt,
    this.updatedAt,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int,
      title: json['title'] as String,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      duration: json['duration'] as int?,
      releaseDate: json['release_date'] as String?,
      endDate: json['end_date'] as String?,
      director: json['director'] as String?,
      cast: json['cast'] as String?,
      language: json['language'] as String?,
      subtitle: json['subtitle'] as String?,
      ageRating: json['age_rating'] as String?,
      ageClassification: json['age_classification'] as String?,
      trailerUrl: json['trailer_url'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      status: json['status'] as String?,
      computedStatus: json['computed_status'] as String?,
      statusLabel: json['status_label'] as String?,
      genre: json['genre'] as String?,
      poster: json['poster'] != null
          ? Media.fromJson(json['poster'] as Map<String, dynamic>)
          : null,
      banner: json['banner'] != null
          ? Media.fromJson(json['banner'] as Map<String, dynamic>)
          : null,
      genres: json['genres'] != null
          ? List<String>.from(json['genres'] as List)
          : null,
      showtimes: (json['showtimes'] as List<dynamic>?)
          ?.map((e) => Showtime.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'description': description,
      'duration': duration,
      'release_date': releaseDate,
      'end_date': endDate,
      'director': director,
      'cast': cast,
      'language': language,
      'subtitle': subtitle,
      'age_rating': ageRating,
      'age_classification': ageClassification,
      'trailer_url': trailerUrl,
      'rating': rating,
      'status': status,
      'computed_status': computedStatus,
      'status_label': statusLabel,
      'genre': genre,
      'poster': poster?.toJson(),
      'banner': banner?.toJson(),
      'genres': genres,
      'showtimes': showtimes?.map((e) => e.toJson()).toList(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Format duration as "Xh Ym"
  String get formattedDuration {
    if (duration == null) return '';
    final hours = duration! ~/ 60;
    final minutes = duration! % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  /// Get genre list from genre string
  List<String> get genreList {
    if (genre != null && genre!.isNotEmpty) {
      return genre!.split(', ').map((e) => e.trim()).toList();
    }
    return genres ?? [];
  }

  /// Check if movie is now showing
  bool get isNowShowing => computedStatus == 'NOW_SHOWING';

  /// Check if movie is coming soon
  bool get isComingSoon => computedStatus == 'COMING_SOON';

  /// Get poster URL
  String? get posterUrl => poster?.url;

  /// Get banner URL
  String? get bannerUrl => banner?.url;
}
