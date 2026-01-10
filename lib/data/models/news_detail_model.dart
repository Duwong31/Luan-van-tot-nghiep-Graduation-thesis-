class NewsDetail {
  final int id;
  final String title;
  final String slug;
  final String summary;
  final String content;
  final String status;
  final MediaFile? thumbnail;
  final Author? author;
  final String createdAt;
  final String updatedAt;

  NewsDetail({
    required this.id,
    required this.title,
    required this.slug,
    required this.summary,
    required this.content,
    required this.status,
    this.thumbnail,
    this.author,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NewsDetail.fromJson(Map<String, dynamic> json) {
    return NewsDetail(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      summary: json['summary'] ?? '',
      content: json['content'] ?? '',
      status: json['status'] ?? '',
      thumbnail: json['thumbnail'] != null
          ? MediaFile.fromJson(json['thumbnail'])
          : null,
      author: json['author'] != null ? Author.fromJson(json['author']) : null,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'summary': summary,
      'content': content,
      'status': status,
      'thumbnail': thumbnail?.toJson(),
      'author': author?.toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class MediaFile {
  final int id;
  final int? folderId;
  final String userId;
  final String fileName;
  final String filePath;
  final String url;
  final String mimeType;
  final int size;
  final String type;
  final String createdAt;
  final String updatedAt;

  MediaFile({
    required this.id,
    this.folderId,
    required this.userId,
    required this.fileName,
    required this.filePath,
    required this.url,
    required this.mimeType,
    required this.size,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MediaFile.fromJson(Map<String, dynamic> json) {
    return MediaFile(
      id: json['id'] ?? 0,
      folderId: json['folder_id'],
      userId: json['user_id']?.toString() ?? '',
      fileName: json['file_name'] ?? '',
      filePath: json['file_path'] ?? '',
      url: json['url'] ?? '',
      mimeType: json['mime_type'] ?? '',
      size: json['size'] ?? 0,
      type: json['type'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'folder_id': folderId,
      'user_id': userId,
      'file_name': fileName,
      'file_path': filePath,
      'url': url,
      'mime_type': mimeType,
      'size': size,
      'type': type,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Author {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String? dateOfBirth;
  final String? gender;
  final String? emailVerifiedAt;
  final String createdAt;
  final String updatedAt;

  Author({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.dateOfBirth,
    this.gender,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      dateOfBirth: json['date_of_birth'],
      gender: json['gender'],
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
