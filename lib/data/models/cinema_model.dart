/// Model cho Cinema (Rạp phim)
class Cinema {
  final int id;
  final String name;
  final String? location;
  final String? address;
  final String? latitude;
  final String? longitude;
  final String? phone;
  final String? createdAt;
  final String? updatedAt;

  Cinema({
    required this.id,
    required this.name,
    this.location,
    this.address,
    this.latitude,
    this.longitude,
    this.phone,
    this.createdAt,
    this.updatedAt,
  });

  factory Cinema.fromJson(Map<String, dynamic> json) {
    return Cinema(
      id: json['id'] as int,
      name: json['name'] as String,
      location: json['location'] as String?,
      address: json['address'] as String?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      phone: json['phone'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Get full address with location
  String get fullAddress {
    if (address != null && location != null) {
      return '$address, $location';
    }
    return address ?? location ?? '';
  }

  /// Get latitude as double for map usage
  double? get lat => latitude != null ? double.tryParse(latitude!) : null;

  /// Get longitude as double for map usage
  double? get lng => longitude != null ? double.tryParse(longitude!) : null;

  /// Check if coordinates are available
  bool get hasCoordinates => lat != null && lng != null;
}
