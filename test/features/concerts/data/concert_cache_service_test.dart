import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:conciertos_app/features/concerts/data/models/concert_model.dart';
import 'package:conciertos_app/features/concerts/data/services/concert_cache_service.dart';

ConcertModel _model(String id) => ConcertModel(
      id: id,
      name: 'Concert $id',
      artist: 'Artist',
      festival: '',
      date: DateTime(2024, 6, 15),
      imageUrl: '',
      rating: 3,
      liked: false,
      favorite: false,
      venue: 'Venue',
      city: 'Madrid',
      userId: 'u1',
      price: 50.0,
    );

void main() {
  late ConcertCacheService svc;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    svc = ConcertCacheService();
  });

  group('ConcertCacheService.save / load', () {
    test('saves and loads a list of concerts', () async {
      final concerts = [_model('c1'), _model('c2')];
      await svc.save(concerts);
      final loaded = await svc.load();
      expect(loaded.length, 2);
      expect(loaded.map((c) => c.id), containsAll(['c1', 'c2']));
    });

    test('load returns empty list when cache is empty', () async {
      final loaded = await svc.load();
      expect(loaded, isEmpty);
    });

    test('save overwrites previous cache', () async {
      await svc.save([_model('old')]);
      await svc.save([_model('new1'), _model('new2')]);
      final loaded = await svc.load();
      expect(loaded.length, 2);
      expect(loaded.map((c) => c.id), containsAll(['new1', 'new2']));
    });

    test('load returns empty list for corrupted data', () async {
      SharedPreferences.setMockInitialValues({
        'concerts_cache_v2': 'NOT_VALID_JSON',
      });
      svc = ConcertCacheService();
      final loaded = await svc.load();
      expect(loaded, isEmpty);
    });

    test('loaded model preserves artist and city', () async {
      final m = _model('c3');
      await svc.save([m]);
      final loaded = await svc.load();
      expect(loaded.first.artist, 'Artist');
      expect(loaded.first.city, 'Madrid');
      expect(loaded.first.price, 50.0);
    });
  });

  group('ConcertCacheService.isValid', () {
    test('returns false when no data', () async {
      expect(await svc.isValid(), isFalse);
    });

    test('returns true immediately after save', () async {
      await svc.save([_model('c4')]);
      expect(await svc.isValid(), isTrue);
    });

    test('returns false when timestamp is too old', () async {
      // Set a timestamp 13 hours in the past (older than 12h max age)
      final oldTs = DateTime.now()
          .subtract(const Duration(hours: 13))
          .millisecondsSinceEpoch;
      SharedPreferences.setMockInitialValues({
        'concerts_cache_v2': '[{"id":"c5","name":"X","artist":"A","festival":"",'
            '"date":"2024-01-01T00:00:00.000Z","imageUrl":"","rating":0,'
            '"liked":false,"favorite":false,"venue":"V","city":"","userId":"",'
            '"price":0,"description":"","user":{"id":"","name":""},'
            '"participants":[]}]',
        'concerts_cache_ts_v2': oldTs,
      });
      svc = ConcertCacheService();
      expect(await svc.isValid(), isFalse);
    });
  });

  group('ConcertCacheService.clear', () {
    test('clears data and isValid returns false', () async {
      await svc.save([_model('c6')]);
      expect(await svc.isValid(), isTrue);
      await svc.clear();
      expect(await svc.isValid(), isFalse);
      expect(await svc.load(), isEmpty);
    });
  });
}
