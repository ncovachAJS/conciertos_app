import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/spotify_artist.dart';
import 'spotify_auth_service.dart';

class SpotifyApiService {
  final SpotifyAuthService _auth;

  SpotifyApiService([SpotifyAuthService? auth])
      : _auth = auth ?? SpotifyAuthService();

  static const _base = 'https://api.spotify.com/v1';

  Future<Map<String, String>> _headers() async {
    final token = await _auth.getValidAccessToken();
    return {'Authorization': 'Bearer $token'};
  }

  // ────────────────────────────────────────── Búsqueda de artista (sin auth de usuario)

  /// Busca un artista por nombre y devuelve el primero encontrado.
  /// Requiere que el usuario haya iniciado sesión con su cuenta de Spotify.
  /// Devuelve null si no hay sesión o si no se encontró el artista.
  Future<SpotifyArtist?> searchArtist(String query) async {
    try {
      final headers = await _headers();
      final uri = Uri.parse('$_base/search').replace(
        queryParameters: {'q': query, 'type': 'artist', 'limit': '1'},
      );
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final items =
          (data['artists'] as Map<String, dynamic>)['items'] as List<dynamic>;
      if (items.isEmpty) return null;

      return SpotifyArtist.fromJson(items.first as Map<String, dynamic>);
    } catch (_) {
      return null; // Sin sesión o error de red → fallo silencioso
    }
  }

  // ────────────────────────────────────────── Top artistas del usuario

  /// Artistas más escuchados a largo plazo (hasta 50).
  Future<List<SpotifyArtist>> getTopArtists({int limit = 50}) async {
    final uri = Uri.parse('$_base/me/top/artists').replace(
      queryParameters: {'limit': '$limit', 'time_range': 'long_term'},
    );

    final response = await http.get(uri, headers: await _headers());

    if (response.statusCode != 200) {
      throw Exception('Error al obtener artistas top: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>;
    return items
        .map((e) => SpotifyArtist.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ────────────────────────────────────────── Artistas recientes

  /// Artistas de las últimas escuchas (deduplicados por ID).
  Future<List<SpotifyArtist>> getRecentArtists({int limit = 50}) async {
    final uri = Uri.parse('$_base/me/player/recently-played').replace(
      queryParameters: {'limit': '$limit'},
    );

    final response = await http.get(uri, headers: await _headers());

    if (response.statusCode != 200) {
      throw Exception(
        'Error al obtener escuchas recientes: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>;

    // recently-played → track → artists (lista); deduplicar por ID
    final seen = <String>{};
    final artists = <SpotifyArtist>[];
    for (final item in items) {
      final track = item['track'] as Map<String, dynamic>;
      for (final a in (track['artists'] as List<dynamic>)) {
        final id = a['id'] as String;
        if (seen.add(id)) {
          artists.add(SpotifyArtist(
            id: id,
            name: a['name'] as String,
            imageUrl: null,
            genres: const [],
            popularity: 0,
          ));
        }
      }
    }
    return artists;
  }
}
