import 'package:flutter_test/flutter_test.dart';

import 'package:conciertos_app/features/concerts/data/models/concert_model.dart';
import 'package:conciertos_app/features/concerts/domain/entities/concert.dart';

Map<String, dynamic> _fullJson() => {
      'id': 'c1',
      'name': 'Tour 2024',
      'artist': 'Radiohead',
      'festival': '',
      'date': '2024-07-20T20:30:00.000Z',
      'imageUrl': 'https://res.cloudinary.com/x/upload/v1/img.jpg',
      'rating': 4,
      'liked': true,
      'favorite': false,
      'venue': 'WiZink Center',
      'city': 'Madrid',
      'price': 65.5,
      'description': 'Amazing concert',
      'genre': 'Alternative',
      'userId': 'u1',
      'user': {'id': 'u1', 'name': 'Nico', 'avatarUrl': 'https://av.com/a.jpg'},
      'participants': [],
    };

void main() {
  group('ConcertModel.fromJson', () {
    test('parses all fields correctly', () {
      final m = ConcertModel.fromJson(_fullJson());
      expect(m.id, 'c1');
      expect(m.name, 'Tour 2024');
      expect(m.artist, 'Radiohead');
      expect(m.venue, 'WiZink Center');
      expect(m.city, 'Madrid');
      expect(m.rating, 4);
      expect(m.liked, isTrue);
      expect(m.favorite, isFalse);
      expect(m.price, 65.5);
      expect(m.notes, 'Amazing concert');
      expect(m.genre, 'Alternative');
      expect(m.userId, 'u1');
      expect(m.userName, 'Nico');
      expect(m.userAvatarUrl, 'https://av.com/a.jpg');
    });

    test('parses date correctly', () {
      final m = ConcertModel.fromJson(_fullJson());
      expect(m.date.year, 2024);
      expect(m.date.month, 7);
      expect(m.date.day, 20);
    });

    test('uses defaults for missing optional fields', () {
      final json = {
        'id': 'c2',
        'name': 'Gig',
        'artist': 'X',
        'festival': '',
        'date': '2023-05-01T00:00:00.000Z',
        'venue': 'Club',
      };
      final m = ConcertModel.fromJson(json);
      expect(m.imageUrl, '');
      expect(m.rating, 0);
      expect(m.liked, isFalse);
      expect(m.favorite, isFalse);
      expect(m.price, 0.0);
      expect(m.notes, '');
      expect(m.genre, '');
      expect(m.city, '');
      expect(m.userId, '');
    });

    test('falls back to DateTime.now() for invalid date', () {
      final json = {..._fullJson(), 'date': 'not-a-date'};
      final before = DateTime.now().subtract(const Duration(seconds: 1));
      final m = ConcertModel.fromJson(json);
      expect(m.date.isAfter(before), isTrue);
    });

    test('adds owner to participants if not already present', () {
      final json = _fullJson();
      final m = ConcertModel.fromJson(json);
      expect(m.participantIds, contains('u1'));
      expect(m.participants.any((p) => p.id == 'u1'), isTrue);
    });

    test('does not duplicate owner in participants', () {
      final json = {
        ..._fullJson(),
        'participants': [
          {
            'id': 'u1',
            'user': {'id': 'u1', 'name': 'Nico'},
          }
        ],
      };
      final m = ConcertModel.fromJson(json);
      final count = m.participants.where((p) => p.id == 'u1').length;
      expect(count, 1);
    });

    test('parses nested participants correctly', () {
      final json = {
        ..._fullJson(),
        'participants': [
          {
            'user': {'id': 'u2', 'name': 'Carlos', 'avatarUrl': null},
          }
        ],
      };
      final m = ConcertModel.fromJson(json);
      expect(m.participants.any((p) => p.id == 'u2' && p.name == 'Carlos'), isTrue);
    });
  });

  group('ConcertModel.fromEntity', () {
    test('copies all fields from a Concert entity', () {
      final c = Concert(
        id: 'e1',
        name: 'Entity Concert',
        artist: 'Muse',
        festival: 'Rock en Seine',
        date: DateTime(2023, 8, 25),
        venue: 'Domaine National',
        city: 'Paris',
        imageUrl: '',
        rating: 5,
        liked: true,
        favorite: true,
        price: 80.0,
        notes: 'Great',
        genre: 'Rock',
        userId: 'u5',
      );
      final m = ConcertModel.fromEntity(c);
      expect(m.id, 'e1');
      expect(m.artist, 'Muse');
      expect(m.festival, 'Rock en Seine');
      expect(m.rating, 5);
      expect(m.price, 80.0);
      expect(m.genre, 'Rock');
      expect(m.taggedFriendIds, isEmpty);
    });
  });

  group('ConcertModel.toCacheJson', () {
    test('serializes all fields for cache', () {
      final m = ConcertModel.fromJson(_fullJson());
      final json = m.toCacheJson();
      expect(json['id'], 'c1');
      expect(json['artist'], 'Radiohead');
      expect(json['rating'], 4);
      expect(json['price'], 65.5);
      expect(json['description'], 'Amazing concert');
      expect(json['genre'], 'Alternative');
      expect((json['user'] as Map)['name'], 'Nico');
    });

    test('round-trips through fromJson correctly', () {
      final original = ConcertModel.fromJson(_fullJson());
      final cache = original.toCacheJson();
      final restored = ConcertModel.fromJson(cache);
      expect(restored.id, original.id);
      expect(restored.artist, original.artist);
      expect(restored.rating, original.rating);
    });

    test('omits genre key when genre is empty', () {
      final json = {..._fullJson(), 'genre': ''};
      final m = ConcertModel.fromJson(json);
      final cache = m.toCacheJson();
      expect(cache.containsKey('genre'), isFalse);
    });
  });

  group('ConcertModel.toCreateJson', () {
    test('includes required fields', () {
      final m = ConcertModel.fromJson(_fullJson());
      final json = m.toCreateJson();
      expect(json['name'], 'Tour 2024');
      expect(json['artist'], 'Radiohead');
      expect(json['rating'], 4);
      expect(json['liked'], isTrue);
      expect(json['favorite'], isFalse);
    });

    test('includes optional fields when present', () {
      final m = ConcertModel.fromJson(_fullJson());
      final json = m.toCreateJson();
      expect(json['price'], 65.5);
      expect(json['description'], 'Amazing concert');
      expect(json['genre'], 'Alternative');
      expect(json['city'], 'Madrid');
    });

    test('omits price when zero', () {
      final json = {..._fullJson(), 'price': 0};
      final m = ConcertModel.fromJson(json);
      final create = m.toCreateJson();
      expect(create.containsKey('price'), isFalse);
    });

    test('toUpdateJson matches toCreateJson', () {
      final m = ConcertModel.fromJson(_fullJson());
      expect(m.toUpdateJson(), m.toCreateJson());
    });

    test('toJson includes id', () {
      final m = ConcertModel.fromJson(_fullJson());
      final json = m.toJson();
      expect(json['id'], 'c1');
    });
  });
}
