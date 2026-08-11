import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;

/// Credenciales obtenidas tras el flujo PKCE de Spotify.
class SpotifyTokens {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  SpotifyTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

class SpotifyAuthService {
  static String get _clientId =>
      dotenv.env['SPOTIFY_CLIENT_ID'] ?? '';
  static const _redirectUri = 'lavdapp://spotify-callback';
  static const _scopes = 'user-top-read user-read-recently-played';

  static const _storage = FlutterSecureStorage();
  static const _keyAccessToken = 'spotify_access_token';
  static const _keyRefreshToken = 'spotify_refresh_token';
  static const _keyExpiresAt = 'spotify_expires_at';

  // ---------------------------------------------------------------- PKCE utils

  /// 64 bytes aleatorios → base64url sin padding
  static String _generateCodeVerifier() {
    final random = Random.secure();
    final bytes = List<int>.generate(64, (_) => random.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  /// SHA-256(verifier) → base64url sin padding
  static String _generateCodeChallenge(String verifier) {
    final bytes = utf8.encode(verifier);
    final digest = sha256.convert(bytes);
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }

  // ------------------------------------------------------ Flujo de autorización

  /// Abre el navegador de Spotify, captura el callback y devuelve los tokens.
  /// Lanza [Exception] si el usuario cancela o hay algún error.
  Future<SpotifyTokens> authorize() async {
    final verifier = _generateCodeVerifier();
    final challenge = _generateCodeChallenge(verifier);

    final authUrl = Uri.https('accounts.spotify.com', '/authorize', {
      'response_type': 'code',
      'client_id': _clientId,
      'scope': _scopes,
      'redirect_uri': _redirectUri,
      'code_challenge_method': 'S256',
      'code_challenge': challenge,
    });

    // Abre WebView y espera el redirect con el code
    final result = await FlutterWebAuth2.authenticate(
      url: authUrl.toString(),
      callbackUrlScheme: 'lavdapp',
    );

    final code = Uri.parse(result).queryParameters['code'];
    if (code == null) {
      throw Exception('Spotify no devolvió un código de autorización.');
    }

    return _exchangeCode(code, verifier);
  }

  // ------------------------------------------------------- Intercambio de code

  Future<SpotifyTokens> _exchangeCode(String code, String verifier) async {
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': _redirectUri,
        'client_id': _clientId,
        'code_verifier': verifier,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Error al obtener tokens: ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final tokens = SpotifyTokens(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresAt: DateTime.now().add(
        Duration(seconds: json['expires_in'] as int),
      ),
    );

    await _saveTokens(tokens);
    return tokens;
  }

  // ------------------------------------------------------- Refresh del token

  Future<SpotifyTokens> _refresh(String refreshToken) async {
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
        'client_id': _clientId,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Error al refrescar token: ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final tokens = SpotifyTokens(
      accessToken: json['access_token'] as String,
      // Spotify puede o no devolver un nuevo refresh token
      refreshToken: json['refresh_token'] as String? ?? refreshToken,
      expiresAt: DateTime.now().add(
        Duration(seconds: json['expires_in'] as int),
      ),
    );

    await _saveTokens(tokens);
    return tokens;
  }

  // ---------------------------------- Token válido (refresca automáticamente)

  /// Devuelve un access token válido; refresca si ha expirado.
  /// Lanza [Exception] si no hay sesión guardada.
  Future<String> getValidAccessToken() async {
    final accessToken = await _storage.read(key: _keyAccessToken);
    final refreshToken = await _storage.read(key: _keyRefreshToken);
    final expiresAtStr = await _storage.read(key: _keyExpiresAt);

    if (accessToken == null || refreshToken == null || expiresAtStr == null) {
      throw Exception('No hay sesión de Spotify. Inicia sesión primero.');
    }

    final expiresAt = DateTime.parse(expiresAtStr);
    if (DateTime.now().isBefore(expiresAt)) {
      return accessToken;
    }

    final refreshed = await _refresh(refreshToken);
    return refreshed.accessToken;
  }

  // ------------------------------------------ Persistencia en secure storage

  Future<void> _saveTokens(SpotifyTokens tokens) async {
    await Future.wait([
      _storage.write(key: _keyAccessToken, value: tokens.accessToken),
      _storage.write(key: _keyRefreshToken, value: tokens.refreshToken),
      _storage.write(
        key: _keyExpiresAt,
        value: tokens.expiresAt.toIso8601String(),
      ),
    ]);
  }

  Future<void> logout() async {
    await Future.wait([
      _storage.delete(key: _keyAccessToken),
      _storage.delete(key: _keyRefreshToken),
      _storage.delete(key: _keyExpiresAt),
    ]);
  }

  Future<bool> get isLoggedIn async {
    final token = await _storage.read(key: _keyAccessToken);
    return token != null;
  }
}
