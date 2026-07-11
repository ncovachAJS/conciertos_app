import 'dart:convert';

import 'package:conciertos_app/config/api_config.dart';
import 'package:http/http.dart' as http;

import '../models/recommended_event_model.dart';

class RecommendationsApiService {
  Future<List<RecommendedEventModel>> getRecommendations({
    required List<String> artists,
    String countryCode = '',
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/recommendations'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'artists': artists, 'countryCode': countryCode}),
    );

    if (response.statusCode != 200) {
      throw Exception('Error obteniendo recomendaciones');
    }

    final List<dynamic> json = jsonDecode(response.body);

    return json.map((e) => RecommendedEventModel.fromJson(e)).toList();
  }
}
