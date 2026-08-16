import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../config/api_config.dart';
import '../../domain/entities/spotify_artist.dart';
import '../../domain/entities/spotify_track.dart';

/// Servicio que obtiene datos de Spotify proxiando a través del backend propio.
///
/// El backend mantiene las credenciales Spotify (Client Credentials) de forma
/// segura. Este cliente nunca necesita SPOTIFY_CLIENT_SECRET en el APK/IPA.
class SpotifyClientService {
  static const Duration _timeout = Duration(seconds: 15);
  static const Duration _cacheDuration = Duration(minutes: 30);

  // Caché en memoria: artistId → lista de tracks
  static final Map<String, _CachedTracks> _tracksCache = {};
  // Caché en memoria: artistName → SpotifyArtist
  static final Map<String, _CachedArtist> _artistCache = {};

  final _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _authHeaders() async {
    final token = await _storage.read(key: 'token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ── Búsqueda de artista ───────────────────────────────────────────────────

  Future<SpotifyArtist?> searchArtist(String name) async {
    final q = name.trim();
    if (q.isEmpty) return null;

    final cached = _artistCache[q.toLowerCase()];
    if (cached != null &&
        DateTime.now().difference(cached.createdAt) < _cacheDuration) {
      return cached.artist;
    }

    try {
      final uri = Uri.parse(ApiConfig.spotifyArtistEndpoint)
          .replace(queryParameters: {'name': q});
      final response = await http
          .get(uri, headers: await _authHeaders())
          .timeout(_timeout);

      debugPrint('[SpotifyClient] searchArtist "$q" → ${response.statusCode}');
      if (response.statusCode != 200 || response.body == 'null') return null;

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) return null;

      final artist = SpotifyArtist.fromJson(decoded);
      _artistCache[q.toLowerCase()] = _CachedArtist(artist, DateTime.now());
      return artist;
    } catch (e) {
      debugPrint('[SpotifyClient] searchArtist error: $e');
      return null;
    }
  }

  // ── Top tracks ────────────────────────────────────────────────────────────

  Future<List<SpotifyTrack>> getTopTracks(
    String artistId, {
    String artistName = '',
    String market = 'ES',
    int limit = 5,
  }) async {
    if (artistId.isEmpty) {
      debugPrint('[SpotifyClient] getTopTracks: artistId vacío');
      return [];
    }

    final cacheKey = '$artistId|$market';
    final cached = _tracksCache[cacheKey];
    if (cached != null &&
        DateTime.now().difference(cached.createdAt) < _cacheDuration) {
      return cached.tracks.take(limit).toList();
    }

    try {
      final uri = Uri.parse(ApiConfig.spotifyTopTracksEndpoint(artistId))
          .replace(queryParameters: {'market': market});
      final response = await http
          .get(uri, headers: await _authHeaders())
          .timeout(_timeout);

      debugPrint('[SpotifyClient] topTracks "$artistId" → ${response.statusCode}');
      if (response.statusCode != 200) return [];

      final List data = jsonDecode(response.body) as List;
      final tracks = data
          .cast<Map<String, dynamic>>()
          .map(SpotifyTrack.fromJson)
          .toList();

      _tracksCache[cacheKey] = _CachedTracks(tracks, DateTime.now());
      debugPrint('[SpotifyClient] tracks obtenidas: ${tracks.length}');
      return tracks.take(limit).toList();
    } catch (e) {
      debugPrint('[SpotifyClient] getTopTracks error: $e');
      return [];
    }
  }
}

class _CachedTracks {
  const _CachedTracks(this.tracks, this.createdAt);
  final List<SpotifyTrack> tracks;
  final DateTime createdAt;
}

class _CachedArtist {
  const _CachedArtist(this.artist, this.createdAt);
  final SpotifyArtist artist;
  final DateTime createdAt;
}
