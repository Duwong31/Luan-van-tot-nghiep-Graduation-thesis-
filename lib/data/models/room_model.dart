import 'package:Celes/data/models/cinema_model.dart';

/// Model cho Room (Phòng chiếu phim)
class Room {
  final int id;
  final String name;
  final int? cinemaId;
  final String? cinemaName;
  final int? capacity;
  final int? seatCount;
  final String? type;
  final String? status;
  final Cinema? cinema;
  final String? createdAt;
  final String? updatedAt;

  Room({
    required this.id,
    required this.name,
    this.cinemaId,
    this.cinemaName,
    this.capacity,
    this.seatCount,
    this.type,
    this.status,
    this.cinema,
    this.createdAt,
    this.updatedAt,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as int,
      name: json['name'] as String,
      cinemaId: json['cinema_id'] as int?,
      cinemaName: json['cinema_name'] as String?,
      capacity: json['capacity'] as int?,
      seatCount: json['seat_count'] as int?,
      type: json['type'] as String?,
      status: json['status'] as String?,
      cinema: json['cinema'] != null
          ? Cinema.fromJson(json['cinema'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cinema_id': cinemaId,
      'cinema_name': cinemaName,
      'capacity': capacity,
      'seat_count': seatCount,
      'type': type,
      'status': status,
      'cinema': cinema?.toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Get total seats (from seatCount or capacity)
  int get totalSeats => seatCount ?? capacity ?? 0;

  /// Get cinema name (from cinema object or cinemaName field)
  String get getCinemaName => cinema?.name ?? cinemaName ?? '';

  /// Get cinema location
  String? get cinemaLocation => cinema?.location;

  /// Get cinema address
  String? get cinemaAddress => cinema?.address;

  /// Get cinema latitude
  double? get cinemaLat => cinema?.lat;

  /// Get cinema longitude
  double? get cinemaLng => cinema?.lng;

  /// Check if cinema has coordinates
  bool get hasCinemaCoordinates => cinema?.hasCoordinates ?? false;
}
