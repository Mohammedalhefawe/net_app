class NotificationsModel {
  final List<NotificationData>?
      data; 
  final String message;

  NotificationsModel({
    required this.data,
    required this.message,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    return NotificationsModel(
      data: json['data'] != null
          ? (json['data'] as List<dynamic>)
              .map((e) => NotificationData.fromJson(e))
              .toList()
          : null, // Handle null case for `data`
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data':
          data?.map((e) => e.toJson()).toList(), // Handle null case for `data`
      'message': message,
    };
  }
}

class NotificationData {
  final int id;
  final int userId;
  final String content;
  final String createdAt;
  final String updatedAt;

  NotificationData({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      content: json['content'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'content': content,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
