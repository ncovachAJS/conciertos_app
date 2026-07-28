import '../../domain/entities/friend.dart';

class FriendModel extends Friend {
  const FriendModel({
    required super.id,
    required super.name,
    required super.email,
    super.avatarUrl,
    super.friendshipId,
    super.friendshipStatus,
    super.isSender,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    // Respuesta de /friends — viene como { friendshipId, friend: {...} }
    if (json.containsKey('friend')) {
      final f = json['friend'] as Map<String, dynamic>;
      return FriendModel(
        id: f['id'] as String,
        name: f['name'] as String,
        email: f['email'] as String? ?? '',
        avatarUrl: f['avatarUrl'] as String?,
        friendshipId: json['friendshipId'] as String?,
        friendshipStatus: 'ACCEPTED',
      );
    }

    // Respuesta de /friends/search — viene el usuario directo con friendshipStatus
    return FriendModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      friendshipId: json['friendshipId'] as String?,
      friendshipStatus: json['friendshipStatus'] as String?,
      isSender: json['isSender'] as bool?,
    );
  }

  // Para solicitudes pendientes — viene como { id, sender: {...} }
  factory FriendModel.fromPendingRequest(Map<String, dynamic> json) {
    final sender = json['sender'] as Map<String, dynamic>;
    return FriendModel(
      id: sender['id'] as String,
      name: sender['name'] as String,
      email: '',
      avatarUrl: sender['avatarUrl'] as String?,
      friendshipId: json['id'] as String?,
      friendshipStatus: 'PENDING',
      isSender: false,
    );
  }
}
