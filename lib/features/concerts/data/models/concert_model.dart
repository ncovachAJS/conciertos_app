import '../../domain/entities/concert.dart';

class ConcertModel extends Concert {
  const ConcertModel({
    required String id,
    required String artist,
    required String festival,
    required DateTime date,
    required String city,
    required String imageUrl,
    required int rating,
    required bool liked,
    required String venue,
  }) : super(
         id: id,
         artist: artist,
         festival: festival,
         date: date,
         city: city,
         imageUrl: imageUrl,
         rating: rating,
         liked: liked,
         venue: venue,
       );

  factory ConcertModel.fromJson(Map<String, dynamic> json) {
    return ConcertModel(
      id: json['id']?.toString() ?? '',
      artist: json['banda']?.toString() ?? '',
      festival: json['festival']?.toString() ?? '',
      city: json['nombre']?.toString() ?? '',
      imageUrl: json['imagen']?.toString() ?? '',
      venue: json['venue']?.toString() ?? '',
      date: DateTime.tryParse(json['fecha'] ?? '') ?? DateTime.now(),
      rating: int.tryParse(json['rating'].toString()) ?? 0,
      liked: json['liked'].toString() == 'true',
    );
  }

  factory ConcertModel.fromEntity(Concert concert) {
    return ConcertModel(
      id: concert.id,
      artist: concert.artist,
      festival: concert.festival,
      city: concert.city,
      date: concert.date,
      imageUrl: concert.imageUrl,
      rating: concert.rating,
      liked: concert.liked,
      venue: concert.venue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': city,
      'banda': artist,
      'fecha': date.toIso8601String(),
      'festival': festival,
      'descripcion': '',
      'imagen': imageUrl,
      'rating': rating,
      'liked': liked,
      'venue': venue,
    };
  }
}
