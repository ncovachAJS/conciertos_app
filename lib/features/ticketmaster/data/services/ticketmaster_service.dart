import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../config/api_config.dart';
import '../models/ticketmaster_event_model.dart';

/// Servicio de recomendaciones de conciertos.
///
/// Las llamadas van al backend propio en lugar de a Ticketmaster directamente,
/// para no exponer la API key en el APK/IPA.
class TicketmasterService {
  static const Duration _timeout = Duration(seconds: 15);
  static const Duration _cacheDuration = Duration(minutes: 15);

  static final Map<String, _CachedEvents> _cache = {};

  final _storage = const FlutterSecureStorage();

  Future<List<TicketmasterEventModel>> getRecommendedEvents(
    List<String> artists,
  ) async {
    final uniqueArtists = artists
        .map((a) => a.trim())
        .where((a) => a.isNotEmpty)
        .toSet()
        .toList();

    if (uniqueArtists.isEmpty) return const [];

    // Clave de caché: artistas ordenados
    final cacheKey = (List<String>.from(uniqueArtists)..sort()).join('|');
    final cached = _cache[cacheKey];
    if (cached != null &&
        DateTime.now().difference(cached.createdAt) < _cacheDuration) {
      return cached.events;
    }

    final token = await _storage.read(key: 'token');
    if (token == null) return const [];

    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.recommendationsEndpoint),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'artists': uniqueArtists}),
          )
          .timeout(_timeout);

      if (response.statusCode != 200 && response.statusCode != 201) {
        return const [];
      }

      final List data = jsonDecode(response.body) as List;

      // El backend devuelve una lista plana con { id, artist, venue, city,
      // country, date, imageUrl, ticketUrl, recommendedBecause? }.
      final events = data.map((item) {
        final map = item as Map<String, dynamic>;
        // 'recommendedBecause' puede venir del backend; si no, usamos el campo
        // que sea más descriptivo del artista buscado.
        final recommendedBecause =
            map['recommendedBecause']?.toString() ??
            map['artist']?.toString() ??
            '';
        return TicketmasterEventModel.fromBackendJson(
          map,
          artist: recommendedBecause,
        );
      }).toList();

      // Solo conciertos futuros
      final now = DateTime.now();
      events.removeWhere(
        (e) => e.date.isBefore(DateTime(now.year, now.month, now.day)),
      );

      // Eliminar duplicados por id
      final unique = <String, TicketmasterEventModel>{};
      for (final e in events) {
        unique[e.id] = e;
      }
      final result = unique.values.toList()
        ..sort((a, b) => a.date.compareTo(b.date));

      _cache[cacheKey] = _CachedEvents(result, DateTime.now());
      return result;
    } catch (_) {
      return const [];
    }
  }
}

class _CachedEvents {
  const _CachedEvents(this.events, this.createdAt);

  final List<TicketmasterEventModel> events;
  final DateTime createdAt;
}
