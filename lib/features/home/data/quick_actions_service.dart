import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/presentation/controllers/auth_controller.dart';
import '../domain/quick_action.dart';

/// Persiste qué atajos aparecen en la fila de accesos rápidos del dashboard.
class QuickActionsService {
  static const _key = 'quick_actions_v1';

  /// Convierte lo guardado (lista de nombres) en una lista válida:
  /// descarta nombres desconocidos, duplicados y atajos Pro si [isPro] es
  /// false, recorta a [kMaxQuickActions] y, si no queda nada, usa los
  /// valores por defecto.
  static List<QuickActionId> merge(List<String> saved, {required bool isPro}) {
    final result = <QuickActionId>[];
    for (final name in saved) {
      final id = QuickActionId.values.where((e) => e.name == name).firstOrNull;
      if (id == null || result.contains(id)) continue;
      if (!isPro && kProOnlyQuickActions.contains(id)) continue;
      result.add(id);
      if (result.length == kMaxQuickActions) break;
    }
    return result.isEmpty ? List.of(kDefaultQuickActions) : result;
  }

  Future<List<QuickActionId>> load() async {
    // Fase de pruebas: isPro real (ProConfig.isUserPro está abierto a todos).
    final isPro = AuthController.instance.user?.isPro == true;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return List.of(kDefaultQuickActions);
    try {
      final names = (jsonDecode(raw) as List<dynamic>).cast<String>();
      return merge(names, isPro: isPro);
    } catch (_) {
      return List.of(kDefaultQuickActions);
    }
  }

  Future<void> save(List<QuickActionId> actions) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(actions.map((a) => a.name).toList()),
    );
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
