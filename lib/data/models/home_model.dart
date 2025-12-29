import 'package:Celes/data/models/movie_model.dart';
import 'package:Celes/data/models/news_model.dart';
import 'package:Celes/data/models/room_model.dart';

/// Model cho Home Data
class HomeData {
  final List<Movie> nowShowing;
  final List<Movie> comingSoon;
  final List<Movie> upcoming;
  final List<Room> rooms;
  final List<News> news;

  HomeData({
    required this.nowShowing,
    required this.comingSoon,
    required this.upcoming,
    required this.rooms,
    required this.news,
  });

  /// Parse từ JSON
  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      nowShowing: (json['now_showing'] as List<dynamic>?)
              ?.map((e) => Movie.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      comingSoon: (json['coming_soon'] as List<dynamic>?)
              ?.map((e) => Movie.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      upcoming: (json['upcoming'] as List<dynamic>?)
              ?.map((e) => Movie.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      rooms: (json['rooms'] as List<dynamic>?)
              ?.map((e) => Room.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      news: (json['news'] as List<dynamic>?)
              ?.map((e) => News.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Convert sang JSON
  Map<String, dynamic> toJson() {
    return {
      'now_showing': nowShowing.map((e) => e.toJson()).toList(),
      'coming_soon': comingSoon.map((e) => e.toJson()).toList(),
      'upcoming': upcoming.map((e) => e.toJson()).toList(),
      'rooms': rooms.map((e) => e.toJson()).toList(),
      'news': news.map((e) => e.toJson()).toList(),
    };
  }

  /// Check if home data is empty
  bool get isEmpty =>
      nowShowing.isEmpty &&
      comingSoon.isEmpty &&
      upcoming.isEmpty &&
      rooms.isEmpty &&
      news.isEmpty;
}
