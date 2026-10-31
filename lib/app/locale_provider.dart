import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:conciertos_app/core/utils/user_prefs.dart';
import 'package:conciertos_app/features/auth/presentation/providers/current_user_provider.dart';

const _kLocaleKey = 'app_locale';

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    ref.watch(currentUserIdProvider);
    _load();
    return const Locale('es');
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    await UserPrefs.claimLegacy(prefs, _kLocaleKey);
    final saved = prefs.getString(UserPrefs.key(_kLocaleKey));
    if (saved != null) state = Locale(saved);
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(UserPrefs.key(_kLocaleKey), locale.languageCode);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);
