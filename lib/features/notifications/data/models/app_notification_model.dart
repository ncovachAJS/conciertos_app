import '../../domain/entities/app_notification.dart';

class AppNotificationModel extends AppNotification {
  const AppNotificationModel({
    required super.id,
    required super.type,
    required super.title,
    required super.body,
    required super.read,
    required super.createdAt,
    super.data,
    super.sender,
  });

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) {
    final senderJson = json['sender'] as Map<String, dynamic>?;

    return AppNotificationModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      read: json['read'] as bool? ?? false,
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      data: json['data'] as Map<String, dynamic>?,
      sender: senderJson != null
          ? NotificationSender(
              id: senderJson['id']?.toString() ?? '',
              name: senderJson['name']?.toString() ?? '',
              avatarUrl: senderJson['avatarUrl']?.toString(),
            )
          : null,
    );
  }
}
