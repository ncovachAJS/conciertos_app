class Concert {
  final String id;
  final String artist;
  final String festival;
  final DateTime date;
  final String city;
  final bool favorite;
  final String imageUrl;
  final int rating;
  final bool liked;
  final String venue;

  const Concert({
    required this.id,
    required this.artist,
    required this.festival,
    required this.date,
    required this.city,
    required this.venue,
    this.favorite = false,
    this.imageUrl = '',
    this.rating = 0,
    this.liked = false,
  });

  /// Indica si el concierto ya ha pasado.
  bool get isPastConcert {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final concertDay = DateTime(date.year, date.month, date.day);

    return concertDay.isBefore(today);
  }

  Concert copyWith({
    String? id,
    String? artist,
    String? festival,
    DateTime? date,
    String? city,
    bool? favorite,
    String? imageUrl,
    int? rating,
    bool? liked,
    String? venue,
  }) {
    return Concert(
      id: id ?? this.id,
      artist: artist ?? this.artist,
      festival: festival ?? this.festival,
      date: date ?? this.date,
      city: city ?? this.city,
      favorite: favorite ?? this.favorite,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      liked: liked ?? this.liked,
      venue: venue ?? this.venue,
    );
  }
}
