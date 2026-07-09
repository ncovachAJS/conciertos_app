import '../../domain/entities/concert_photo.dart';

class ConcertPhotoModel extends ConcertPhoto {
  const ConcertPhotoModel({
    required super.id,
    required super.concertId,
    required super.imageUrl,
    super.caption,
    super.createdAt,
    super.concert,
  });

  factory ConcertPhotoModel.fromJson(Map<String, dynamic> json) {
    final concertJson = json['concert'];

    return ConcertPhotoModel(
      id: json['id']?.toString() ?? '',
      concertId: json['concertId']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      caption: json['caption']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      concert: concertJson is Map<String, dynamic>
          ? _refFromJson(concertJson)
          : null,
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

  /// Payload para `POST /concerts/:id/photos`.
  Map<String, dynamic> toCreateJson() {
    final json = <String, dynamic>{'imageUrl': imageUrl};

    if (caption.isNotEmpty) {
      json['caption'] = caption;
    }

    return json;
  }
}
