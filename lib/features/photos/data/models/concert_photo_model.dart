import '../../domain/entities/concert_photo.dart';

class ConcertPhotoModel extends ConcertPhoto {
  final List<String> taggedFriendIds;

  const ConcertPhotoModel({
    required super.id,
    required super.concertId,
    required super.imageUrl,
    super.caption,
    super.createdAt,
    super.concert,
    super.uploader,
    super.participants = const [],
    this.taggedFriendIds = const [],
  });

  factory ConcertPhotoModel.fromJson(Map<String, dynamic> json) {
    final concertJson = json['concert'];

    // Parsear participantes
    final participantsList = json['participants'] as List<dynamic>? ?? [];
    final participants = participantsList
        .where((p) => p is Map)
        .map((p) => PhotoParticipant.fromJson(p as Map<String, dynamic>))
        .where((p) => p.id.isNotEmpty)
        .toList();

    // Parsear uploader
    final uploaderJson = json['user'] as Map<String, dynamic>?;
    final uploader = uploaderJson != null
        ? PhotoUploader.fromJson(uploaderJson)
        : null;

    return ConcertPhotoModel(
      id: json['id']?.toString() ?? '',
      concertId: json['concertId']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      caption: json['caption']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      concert: concertJson is Map<String, dynamic>
          ? _refFromJson(concertJson)
          : null,
      uploader: uploader,
      participants: participants,
    );
  }

  static PhotoConcertRef _refFromJson(Map<String, dynamic> json) {
    return PhotoConcertRef(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      artist: json['artist']?.toString() ?? '',
      festival: json['festival']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      venue: json['venue']?.toString() ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toCreateJson({List<String> taggedFriendIds = const []}) {
    final json = <String, dynamic>{
      'imageUrl': imageUrl,
      'taggedFriendIds': taggedFriendIds,
    };
    if (caption.isNotEmpty) json['caption'] = caption;
    return json;
  }
}
