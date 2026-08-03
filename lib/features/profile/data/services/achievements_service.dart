import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/achievement.dart';

class AchievementsService {
  static const _key = 'unlocked_achievements';

  static Future<Set<String>> getUnlocked() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key)?.toSet() ?? {};
  }

  /// Compara los logros actuales con los guardados.
  /// Guarda los nuevos y devuelve la lista de logros recién desbloqueados.
  static Future<List<Achievement>> checkNewUnlocks(
      List<Achievement> current) async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_key)?.toSet() ?? {};

    final nowUnlocked = current.where((a) => a.unlocked).map((a) => a.id).toSet();
    final newOnes = nowUnlocked.difference(stored);

    if (newOnes.isNotEmpty) {
      await prefs.setStringList(_key, nowUnlocked.toList());
    }

    return current.where((a) => newOnes.contains(a.id)).toList();
  }
}
