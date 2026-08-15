class ConcertComment {
  final String id;
  final String userId;
  final String userName;
  final String userAvatarUrl;
  final String text;
  final DateTime createdAt;

  const ConcertComment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatarUrl,
    required this.text,
    required this.createdAt,
  });

  factory ConcertComment.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    return ConcertComment(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? user?['id']?.toString() ?? '',
      userName: user?['name']?.toString() ?? json['userName']?.toString() ?? '',
      userAvatarUrl:
          user?['avatarUrl']?.toString() ?? json['userAvatarUrl']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      createdAt: DateTime.tryParse(
              json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
