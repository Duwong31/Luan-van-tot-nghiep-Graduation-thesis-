import 'package:Celes/data/models/showtime_model.dart';

/// Simple movie info trong response showtimes
class MovieInfo {
  final int id;
  final String title;

  MovieInfo({
    required this.id,
    required this.title,
  });

  factory MovieInfo.fromJson(Map<String, dynamic> json) {
    return MovieInfo(
      id: json['id'] as int,
      title: json['title'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}

/// Model cho Schedule Item (group_by_date=true)
/// Chứa danh sách showtimes theo ngày
class ScheduleItem {
  final String date;
  final List<Showtime> showtimes;

  ScheduleItem({
    required this.date,
    required this.showtimes,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      date: json['date'] as String,
      showtimes: (json['showtimes'] as List<dynamic>)
          .map((e) => Showtime.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'showtimes': showtimes.map((e) => e.toJson()).toList(),
    };
  }

  /// Get formatted date (dd/MM/yyyy)
  String get formattedDate {
    try {
      final parts = date.split('-');
      if (parts.length == 3) {
        return '${parts[2]}/${parts[1]}/${parts[0]}';
      }
    } catch (_) {}
    return date;
  }

  /// Check if this schedule is for today
  bool get isToday {
    final now = DateTime.now();
    final todayString =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    return date == todayString;
  }
}

/// Model cho Movie Showtimes Response với group_by_date=true
/// Response từ API: GET api/movies/{movieId}/showtimes?group_by_date=true
class MovieShowtimesGroupedData {
  final MovieInfo movie;
  final List<ScheduleItem> schedule;

  MovieShowtimesGroupedData({
    required this.movie,
    required this.schedule,
  });

  factory MovieShowtimesGroupedData.fromJson(Map<String, dynamic> json) {
    return MovieShowtimesGroupedData(
      movie: MovieInfo.fromJson(json['movie'] as Map<String, dynamic>),
      schedule: (json['schedule'] as List<dynamic>)
          .map((e) => ScheduleItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movie': movie.toJson(),
      'schedule': schedule.map((e) => e.toJson()).toList(),
    };
  }

  /// Check if there are any schedules available
  bool get hasSchedule => schedule.isNotEmpty;

  /// Get all available dates
  List<String> get availableDates => schedule.map((e) => e.date).toList();

  /// Get schedule for a specific date
  ScheduleItem? getScheduleByDate(String date) {
    try {
      return schedule.firstWhere((e) => e.date == date);
    } catch (_) {
      return null;
    }
  }

  /// Get all showtimes flattened
  List<Showtime> get allShowtimes {
    return schedule.expand((e) => e.showtimes).toList();
  }
}

/// Model cho Movie Showtimes Response với date filter hoặc không có group
/// Response từ API: GET api/movies/{movieId}/showtimes hoặc
///                  GET api/movies/{movieId}/showtimes?date=2025-12-29
class MovieShowtimesData {
  final MovieInfo movie;
  final List<Showtime> showtimes;

  MovieShowtimesData({
    required this.movie,
    required this.showtimes,
  });

  factory MovieShowtimesData.fromJson(Map<String, dynamic> json) {
    return MovieShowtimesData(
      movie: MovieInfo.fromJson(json['movie'] as Map<String, dynamic>),
      showtimes: (json['showtimes'] as List<dynamic>)
          .map((e) => Showtime.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movie': movie.toJson(),
      'showtimes': showtimes.map((e) => e.toJson()).toList(),
    };
  }

  /// Check if there are any showtimes available
  bool get hasShowtimes => showtimes.isNotEmpty;

  /// Get showtimes grouped by date
  Map<String, List<Showtime>> get showtimesByDate {
    final Map<String, List<Showtime>> grouped = {};
    for (final showtime in showtimes) {
      if (grouped.containsKey(showtime.date)) {
        grouped[showtime.date]!.add(showtime);
      } else {
        grouped[showtime.date] = [showtime];
      }
    }
    return grouped;
  }

  /// Get showtimes grouped by cinema
  Map<String, List<Showtime>> get showtimesByCinema {
    final Map<String, List<Showtime>> grouped = {};
    for (final showtime in showtimes) {
      final cinemaName = showtime.cinemaName;
      if (grouped.containsKey(cinemaName)) {
        grouped[cinemaName]!.add(showtime);
      } else {
        grouped[cinemaName] = [showtime];
      }
    }
    return grouped;
  }

  /// Get available dates
  List<String> get availableDates {
    return showtimes.map((e) => e.date).toSet().toList()..sort();
  }

  /// Get available cinemas
  List<String> get availableCinemas {
    return showtimes.map((e) => e.cinemaName).toSet().toList()..sort();
  }

  /// Filter showtimes by date
  List<Showtime> getShowtimesByDate(String date) {
    return showtimes.where((e) => e.date == date).toList();
  }

  /// Filter showtimes by cinema
  List<Showtime> getShowtimesByCinemaName(String cinemaName) {
    return showtimes.where((e) => e.cinemaName == cinemaName).toList();
  }

  /// Filter showtimes by date and cinema
  List<Showtime> getShowtimesByDateAndCinema(String date, String cinemaName) {
    return showtimes
        .where((e) => e.date == date && e.cinemaName == cinemaName)
        .toList();
  }
}
