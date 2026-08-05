import '../../domain/entities/concert.dart';
import '../../domain/entities/concert_participant.dart';

class ConcertModel extends Concert {
  final List<String> taggedFriendIds;

  const ConcertModel({
    required super.id,
    required super.name,
    required super.artist,
    required super.festival,
    required super.date,
    required super.imageUrl,
    required super.rating,
    required super.liked,
    required super.favorite,
    required super.venue,
    super.city = '',
    super.participantIds = const [],
    super.participants = const [],
    super.userId = '',
    super.price = 0.0,
    super.notes = '',
    super.userName = '',
    super.userAvatarUrl = '',
    super.genre = '',
    this.taggedFriendIds = const [],
  });

  factory ConcertModel.fromJson(Map<String, dynamic> json) {
    final participantsList = json['participants'] as List<dynamic>? ?? [];

    final participantIds = participantsList
        .map((p) {
          if (p is Map) {
            final user = p['user'] as Map<String, dynamic>?;
            return user?['id']?.toString() ?? '';
          }
          return '';
        })
        .where((id) => id.isNotEmpty)
        .toList();

    final participants = participantsList
        .where((p) => p is Map)
        .map((p) => ConcertParticipant.fromJson(p as Map<String, dynamic>))
        .where((p) => p.id.isNotEmpty)
        .toList();

    // Añadir el dueño del concierto a la lista de participantes si viene
    final ownerJson = json['user'] as Map<String, dynamic>?;
    final ownerId = json['userId']?.toString() ?? '';
    if (ownerJson != null && ownerId.isNotEmpty) {
      final ownerParticipant = ConcertParticipant(
        id: ownerId,
        name: ownerJson['name']?.toString() ?? '',
        avatarUrl: ownerJson['avatarUrl']?.toString(),
      );
      if (!participants.any((p) => p.id == ownerId)) {
        participants.insert(0, ownerParticipant);
      }
      if (!participantIds.contains(ownerId)) {
        participantIds.insert(0, ownerId);
      }
    }

    return ConcertModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      artist: json['artist']?.toString() ?? '',
      festival: json['festival']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      favorite: json['favorite'] ?? false,
      venue: json['venue']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      rating: json['rating'] ?? 0,
      liked: json['liked'] ?? false,
      participantIds: participantIds,
      participants: participants,
      userId: ownerId,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      notes: json['description']?.toString() ?? '',
      userName: ownerJson?['name']?.toString() ?? '',
      userAvatarUrl: ownerJson?['avatarUrl']?.toString() ?? '',
      genre: json['genre']?.toString() ?? '',
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
      favorite: concert.favorite,
      venue: concert.venue,
      city: concert.city,
      participantIds: concert.participantIds,
      participants: concert.participants,
      userId: concert.userId,
      price: concert.price,
      notes: concert.notes,
      userName: concert.userName,
      userAvatarUrl: concert.userAvatarUrl,
      genre: concert.genre,
    );
  }

  /// Serialización completa para caché local — preserva todos los campos.
  Map<String, dynamic> toCacheJson() => {
    'id': id,
    'name': name,
    'artist': artist,
    'festival': festival,
    'date': date.toIso8601String(),
    'imageUrl': imageUrl,
    'rating': rating,
    'liked': liked,
    'favorite': favorite,
    'venue': venue,
    'city': city,
    'userId': userId,
    'price': price,
    'description': notes,
    if (genre.isNotEmpty) 'genre': genre,
    'user': {
      'id': userId,
      'name': userName,
      if (userAvatarUrl.isNotEmpty) 'avatarUrl': userAvatarUrl,
    },
    'participants': participants.map((p) => {
      'id': p.id,
      'user': {
        'id': p.id,
        'name': p.name,
        if (p.avatarUrl != null) 'avatarUrl': p.avatarUrl,
      },
    }).toList(),
  };

  Map<String, dynamic> toCreateJson() {
    final json = <String, dynamic>{
      'name': name,
      'artist': artist,
      'date': date.toIso8601String(),
      'festival': festival,
      'venue': venue,
      'rating': rating,
      'liked': liked,
      'favorite': favorite,
      'taggedFriendIds': taggedFriendIds,
    };
    if (city.isNotEmpty) json['city'] = city;
    if (imageUrl.isNotEmpty) json['imageUrl'] = imageUrl;
    if (price > 0) json['price'] = price;
    if (notes.isNotEmpty) json['description'] = notes;
    if (genre.isNotEmpty) json['genre'] = genre;
    return json;
  }

  Map<String, dynamic> toUpdateJson() => toCreateJson();

  Map<String, dynamic> toJson() => toCreateJson()..['id'] = id;
}
