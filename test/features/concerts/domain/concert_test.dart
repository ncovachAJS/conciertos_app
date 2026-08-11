import 'package:flutter_test/flutter_test.dart';

import 'package:conciertos_app/features/concerts/domain/entities/concert.dart';
import 'package:conciertos_app/features/concerts/domain/entities/concert_participant.dart';

Concert _concert({
  String id = 'c1',
  String artist = 'Radiohead',
  DateTime? date,
  int rating = 0,
  bool favorite = false,
  double price = 0,
  String festival = '',
  String venue = 'WiZink Center',
  String city = 'Madrid',
  String genre = 'Rock',
  String notes = '',
  String userId = 'u1',
  String imageUrl = '',
  bool liked = false,
}) {
  return Concert(
    id: id,
    name: 'Concert $id',
    artist: artist,
    festival: festival,
    date: date ?? DateTime(2020, 6, 15),
    venue: venue,
    city: city,
    rating: rating,
    favorite: favorite,
    price: price,
    notes: notes,
    genre: genre,
    userId: userId,
    imageUrl: imageUrl,
    liked: liked,
  );
}

void main() {
  group('Concert.isPastConcert', () {
    test('returns true for a date in the past', () {
      final past = _concert(date: DateTime(2000, 1, 1));
      expect(past.isPastConcert, isTrue);
    });

    test('returns false for a date in the future', () {
      final future = _concert(date: DateTime(2099, 12, 31));
      expect(future.isPastConcert, isFalse);
    });

    test('returns false for today (same day)', () {
      final now = DateTime.now();
      final today = _concert(date: DateTime(now.year, now.month, now.day));
      // Today is NOT past (isPastConcert requires strictly before today)
      expect(today.isPastConcert, isFalse);
    });

    test('returns true for yesterday', () {
      final now = DateTime.now();
      final yesterday = _concert(
        date: DateTime(now.year, now.month, now.day).subtract(const Duration(days: 1)),
      );
      expect(yesterday.isPastConcert, isTrue);
    });
  });

  group('Concert.copyWith', () {
    final original = _concert(
      id: 'orig',
      artist: 'Muse',
      rating: 4,
      favorite: false,
      price: 50,
      venue: 'Palau',
    );

    test('copies all fields when no overrides', () {
      final copy = original.copyWith();
      expect(copy.id, original.id);
      expect(copy.artist, original.artist);
      expect(copy.rating, original.rating);
      expect(copy.favorite, original.favorite);
      expect(copy.price, original.price);
    });

    test('overrides artist', () {
      final copy = original.copyWith(artist: 'Coldplay');
      expect(copy.artist, 'Coldplay');
      expect(copy.id, original.id);
    });

    test('overrides rating', () {
      final copy = original.copyWith(rating: 5);
      expect(copy.rating, 5);
    });

    test('overrides favorite', () {
      final copy = original.copyWith(favorite: true);
      expect(copy.favorite, isTrue);
    });

    test('overrides multiple fields at once', () {
      final copy = original.copyWith(venue: 'Barclaycard Arena', city: 'Bilbao');
      expect(copy.venue, 'Barclaycard Arena');
      expect(copy.city, 'Bilbao');
      expect(copy.artist, original.artist);
    });

    test('overrides participants', () {
      const p = ConcertParticipant(id: 'p1', name: 'Alice');
      final copy = original.copyWith(participants: [p]);
      expect(copy.participants, [p]);
    });
  });

  group('Concert fields', () {
    test('default values are set correctly', () {
      final c = Concert(
        id: 'x',
        name: 'Test',
        artist: 'Artist',
        festival: '',
        date: DateTime(2024, 1, 1),
        venue: 'Venue',
        imageUrl: '',
        rating: 0,
        liked: false,
        favorite: false,
      );
      expect(c.city, '');
      expect(c.price, 0.0);
      expect(c.notes, '');
      expect(c.userId, '');
      expect(c.genre, '');
      expect(c.participantIds, isEmpty);
      expect(c.participants, isEmpty);
    });
  });
}
