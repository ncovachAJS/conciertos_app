import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../config/api_config.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/recommended_event.dart';

class WantToAttendApiService {
  Map<String, String> get _headers {
    final token = AuthController.instance.token;
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<RecommendedEvent>> getAll() async {
    final response = await http.get(
      Uri.parse(ApiConfig.wantToAttendEndpoint),
      headers: _headers,
    );
    if (response.statusCode != 200) throw Exception(response.body);
    final List list = jsonDecode(response.body);
    return list.map((e) => _fromJson(e)).toList();
  }

  Future<bool> toggle(RecommendedEvent event) async {
    final response = await http.post(
      Uri.parse(ApiConfig.wantToAttendToggleEndpoint),
      headers: _headers,
      body: jsonEncode({
        'eventId': event.id,
        'artist': event.artist,
        'venue': event.venue,
        'city': event.city,
        'country': event.country,
        'date': event.date.toIso8601String(),
        'imageUrl': event.imageUrl,
        'ticketUrl': event.ticketUrl,
      }),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.body);
    }
    final body = jsonDecode(response.body);
    return body['added'] as bool;
  }

  static RecommendedEvent _fromJson(Map<String, dynamic> j) => RecommendedEvent(
        id: j['eventId'] as String,
        artist: j['artist'] as String,
        venue: j['venue'] as String,
        city: j['city'] as String,
        country: j['country'] as String,
        date: DateTime.parse(j['date'] as String),
        imageUrl: j['imageUrl'] as String,
        ticketUrl: j['ticketUrl'] as String,
      );
}
