import 'package:Celes/data/models/seat_model.dart';
import 'package:Celes/data/models/showtime_model.dart';

/// Model cho ShowtimeSeatsData
/// Response từ API: GET api/showtimes/{showtimeId}/seats
class ShowtimeSeatsData {
  final Showtime showtime;
  final List<Seat> seats;
  final List<SeatRow> seatsByRow;
  final SeatsSummary summary;

  ShowtimeSeatsData({
    required this.showtime,
    required this.seats,
    required this.seatsByRow,
    required this.summary,
  });

  factory ShowtimeSeatsData.fromJson(Map<String, dynamic> json) {
    return ShowtimeSeatsData(
      showtime: Showtime.fromJson(json['showtime'] as Map<String, dynamic>),
      seats: (json['seats'] as List<dynamic>)
          .map((e) => Seat.fromJson(e as Map<String, dynamic>))
          .toList(),
      seatsByRow: (json['seats_by_row'] as List<dynamic>)
          .map((e) => SeatRow.fromJson(e as Map<String, dynamic>))
          .toList(),
      summary: SeatsSummary.fromJson(json['summary'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'showtime': showtime.toJson(),
      'seats': seats.map((e) => e.toJson()).toList(),
      'seats_by_row': seatsByRow.map((e) => e.toJson()).toList(),
      'summary': summary.toJson(),
    };
  }

  /// Check if there are any seats
  bool get hasSeats => seats.isNotEmpty;

  /// Get all available seats
  List<Seat> get availableSeats => seats.where((s) => s.isAvailable).toList();

  /// Get all booked seats
  List<Seat> get bookedSeats => seats.where((s) => s.isBooked).toList();

  /// Get all row labels
  List<String> get rowLabels => seatsByRow.map((r) => r.row).toList();

  /// Get seat by row and number
  Seat? getSeat(String row, int number) {
    try {
      return seats.firstWhere((s) => s.row == row && s.number == number);
    } catch (_) {
      return null;
    }
  }

  /// Get seats for a specific row
  List<Seat>? getSeatsForRow(String row) {
    try {
      return seatsByRow.firstWhere((r) => r.row == row).seats;
    } catch (_) {
      return null;
    }
  }

  /// Get ticket price
  int get ticketPrice => showtime.price;

  /// Get formatted ticket price
  String get formattedPrice => showtime.formattedPrice;
}
