import 'package:shared_preferences/shared_preferences.dart';

/// Gestiona qué tutoriales ya se han mostrado.
/// Usa SharedPreferences para persistir entre sesiones.
class TutorialService {
  // ── Claves privadas ────────────────────────────────────────────────────────
  static const _dashboard    = 'tutorial_dashboard_v1';
  static const _detail       = 'tutorial_detail_v1';
  static const _addConcert   = 'tutorial_add_concert_v1';
  static const _concerts     = 'tutorial_concerts_v1';
  static const _statistics   = 'tutorial_statistics_v1';
  static const _profile      = 'tutorial_profile_v1';
  static const _friends      = 'tutorial_friends_v1';
  static const _feed         = 'tutorial_feed_v1';
  static const _recs         = 'tutorial_recs_v1';
  static const _import       = 'tutorial_import_v1';

  static const _allKeys = [
    _dashboard, _detail, _addConcert, _concerts,
    _statistics, _profile, _friends, _feed, _recs, _import,
  ];

  // ── Getters públicos ───────────────────────────────────────────────────────
  static String get dashboard  => _dashboard;
  static String get detail     => _detail;
  static String get addConcert => _addConcert;
  static String get concerts   => _concerts;
  static String get statistics => _statistics;
  static String get profile    => _profile;
  static String get friends    => _friends;
  static String get feed       => _feed;
  static String get recs       => _recs;
  static String get import_    => _import;

  // ── API ───────────────────────────────────────────────────────────────────

  /// Devuelve true si el tutorial aún no se ha mostrado.
  static Future<bool> shouldShow(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(key) ?? false);
  }

  /// Marca el tutorial como ya mostrado.
  static Future<void> markShown(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, true);
  }

  /// Resetea TODOS los tutoriales (al registrar cuenta nueva).
  static Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in _allKeys) {
      await prefs.remove(key);
    }
  }
}
