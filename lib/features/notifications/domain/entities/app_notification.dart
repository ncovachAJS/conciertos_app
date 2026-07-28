class AppNotification {
  final String id;
  final String
  type; // CONCERT_TAG | PHOTO_TAG | FRIEND_REQUEST | FRIEND_ACCEPTED | FRIEND_CONCERT
  final String title;
  final String body;
  final bool read;
  final DateTime createdAt;
  final Map<String, dynamic>? data;
  final NotificationSender? sender;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.read,
    required this.createdAt,
    this.data,
    this.sender,
  });
}

class NotificationSender {
  final String id;
  final String name;
  final String? avatarUrl;

  const NotificationSender({
    required this.id,
    required this.name,
    this.avatarUrl,
  });
}
