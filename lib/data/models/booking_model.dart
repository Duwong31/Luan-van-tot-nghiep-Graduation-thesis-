import 'package:Celes/data/models/showtime_model.dart';

/// Model cho BookingRequest
class BookingRequest {
  final int showtimeId;
  final List<int> seatIds;
  final String paymentMethod; // 'stripe', 'vnpay'
  final String? voucherCode;

  BookingRequest({
    required this.showtimeId,
    required this.seatIds,
    required this.paymentMethod,
    this.voucherCode,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'showtime_id': showtimeId,
      'seat_ids': seatIds,
      'payment_method': paymentMethod,
    };
    if (voucherCode != null && voucherCode!.isNotEmpty) {
      json['voucher_code'] = voucherCode;
    }
    return json;
  }
}

/// Model cho BookingSeat
class BookingSeat {
  final int id;
  final String row;
  final int number;
  final String type;
  final String status;

  BookingSeat({
    required this.id,
    required this.row,
    required this.number,
    required this.type,
    required this.status,
  });

  factory BookingSeat.fromJson(Map<String, dynamic> json) {
    return BookingSeat(
      id: json['id'] as int,
      row: json['row'] as String,
      number: json['number'] as int,
      type: json['type'] as String,
      status: json['status'] as String,
    );
  }

  String get label => '$row$number';
}

/// Model cho PaymentInfo
class PaymentInfo {
  final String method;
  final String? checkoutUrl;
  final String? clientSecret;
  final String? expiresAt;

  PaymentInfo({
    required this.method,
    this.checkoutUrl,
    this.clientSecret,
    this.expiresAt,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      method: json['method'] as String,
      checkoutUrl: json['checkout_url'] as String?,
      clientSecret: json['client_secret'] as String?,
      expiresAt: json['expires_at'] as String?,
    );
  }

  /// Check if using VNPay
  bool get isVnpay => method == 'vnpay';

  /// Check if using Stripe
  bool get isStripe => method == 'stripe';

  /// Check if has checkout URL (for WebView payment)
  bool get hasCheckoutUrl => checkoutUrl != null && checkoutUrl!.isNotEmpty;

  /// Check if has client secret (for Stripe SDK payment)
  bool get hasClientSecret => clientSecret != null && clientSecret!.isNotEmpty;
}

/// Simplified User model for Booking response (doesn't require role)
class BookingUser {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String? dateOfBirth;
  final String? gender;

  BookingUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.dateOfBirth,
    this.gender,
  });

  factory BookingUser.fromJson(Map<String, dynamic> json) {
    return BookingUser(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      gender: json['gender'] as String?,
    );
  }
}

/// Model cho Booking
class Booking {
  final int id;
  final String code;
  final String status;
  final bool isPaid;
  final int price;
  final int totalPrice;
  final int voucherAmount;
  final String paymentMethod;
  final String? paymentIntentId;
  final String? paidAt;
  final BookingUser? user;
  final Showtime? showtime;
  final List<BookingSeat> seats;
  final dynamic voucher;
  final String createdAt;
  final String updatedAt;

  Booking({
    required this.id,
    required this.code,
    required this.status,
    required this.isPaid,
    required this.price,
    required this.totalPrice,
    required this.voucherAmount,
    required this.paymentMethod,
    this.paymentIntentId,
    this.paidAt,
    this.user,
    this.showtime,
    required this.seats,
    this.voucher,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as int,
      code: json['code'] as String,
      status: json['status'] as String,
      isPaid: json['is_paid'] as bool? ?? false,
      price: json['price'] as int,
      totalPrice: json['total_price'] as int,
      voucherAmount: json['voucher_amount'] as int? ?? 0,
      paymentMethod: json['payment_method'] as String,
      paymentIntentId: json['payment_intent_id'] as String?,
      paidAt: json['paid_at'] as String?,
      user: json['user'] != null
          ? BookingUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      showtime: json['showtime'] != null
          ? Showtime.fromJson(json['showtime'] as Map<String, dynamic>)
          : null,
      seats: (json['seats'] as List<dynamic>?)
              ?.map((e) => BookingSeat.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      voucher: json['voucher'],
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  /// Get seat labels
  String get seatLabels => seats.map((s) => s.label).join(', ');

  /// Get formatted total price
  String get formattedTotalPrice {
    return '${totalPrice.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )} VND';
  }

  /// Check if pending
  bool get isPending => status == 'pending';

  /// Check if confirmed
  bool get isConfirmed => status == 'confirmed';

  /// Check if completed
  bool get isCompleted => status == 'completed';

  /// Check if cancelled
  bool get isCancelled => status == 'cancelled';

  /// Get movie title
  String? get movieTitle => showtime?.movie?.title;

  /// Get movie poster
  String? get moviePoster => showtime?.movie?.posterUrl;

  /// Get movie genre
  String? get movieGenre => showtime?.movie?.genre;

  /// Get movie duration formatted
  String? get movieDuration {
    final duration = showtime?.movie?.duration;
    if (duration == null) return null;
    return '$duration minutes';
  }

  /// Get showtime date formatted
  String? get showtimeDate {
    if (showtime == null) return null;
    final parts = showtime!.date.split('-');
    if (parts.length == 3) {
      return '${parts[2]}.${parts[1]}.${parts[0]}';
    }
    return showtime!.date;
  }

  /// Get showtime time
  String? get showtimeTime {
    final startTime = showtime?.startTime;
    if (startTime == null) return null;
    return startTime.length > 5 ? startTime.substring(0, 5) : startTime;
  }

  /// Get cinema/room name
  String? get roomName => showtime?.room?.name;
}

/// Model cho BookingResponse
class BookingData {
  final Booking booking;
  final PaymentInfo payment;

  BookingData({
    required this.booking,
    required this.payment,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      booking: Booking.fromJson(json['booking'] as Map<String, dynamic>),
      payment: PaymentInfo.fromJson(json['payment'] as Map<String, dynamic>),
    );
  }

  /// Get checkout URL for VNPay
  String? get checkoutUrl => payment.checkoutUrl;

  /// Get client secret for Stripe
  String? get clientSecret => payment.clientSecret;

  /// Get booking code
  String get bookingCode => booking.code;
}
