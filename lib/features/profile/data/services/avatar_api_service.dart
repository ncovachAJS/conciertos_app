import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../config/api_config.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class AvatarApiService {
  Future<String> updateAvatar(String avatarUrl) async {
    final token = AuthController.instance.token;

    final response = await http.patch(
      Uri.parse('${ApiConfig.baseUrl}/users/me/avatar'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'avatarUrl': avatarUrl}),
    );

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }

    final json = jsonDecode(response.body);
    return json['avatarUrl']?.toString() ?? avatarUrl;
  }
}
