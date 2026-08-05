import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../config/api_config.dart';
import '../../concerts/data/models/concert_model.dart';

class FriendsActivityService {
  final _storage = const FlutterSecureStorage();

  Future<List<ConcertModel>> getActivity({int page = 1, int limit = 20}) async {
    final token = await _storage.read(key: 'token');

    final uri = Uri.parse(ApiConfig.friendsActivityEndpoint).replace(
      queryParameters: {'page': '$page', 'limit': '$limit'},
    );

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }

    final body = jsonDecode(response.body);
    final List<dynamic> items = body is Map
        ? (body['data'] ?? body['concerts'] ?? [])
        : body;

    return items.map((e) => ConcertModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
