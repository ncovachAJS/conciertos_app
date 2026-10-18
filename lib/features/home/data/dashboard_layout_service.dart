import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/presentation/controllers/auth_controller.dart';
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
    DashboardSection(id: DashboardSectionId.records, visible: true),
    DashboardSection(id: DashboardSectionId.stats, visible: true),
    DashboardSection(id: DashboardSectionId.recommended, visible: true),
    DashboardSection(id: DashboardSectionId.favorites, visible: true),
    DashboardSection(id: DashboardSectionId.recent, visible: true),
  ];

  /// Secciones que solo existen para usuarios con Pro real.
  static const _proOnly = {DashboardSectionId.records};

  /// Combina el layout guardado con los valores por defecto.
  ///
  /// - Descarta secciones eliminadas (spotifyEmbed) y las Pro si [isPro] es false.
  /// - Las secciones nuevas que el usuario aún no tiene se insertan justo
  ///   detrás de la que las precede en [defaults] (no al final, donde nadie
  ///   las vería), con visible=true.
  static List<DashboardSection> merge(
    List<DashboardSection> saved, {
    required bool isPro,
  }) {
    bool allowed(DashboardSectionId id) => isPro || !_proOnly.contains(id);

    final result = saved
        .where((s) => s.id != DashboardSectionId.spotifyEmbed)
        .where((s) => allowed(s.id))
        .toList();

    for (var i = 0; i < defaults.length; i++) {
      final d = defaults[i];
      if (!allowed(d.id) || result.any((s) => s.id == d.id)) continue;

      var insertAt = 0;
      if (i > 0) {
        final prevIndex = result.indexWhere((s) => s.id == defaults[i - 1].id);
        insertAt = prevIndex >= 0 ? prevIndex + 1 : result.length;
      }
      result.insert(insertAt, d);
    }
    return result;
  }

  Future<List<DashboardSection>> load() async {
    // Fase de pruebas: isPro real (no ProConfig.isUserPro, que está abierto a todos).
    final isPro = AuthController.instance.user?.isPro == true;

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return merge(const [], isPro: isPro);

    try {
      final list = jsonDecode(raw) as List<dynamic>;
      final saved = list
          .map((e) => DashboardSection.fromJson(e as Map<String, dynamic>))
          .toList();
      return merge(saved, isPro: isPro);
    } catch (_) {
      return merge(const [], isPro: isPro);
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
