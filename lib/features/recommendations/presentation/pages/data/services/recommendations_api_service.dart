import 'dart:convert';

import 'package:conciertos_app/config/api_config.dart';
import 'package:http/http.dart' as http;

import '../models/recommended_event_model.dart';

class RecommendationsApiService {
  Future<List<RecommendedEventModel>> getRecommendations({
    required String artist,
    String countryCode = '',
  }) async {
    final body = {'artist': artist, 'countryCode': countryCode};

    print(jsonEncode(body));

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/recommendations'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    print('STATUS => ${response.statusCode}');
    print('BODY => ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }

    final List<dynamic> json = jsonDecode(response.body);

    return json.map((e) => RecommendedEventModel.fromJson(e)).toList();
  }
}
