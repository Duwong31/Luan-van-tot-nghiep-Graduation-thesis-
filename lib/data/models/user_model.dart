import 'package:Celes/data/models/role_model.dart';

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
  final int? avatarId;
  final String? dateOfBirth;
  final String? gender;
  final String? avatarUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.emailVerifiedAt,
    required this.role,
    required this.createdAt,
    this.avatarId,
    this.dateOfBirth,
    this.gender,
    this.avatarUrl,
  });

  /// Parse từ JSON
  factory User.fromJson(Map<String, dynamic> json) {
    String? avatarUrl = json['avatar_url'] as String?;
    int? avatarId = json['avatar_id'] as int?;

    if (avatarUrl == null && json['avatar'] != null) {
      avatarUrl = json['avatar']['url'] as String?;
    }

    if (avatarId == null && json['avatar'] != null) {
      avatarId = json['avatar']['id'] as int?;
    }

    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      emailVerifiedAt: json['email_verified_at'] as String?,
      role: Role.fromJson(json['role'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String,
      avatarId: avatarId,
      dateOfBirth: json['date_of_birth'] as String?,
      gender: json['gender'] as String?,
      avatarUrl: avatarUrl,
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
      'avatar_id': avatarId,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'avatar_url': avatarUrl,
    };
  }

  /// Check xem email đã verify chưa
  bool get isEmailVerified => emailVerifiedAt != null;
}
