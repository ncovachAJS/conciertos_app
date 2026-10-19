import 'dart:convert';

import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;

import '../../../../config/api_config.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

/// El usuario canceló la autorización en Discogs.
class DiscogsDeniedException implements Exception {}

class DiscogsStatus {
  final bool connected;
  final String? username;
  const DiscogsStatus({required this.connected, this.username});
}

class DiscogsImportResult {
  final int collection;
  final int wishlist;
  final int skipped;
  const DiscogsImportResult({
    required this.collection,
    required this.wishlist,
    required this.skipped,
  });
}

/// Vinculación OAuth 1.0a con Discogs. Los secretos viven en el backend;
/// la app solo abre la página de autorización y reenvía el verifier.
class DiscogsLinkService {
  static const _timeout = Duration(seconds: 60);

  Map<String, String> get _headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthController.instance.token}',
      };

  Future<DiscogsStatus> status() async {
    final res = await http
        .get(Uri.parse(ApiConfig.discogsStatusEndpoint), headers: _headers)
        .timeout(_timeout);
    if (res.statusCode != 200) {
      throw Exception('Discogs status (${res.statusCode})');
    }
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return DiscogsStatus(
      connected: json['connected'] == true,
      username: json['username'] as String?,
    );
  }

  /// Abre Discogs para autorizar y devuelve el nombre de usuario vinculado.
  Future<String> connect() async {
    final start = await http
        .post(Uri.parse(ApiConfig.discogsStartEndpoint), headers: _headers)
        .timeout(_timeout);
    if (start.statusCode != 201 && start.statusCode != 200) {
      throw Exception('Discogs start (${start.statusCode})');
    }
    final authorizeUrl =
        (jsonDecode(start.body) as Map<String, dynamic>)['authorizeUrl']
            as String;

    final result = await FlutterWebAuth2.authenticate(
      url: authorizeUrl,
      callbackUrlScheme: 'lavdapp',
      options: const FlutterWebAuth2Options(preferEphemeral: true),
    );
    final q = Uri.parse(result).queryParameters;
    final token = q['oauth_token'];
    final verifier = q['oauth_verifier'];
    if (token == null || verifier == null) throw DiscogsDeniedException();

    final finish = await http
        .post(
          Uri.parse(ApiConfig.discogsFinishEndpoint),
          headers: _headers,
          body: jsonEncode({'oauthToken': token, 'oauthVerifier': verifier}),
        )
        .timeout(_timeout);
    if (finish.statusCode != 201 && finish.statusCode != 200) {
      throw Exception('Discogs finish (${finish.statusCode})');
    }
    return (jsonDecode(finish.body) as Map<String, dynamic>)['username']
        as String;
  }

  Future<DiscogsImportResult> import() async {
    final res = await http
        .post(Uri.parse(ApiConfig.discogsImportEndpoint), headers: _headers)
        .timeout(const Duration(minutes: 3));
    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception('Discogs import (${res.statusCode})');
    }
    final j = jsonDecode(res.body) as Map<String, dynamic>;
    return DiscogsImportResult(
      collection: (j['collection'] as num).toInt(),
      wishlist: (j['wishlist'] as num).toInt(),
      skipped: (j['skipped'] as num).toInt(),
    );
  }

  Future<void> disconnect() async {
    final res = await http
        .delete(
          Uri.parse(ApiConfig.discogsConnectionEndpoint),
          headers: _headers,
        )
        .timeout(_timeout);
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Discogs disconnect (${res.statusCode})');
    }
  }
}
