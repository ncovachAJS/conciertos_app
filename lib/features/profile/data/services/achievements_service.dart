import 'package:conciertos_app/core/utils/user_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/achievement.dart';

class AchievementsService {
  static const _key = 'unlocked_achievements';

  static Future<Set<String>> getUnlocked() async {
    final prefs = await SharedPreferences.getInstance();
    await UserPrefs.claimLegacy(prefs, _key);
    return prefs.getStringList(UserPrefs.key(_key))?.toSet() ?? {};
  }

  /// Compara los logros actuales con los guardados.
  /// Guarda los nuevos y devuelve la lista de logros recién desbloqueados.
  static Future<List<Achievement>> checkNewUnlocks(
      List<Achievement> current) async {
    final prefs = await SharedPreferences.getInstance();
    await UserPrefs.claimLegacy(prefs, _key);
    final stored = prefs.getStringList(UserPrefs.key(_key))?.toSet() ?? {};

    final nowUnlocked = current.where((a) => a.unlocked).map((a) => a.id).toSet();
    final newOnes = nowUnlocked.difference(stored);

    if (newOnes.isNotEmpty) {
      await prefs.setStringList(UserPrefs.key(_key), nowUnlocked.toList());
    }

    return current.where((a) => newOnes.contains(a.id)).toList();
  }
}
