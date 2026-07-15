import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../config/api_config.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../models/recommended_event_model.dart';

class RecommendationsApiService {
  Future<List<RecommendedEventModel>> getRecommendations({
    required String artist,
    String countryCode = '',
  }) async {
    final token = AuthController.instance.token;

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/recommendations'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'artist': artist, 'countryCode': countryCode}),
    );

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }

    final List<dynamic> json = jsonDecode(response.body);
    return json.map((e) => RecommendedEventModel.fromJson(e)).toList();
  }
}
