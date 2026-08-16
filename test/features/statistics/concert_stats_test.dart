import 'package:flutter_test/flutter_test.dart';

import 'package:conciertos_app/features/concerts/domain/entities/concert.dart';
import 'package:conciertos_app/features/statistics/domain/concert_stats.dart';

/// Factoría de Concert mínima para tests de estadísticas.
/// Cuando [rating] > 0 se replica en todos los sub-ratings para que
/// [detailedAvg] devuelva exactamente ese valor (comportamiento post-migración).
Concert _c({
  String id = 'c',
  String artist = 'Artist',
  DateTime? date,
  int rating = 0,
  double price = 0,
  String festival = '',
  String venue = 'Venue',
  String city = 'Madrid',
  String genre = '',
  String userId = 'u1',
}) {
  return Concert(
    id: id,
    name: 'Concert $id',
    artist: artist,
    festival: festival,
    date: date ?? DateTime(2023, 6, 15),
    venue: venue,
    city: city,
    imageUrl: '',
    rating: rating,
    // Sub-ratings: se igualan a rating para que detailedAvg == rating
    soundRating: rating,
    atmosphereRating: rating,
    setlistRating: rating,
    valueRating: rating,
    artistRating: rating,
    liked: false,
    favorite: false,
    price: price,
    genre: genre,
    userId: userId,
  );
}

void main() {
  group('ConcertStatistics — empty list', () {
    final s = ConcertStatistics([]);

    test('total is 0', () => expect(s.total, 0));
    test('uniqueArtists is 0', () => expect(s.uniqueArtists, 0));
    test('uniqueFestivals is 0', () => expect(s.uniqueFestivals, 0));
    test('activeYears is 0', () => expect(s.activeYears, 0));
    test('avgRating is 0', () => expect(s.avgRating, 0));
    test('byYear is empty', () => expect(s.byYear, isEmpty));
    test('topArtists is empty', () => expect(s.topArtists, isEmpty));
    test('topFestivals is empty', () => expect(s.topFestivals, isEmpty));
    test('topCities is empty', () => expect(s.topCities, isEmpty));
    test('favoriteMonthIndex is null', () => expect(s.favoriteMonthIndex, isNull));
    test('totalSpent is 0', () => expect(s.totalSpent, 0));
    test('concertsWithPrice is 0', () => expect(s.concertsWithPrice, 0));
    test('festivalCount is 0', () => expect(s.festivalCount, 0));
    test('soloCount is 0', () => expect(s.soloCount, 0));
    test('repeatArtistPercent is 0', () => expect(s.repeatArtistPercent, 0));
    test('avgPrice is 0', () => expect(s.avgPrice, 0));
    test('mostExpensive is null', () => expect(s.mostExpensive, isNull));
    test('cheapest is null', () => expect(s.cheapest, isNull));
    test('avgRatingByYear is empty', () => expect(s.avgRatingByYear, isEmpty));
    test('topRatedArtists is empty', () => expect(s.topRatedArtists, isEmpty));
    test('longestStreakMonths is 0', () => expect(s.longestStreakMonths, 0));
    test('longestGapDays is 0', () => expect(s.longestGapDays, 0));
    test('byMonth has all 12 months with 0', () {
      final m = s.byMonth;
      expect(m.length, 12);
      expect(m.values.every((v) => v == 0), isTrue);
    });
    test('byDayOfWeek has all 7 days with 0', () {
      final m = s.byDayOfWeek;
      expect(m.length, 7);
      expect(m.values.every((v) => v == 0), isTrue);
    });
  });

  group('ConcertStatistics.total', () {
    test('counts all concerts', () {
      final s = ConcertStatistics([_c(id: 'a'), _c(id: 'b'), _c(id: 'c')]);
      expect(s.total, 3);
    });
  });

  group('ConcertStatistics.uniqueArtists', () {
    test('counts distinct non-empty artists', () {
      final s = ConcertStatistics([
        _c(artist: 'Muse'),
        _c(artist: 'Muse'),
        _c(artist: 'Radiohead'),
        _c(artist: ''),
      ]);
      expect(s.uniqueArtists, 2);
    });

    test('trims whitespace before comparing', () {
      final s = ConcertStatistics([_c(artist: ' Muse '), _c(artist: 'Muse')]);
      expect(s.uniqueArtists, 1);
    });
  });

  group('ConcertStatistics.uniqueFestivals', () {
    test('counts distinct non-empty festival names', () {
      final s = ConcertStatistics([
        _c(festival: 'Primavera'),
        _c(festival: 'Primavera'),
        _c(festival: 'Mad Cool'),
        _c(festival: ''),
      ]);
      expect(s.uniqueFestivals, 2);
    });
  });

  group('ConcertStatistics.avgRating', () {
    test('ignores concerts with rating 0', () {
      final s = ConcertStatistics([_c(rating: 0), _c(rating: 4), _c(rating: 2)]);
      expect(s.avgRating, 3.0);
    });

    test('returns 0 when no concerts are rated', () {
      final s = ConcertStatistics([_c(rating: 0)]);
      expect(s.avgRating, 0.0);
    });
  });

  group('ConcertStatistics.byYear', () {
    test('groups concerts by year in ascending order', () {
      final s = ConcertStatistics([
        _c(date: DateTime(2022, 3, 1)),
        _c(date: DateTime(2022, 7, 1)),
        _c(date: DateTime(2023, 1, 1)),
      ]);
      expect(s.byYear, {2022: 2, 2023: 1});
      expect(s.byYear.keys.toList(), [2022, 2023]);
    });
  });

  group('ConcertStatistics.topArtists', () {
    test('returns top 5 artists sorted by count desc', () {
      final concerts = [
        for (int i = 0; i < 4; i++) _c(artist: 'Muse'),
        for (int i = 0; i < 2; i++) _c(artist: 'Radiohead'),
        _c(artist: 'Coldplay'),
      ];
      final s = ConcertStatistics(concerts);
      final top = s.topArtists;
      expect(top.first.key, 'Muse');
      expect(top.first.value, 4);
    });

    test('limits to 5 results', () {
      final concerts = [
        for (final a in ['A', 'B', 'C', 'D', 'E', 'F']) _c(artist: a),
      ];
      expect(ConcertStatistics(concerts).topArtists.length, 5);
    });

    test('excludes empty artist names', () {
      final s = ConcertStatistics([_c(artist: ''), _c(artist: ''), _c(artist: 'X')]);
      expect(s.topArtists.length, 1);
      expect(s.topArtists.first.key, 'X');
    });
  });

  group('ConcertStatistics.topFestivals', () {
    test('counts festival visits across years', () {
      final s = ConcertStatistics([
        _c(festival: 'Primavera', date: DateTime(2022, 6, 1)),
        _c(festival: 'Primavera', date: DateTime(2022, 6, 2)), // same year
        _c(festival: 'Primavera', date: DateTime(2023, 6, 1)), // different year
      ]);
      // 2 editions (2022 + 2023)
      final top = s.topFestivals;
      expect(top.first.key, 'Primavera');
      expect(top.first.value, 2);
    });
  });

  group('ConcertStatistics.topCities', () {
    test('counts concerts per city', () {
      final s = ConcertStatistics([
        _c(city: 'Madrid'),
        _c(city: 'Madrid'),
        _c(city: 'Barcelona'),
      ]);
      final top = s.topCities;
      expect(top.first.key, 'Madrid');
      expect(top.first.value, 2);
    });

    test('deduplicates festival days in same city', () {
      final s = ConcertStatistics([
        _c(city: 'Madrid', festival: 'Mad Cool', date: DateTime(2023, 7, 1)),
        _c(city: 'Madrid', festival: 'Mad Cool', date: DateTime(2023, 7, 2)),
        _c(city: 'Madrid', festival: ''), // solo — counts
      ]);
      // Mad Cool in Madrid 2023 counted once + solo
      final top = s.topCities;
      expect(top.where((e) => e.key == 'Madrid').first.value, 2);
    });

    test('ignores empty city', () {
      final s = ConcertStatistics([_c(city: ''), _c(city: 'Valencia')]);
      expect(s.topCities.length, 1);
    });
  });

  group('ConcertStatistics.byRating', () {
    test('counts concerts per rating value', () {
      final s = ConcertStatistics([
        _c(rating: 5), _c(rating: 5),
        _c(rating: 3),
        _c(rating: 0),
      ]);
      final r = s.byRating;
      expect(r[5], 2);
      expect(r[3], 1);
      expect(r[1], 0);
    });

    test('always has keys 1-5', () {
      expect(ConcertStatistics([]).byRating.keys.toSet(), {1, 2, 3, 4, 5});
    });
  });

  group('ConcertStatistics.favoriteMonthIndex', () {
    test('returns month with most concerts', () {
      final s = ConcertStatistics([
        _c(date: DateTime(2023, 7, 1)),
        _c(date: DateTime(2023, 7, 15)),
        _c(date: DateTime(2023, 6, 10)),
      ]);
      expect(s.favoriteMonthIndex, 7);
    });

    test('returns null for empty list', () {
      expect(ConcertStatistics([]).favoriteMonthIndex, isNull);
    });
  });

  group('ConcertStatistics.totalSpent', () {
    test('sums solo concert prices', () {
      final s = ConcertStatistics([
        _c(price: 50, festival: ''),
        _c(price: 30, festival: ''),
      ]);
      expect(s.totalSpent, 80.0);
    });

    test('uses max price for festival group, not sum', () {
      final s = ConcertStatistics([
        _c(festival: 'Primavera', price: 150, date: DateTime(2023, 6, 1)),
        _c(festival: 'Primavera', price: 0, date: DateTime(2023, 6, 2)),
      ]);
      expect(s.totalSpent, 150.0);
    });

    test('counts same festival in different years separately', () {
      final s = ConcertStatistics([
        _c(festival: 'P', price: 100, date: DateTime(2022, 6, 1)),
        _c(festival: 'P', price: 120, date: DateTime(2023, 6, 1)),
      ]);
      expect(s.totalSpent, 220.0);
    });
  });

  group('ConcertStatistics.concertsWithPrice', () {
    test('counts solo concerts with price > 0', () {
      final s = ConcertStatistics([
        _c(price: 50), _c(price: 0), _c(price: 30),
      ]);
      expect(s.concertsWithPrice, 2);
    });

    test('counts festival group as 1 if any day has price', () {
      final s = ConcertStatistics([
        _c(festival: 'F', price: 0, date: DateTime(2023, 6, 1)),
        _c(festival: 'F', price: 80, date: DateTime(2023, 6, 2)),
      ]);
      expect(s.concertsWithPrice, 1);
    });
  });

  group('ConcertStatistics.byMonth', () {
    test('increments correct month', () {
      final s = ConcertStatistics([
        _c(date: DateTime(2023, 3, 10)),
        _c(date: DateTime(2023, 3, 20)),
        _c(date: DateTime(2023, 7, 5)),
      ]);
      final m = s.byMonth;
      expect(m[3], 2);
      expect(m[7], 1);
      expect(m[1], 0);
    });
  });

  group('ConcertStatistics.byDayOfWeek', () {
    test('increments correct weekday', () {
      // 2023-03-10 is a Friday (5), 2023-03-11 is a Saturday (6)
      final s = ConcertStatistics([
        _c(date: DateTime(2023, 3, 10)),
        _c(date: DateTime(2023, 3, 11)),
        _c(date: DateTime(2023, 3, 10)),
      ]);
      final d = s.byDayOfWeek;
      expect(d[5], 2); // Friday x2
      expect(d[6], 1); // Saturday x1
    });
  });

  group('ConcertStatistics.festivalCount / soloCount', () {
    test('festival vs solo split', () {
      final s = ConcertStatistics([
        _c(festival: 'F'), _c(festival: 'F'), _c(festival: ''),
      ]);
      expect(s.festivalCount, 2);
      expect(s.soloCount, 1);
    });
  });

  group('ConcertStatistics.repeatArtistPercent', () {
    test('50% when half are repeat artists', () {
      final s = ConcertStatistics([
        _c(artist: 'Muse'),
        _c(artist: 'Muse'),
        _c(artist: 'Radiohead'),
        _c(artist: 'Coldplay'),
      ]);
      expect(s.repeatArtistPercent, 50.0);
    });

    test('0% when all artists unique', () {
      final s = ConcertStatistics([_c(artist: 'A'), _c(artist: 'B')]);
      expect(s.repeatArtistPercent, 0.0);
    });

    test('100% when same artist repeated all', () {
      final s = ConcertStatistics([_c(artist: 'X'), _c(artist: 'X')]);
      expect(s.repeatArtistPercent, 100.0);
    });
  });

  group('ConcertStatistics.avgPrice / mostExpensive / cheapest', () {
    final concerts = [
      _c(price: 20),
      _c(id: 'c2', price: 60),
      _c(id: 'c3', price: 40),
    ];
    final s = ConcertStatistics(concerts);

    test('avgPrice is mean of non-zero prices', () {
      expect(s.avgPrice, closeTo(40.0, 0.01));
    });

    test('mostExpensive has highest price', () {
      expect(s.mostExpensive!.price, 60.0);
    });

    test('cheapest has lowest price', () {
      expect(s.cheapest!.price, 20.0);
    });

    test('ignores zero-price concerts in avg', () {
      final s2 = ConcertStatistics([_c(price: 0), _c(price: 80)]);
      expect(s2.avgPrice, 80.0);
    });
  });

  group('ConcertStatistics.avgRatingByYear', () {
    test('groups ratings by year and computes average', () {
      final s = ConcertStatistics([
        _c(date: DateTime(2022, 1, 1), rating: 4),
        _c(date: DateTime(2022, 6, 1), rating: 2),
        _c(date: DateTime(2023, 1, 1), rating: 5),
      ]);
      final avg = s.avgRatingByYear;
      expect(avg[2022], 3.0);
      expect(avg[2023], 5.0);
    });

    test('ignores concerts with rating 0', () {
      final s = ConcertStatistics([
        _c(date: DateTime(2022, 1, 1), rating: 0),
        _c(date: DateTime(2022, 6, 1), rating: 4),
      ]);
      expect(s.avgRatingByYear[2022], 4.0);
    });
  });

  group('ConcertStatistics.topRatedArtists', () {
    test('only includes artists seen >= 2 times with rating', () {
      final s = ConcertStatistics([
        _c(artist: 'Muse', rating: 5),
        _c(artist: 'Muse', rating: 3),
        _c(artist: 'Radiohead', rating: 4), // seen once → excluded
      ]);
      final top = s.topRatedArtists;
      expect(top.length, 1);
      expect(top.first.key, 'Muse');
      expect(top.first.value, closeTo(4.0, 0.01));
    });

    test('sorts by avg rating descending', () {
      final s = ConcertStatistics([
        _c(artist: 'A', rating: 5), _c(artist: 'A', rating: 5),
        _c(artist: 'B', rating: 3), _c(artist: 'B', rating: 3),
      ]);
      final top = s.topRatedArtists;
      expect(top.first.key, 'A');
    });

    test('limits to 5 artists', () {
      final artists = ['A', 'B', 'C', 'D', 'E', 'F'];
      final concerts = [
        for (final a in artists) ...[
          _c(artist: a, rating: 4),
          _c(artist: a, rating: 4),
        ]
      ];
      expect(ConcertStatistics(concerts).topRatedArtists.length, 5);
    });
  });

  group('ConcertStatistics.longestStreakMonths', () {
    test('returns 1 for isolated months', () {
      final s = ConcertStatistics([
        _c(date: DateTime(2023, 1, 1)),
        _c(date: DateTime(2023, 3, 1)),
        _c(date: DateTime(2023, 5, 1)),
      ]);
      expect(s.longestStreakMonths, 1);
    });

    test('detects 3-month streak', () {
      final s = ConcertStatistics([
        _c(date: DateTime(2023, 6, 1)),
        _c(date: DateTime(2023, 7, 1)),
        _c(date: DateTime(2023, 8, 1)),
        _c(date: DateTime(2023, 10, 1)),
      ]);
      expect(s.longestStreakMonths, 3);
    });

    test('handles consecutive months across year boundary', () {
      final s = ConcertStatistics([
        _c(date: DateTime(2022, 11, 1)),
        _c(date: DateTime(2022, 12, 1)),
        _c(date: DateTime(2023, 1, 1)),
      ]);
      expect(s.longestStreakMonths, 3);
    });

    test('deduplicates multiple concerts in same month', () {
      final s = ConcertStatistics([
        _c(date: DateTime(2023, 6, 1)),
        _c(date: DateTime(2023, 6, 15)),
        _c(date: DateTime(2023, 7, 1)),
      ]);
      expect(s.longestStreakMonths, 2);
    });
  });

  group('ConcertStatistics.longestGapDays', () {
    test('returns 0 for single concert', () {
      expect(ConcertStatistics([_c()]).longestGapDays, 0);
    });

    test('computes gap between two concerts', () {
      final s = ConcertStatistics([
        _c(date: DateTime(2023, 1, 1)),
        _c(date: DateTime(2023, 1, 11)),
      ]);
      expect(s.longestGapDays, 10);
    });

    test('returns largest gap when multiple concerts', () {
      final s = ConcertStatistics([
        _c(date: DateTime(2023, 1, 1)),
        _c(date: DateTime(2023, 1, 5)),   // gap 4
        _c(date: DateTime(2023, 2, 5)),   // gap 31
      ]);
      expect(s.longestGapDays, 31);
    });

    test('ignores time component', () {
      final s = ConcertStatistics([
        _c(date: DateTime(2023, 6, 1, 20, 0)),
        _c(date: DateTime(2023, 6, 8, 10, 0)),
      ]);
      expect(s.longestGapDays, 7);
    });
  });

  group('ConcertStatistics.topGenres', () {
    test('returns top genres by count', () {
      final s = ConcertStatistics([
        _c(genre: 'Rock'), _c(genre: 'Rock'),
        _c(genre: 'Pop'),
        _c(genre: ''),
      ]);
      final top = s.topGenres;
      expect(top.first.key, 'Rock');
      expect(top.first.value, 2);
    });

    test('limits to 8 genres', () {
      final genres = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'];
      final concerts = [for (final g in genres) _c(genre: g)];
      expect(ConcertStatistics(concerts).topGenres.length, 8);
    });
  });

  group('ConcertStatistics.topVenues', () {
    test('returns top venues by count', () {
      final s = ConcertStatistics([
        _c(venue: 'WiZink'), _c(venue: 'WiZink'),
        _c(venue: 'Palau'),
      ]);
      expect(s.topVenues.first.key, 'WiZink');
    });

    test('limits to 5 venues', () {
      final venues = ['A', 'B', 'C', 'D', 'E', 'F'];
      final concerts = [for (final v in venues) _c(venue: v)];
      expect(ConcertStatistics(concerts).topVenues.length, 5);
    });
  });
}
