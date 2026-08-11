import 'package:flutter_test/flutter_test.dart';

import 'package:conciertos_app/features/auth/domain/entities/user.dart';
import 'package:conciertos_app/features/auth/data/models/user_model.dart';

void main() {
  const baseUser = User(
    id: 'u1',
    name: 'Nico',
    email: 'nico@example.com',
    memberNumber: 42,
    avatarUrl: 'https://av.com/u1.jpg',
  );

  group('User.copyWith', () {
    test('returns identical user when no overrides', () {
      final copy = baseUser.copyWith();
      expect(copy.id, baseUser.id);
      expect(copy.name, baseUser.name);
      expect(copy.email, baseUser.email);
      expect(copy.memberNumber, baseUser.memberNumber);
      expect(copy.avatarUrl, baseUser.avatarUrl);
    });

    test('overrides name', () {
      final copy = baseUser.copyWith(name: 'Carlos');
      expect(copy.name, 'Carlos');
      expect(copy.id, baseUser.id);
    });

    test('overrides email', () {
      final copy = baseUser.copyWith(email: 'new@example.com');
      expect(copy.email, 'new@example.com');
    });

    test('overrides memberNumber', () {
      final copy = baseUser.copyWith(memberNumber: 99);
      expect(copy.memberNumber, 99);
    });

    test('overrides avatarUrl to null', () {
      final copy = baseUser.copyWith(avatarUrl: null);
      // copyWith with null keeps old value (null-aware)
      expect(copy.avatarUrl, baseUser.avatarUrl);
    });

    test('overrides avatarUrl to new value', () {
      final copy = baseUser.copyWith(avatarUrl: 'https://new.com/img.jpg');
      expect(copy.avatarUrl, 'https://new.com/img.jpg');
    });
  });

  group('UserModel.fromJson', () {
    test('parses all fields', () {
      final json = {
        'id': 'u2',
        'name': 'Alice',
        'email': 'alice@example.com',
        'memberNumber': 7,
        'avatarUrl': 'https://av.com/a.jpg',
      };
      final m = UserModel.fromJson(json);
      expect(m.id, 'u2');
      expect(m.name, 'Alice');
      expect(m.email, 'alice@example.com');
      expect(m.memberNumber, 7);
      expect(m.avatarUrl, 'https://av.com/a.jpg');
    });

    test('handles missing optional fields with defaults', () {
      final json = {'id': 'u3', 'name': 'Bob', 'email': 'bob@x.com'};
      final m = UserModel.fromJson(json);
      expect(m.memberNumber, 0);
      expect(m.avatarUrl, isNull);
    });

    test('coerces memberNumber from num', () {
      final json = {
        'id': 'u4',
        'name': 'Carol',
        'email': 'carol@x.com',
        'memberNumber': 3.0, // comes as double sometimes
      };
      final m = UserModel.fromJson(json);
      expect(m.memberNumber, 3);
    });

    test('handles null email with empty string', () {
      final json = {'id': 'u5', 'name': 'Dan', 'memberNumber': 1};
      final m = UserModel.fromJson(json);
      expect(m.email, '');
    });

    test('is a subtype of User', () {
      final m = UserModel.fromJson({'id': 'u6', 'name': 'E', 'email': 'e@x.com'});
      expect(m, isA<User>());
    });
  });
}
