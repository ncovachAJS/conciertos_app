import 'package:shared_preferences/shared_preferences.dart';

import 'package:conciertos_app/features/auth/presentation/controllers/auth_controller.dart';

/// Claves de SharedPreferences separadas por usuario, para que cada cuenta
/// conserve su propia personalización en un mismo dispositivo.
class UserPrefs {
  UserPrefs._();

  /// Clave de [base] para el usuario con sesión iniciada (`guest` si no hay).
  static String key(String base) =>
      '${base}_u${AuthController.instance.user?.id ?? 'guest'}';

  /// Antes las preferencias eran globales. El primer usuario que las lee las
  /// reclama (se copian a su clave y se borra la global); los demás empiezan
  /// con los valores por defecto.
  static Future<void> claimLegacy(SharedPreferences prefs, String base) async {
    if (AuthController.instance.user == null) return;
    final scoped = key(base);
    if (prefs.containsKey(scoped) || !prefs.containsKey(base)) return;
    final value = prefs.get(base);
    if (value is String) {
      await prefs.setString(scoped, value);
    } else if (value is bool) {
      await prefs.setBool(scoped, value);
    } else if (value is int) {
      await prefs.setInt(scoped, value);
    } else if (value is List<String>) {
      await prefs.setStringList(scoped, value);
    }
    await prefs.remove(base);
  }
}
