import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../config/api_config.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class UserApiService {
  Map<String, String> get _headers {
    final token = AuthController.instance.token;
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<String> updateName(String name) async {
    final response = await http.patch(
      Uri.parse('${ApiConfig.baseUrl}/users/me/name'),
      headers: _headers,
      body: jsonEncode({'name': name}),
    );
    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Error al actualizar el nombre');
    }
    final json = jsonDecode(response.body);
    return json['name']?.toString() ?? name;
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await http.patch(
      Uri.parse('${ApiConfig.baseUrl}/users/me/password'),
      headers: _headers,
      body: jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );
    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Error al cambiar la contraseña');
    }
  }
}
