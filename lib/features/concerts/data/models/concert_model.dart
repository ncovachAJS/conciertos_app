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
      // Solo añadir si no está ya en participants
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
    );
  }

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
    return json;
  }

  Map<String, dynamic> toUpdateJson() => toCreateJson();

  Map<String, dynamic> toJson() => toCreateJson()..['id'] = id;
}
