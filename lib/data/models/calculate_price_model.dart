/// Model cho CalculatePriceRequest
class CalculatePriceRequest {
  final int showtimeId;
  final List<int> seatIds;
  final String? voucherCode;

  CalculatePriceRequest({
    required this.showtimeId,
    required this.seatIds,
    this.voucherCode,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'showtime_id': showtimeId,
      'seat_ids': seatIds,
    };
    if (voucherCode != null && voucherCode!.isNotEmpty) {
      json['voucher_code'] = voucherCode;
    }
    return json;
  }
}

/// Model cho SeatInfo trong response
class SeatInfo {
  final int id;
  final String row;
  final int number;

  SeatInfo({
    required this.id,
    required this.row,
    required this.number,
  });

  factory SeatInfo.fromJson(Map<String, dynamic> json) {
    return SeatInfo(
      id: json['id'] as int,
      row: json['row'] as String,
      number: json['number'] as int,
    );
  }

  String get label => '$row$number';
}

/// Model cho ShowtimeInfo trong response
class ShowtimeInfo {
  final String date;
  final String startTime;

  ShowtimeInfo({
    required this.date,
    required this.startTime,
  });

  factory ShowtimeInfo.fromJson(Map<String, dynamic> json) {
    return ShowtimeInfo(
      date: json['date'] as String,
      startTime: json['start_time'] as String,
    );
  }

  /// Get formatted date (YYYY-MM-DD -> DD/MM/YYYY)
  String get formattedDate {
    final parts = date.split('-');
    if (parts.length == 3) {
      return '${parts[2]}/${parts[1]}/${parts[0]}';
    }
    return date;
  }

  /// Get formatted time (HH:mm:ss -> HH:mm)
  String get formattedTime {
    return startTime.length > 5 ? startTime.substring(0, 5) : startTime;
  }
}

/// Model cho CalculatePriceResponse
class CalculatePriceData {
  final String movieTitle;
  final String genre;
  final ShowtimeInfo showtime;
  final List<SeatInfo> seats;
  final int seatCount;
  final int price;
  final String? voucherCode;
  final int? voucherDiscount;
  final int totalPrice;

  CalculatePriceData({
    required this.movieTitle,
    required this.genre,
    required this.showtime,
    required this.seats,
    required this.seatCount,
    required this.price,
    this.voucherCode,
    this.voucherDiscount,
    required this.totalPrice,
  });

  factory CalculatePriceData.fromJson(Map<String, dynamic> json) {
    return CalculatePriceData(
      movieTitle: json['movie_title'] as String,
      genre: json['genre'] as String,
      showtime: ShowtimeInfo.fromJson(json['showtime'] as Map<String, dynamic>),
      seats: (json['seats'] as List<dynamic>)
          .map((e) => SeatInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      seatCount: json['seat_count'] as int,
      price: json['price'] as int,
      voucherCode: json['voucher_code'] as String?,
      voucherDiscount: json['voucher_discount'] as int?,
      totalPrice: json['total_price'] as int,
    );
  }

  /// Check if voucher is applied
  bool get hasVoucher =>
      voucherCode != null && voucherDiscount != null && voucherDiscount! > 0;

  /// Get seat labels (e.g., "C2, C3")
  String get seatLabels => seats.map((s) => s.label).join(', ');

  /// Get original price formatted
  String get formattedPrice {
    return '${price.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )} VND';
  }

  /// Get discount formatted
  String get formattedDiscount {
    final discount = voucherDiscount ?? 0;
    return '-${discount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )} VND';
  }

  /// Get total price formatted
  String get formattedTotalPrice {
    return '${totalPrice.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )} VND';
  }
}
