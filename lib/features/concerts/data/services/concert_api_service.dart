import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/entities/concert.dart';
import '../models/concert_model.dart';

import '../../../../config/api_config.dart';

class ConcertApiService {
  final _storage = const FlutterSecureStorage();

  Future<List<ConcertModel>> getConcerts() async {
    final token = await _storage.read(key: 'token');

    final response = await http.get(
      Uri.parse(ApiConfig.concertsEndpoint),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }

    final List<dynamic> json = jsonDecode(response.body);

    return json.map((item) => ConcertModel.fromJson(item)).toList();
  }

  Future<void> addConcert(Concert concert) async {
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
