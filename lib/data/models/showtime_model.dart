import 'package:Celes/data/models/room_model.dart';

// Forward declare Movie to avoid circular imports
class Movie {
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
  final String? posterUrl;

  Movie({
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
    this.posterUrl,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    // Get poster URL from nested poster object or direct poster_url
    String? posterUrl = json['poster_url'] as String?;
    if (posterUrl == null && json['poster'] != null && json['poster'] is Map) {
      posterUrl = json['poster']['url'] as String?;
    }

    return Movie(
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
      posterUrl: posterUrl,
    );
  }
}

/// Model cho Showtime (Suất chiếu)
class Showtime {
  final int id;
  final String date;
  final String startTime;
  final String endTime;
  final int price;
  final String status;
  final Room? room;
  final Movie? movie;
  final String? createdAt;
  final String? updatedAt;

  Showtime({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.price,
    required this.status,
    this.room,
    this.movie,
    this.createdAt,
    this.updatedAt,
  });

  factory Showtime.fromJson(Map<String, dynamic> json) {
    return Showtime(
      id: json['id'] as int,
      date: json['date'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      price: json['price'] as int,
      status: json['status'] as String,
      room: json['room'] != null
          ? Room.fromJson(json['room'] as Map<String, dynamic>)
          : null,
      movie: json['movie'] != null
          ? Movie.fromJson(json['movie'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      'price': price,
      'status': status,
      'room': room?.toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Format price as currency (VND)
  String get formattedPrice => '${price.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      )}đ';

  /// Get time range string
  String get timeRange => '$startTime - $endTime';

  /// Get room name
  String get roomName => room?.name ?? '';

  /// Get cinema name
  String get cinemaName => room?.getCinemaName ?? '';

  /// Get cinema location
  String? get cinemaLocation => room?.cinemaLocation;

  /// Get cinema address
  String? get cinemaAddress => room?.cinemaAddress;

  /// Check if showtime is ongoing
  bool get isOngoing => status == 'ongoing';

  /// Check if showtime is available for booking
  bool get isAvailable => status == 'ongoing' || status == 'available';
}
