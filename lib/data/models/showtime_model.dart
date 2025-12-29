/// Model cho Showtime (Suất chiếu)
class Showtime {
  final int id;
  final String date;
  final String startTime;
  final String endTime;
  final int price;
  final String status;
  final String createdAt;
  final String updatedAt;

  Showtime({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.price,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Showtime.fromJson(Map<String, dynamic> json) {
    return Showtime(
      id: json['id'] as int,
      date: json['date'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      price: json['price'] as int,
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
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
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Format price as currency
  String get formattedPrice => '${price.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      )}đ';

  /// Get time range string
  String get timeRange => '$startTime - $endTime';
}
