import 'package:flutter_test/flutter_test.dart';

import 'package:conciertos_app/features/profile/domain/achievement.dart';

UserStats _stats({
  int total = 0,
  int artists = 0,
  int festivals = 0,
  int cities = 0,
  int rated = 0,
  int oldestYear = 0,
  int rock = 0,
  int metal = 0,
  int jazz = 0,
  int urban = 0,
  int fiveStar = 0,
  int maxSame = 0,
  double spent = 0,
  int favorites = 0,
}) =>
    UserStats(
      totalConcerts: total,
      uniqueArtists: artists,
      uniqueFestivals: festivals,
      uniqueCities: cities,
      totalRated: rated,
      oldestYear: oldestYear,
      rockConcerts: rock,
      metalConcerts: metal,
      jazzConcerts: jazz,
      urbanConcerts: urban,
      fiveStarConcerts: fiveStar,
      maxSameArtist: maxSame,
      totalSpent: spent,
      totalFavorites: favorites,
    );

void main() {
  group('AchievementsEngine.compute', () {
    test('no achievements unlocked with empty stats', () {
      final list = AchievementsEngine.compute(_stats());
      expect(list.where((a) => a.unlocked), isEmpty);
    });

    test('first_concert unlocks at 1 concert', () {
      final list = AchievementsEngine.compute(_stats(total: 1));
      final a = list.firstWhere((x) => x.id == 'first_concert');
      expect(a.unlocked, isTrue);
    });

    test('five_concerts unlocks at 5 concerts', () {
      final list = AchievementsEngine.compute(_stats(total: 5));
      expect(list.firstWhere((x) => x.id == 'five_concerts').unlocked, isTrue);
      expect(list.firstWhere((x) => x.id == 'twenty_five').unlocked, isFalse);
    });

    test('twenty_five unlocks at 25 concerts', () {
      final list = AchievementsEngine.compute(_stats(total: 25));
      expect(list.firstWhere((x) => x.id == 'twenty_five').unlocked, isTrue);
    });

    test('hundred_concerts unlocks at 100', () {
      final list = AchievementsEngine.compute(_stats(total: 100));
      expect(list.firstWhere((x) => x.id == 'hundred_concerts').unlocked, isTrue);
    });

    test('two_hundred unlocks at 200', () {
      final list = AchievementsEngine.compute(_stats(total: 200));
      expect(list.firstWhere((x) => x.id == 'two_hundred').unlocked, isTrue);
    });

    test('rockero unlocks at 3 rock concerts', () {
      final list = AchievementsEngine.compute(_stats(rock: 3));
      expect(list.firstWhere((x) => x.id == 'rockero').unlocked, isTrue);
    });

    test('rockero_pro unlocks at 10 rock concerts', () {
      final list = AchievementsEngine.compute(_stats(rock: 10));
      expect(list.firstWhere((x) => x.id == 'rockero_pro').unlocked, isTrue);
    });

    test('metalero unlocks at 3 metal concerts', () {
      final list = AchievementsEngine.compute(_stats(metal: 3));
      expect(list.firstWhere((x) => x.id == 'metalero').unlocked, isTrue);
    });

    test('urbano unlocks at 3 urban concerts', () {
      final list = AchievementsEngine.compute(_stats(urban: 3));
      expect(list.firstWhere((x) => x.id == 'urbano').unlocked, isTrue);
    });

    test('first_festival unlocks at 1 festival', () {
      final list = AchievementsEngine.compute(_stats(festivals: 1));
      expect(list.firstWhere((x) => x.id == 'first_festival').unlocked, isTrue);
    });

    test('ten_festivals unlocks at 10 festivals', () {
      final list = AchievementsEngine.compute(_stats(festivals: 10));
      expect(list.firstWhere((x) => x.id == 'ten_festivals').unlocked, isTrue);
    });

    test('eclectico unlocks at 10 unique artists', () {
      final list = AchievementsEngine.compute(_stats(artists: 10));
      expect(list.firstWhere((x) => x.id == 'eclectico').unlocked, isTrue);
    });

    test('coleccionista unlocks at 50 unique artists', () {
      final list = AchievementsEngine.compute(_stats(artists: 50));
      expect(list.firstWhere((x) => x.id == 'coleccionista').unlocked, isTrue);
    });

    test('superfan unlocks at maxSameArtist >= 3', () {
      final list = AchievementsEngine.compute(_stats(maxSame: 3));
      expect(list.firstWhere((x) => x.id == 'superfan').unlocked, isTrue);
    });

    test('obsesionado unlocks at maxSameArtist >= 5', () {
      final list = AchievementsEngine.compute(_stats(maxSame: 5));
      expect(list.firstWhere((x) => x.id == 'obsesionado').unlocked, isTrue);
    });

    test('viajero unlocks at 3 cities', () {
      final list = AchievementsEngine.compute(_stats(cities: 3));
      expect(list.firstWhere((x) => x.id == 'viajero').unlocked, isTrue);
    });

    test('turista unlocks at 10 cities', () {
      final list = AchievementsEngine.compute(_stats(cities: 10));
      expect(list.firstWhere((x) => x.id == 'turista').unlocked, isTrue);
    });

    test('critico unlocks at 1 rated concert', () {
      final list = AchievementsEngine.compute(_stats(rated: 1));
      expect(list.firstWhere((x) => x.id == 'critico').unlocked, isTrue);
    });

    test('analitico unlocks at 25 rated concerts', () {
      final list = AchievementsEngine.compute(_stats(rated: 25));
      expect(list.firstWhere((x) => x.id == 'analitico').unlocked, isTrue);
    });

    test('perfeccionista unlocks at 1 five-star concert', () {
      final list = AchievementsEngine.compute(_stats(fiveStar: 1));
      expect(list.firstWhere((x) => x.id == 'perfeccionista').unlocked, isTrue);
    });

    test('apasionado unlocks at 10 favorites', () {
      final list = AchievementsEngine.compute(_stats(favorites: 10));
      expect(list.firstWhere((x) => x.id == 'apasionado').unlocked, isTrue);
    });

    test('maniroto unlocks at 500+ spent', () {
      final list = AchievementsEngine.compute(_stats(spent: 500));
      expect(list.firstWhere((x) => x.id == 'maniroto').unlocked, isTrue);
    });

    test('historico unlocks when oldestYear is 5+ years ago', () {
      final fiveYearsAgo = DateTime.now().year - 5;
      final list = AchievementsEngine.compute(_stats(oldestYear: fiveYearsAgo));
      expect(list.firstWhere((x) => x.id == 'historico').unlocked, isTrue);
    });

    test('historico does NOT unlock with recent year', () {
      final thisYear = DateTime.now().year;
      final list = AchievementsEngine.compute(_stats(oldestYear: thisYear));
      expect(list.firstWhere((x) => x.id == 'historico').unlocked, isFalse);
    });

    test('decada unlocks when oldestYear is 10+ years ago', () {
      final tenYearsAgo = DateTime.now().year - 10;
      final list = AchievementsEngine.compute(_stats(oldestYear: tenYearsAgo));
      expect(list.firstWhere((x) => x.id == 'decada').unlocked, isTrue);
    });

    test('all achievements have id, emoji, title, description', () {
      final list = AchievementsEngine.compute(_stats(total: 200));
      for (final a in list) {
        expect(a.id, isNotEmpty);
        expect(a.emoji, isNotEmpty);
        expect(a.title, isNotEmpty);
        expect(a.description, isNotEmpty);
      }
    });

    test('returns list with expected number of achievements', () {
      final list = AchievementsEngine.compute(_stats());
      expect(list.length, greaterThan(20));
    });
  });

  group('UserStats.fromJson', () {
    test('parses all fields from JSON', () {
      final json = {
        'totalConcerts': 10,
        'uniqueArtists': 8,
        'uniqueFestivals': 3,
        'uniqueCities': 5,
        'totalRated': 7,
        'oldestYear': 2015,
        'rockConcerts': 4,
        'metalConcerts': 1,
        'jazzConcerts': 0,
        'urbanConcerts': 2,
        'fiveStarConcerts': 3,
        'maxSameArtist': 2,
        'totalSpent': 350.0,
        'totalFavorites': 6,
      };
      final s = UserStats.fromJson(json);
      expect(s.totalConcerts, 10);
      expect(s.uniqueArtists, 8);
      expect(s.uniqueFestivals, 3);
      expect(s.oldestYear, 2015);
      expect(s.rockConcerts, 4);
      expect(s.totalSpent, 350.0);
      expect(s.totalFavorites, 6);
    });

    test('uses default values for missing keys', () {
      final s = UserStats.fromJson({});
      expect(s.totalConcerts, 0);
      expect(s.totalSpent, 0.0);
    });
  });
}
