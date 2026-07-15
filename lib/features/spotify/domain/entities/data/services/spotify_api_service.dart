import 'dart:convert';

import 'package:conciertos_app/config/api_config.dart';
import 'package:conciertos_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:conciertos_app/features/spotify/domain/entities/spotify_artist.dart';
import 'package:http/http.dart' as http;

class SpotifyApiService {
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

    return SpotifyArtist.fromJson(jsonDecode(response.body));
  }
}
