import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/concert_model.dart';

/// Caché local de conciertos usando SharedPreferences.
/// Permite mostrar datos instantáneamente al abrir la app (modo offline).
class ConcertCacheService {
  // v2: incluye id, userId y participants (v1 no los tenía)
  static const _kCacheKey = 'concerts_cache_v2';
  static const _kCacheTimestampKey = 'concerts_cache_ts_v2';

  /// Duración máxima del caché antes de considerarlo "viejo" (12 horas).
  static const _maxAge = Duration(hours: 12);

  /// Guarda la lista de conciertos en caché.
  Future<void> save(List<ConcertModel> concerts) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = concerts.map((c) => c.toCacheJson()).toList();
    await prefs.setString(_kCacheKey, jsonEncode(jsonList));
    await prefs.setInt(
      _kCacheTimestampKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Lee la lista del caché. Devuelve lista vacía si no hay datos.
  Future<List<ConcertModel>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kCacheKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((e) => ConcertModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  /// Indica si el caché tiene datos válidos (no vacíos y no expirados).
  Future<bool> isValid() async {
    final prefs = await SharedPreferences.getInstance();
    final ts = prefs.getInt(_kCacheTimestampKey);
    if (ts == null) return false;
    final age = DateTime.now().difference(
      DateTime.fromMillisecondsSinceEpoch(ts),
    );
    final hasData = (prefs.getString(_kCacheKey)?.isNotEmpty) ?? false;
    return hasData && age < _maxAge;
  }

  /// Borra el caché.
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kCacheKey);
    await prefs.remove(_kCacheTimestampKey);
  }
}
