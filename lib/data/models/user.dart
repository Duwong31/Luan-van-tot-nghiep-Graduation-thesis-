import 'role.dart';

/// Model cho User
class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String? emailVerifiedAt;
  final Role role;
  final String createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.emailVerifiedAt,
    required this.role,
    required this.createdAt,
  });

  /// Parse từ JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      emailVerifiedAt: json['email_verified_at'] as String?,
      role: Role.fromJson(json['role'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String,
    );
  }

  /// Convert sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'email_verified_at': emailVerifiedAt,
      'role': role.toJson(),
      'created_at': createdAt,
    };
  }

  /// Check xem email đã verify chưa
  bool get isEmailVerified => emailVerifiedAt != null;
}
