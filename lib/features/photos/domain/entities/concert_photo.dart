/// Datos mínimos del concierto que acompañan a una foto en el feed global.
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

/// Foto de recuerdo asociada a un concierto.
class ConcertPhoto {
  final String id;
  final String concertId;
  final String imageUrl;
  final String caption;
  final DateTime? createdAt;

  /// Solo presente en las respuestas del feed global.
  final PhotoConcertRef? concert;

  const ConcertPhoto({
    required this.id,
    required this.concertId,
    required this.imageUrl,
    this.caption = '',
    this.createdAt,
    this.concert,
  });
}
