import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/user.dart';
import '../models/user_model.dart';

import '../../../../config/api_config.dart';

/// Timeout para todas las llamadas. Render free puede tardar hasta
/// 30-60 s en despertar tras inactividad — con 20 s damos margen
/// razonable sin que el usuario espere indefinidamente.
const _kTimeout = Duration(seconds: 20);

class AuthApiService {
  Future<(User, String)> login({
    required String email,
    required String password,
  }) async {
    final response = await http
        .post(
          Uri.parse(ApiConfig.loginEndpoint),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        )
        .timeout(_kTimeout);

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }

    final json = jsonDecode(response.body);
    final user = UserModel.fromJson(json['user']);
    final token = json['token'] as String;

    return (user, token);
  }

  Future<User?> me(String token) async {
    final response = await http
        .get(
          Uri.parse('${ApiConfig.baseUrl}/auth/me'),
          headers: {'Authorization': 'Bearer $token'},
        )
        .timeout(_kTimeout);

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    }

    return null;
  }

  Future<(User, String)> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http
        .post(
          Uri.parse(ApiConfig.registerEndpoint),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': name,
            'email': email,
            'password': password,
          }),
        )
        .timeout(_kTimeout);

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }

    final json = jsonDecode(response.body);
    final user = UserModel.fromJson(json['user']);
    final token = json['token'] as String;

    return (user, token);
  }
}
