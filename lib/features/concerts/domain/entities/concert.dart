class Concert {
  final String id;
  final String name;
  final String artist;
  final String festival;
  final DateTime date;
  final bool favorite;
  final String imageUrl;
  final int rating;
  final bool liked;
  final String venue;

  const Concert({
    required this.id,
    required this.name,
    required this.artist,
    required this.festival,
    required this.date,
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
    String? name,
    String? artist,
    String? festival,
    DateTime? date,
    bool? favorite,
    String? imageUrl,
    int? rating,
    bool? liked,
    String? venue,
  }) {
    return Concert(
      id: id ?? this.id,
      name: name ?? this.name,
      artist: artist ?? this.artist,
      festival: festival ?? this.festival,
      date: date ?? this.date,
      favorite: favorite ?? this.favorite,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      liked: liked ?? this.liked,
      venue: venue ?? this.venue,
    );
  }
}