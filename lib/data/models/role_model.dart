/// Model cho Role
class Role {
  final int id;
  final String name;
  final String slug;

  Role({
    required this.id,
    required this.name,
    required this.slug,
  });

  /// Parse từ JSON
  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
    );
  }

  /// Convert sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
    };
  }
}
