import 'package:flutter_test/flutter_test.dart';

import 'package:conciertos_app/features/notifications/data/models/app_notification_model.dart';
import 'package:conciertos_app/features/notifications/domain/entities/app_notification.dart';

void main() {
  group('AppNotificationModel.fromJson', () {
    Map<String, dynamic> _baseJson({bool withSender = true}) => {
          'id': 'n1',
          'type': 'CONCERT_TAG',
          'title': 'Te han etiquetado',
          'body': 'Nico te etiquetó en un concierto',
          'read': false,
          'createdAt': '2024-06-15T10:30:00.000Z',
          if (withSender)
            'sender': {
              'id': 'u2',
              'name': 'Nico',
              'avatarUrl': 'https://av.com/n.jpg',
            },
        };

    test('parses all fields including sender', () {
      final n = AppNotificationModel.fromJson(_baseJson());
      expect(n.id, 'n1');
      expect(n.type, 'CONCERT_TAG');
      expect(n.title, 'Te han etiquetado');
      expect(n.body, 'Nico te etiquetó en un concierto');
      expect(n.read, isFalse);
      expect(n.sender, isNotNull);
      expect(n.sender!.id, 'u2');
      expect(n.sender!.name, 'Nico');
      expect(n.sender!.avatarUrl, 'https://av.com/n.jpg');
    });

    test('parses createdAt date correctly', () {
      final n = AppNotificationModel.fromJson(_baseJson());
      expect(n.createdAt.year, 2024);
      expect(n.createdAt.month, 6);
      expect(n.createdAt.day, 15);
    });

    test('sender is null when not provided', () {
      final n = AppNotificationModel.fromJson(_baseJson(withSender: false));
      expect(n.sender, isNull);
    });

    test('handles missing optional fields with defaults', () {
      final json = <String, dynamic>{};
      final n = AppNotificationModel.fromJson(json);
      expect(n.id, '');
      expect(n.type, '');
      expect(n.title, '');
      expect(n.body, '');
      expect(n.read, isFalse);
      expect(n.sender, isNull);
    });

    test('falls back to DateTime.now() for invalid createdAt', () {
      final json = {..._baseJson(withSender: false), 'createdAt': 'bad-date'};
      final before = DateTime.now().subtract(const Duration(seconds: 1));
      final n = AppNotificationModel.fromJson(json);
      expect(n.createdAt.isAfter(before), isTrue);
    });

    test('read flag is parsed correctly as true', () {
      final json = {..._baseJson(withSender: false), 'read': true};
      final n = AppNotificationModel.fromJson(json);
      expect(n.read, isTrue);
    });

    test('data field is parsed when present', () {
      final json = {
        ..._baseJson(withSender: false),
        'data': {'concertId': 'c99'},
      };
      final n = AppNotificationModel.fromJson(json);
      expect(n.data, isNotNull);
      expect(n.data!['concertId'], 'c99');
    });

    test('is a subtype of AppNotification', () {
      final n = AppNotificationModel.fromJson(_baseJson());
      expect(n, isA<AppNotification>());
    });

    test('sender avatarUrl can be null', () {
      final json = {
        ..._baseJson(withSender: false),
        'sender': {'id': 'u3', 'name': 'X'},
      };
      final n = AppNotificationModel.fromJson(json);
      expect(n.sender!.avatarUrl, isNull);
    });
  });

  group('NotificationSender', () {
    test('const constructor works', () {
      const s = NotificationSender(
        id: 's1',
        name: 'Sender',
        avatarUrl: 'url',
      );
      expect(s.id, 's1');
      expect(s.avatarUrl, 'url');
    });
  });
}
