/// Voucher Model
class Voucher {
  final int id;
  final String code;
  final String name;
  final String type; // 'percentage' or 'fixed'
  final int amount;
  final int usageLimit;
  final int perUserLimit;
  final int usedCount;
  final String appliesTo; // 'all_users', 'specific_user', etc.
  final int? onlyForUser;
  final int? onlyForMovie;
  final String validFrom;
  final String validTo;
  final String status; // 'active', 'inactive', 'expired'
  final String createdAt;
  final String updatedAt;

  Voucher({
    required this.id,
    required this.code,
    required this.name,
    required this.type,
    required this.amount,
    required this.usageLimit,
    required this.perUserLimit,
    required this.usedCount,
    required this.appliesTo,
    this.onlyForUser,
    this.onlyForMovie,
    required this.validFrom,
    required this.validTo,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      id: json['id'] as int,
      code: json['code'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      amount: json['amount'] as int,
      usageLimit: json['usage_limit'] as int,
      perUserLimit: json['per_user_limit'] as int,
      usedCount: json['used_count'] as int,
      appliesTo: json['applies_to'] as String,
      onlyForUser: json['only_for_user'] as int?,
      onlyForMovie: json['only_for_movie'] as int?,
      validFrom: json['valid_from'] as String,
      validTo: json['valid_to'] as String,
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'type': type,
      'amount': amount,
      'usage_limit': usageLimit,
      'per_user_limit': perUserLimit,
      'used_count': usedCount,
      'applies_to': appliesTo,
      'only_for_user': onlyForUser,
      'only_for_movie': onlyForMovie,
      'valid_from': validFrom,
      'valid_to': validTo,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Check if voucher is currently valid
  bool get isValid {
    if (status != 'active') return false;

    try {
      final now = DateTime.now();
      final from = DateTime.parse(validFrom);
      final to = DateTime.parse(validTo);

      return now.isAfter(from) && now.isBefore(to);
    } catch (e) {
      return false;
    }
  }

  /// Check if voucher has reached usage limit
  bool get hasReachedLimit {
    return usedCount >= usageLimit;
  }

  /// Get discount display text
  String get discountDisplay {
    if (type == 'percentage') {
      return '$amount%';
    } else {
      return '${amount.toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]}.',
          )} VND';
    }
  }

  /// Get formatted valid period
  String get validPeriod {
    try {
      final from = DateTime.parse(validFrom);
      final to = DateTime.parse(validTo);

      return '${from.day}/${from.month}/${from.year} - ${to.day}/${to.month}/${to.year}';
    } catch (e) {
      return '$validFrom - $validTo';
    }
  }
}
