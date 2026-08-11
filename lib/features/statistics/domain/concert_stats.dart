import '../../concerts/domain/entities/concert.dart';

/// Cálculos estadísticos sobre una lista de conciertos.
///
/// Clase pública extraída de statistics_page.dart para permitir
/// pruebas unitarias independientes del framework de UI.
class ConcertStatistics {
  final List<Concert> concerts;

  ConcertStatistics(this.concerts);

  int get total => concerts.length;

  int get uniqueArtists => concerts
      .map((c) => c.artist.trim())
      .where((a) => a.isNotEmpty)
      .toSet()
      .length;

  int get uniqueFestivals => concerts
      .map((c) => c.festival.trim())
      .where((f) => f.isNotEmpty)
      .toSet()
      .length;

  int get activeYears => concerts.map((c) => c.date.year).toSet().length;

  double get avgRating {
    final rated = concerts.where((c) => c.rating > 0).toList();
    if (rated.isEmpty) return 0;
    return rated.fold<int>(0, (s, c) => s + c.rating) / rated.length;
  }

  Map<int, int> get byYear {
    final map = <int, int>{};
    for (final c in concerts) {
      map[c.date.year] = (map[c.date.year] ?? 0) + 1;
    }
    return Map.fromEntries(
      map.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  List<MapEntry<String, int>> get topArtists =>
      _top(concerts.map((c) => c.artist.trim()).where((a) => a.isNotEmpty));

  List<MapEntry<String, int>> get topFestivals {
    final uniqueVisits = <String>{};
    for (final concert in concerts) {
      if (concert.festival.trim().isEmpty) continue;
      uniqueVisits.add('${concert.festival.trim()}_${concert.date.year}');
    }
    final counts = <String, int>{};
    for (final visit in uniqueVisits) {
      final festival = visit.substring(0, visit.lastIndexOf('_'));
      counts[festival] = (counts[festival] ?? 0) + 1;
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(5).toList();
  }

  List<MapEntry<String, int>> get topCities {
    final counts = <String, int>{};
    final countedFestivals = <String>{};
    for (final concert in concerts) {
      if (concert.city.trim().isEmpty) continue;
      if (concert.festival.trim().isNotEmpty) {
        final festivalVisit =
            '${concert.festival.trim()}_${concert.date.year}_${concert.city.trim()}';
        if (countedFestivals.contains(festivalVisit)) continue;
        countedFestivals.add(festivalVisit);
      }
      counts[concert.city] = (counts[concert.city] ?? 0) + 1;
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(5).toList();
  }

  Map<int, int> get byRating {
    final map = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final c in concerts.where((c) => c.rating > 0)) {
      map[c.rating] = (map[c.rating] ?? 0) + 1;
    }
    return map;
  }

  int? get favoriteMonthIndex {
    final map = <int, int>{};
    for (final c in concerts) {
      map[c.date.month] = (map[c.date.month] ?? 0) + 1;
    }
    if (map.isEmpty) return null;
    return map.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  double get totalSpent {
    var total = 0.0;
    final countedFestivals = <String>{};
    for (final c in concerts) {
      final fest = c.festival.trim();
      if (fest.isNotEmpty) {
        final key = '${fest}_${c.date.year}';
        if (!countedFestivals.contains(key)) {
          final festMax = concerts
              .where(
                  (f) => f.festival.trim() == fest && f.date.year == c.date.year)
              .fold(0.0, (max, f) => f.price > max ? f.price : max);
          total += festMax;
          countedFestivals.add(key);
        }
      } else {
        total += c.price;
      }
    }
    return total;
  }

  int get concertsWithPrice {
    final countedFestivals = <String>{};
    var count = 0;
    for (final c in concerts) {
      final fest = c.festival.trim();
      if (fest.isNotEmpty) {
        final key = '${fest}_${c.date.year}';
        if (!countedFestivals.contains(key)) {
          final hasPrice = concerts.any((f) =>
              f.festival.trim() == fest &&
              f.date.year == c.date.year &&
              f.price > 0);
          if (hasPrice) count++;
          countedFestivals.add(key);
        }
      } else if (c.price > 0) {
        count++;
      }
    }
    return count;
  }

  List<MapEntry<String, int>> _top(Iterable<String> values, {int take = 5}) {
    final map = <String, int>{};
    for (final v in values) {
      map[v] = (map[v] ?? 0) + 1;
    }
    final sorted = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(take).toList();
  }

  // ── Nuevas métricas ─────────────────────────────────────────────────────────

  Map<int, int> get byMonth {
    final map = <int, int>{for (int i = 1; i <= 12; i++) i: 0};
    for (final c in concerts) {
      map[c.date.month] = (map[c.date.month] ?? 0) + 1;
    }
    return map;
  }

  Map<int, int> get byDayOfWeek {
    final map = <int, int>{for (int i = 1; i <= 7; i++) i: 0};
    for (final c in concerts) {
      map[c.date.weekday] = (map[c.date.weekday] ?? 0) + 1;
    }
    return map;
  }

  List<MapEntry<String, int>> get topGenres => _top(
        concerts.map((c) => c.genre.trim()).where((g) => g.isNotEmpty),
        take: 8,
      );

  List<MapEntry<String, int>> get topVenues => _top(
        concerts.map((c) => c.venue.trim()).where((v) => v.isNotEmpty),
      );

  int get festivalCount =>
      concerts.where((c) => c.festival.trim().isNotEmpty).length;

  int get soloCount =>
      concerts.where((c) => c.festival.trim().isEmpty).length;

  double get repeatArtistPercent {
    if (concerts.isEmpty) return 0;
    final counts = <String, int>{};
    for (final c in concerts) {
      final a = c.artist.trim();
      if (a.isNotEmpty) counts[a] = (counts[a] ?? 0) + 1;
    }
    final repeated =
        counts.values.where((v) => v > 1).fold<int>(0, (s, v) => s + v);
    return repeated / concerts.length * 100;
  }

  double get avgPrice {
    final w = concerts.where((c) => c.price > 0).toList();
    if (w.isEmpty) return 0;
    return w.fold<double>(0, (s, c) => s + c.price) / w.length;
  }

  Concert? get mostExpensive {
    final w = concerts.where((c) => c.price > 0).toList();
    if (w.isEmpty) return null;
    return w.reduce((a, b) => a.price > b.price ? a : b);
  }

  Concert? get cheapest {
    final w = concerts.where((c) => c.price > 0).toList();
    if (w.isEmpty) return null;
    return w.reduce((a, b) => a.price < b.price ? a : b);
  }

  Map<int, double> get avgRatingByYear {
    final map = <int, List<int>>{};
    for (final c in concerts.where((c) => c.rating > 0)) {
      (map[c.date.year] ??= []).add(c.rating);
    }
    return map.map(
        (y, r) => MapEntry(y, r.fold<int>(0, (s, v) => s + v) / r.length));
  }

  List<MapEntry<String, double>> get topRatedArtists {
    final map = <String, List<int>>{};
    for (final c
        in concerts.where((c) => c.rating > 0 && c.artist.trim().isNotEmpty)) {
      (map[c.artist.trim()] ??= []).add(c.rating);
    }
    return (map.entries
            .where((e) => e.value.length >= 2)
            .map((e) => MapEntry(
                  e.key,
                  e.value.fold<int>(0, (s, r) => s + r) / e.value.length,
                ))
            .toList()
          ..sort((a, b) => b.value.compareTo(a.value)))
        .take(5)
        .toList();
  }

  int get longestStreakMonths {
    if (concerts.isEmpty) return 0;
    final months = concerts
        .map((c) => c.date.year * 12 + c.date.month)
        .toSet()
        .toList()
      ..sort();
    int maxS = 1, cur = 1;
    for (int i = 1; i < months.length; i++) {
      if (months[i] == months[i - 1] + 1) {
        cur++;
        if (cur > maxS) maxS = cur;
      } else {
        cur = 1;
      }
    }
    return maxS;
  }

  int get longestGapDays {
    if (concerts.length < 2) return 0;
    final sorted = concerts
        .map((c) => DateTime(c.date.year, c.date.month, c.date.day))
        .toList()
      ..sort();
    int maxG = 0;
    for (int i = 1; i < sorted.length; i++) {
      final g = sorted[i].difference(sorted[i - 1]).inDays;
      if (g > maxG) maxG = g;
    }
    return maxG;
  }
}
