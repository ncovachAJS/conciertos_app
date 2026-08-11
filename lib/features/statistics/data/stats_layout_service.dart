import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/stats_section.dart';

class StatsLayoutService {
  static const _key = 'stats_layout_v1';

  static const List<StatsSection> defaults = [
    StatsSection(id: StatsSectionId.summary, visible: true),
    StatsSection(id: StatsSectionId.byYear, visible: true),
    StatsSection(id: StatsSectionId.byMonth, visible: true),
    StatsSection(id: StatsSectionId.byDayOfWeek, visible: true),
    StatsSection(id: StatsSectionId.topArtists, visible: true),
    StatsSection(id: StatsSectionId.topGenres, visible: true),
    StatsSection(id: StatsSectionId.topFestivals, visible: true),
    StatsSection(id: StatsSectionId.topCities, visible: true),
    StatsSection(id: StatsSectionId.topVenues, visible: true),
    StatsSection(id: StatsSectionId.festivalSplit, visible: true),
    StatsSection(id: StatsSectionId.ratingDist, visible: true),
    StatsSection(id: StatsSectionId.avgRatingByYear, visible: true),
    StatsSection(id: StatsSectionId.topRatedArtists, visible: true),
    StatsSection(id: StatsSectionId.priceStats, visible: true),
  ];

  Future<List<StatsSection>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return List.of(defaults);

    try {
      final list = jsonDecode(raw) as List<dynamic>;
      final saved = list
          .map((e) => StatsSection.fromJson(e as Map<String, dynamic>))
          .toList();
      final savedIds = saved.map((s) => s.id).toSet();
      final missing = defaults.where((d) => !savedIds.contains(d.id));
      return [...saved, ...missing];
    } catch (_) {
      return List.of(defaults);
    }
  }

  Future<void> save(List<StatsSection> sections) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(sections.map((s) => s.toJson()).toList()),
    );
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
