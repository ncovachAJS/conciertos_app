import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:conciertos_app/core/utils/user_prefs.dart';
import 'package:conciertos_app/features/auth/presentation/providers/current_user_provider.dart';

import 'color_themes.dart';

const _kThemePackKey = 'theme_pack_id';

class ThemePackNotifier extends Notifier<ThemePack> {
  @override
  ThemePack build() {
    ref.watch(currentUserIdProvider);
    _load();
    return ColorThemes.escenario;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    await UserPrefs.claimLegacy(prefs, _kThemePackKey);
    final id = prefs.getString(UserPrefs.key(_kThemePackKey)) ?? 'escenario';
    state = ColorThemes.findById(id);
  }

  Future<void> setPack(ThemePack pack) async {
    state = pack;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(UserPrefs.key(_kThemePackKey), pack.id);
  }
}

final themePackProvider = NotifierProvider<ThemePackNotifier, ThemePack>(
  ThemePackNotifier.new,
);
