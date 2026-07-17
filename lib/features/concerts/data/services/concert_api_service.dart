import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../config/api_config.dart';
import '../../domain/entities/concert.dart';
import '../models/concert_model.dart';

class ConcertApiService {
  final _storage = const FlutterSecureStorage();

  Future<List<ConcertModel>> getConcerts({int page = 1, int limit = 50}) async {
    final token = await _storage.read(key: 'token');

    final uri = Uri.parse(
      ApiConfig.concertsEndpoint,
    ).replace(queryParameters: {'page': '$page', 'limit': '$limit'});

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }

    final body = jsonDecode(response.body);

    // Soporta respuesta paginada { data: [...] } y array plano
    final List<dynamic> items = body is Map
        ? (body['data'] ?? body['concerts'] ?? [])
        : body;

    return items.map((item) => ConcertModel.fromJson(item)).toList();
  }

  /// Crea un concierto y devuelve el objeto creado por el backend (con el id).
  Future<ConcertModel> addConcert(Concert concert) async {
    final model = ConcertModel.fromEntity(concert);
    final token = await _storage.read(key: 'token');

    final response = await http.post(
      Uri.parse(ApiConfig.concertsEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(model.toCreateJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }

    return ConcertModel.fromJson(jsonDecode(response.body));
  }

  Future<void> updateConcert(Concert concert) async {
    final model = ConcertModel.fromEntity(concert);
    final token = await _storage.read(key: 'token');

    final response = await http.put(
      Uri.parse('${ApiConfig.concertsEndpoint}/${concert.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(model.toUpdateJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<void> deleteConcert(String id) async {
    final token = await _storage.read(key: 'token');

    final response = await http.delete(
      Uri.parse('${ApiConfig.concertsEndpoint}/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }
}
