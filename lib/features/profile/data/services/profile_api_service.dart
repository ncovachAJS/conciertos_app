import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../config/api_config.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class ProfileApiService {
  Future<void> updateAvatar(String imageUrl) async {
    final response = await http.post(
      Uri.parse(ApiConfig.userAvatarEndpoint),
      headers: _headers,
      body: jsonEncode({'imageUrl': imageUrl}),
    );

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  Future<void> deleteAvatar() async {
    final response = await http.delete(
      Uri.parse(ApiConfig.userAvatarEndpoint),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }

  Map<String, String> get _headers {
    final token = AuthController.instance.token;

    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}
