import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../config/api_config.dart';
import '../../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/spotify_artist.dart';
import 'spotify_client_service.dart';

/// Servicio que consulta el backend propio para obtener información de
/// un artista en Spotify (géneros, imagen, etc.) sin requerir OAuth de usuario.
/// Si el backend falla, hace fallback a llamada directa a Spotify con
/// Client Credentials (requiere SPOTIFY_CLIENT_SECRET en .env).
class SpotifySearchService {
  final _directClient = SpotifyClientService();

  Future<SpotifyArtist?> searchArtist(String artist) async {
    if (artist.trim().isEmpty) return null;

    // ── 1. Intentar vía backend ──────────────────────────────────────────────
    try {
      final token = AuthController.instance.token;
      final uri = Uri.parse(
        '${ApiConfig.baseUrl}/spotify/artist?name=${Uri.encodeComponent(artist.trim())}',
      );

      final response = await http.get(
        uri,
        headers: {if (token != null) 'Authorization': 'Bearer $token'},
      );

      debugPrint(
        '[SpotifySearch] backend "${artist.trim()}" → ${response.statusCode} | ${response.body.length > 200 ? response.body.substring(0, 200) : response.body}',
      );

      if (response.statusCode == 200 && response.body != 'null') {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return SpotifyArtist.fromJson(decoded);
        }
      }
    } catch (e) {
      debugPrint('[SpotifySearch] backend error: $e');
    }

    // ── 2. Fallback: llamada directa a Spotify API ───────────────────────────
    debugPrint('[SpotifySearch] Intentando búsqueda directa a Spotify...');
    return _directClient.searchArtist(artist);
  }
}
