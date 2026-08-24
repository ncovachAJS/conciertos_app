import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/spotify_track.dart';
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

  // ────────────────────────────────────────── Playlist personal del usuario

  /// Busca en las playlists del usuario una que sirva como "top tracks":
  /// primero busca las que Spotify genera automáticamente ("Your Top Songs",
  /// "Tus mejores canciones", etc.), si no encuentra ninguna devuelve la
  /// primera playlist disponible, y si no tiene ninguna devuelve null.
  Future<SpotifyPlaylist?> getTopTracksPlaylist() async {
    final uri = Uri.parse('$_base/me/playlists').replace(
      queryParameters: {'limit': '50'},
    );
    final response = await http.get(uri, headers: await _headers());
    if (response.statusCode != 200) return null;

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final items = (data['items'] as List<dynamic>)
        .whereType<Map<String, dynamic>>()
        .toList();
    if (items.isEmpty) return null;

    // Palabras clave que usan las playlists automáticas de Spotify
    const keywords = [
      'top songs', 'top tracks', 'mejores canciones', 'my top',
      'tu mezcla', 'your top', 'tus mejores',
    ];

    // 1. Preferimos las playlists automáticas de Spotify
    for (final item in items) {
      final name = (item['name'] as String? ?? '').toLowerCase();
      if (keywords.any(name.contains)) {
        return SpotifyPlaylist._fromJson(item);
      }
    }

    // 2. Si no hay ninguna "top", usamos la primera de la lista
    return SpotifyPlaylist._fromJson(items.first);
  }

  // ────────────────────────────────────────── Top canciones del usuario

  /// Canciones más escuchadas del usuario a largo plazo (hasta [limit]).
  /// Usa el token OAuth del usuario → resultado 100 % personal.
  Future<List<SpotifyTrack>> getUserTopTracks({int limit = 30}) async {
    final uri = Uri.parse('$_base/me/top/tracks').replace(
      queryParameters: {'limit': '$limit', 'time_range': 'long_term'},
    );

    final response = await http.get(uri, headers: await _headers());

    if (response.statusCode != 200) {
      throw Exception(
          'Error al obtener canciones top: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>;
    return items
        .map((e) => SpotifyTrack.fromJson(e as Map<String, dynamic>))
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

/// Datos mínimos de una playlist de Spotify necesarios para el embed.
class SpotifyPlaylist {
  final String id;
  final String name;
  final String? imageUrl;

  const SpotifyPlaylist({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  factory SpotifyPlaylist._fromJson(Map<String, dynamic> json) {
    final images = json['images'] as List<dynamic>? ?? [];
    return SpotifyPlaylist(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: images.isNotEmpty ? (images.first['url'] as String?) : null,
    );
  }
}
