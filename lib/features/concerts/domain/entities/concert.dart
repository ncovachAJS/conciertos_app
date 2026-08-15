import 'concert_participant.dart';

class Concert {
  final String id;
  final String name;
  final String artist;
  final String festival;
  final DateTime date;
  final bool favorite;
  final String imageUrl;
  final int rating;
  final int soundRating;       // 0-5, 0 = no valorado
  final int atmosphereRating;  // 0-5
  final int setlistRating;     // 0-5
  final int valueRating;       // 0-5
  final int artistRating;      // 0-5
  final bool liked;
  final String venue;
  final String city;
  final List<String> participantIds;
  final List<ConcertParticipant> participants;
  final String userId;
  final double price;
  final String notes;
  // Datos del dueño del concierto (útil en el feed de amigos)
  final String userName;
  final String userAvatarUrl;
  final String genre;

  const Concert({
    required this.id,
    required this.name,
    required this.artist,
    required this.festival,
    required this.date,
    required this.venue,
    this.city = '',
    this.favorite = false,
    this.imageUrl = '',
    this.rating = 0,
    this.soundRating = 0,
    this.atmosphereRating = 0,
    this.setlistRating = 0,
    this.valueRating = 0,
    this.artistRating = 0,
    this.liked = false,
    this.participantIds = const [],
    this.participants = const [],
    this.userId = '',
    this.price = 0.0,
    this.notes = '',
    this.userName = '',
    this.userAvatarUrl = '',
    this.genre = '',
  });

  bool get isPastConcert {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final concertDay = DateTime(date.year, date.month, date.day);
    return concertDay.isBefore(today);
  }

  bool get hasDetailedRating =>
      soundRating > 0 || atmosphereRating > 0 || setlistRating > 0 || valueRating > 0 || artistRating > 0;

  /// Media de las sub-valoraciones rellenadas (0 si ninguna).
  double get detailedAvg {
    final vals = [soundRating, atmosphereRating, setlistRating, valueRating, artistRating]
        .where((v) => v > 0)
        .toList();
    if (vals.isEmpty) return 0;
    return vals.fold<int>(0, (s, v) => s + v) / vals.length;
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
    int? soundRating,
    int? atmosphereRating,
    int? setlistRating,
    int? valueRating,
    int? artistRating,
    bool? liked,
    String? venue,
    String? city,
    List<String>? participantIds,
    List<ConcertParticipant>? participants,
    String? userId,
    double? price,
    String? notes,
    String? userName,
    String? userAvatarUrl,
    String? genre,
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
      soundRating: soundRating ?? this.soundRating,
      atmosphereRating: atmosphereRating ?? this.atmosphereRating,
      setlistRating: setlistRating ?? this.setlistRating,
      valueRating: valueRating ?? this.valueRating,
      artistRating: artistRating ?? this.artistRating,
      liked: liked ?? this.liked,
      venue: venue ?? this.venue,
      city: city ?? this.city,
      participantIds: participantIds ?? this.participantIds,
      participants: participants ?? this.participants,
      userId: userId ?? this.userId,
      price: price ?? this.price,
      notes: notes ?? this.notes,
      userName: userName ?? this.userName,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      genre: genre ?? this.genre,
    );
  }
}
