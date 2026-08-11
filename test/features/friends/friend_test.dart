import 'package:flutter_test/flutter_test.dart';

import 'package:conciertos_app/features/friends/domain/entities/friend.dart';
import 'package:conciertos_app/features/friends/data/models/friend_model.dart';

void main() {
  group('Friend computed getters', () {
    test('isAccepted is true when status is ACCEPTED', () {
      const f = Friend(
        id: 'f1', name: 'A', email: 'a@x.com',
        friendshipStatus: 'ACCEPTED',
      );
      expect(f.isAccepted, isTrue);
      expect(f.isPending, isFalse);
      expect(f.hasNoRelation, isFalse);
    });

    test('isPending is true when status is PENDING', () {
      const f = Friend(
        id: 'f2', name: 'B', email: 'b@x.com',
        friendshipStatus: 'PENDING',
      );
      expect(f.isPending, isTrue);
      expect(f.isAccepted, isFalse);
      expect(f.hasNoRelation, isFalse);
    });

    test('hasNoRelation is true when status is null', () {
      const f = Friend(id: 'f3', name: 'C', email: 'c@x.com');
      expect(f.hasNoRelation, isTrue);
      expect(f.isAccepted, isFalse);
      expect(f.isPending, isFalse);
    });

    test('REJECTED status makes all getters false except hasNoRelation', () {
      const f = Friend(
        id: 'f4', name: 'D', email: 'd@x.com',
        friendshipStatus: 'REJECTED',
      );
      expect(f.isAccepted, isFalse);
      expect(f.isPending, isFalse);
      // hasNoRelation is false too because status is not null
      expect(f.hasNoRelation, isFalse);
    });
  });

  group('FriendModel.fromJson (friend format)', () {
    test('parses /friends response with nested friend object', () {
      final json = {
        'friendshipId': 'fs1',
        'friend': {
          'id': 'u10',
          'name': 'Alice',
          'email': 'alice@x.com',
          'avatarUrl': 'https://av.com/a.jpg',
        },
      };
      final m = FriendModel.fromJson(json);
      expect(m.id, 'u10');
      expect(m.name, 'Alice');
      expect(m.email, 'alice@x.com');
      expect(m.avatarUrl, 'https://av.com/a.jpg');
      expect(m.friendshipId, 'fs1');
      expect(m.friendshipStatus, 'ACCEPTED');
    });

    test('parses /friends response without avatarUrl', () {
      final json = {
        'friendshipId': 'fs2',
        'friend': {'id': 'u11', 'name': 'Bob', 'email': ''},
      };
      final m = FriendModel.fromJson(json);
      expect(m.avatarUrl, isNull);
      expect(m.isAccepted, isTrue);
    });
  });

  group('FriendModel.fromJson (search format)', () {
    test('parses /friends/search response', () {
      final json = {
        'id': 'u20',
        'name': 'Carlos',
        'email': 'c@x.com',
        'friendshipId': 'fs3',
        'friendshipStatus': 'PENDING',
        'isSender': true,
      };
      final m = FriendModel.fromJson(json);
      expect(m.id, 'u20');
      expect(m.friendshipStatus, 'PENDING');
      expect(m.isSender, isTrue);
    });

    test('handles null friendshipStatus in search response', () {
      final json = {
        'id': 'u21',
        'name': 'Diana',
        'email': 'd@x.com',
      };
      final m = FriendModel.fromJson(json);
      expect(m.friendshipStatus, isNull);
      expect(m.hasNoRelation, isTrue);
    });
  });

  group('FriendModel.fromPendingRequest', () {
    test('parses pending request with sender nested', () {
      final json = {
        'id': 'req1',
        'sender': {
          'id': 'u30',
          'name': 'Eve',
          'avatarUrl': 'https://av.com/e.jpg',
        },
      };
      final m = FriendModel.fromPendingRequest(json);
      expect(m.id, 'u30');
      expect(m.name, 'Eve');
      expect(m.friendshipId, 'req1');
      expect(m.friendshipStatus, 'PENDING');
      expect(m.isSender, isFalse);
      expect(m.email, '');
    });

    test('handles missing avatarUrl in pending request', () {
      final json = {
        'id': 'req2',
        'sender': {'id': 'u31', 'name': 'Frank'},
      };
      final m = FriendModel.fromPendingRequest(json);
      expect(m.avatarUrl, isNull);
    });
  });
}
