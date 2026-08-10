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

  /// Cambia el email. Requiere la contraseña actual para verificar.
  Future<String> updateEmail({
    required String email,
    required String currentPassword,
  }) async {
    final response = await http.patch(
      Uri.parse('${ApiConfig.baseUrl}/users/me/email'),
      headers: _headers,
      body: jsonEncode({
        'email': email,
        'currentPassword': currentPassword,
      }),
    );
    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Error al actualizar el email');
    }
    final json = jsonDecode(response.body);
    return json['email']?.toString() ?? email;
  }

  /// Elimina la cuenta y todos los datos. Requiere contraseña para confirmar.
  Future<void> deleteAccount({required String currentPassword}) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/users/me'),
      headers: _headers,
      body: jsonEncode({'currentPassword': currentPassword}),
    );
    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Error al eliminar la cuenta');
    }
  }
}
