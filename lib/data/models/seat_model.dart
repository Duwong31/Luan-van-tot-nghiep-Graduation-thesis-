/// Model cho Seat (Ghế ngồi)
class Seat {
  final int id;
  final String row;
  final int number;
  final String type;
  final String status;
  final String bookingStatus;

  Seat({
    required this.id,
    required this.row,
    required this.number,
    required this.type,
    required this.status,
    required this.bookingStatus,
  });

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      id: json['id'] as int,
      row: json['row'] as String,
      number: json['number'] as int,
      type: json['type'] as String,
      status: json['status'] as String,
      bookingStatus: json['booking_status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'row': row,
      'number': number,
      'type': type,
      'status': status,
      'booking_status': bookingStatus,
    };
  }

  /// Get seat label (e.g., "A1", "B5")
  String get label => '$row$number';

  /// Check if seat is available for booking
  bool get isAvailable => bookingStatus == 'available' && status == 'active';

  /// Check if seat is booked
  bool get isBooked => bookingStatus == 'booked';

  /// Check if seat is reserved (held temporarily)
  bool get isReserved => bookingStatus == 'reserved';

  /// Check if seat is VIP type
  bool get isVip => type == 'vip';

  /// Check if seat is couple type
  bool get isCouple => type == 'couple';

  /// Check if seat is normal type
  bool get isNormal => type == 'normal';
}

/// Model cho SeatRow (Hàng ghế)
class SeatRow {
  final String row;
  final List<Seat> seats;

  SeatRow({
    required this.row,
    required this.seats,
  });

  factory SeatRow.fromJson(Map<String, dynamic> json) {
    return SeatRow(
      row: json['row'] as String,
      seats: (json['seats'] as List<dynamic>)
          .map((e) => Seat.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'row': row,
      'seats': seats.map((e) => e.toJson()).toList(),
    };
  }

  /// Get number of available seats in this row
  int get availableCount => seats.where((s) => s.isAvailable).length;

  /// Get number of booked seats in this row
  int get bookedCount => seats.where((s) => s.isBooked).length;
}

/// Model cho SeatsSummary (Tổng kết ghế)
class SeatsSummary {
  final int total;
  final int available;
  final int booked;

  SeatsSummary({
    required this.total,
    required this.available,
    required this.booked,
  });

  factory SeatsSummary.fromJson(Map<String, dynamic> json) {
    return SeatsSummary(
      total: json['total'] as int,
      available: json['available'] as int,
      booked: json['booked'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'available': available,
      'booked': booked,
    };
  }

  /// Get occupancy rate (0.0 - 1.0)
  double get occupancyRate => total > 0 ? booked / total : 0.0;

  /// Get formatted occupancy percentage
  String get occupancyPercentage =>
      '${(occupancyRate * 100).toStringAsFixed(1)}%';
}
