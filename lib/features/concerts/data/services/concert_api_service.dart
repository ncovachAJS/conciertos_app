import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../config/api_config.dart';
import '../../domain/entities/concert.dart';
import '../models/concert_model.dart';

/// Timeout compartido: Render free puede tardar hasta 30-60 s en despertar.
/// 25 s da margen sin que el usuario espere indefinidamente.
const _kTimeout = Duration(seconds: 25);

class ConcertApiService {
  final _storage = const FlutterSecureStorage();

  Future<List<ConcertModel>> getConcerts({
    int page = 1,
    int limit = 200,
  }) async {
    final token = await _storage.read(key: 'token');

    final uri = Uri.parse(
      ApiConfig.concertsEndpoint,
    ).replace(queryParameters: {'page': '$page', 'limit': '$limit'});

    final response = await http
        .get(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(_kTimeout);

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }

    final body = jsonDecode(response.body);

    final List<dynamic> items = body is Map
        ? (body['data'] ?? body['concerts'] ?? [])
        : body;

    return items.map((item) => ConcertModel.fromJson(item)).toList();
  }

  /// Crea un concierto. Acepta ConcertModel directamente para preservar
  /// taggedFriendIds, o un Concert genérico sin etiquetas.
  Future<ConcertModel> addConcert(Concert concert) async {
    final token = await _storage.read(key: 'token');

    // Si ya es ConcertModel lo usamos directamente, sino convertimos
    final model = concert is ConcertModel
        ? concert
        : ConcertModel.fromEntity(concert);

    final body = model.toCreateJson();

    final response = await http
        .post(
          Uri.parse(ApiConfig.concertsEndpoint),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(body),
        )
        .timeout(_kTimeout);

    if (response.statusCode != 201) {
      debugPrint('❌ addConcert ${response.statusCode}: ${response.body}');
      debugPrint('❌ body enviado: ${jsonEncode(body)}');
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }

    return ConcertModel.fromJson(jsonDecode(response.body));
  }

  Future<void> updateConcert(Concert concert) async {
    final token = await _storage.read(key: 'token');

    final model = concert is ConcertModel
        ? concert
        : ConcertModel.fromEntity(concert);

    final response = await http
        .put(
          Uri.parse('${ApiConfig.concertsEndpoint}/${concert.id}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(model.toUpdateJson()),
        )
        .timeout(_kTimeout);

    if (response.statusCode != 200) {
      debugPrint('❌ updateConcert ${response.statusCode}: ${response.body}');
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<void> deleteConcert(String id) async {
    final token = await _storage.read(key: 'token');

    final response = await http
        .delete(
          Uri.parse('${ApiConfig.concertsEndpoint}/$id'),
          headers: {'Authorization': 'Bearer $token'},
        )
        .timeout(_kTimeout);

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }
}
