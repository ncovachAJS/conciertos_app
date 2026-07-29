import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../config/api_config.dart';
import '../../../../features/auth/presentation/controllers/auth_controller.dart';
import '../models/app_notification_model.dart';

class NotificationsApiService {
  Map<String, String> get _headers {
    final token = AuthController.instance.token;
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<AppNotificationModel>> getAll() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/notifications'),
      headers: _headers,
    );
    debugPrint('🔔 notifications status: ${response.statusCode}');
    debugPrint('🔔 notifications body: ${response.body}');
    if (response.statusCode != 200) throw Exception(response.body);
    final List list = jsonDecode(response.body);
    return list.map((e) => AppNotificationModel.fromJson(e)).toList();
  }

  Future<int> getUnreadCount() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/notifications/unread-count'),
      headers: _headers,
    );
    if (response.statusCode != 200) return 0;
    final body = jsonDecode(response.body);
    return body['count'] as int? ?? 0;
  }

  Future<void> markRead(String id) async {
    await http.put(
      Uri.parse('${ApiConfig.baseUrl}/notifications/$id/read'),
      headers: _headers,
    );
  }

  Future<void> markAllRead() async {
    await http.put(
      Uri.parse('${ApiConfig.baseUrl}/notifications/read-all'),
      headers: _headers,
    );
  }

  Future<void> saveToken(String token, String platform) async {
    await http.post(
      Uri.parse('${ApiConfig.baseUrl}/notifications/token'),
      headers: _headers,
      body: jsonEncode({'token': token, 'platform': platform}),
    );
  }

  Future<void> removeToken(String token) async {
    await http.put(
      Uri.parse('${ApiConfig.baseUrl}/notifications/token/remove'),
      headers: _headers,
      body: jsonEncode({'token': token}),
    );
  }
}
