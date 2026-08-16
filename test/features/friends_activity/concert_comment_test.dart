import 'package:flutter_test/flutter_test.dart';

import 'package:conciertos_app/features/friends_activity/domain/concert_comment.dart';

void main() {
  group('ConcertComment.fromJson', () {
    test('parses all fields from flat json', () {
      final json = {
        'id': 'cm1',
        'userId': 'u1',
        'userName': 'Nico',
        'userAvatarUrl': 'https://av.com/u1.jpg',
        'text': 'Gran concierto',
        'createdAt': '2025-06-01T20:00:00.000Z',
      };
      final comment = ConcertComment.fromJson(json);
      expect(comment.id, 'cm1');
      expect(comment.userId, 'u1');
      expect(comment.userName, 'Nico');
      expect(comment.userAvatarUrl, 'https://av.com/u1.jpg');
      expect(comment.text, 'Gran concierto');
      expect(comment.createdAt, DateTime.parse('2025-06-01T20:00:00.000Z'));
    });

    test('resolves userId and userName from nested user object', () {
      final json = {
        'id': 'cm2',
        'userId': null,
        'text': 'Increíble',
        'createdAt': '2025-07-01T10:00:00.000Z',
        'user': {
          'id': 'u2',
          'name': 'Alice',
          'avatarUrl': 'https://av.com/alice.jpg',
        },
      };
      final comment = ConcertComment.fromJson(json);
      expect(comment.userId, 'u2');
      expect(comment.userName, 'Alice');
      expect(comment.userAvatarUrl, 'https://av.com/alice.jpg');
    });

    test('uses empty strings for missing optional fields', () {
      final json = {
        'id': 'cm3',
        'text': 'Ok',
        'createdAt': '2025-01-01T00:00:00.000Z',
      };
      final comment = ConcertComment.fromJson(json);
      expect(comment.userId, '');
      expect(comment.userName, '');
      expect(comment.userAvatarUrl, '');
    });

    test('falls back to DateTime.now() for invalid createdAt', () {
      final before = DateTime.now().subtract(const Duration(seconds: 1));
      final json = {
        'id': 'cm4',
        'text': 'Test',
        'createdAt': 'not-a-date',
      };
      final comment = ConcertComment.fromJson(json);
      expect(comment.createdAt.isAfter(before), isTrue);
    });

    test('flat userId takes priority over user.id when both present', () {
      final json = {
        'id': 'cm5',
        'userId': 'flat-user',
        'text': 'Priority',
        'createdAt': '2025-06-01T00:00:00.000Z',
        'user': {'id': 'nested-user', 'name': 'Name'},
      };
      final comment = ConcertComment.fromJson(json);
      // flat userId is set, so it wins
      expect(comment.userId, 'flat-user');
    });
  });
}
