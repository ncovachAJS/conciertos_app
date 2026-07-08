import '../../domain/entities/concert.dart';

class ConcertModel extends Concert {
  const ConcertModel({
    required String id,
    required String name,
    required String artist,
    required String festival,
    required DateTime date,
    required String imageUrl,
    required int rating,
    required bool liked,
    required String venue,
    String city = '',
  }) : super(
          id: id,
          name: name,
          artist: artist,
          festival: festival,
          date: date,
          imageUrl: imageUrl,
          rating: rating,
          liked: liked,
          venue: venue,
          city: city,
        );

  factory ConcertModel.fromJson(Map<String, dynamic> json) {
    return ConcertModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      artist: json['artist']?.toString() ?? '',
      festival: json['festival']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      venue: json['venue']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      date: DateTime.tryParse(
            json['date']?.toString() ?? '',
          ) ??
          DateTime.now(),
      rating: json['rating'] ?? 0,
      liked: json['liked'] ?? false,
    );
  }

  factory ConcertModel.fromEntity(Concert concert) {
    return ConcertModel(
      id: concert.id,
      name: concert.name,
      artist: concert.artist,
      festival: concert.festival,
      date: concert.date,
      imageUrl: concert.imageUrl,
      rating: concert.rating,
      liked: concert.liked,
      venue: concert.venue,
      city: concert.city,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'artist': artist,
      'date': date.toIso8601String(),
      'festival': festival,
      'venue': venue,
      'city': city,
      'description': '',
      'imageUrl': imageUrl,
      'rating': rating,
      'liked': liked,
    };
  }

  /// Payload para `POST /concerts`.
  ///
  /// No incluye `id` (lo genera Prisma con `cuid()`) ni campos vacíos que
  /// harían fallar la validación del backend (p. ej. `imageUrl` con `@IsUrl()`).
  Map<String, dynamic> toCreateJson() {
    final json = <String, dynamic>{
      'name': name,
      'artist': artist,
      'date': date.toIso8601String(),
      'festival': festival,
      'venue': venue,
      'rating': rating,
      'liked': liked,
    };

    if (city.isNotEmpty) {
      json['city'] = city;
    }

    if (imageUrl.isNotEmpty) {
      json['imageUrl'] = imageUrl;
    }

    return json;
  }

  /// Payload para `PUT /concerts/:id`.
  ///
  /// Misma forma que [toCreateJson]; el `id` viaja en la URL, no en el body.
  Map<String, dynamic> toUpdateJson() => toCreateJson();
}