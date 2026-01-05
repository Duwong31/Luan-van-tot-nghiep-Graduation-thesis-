/// Notification Model
class NotificationItem {
  final int id;
  final String title;
  final String body;
  final String? imageUrl;
  final String type;
  final String channel;
  final String? relatedType;
  final String? relatedId;
  final dynamic data;
  final bool isRead;
  final String? readAt;
  final String createdAt;
  final String updatedAt;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    required this.type,
    required this.channel,
    this.relatedType,
    this.relatedId,
    this.data,
    required this.isRead,
    this.readAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      imageUrl: json['image_url'] as String?,
      type: json['type'] as String,
      channel: json['channel'] as String,
      relatedType: json['related_type'] as String?,
      relatedId: json['related_id']?.toString(),
      data: json['data'],
      isRead: json['is_read'] as bool,
      readAt: json['read_at'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'image_url': imageUrl,
      'type': type,
      'channel': channel,
      'related_type': relatedType,
      'related_id': relatedId,
      'data': data,
      'is_read': isRead,
      'read_at': readAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Copy with method for updating notification
  NotificationItem copyWith({
    int? id,
    String? title,
    String? body,
    String? imageUrl,
    String? type,
    String? channel,
    String? relatedType,
    String? relatedId,
    dynamic data,
    bool? isRead,
    String? readAt,
    String? createdAt,
    String? updatedAt,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      channel: channel ?? this.channel,
      relatedType: relatedType ?? this.relatedType,
      relatedId: relatedId ?? this.relatedId,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Notification List Response Data
class NotificationListData {
  final int unreadCount;
  final List<NotificationItem> notifications;

  NotificationListData({
    required this.unreadCount,
    required this.notifications,
  });

  factory NotificationListData.fromJson(Map<String, dynamic> json) {
    return NotificationListData(
      unreadCount: json['unread_count'] as int,
      notifications: (json['notifications'] as List)
          .map(
              (item) => NotificationItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unread_count': unreadCount,
      'notifications': notifications.map((item) => item.toJson()).toList(),
    };
  }
}
