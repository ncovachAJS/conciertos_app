import 'package:flutter_test/flutter_test.dart';

import 'package:conciertos_app/features/concerts/domain/entities/concert_participant.dart';

void main() {
  group('ConcertParticipant.fromJson', () {
    test('parses user nested under "user" key', () {
      final json = {
        'user': {'id': 'u1', 'name': 'Alice', 'avatarUrl': 'https://img.com/a.jpg'},
      };
      final p = ConcertParticipant.fromJson(json);
      expect(p.id, 'u1');
      expect(p.name, 'Alice');
      expect(p.avatarUrl, 'https://img.com/a.jpg');
    });

    test('parses directly when no "user" key', () {
      final json = {'id': 'u2', 'name': 'Bob'};
      final p = ConcertParticipant.fromJson(json);
      expect(p.id, 'u2');
      expect(p.name, 'Bob');
      expect(p.avatarUrl, isNull);
    });

    test('handles null avatarUrl gracefully', () {
      final json = {
        'user': {'id': 'u3', 'name': 'Carol'},
      };
      final p = ConcertParticipant.fromJson(json);
      expect(p.avatarUrl, isNull);
    });

    test('handles missing id and name with empty strings', () {
      final json = {'user': <String, dynamic>{}};
      final p = ConcertParticipant.fromJson(json);
      expect(p.id, '');
      expect(p.name, '');
    });

    test('const constructor works', () {
      const p = ConcertParticipant(id: 'x', name: 'X', avatarUrl: 'url');
      expect(p.id, 'x');
      expect(p.avatarUrl, 'url');
    });
  });
}
