import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/spotify_artist.dart';
import '../../domain/entities/spotify_track.dart';

/// Token cacheado en memoria para reutilizar dentro de la sesión.
class _CachedToken {
  final String value;
  final DateTime expiresAt;
  _CachedToken(this.value, int expiresInSeconds)
      : expiresAt = DateTime.now().add(Duration(seconds: expiresInSeconds - 60));
  bool get isValid => DateTime.now().isBefore(expiresAt);
}

/// Servicio que usa Client Credentials (sin login de usuario) para llamar
/// directamente a la API pública de Spotify.
/// Ideal para datos públicos como top-tracks de un artista.
class SpotifyClientService {
  static _CachedToken? _token;

  static String get _clientId => dotenv.env['SPOTIFY_CLIENT_ID'] ?? '';
  static String get _clientSecret => dotenv.env['SPOTIFY_CLIENT_SECRET'] ?? '';

  bool get _hasCredentials => _clientId.isNotEmpty && _clientSecret.isNotEmpty;

  // ─── Token ──────────────────────────────────────────────────────────────────

  Future<String> _getToken() async {
    if (_token != null && _token!.isValid) return _token!.value;

    final credentials = base64.encode(utf8.encode('$_clientId:$_clientSecret'));
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization': 'Basic $credentials',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'grant_type=client_credentials',
    );

    if (response.statusCode != 200) {
      throw Exception('Spotify auth failed (${response.statusCode}): ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    _token = _CachedToken(
      json['access_token'] as String,
      json['expires_in'] as int,
    );
    return _token!.value;
  }

  // ─── Búsqueda de artista (directo a Spotify) ────────────────────────────────

  /// Busca un artista por nombre directamente en Spotify, sin pasar por el backend.
  /// Requiere SPOTIFY_CLIENT_ID y SPOTIFY_CLIENT_SECRET en el .env.
  Future<SpotifyArtist?> searchArtist(String name) async {
    if (name.trim().isEmpty) return null;
    if (!_hasCredentials) {
      debugPrint('[SpotifyClient] Sin credenciales (CLIENT_SECRET falta en .env)');
      return null;
    }

    try {
      final token = await _getToken();
      final uri = Uri.https('api.spotify.com', '/v1/search', {
        'q': name.trim(),
        'type': 'artist',
        'limit': '1',
      });
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      debugPrint('[SpotifyClient] search "$name" → ${response.statusCode}');
      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final items = (json['artists']?['items'] as List<dynamic>?) ?? [];
      if (items.isEmpty) return null;

      final a = items.first as Map<String, dynamic>;
      final images = (a['images'] as List<dynamic>?) ?? [];
      final externalUrls = (a['external_urls'] as Map<String, dynamic>?) ?? {};

      return SpotifyArtist(
        id: a['id']?.toString() ?? '',
        name: a['name']?.toString() ?? '',
        url: externalUrls['spotify']?.toString() ?? '',
        image: images.isNotEmpty ? images.first['url']?.toString() : null,
        followers: (a['followers'] as Map<String, dynamic>?)?['total'] as int? ?? 0,
        genres: (a['genres'] as List<dynamic>?)?.map((g) => g.toString()).toList() ?? [],
      );
    } catch (e) {
      debugPrint('[SpotifyClient] searchArtist error: $e');
      return null;
    }
  }

  // ─── Top tracks (vía Search API) ────────────────────────────────────────────

  /// Devuelve las canciones más populares del artista usando el Search API,
  /// que funciona con Client Credentials (a diferencia de /top-tracks).
  Future<List<SpotifyTrack>> getTopTracks(
    String artistId, {
    String artistName = '',
    String market = 'ES',
    int limit = 5,
  }) async {
    if (artistId.isEmpty && artistName.isEmpty) {
      debugPrint('[SpotifyClient] getTopTracks: artistId y name vacíos');
      return [];
    }
    if (!_hasCredentials) {
      debugPrint('[SpotifyClient] getTopTracks: sin credenciales');
      return [];
    }

    try {
      final token = await _getToken();

      // Buscar tracks del artista por su ID (más preciso que por nombre)
      // query: "artist:ID" no es soportado → usamos el nombre si tenemos,
      // o buscamos por ID con endpoint de albums → tracks (más complejo).
      // La forma más sencilla: search by artist name, type=track, ordenar por popularidad.
      final q = artistName.isNotEmpty ? artistName : artistId;

      final uri = Uri.https('api.spotify.com', '/v1/search', {
        'q': q,
        'type': 'track',
      });
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      debugPrint('[SpotifyClient] search-tracks URI: $uri');
      debugPrint('[SpotifyClient] search-tracks "${artistName.isNotEmpty ? artistName : artistId}" → ${response.statusCode}');
      if (response.statusCode != 200) {
        debugPrint('[SpotifyClient] search-tracks error: ${response.body}');
        return [];
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final items = (json['tracks']?['items'] as List<dynamic>?) ?? [];

      // Filtrar solo tracks cuyo artista principal coincida con el ID buscado,
      // luego ordenar por popularidad descendente y devolver los primeros [limit].
      final filtered = items
          .cast<Map<String, dynamic>>()
          .where((t) {
            if (artistId.isEmpty) return true;
            final artists = (t['artists'] as List<dynamic>?) ?? [];
            return artists.any((a) => (a as Map<String, dynamic>)['id'] == artistId);
          })
          .toList()
        ..sort((a, b) =>
            ((b['popularity'] as int?) ?? 0).compareTo((a['popularity'] as int?) ?? 0));

      final tracks = filtered
          .take(limit)
          .map((t) => SpotifyTrack.fromJson(t))
          .toList();

      debugPrint('[SpotifyClient] tracks encontradas: ${tracks.length}');
      return tracks;
    } catch (e) {
      debugPrint('[SpotifyClient] getTopTracks error: $e');
      return [];
    }
  }
}
