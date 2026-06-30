import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/concert.dart';
import '../models/concert_model.dart';

class ConcertApiService {
  static const String baseUrl =
      'https://script.google.com/macros/s/AKfycbzdFjJefnAOlokx21BIIyK5PDtpmg4TKl0llCJxEecMg1MTW_ma2O55e79ztUYYqLOm/exec';

  Future<List<ConcertModel>> getConcerts() async {
    final response = await http.get(Uri.parse(baseUrl));

    print(response.body);

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }

    final List<dynamic> json = jsonDecode(response.body);

    return json.map((item) => ConcertModel.fromJson(item)).toList();
  }

  Future<void> addConcert(Concert concert) async {
    await _sendConcertAction(concert, 'create');
  }

  Future<void> updateConcert(Concert concert) async {
    await _sendConcertAction(concert, 'update');
  }

  Future<void> deleteConcert(String id) async {
    debugPrint('🗑 Eliminando concierto: $id');

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'action': 'delete', 'id': id}),
    );

    debugPrint('STATUS: ${response.statusCode}');
    debugPrint('BODY: ${response.body}');

    _checkResponse(response);
  }

  Future<void> _sendConcertAction(Concert concert, String action) async {
    final model = ConcertModel.fromEntity(concert);

    final body = model.toJson();

    body['action'] = action;

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    _checkResponse(response);
  }

  void _checkResponse(http.Response response) {
    // Google Apps Script puede responder con 302 después de ejecutar el POST.
    if (response.statusCode != 200 && response.statusCode != 302) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }

    // Si es un 302, asumimos que la operación se ha realizado correctamente.
    if (response.statusCode == 302) {
      return;
    }

    if (response.body.isEmpty) {
      return;
    }

    final result = jsonDecode(response.body);

    if (result is Map && result['ok'] != true) {
      throw Exception(result['error'] ?? 'Error desconocido');
    }
  }
}
