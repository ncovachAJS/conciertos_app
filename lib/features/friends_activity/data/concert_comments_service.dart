import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../config/api_config.dart';
import '../../../features/auth/presentation/controllers/auth_controller.dart';
import '../domain/concert_comment.dart';

class ConcertCommentsService {
  Map<String, String> get _headers {
    final token = AuthController.instance.token;
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<ConcertComment>> getComments(String concertId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/concerts/$concertId/comments'),
        headers: _headers,
      );
      if (response.statusCode != 200) return [];
      final List list = jsonDecode(response.body);
      return list
          .map((e) => ConcertComment.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<ConcertComment?> addComment(String concertId, String text) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/concerts/$concertId/comments'),
        headers: _headers,
        body: jsonEncode({'text': text}),
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        return null;
      }
      return ConcertComment.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}
