import '../../../friends/domain/entities/friend.dart';

class PhotoConcertRef {
  final String id;
  final String name;
  final String artist;
  final String festival;
  final String city;
  final String venue;
  final DateTime date;

  const PhotoConcertRef({
    required this.id,
    required this.name,
    required this.artist,
    required this.festival,
    required this.city,
    required this.venue,
    required this.date,
  });
}

class PhotoUploader {
  final String id;
  final String name;
  final String? avatarUrl;

  const PhotoUploader({required this.id, required this.name, this.avatarUrl});

  factory PhotoUploader.fromJson(Map<String, dynamic> json) {
    return PhotoUploader(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      avatarUrl: json['avatarUrl']?.toString(),
    );
  }
}

class PhotoParticipant {
  final String id;
  final String name;
  final String? avatarUrl;

  const PhotoParticipant({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  factory PhotoParticipant.fromJson(Map<String, dynamic> json) {
    // Viene como { id, user: { id, name, avatarUrl } }
    final user = json['user'] as Map<String, dynamic>? ?? json;
    return PhotoParticipant(
      id: user['id']?.toString() ?? '',
      name: user['name']?.toString() ?? '',
      avatarUrl: user['avatarUrl']?.toString(),
    );
  }
}

class ConcertPhoto {
  final String id;
  final String concertId;
  final String imageUrl;
  final String caption;
  final DateTime? createdAt;
  final PhotoConcertRef? concert;
  final PhotoUploader? uploader;
  final List<PhotoParticipant> participants;

  const ConcertPhoto({
    required this.id,
    required this.concertId,
    required this.imageUrl,
    this.caption = '',
    this.createdAt,
    this.concert,
    this.uploader,
    this.participants = const [],
  });
}
