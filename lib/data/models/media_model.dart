/// Model cho Media (Thumbnail, Avatar, etc.)
class Media {
  final int id;
  final int? folderId;
  final String? userId;
  final String fileName;
  final String filePath;
  final String url;
  final String mimeType;
  final int size;
  final String type;
  final String createdAt;
  final String updatedAt;

  Media({
    required this.id,
    this.folderId,
    this.userId,
    required this.fileName,
    required this.filePath,
    required this.url,
    required this.mimeType,
    required this.size,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Parse từ JSON
  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'] as int,
      folderId: json['folder_id'] as int?,
      userId: json['user_id']?.toString(),
      fileName: json['file_name'] as String,
      filePath: json['file_path'] as String,
      url: json['url'] as String,
      mimeType: json['mime_type'] as String,
      size: json['size'] as int,
      type: json['type'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  /// Convert sang JSON
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
