import 'package:shared_preferences/shared_preferences.dart';

/// Gestiona qué tutoriales ya se han mostrado.
/// Usa SharedPreferences para persistir entre sesiones.
class TutorialService {
  static const _dashboard = 'tutorial_dashboard_v1';
  static const _detail = 'tutorial_detail_v1';
  static const _addConcert = 'tutorial_add_concert_v1';

  static Future<bool> shouldShow(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(key) ?? false);
  }

  static Future<void> markShown(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, true);
  }

  // Claves públicas
  static String get dashboard => _dashboard;
  static String get detail => _detail;
  static String get addConcert => _addConcert;

  /// Resetea todos los tutoriales (útil para testing)
  static Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_dashboard);
    await prefs.remove(_detail);
    await prefs.remove(_addConcert);
  }
}
