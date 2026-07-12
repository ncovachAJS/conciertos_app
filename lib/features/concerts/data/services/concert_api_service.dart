import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/concert.dart';
import '../models/concert_model.dart';

import '../../../../config/api_config.dart';

class ConcertApiService {
  Future<List<ConcertModel>> getConcerts() async {
    final response = await http.get(Uri.parse(ApiConfig.concertsEndpoint));

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }

    final List<dynamic> json = jsonDecode(response.body);

    return json.map((item) => ConcertModel.fromJson(item)).toList();
  }

  Future<void> addConcert(Concert concert) async {
    final model = ConcertModel.fromEntity(concert);

    final response = await http.post(
      Uri.parse(ApiConfig.concertsEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(model.toCreateJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<void> updateConcert(Concert concert) async {
    final model = ConcertModel.fromEntity(concert);

    final response = await http.put(
      Uri.parse('${ApiConfig.concertsEndpoint}/${concert.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(model.toUpdateJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<void> deleteConcert(String id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.concertsEndpoint}/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }
}
