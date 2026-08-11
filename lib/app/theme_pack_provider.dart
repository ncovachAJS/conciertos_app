import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'color_themes.dart';

const _kThemePackKey = 'theme_pack_id';

class ThemePackNotifier extends Notifier<ThemePack> {
  @override
  ThemePack build() {
    _load();
    return ColorThemes.escenario;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_kThemePackKey) ?? 'escenario';
    state = ColorThemes.findById(id);
  }

  Future<void> setPack(ThemePack pack) async {
    state = pack;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemePackKey, pack.id);
  }
}

final themePackProvider = NotifierProvider<ThemePackNotifier, ThemePack>(
  ThemePackNotifier.new,
);
