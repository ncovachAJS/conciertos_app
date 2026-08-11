import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../config/api_config.dart';
import '../../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/spotify_artist.dart'; // modelo backend-proxy

/// Servicio que consulta el backend propio para obtener información de
/// un artista en Spotify (géneros, imagen, etc.) sin requerir OAuth de usuario.
/// El backend hace la llamada a Spotify con sus propias credenciales de app.
class SpotifySearchService {
  Future<SpotifyArtist?> searchArtist(String artist) async {
    if (artist.trim().isEmpty) return null;

    final token = AuthController.instance.token;
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/spotify/artist?name=${Uri.encodeComponent(artist.trim())}',
    );

    final response = await http.get(
      uri,
      headers: {if (token != null) 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) return null;
    if (response.body == 'null') return null;

    return SpotifyArtist.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }
}
