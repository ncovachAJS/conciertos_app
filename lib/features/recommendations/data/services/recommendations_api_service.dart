import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../config/api_config.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../models/recommended_event_model.dart';

class RecommendationsApiService {
  static const _endpoint = '${ApiConfig.baseUrl}/recommendations';
  static const _timeout = Duration(seconds: 15);

  Map<String, String> _headers(String? token) => {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  Future<List<RecommendedEventModel>> _post(Map<String, dynamic> body) async {
    final token = AuthController.instance.token;
    final response = await http
        .post(
          Uri.parse(_endpoint),
          headers: _headers(token),
          body: jsonEncode(body),
        )
        .timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }

    final List<dynamic> json = jsonDecode(response.body);
    return json.map((e) => RecommendedEventModel.fromJson(e)).toList();
  }

  /// Recomendaciones por artista + país (flujo existente).
  Future<List<RecommendedEventModel>> getRecommendations({
    required String artist,
    String countryCode = '',
  }) =>
      _post({'artists': [artist], 'countryCode': countryCode});

  /// Recomendaciones por artista + geolocalización ("cerca de ti").
  Future<List<RecommendedEventModel>> getNearbyRecommendations({
    required String artist,
    required double lat,
    required double lng,
    int radiusKm = 50,
  }) =>
      _post({
        'artists': [artist],
        'lat': lat,
        'lng': lng,
        'radius': radiusKm,
      });
}
