/// Model cho Review
class Review {
  final int id;
  final int userId;
  final int movieId;
  final int rating;
  final String? comment;
  final String createdAt;
  final String updatedAt;

  Review({
    required this.id,
    required this.userId,
    required this.movieId,
    required this.rating,
    this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Parse từ JSON
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      movieId: json['movie_id'] as int,
      rating: json['rating'] as int,
      comment: json['comment'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  /// Convert sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'movie_id': movieId,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
