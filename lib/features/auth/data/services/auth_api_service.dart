import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/user.dart';
import '../models/user_model.dart';

import '../../../../config/api_config.dart';

class AuthApiService {
  Future<(User, String)> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConfig.loginEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }

    final json = jsonDecode(response.body);

    final user = UserModel.fromJson(json['user']);

    final token = json['token'] as String;

    return (user, token);
  }

  Future<User?> me(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/auth/me'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      return null;
    }

    final json = jsonDecode(response.body);

    return UserModel.fromJson(json);
  }

  Future<(User, String)> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConfig.registerEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }

    final json = jsonDecode(response.body);

    final user = UserModel.fromJson(json['user']);

    final token = json['token'] as String;

    return (user, token);
  }
}
