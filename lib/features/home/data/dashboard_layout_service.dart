import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/dashboard_section.dart';

/// Persiste el orden y visibilidad de las secciones del dashboard
/// en SharedPreferences.
class DashboardLayoutService {
  static const _key = 'dashboard_layout_v1';

  /// Orden y visibilidad por defecto.
  static const List<DashboardSection> defaults = [
    DashboardSection(id: DashboardSectionId.streak, visible: true),
    DashboardSection(id: DashboardSectionId.annualGoal, visible: true),
    DashboardSection(id: DashboardSectionId.ratePending, visible: true),
    DashboardSection(id: DashboardSectionId.onThisDay, visible: true),
    DashboardSection(id: DashboardSectionId.upcoming, visible: true),
    DashboardSection(id: DashboardSectionId.stats, visible: true),
    DashboardSection(id: DashboardSectionId.recommended, visible: true),
    DashboardSection(id: DashboardSectionId.favorites, visible: true),
    DashboardSection(id: DashboardSectionId.recent, visible: true),
    DashboardSection(id: DashboardSectionId.spotifyEmbed, visible: true),
  ];

  Future<List<DashboardSection>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return List.of(defaults);

    try {
      final list = jsonDecode(raw) as List<dynamic>;
      final saved = list
          .map((e) => DashboardSection.fromJson(e as Map<String, dynamic>))
          .toList();

      // Compatibilidad hacia adelante: si se añaden secciones nuevas
      // en futuras versiones, las añadimos al final con visible=true.
      final savedIds = saved.map((s) => s.id).toSet();
      final missing = defaults.where((d) => !savedIds.contains(d.id));
      return [...saved, ...missing];
    } catch (_) {
      return List.of(defaults);
    }
  }

  Future<void> save(List<DashboardSection> sections) async {
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
