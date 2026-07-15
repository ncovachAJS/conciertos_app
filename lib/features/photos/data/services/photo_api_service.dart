import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../config/api_config.dart';
import '../models/concert_photo_model.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class PhotoApiService {
  Future<List<ConcertPhotoModel>> getConcertPhotos(String concertId) async {
    final response = await http.get(
      Uri.parse(ApiConfig.concertPhotosEndpoint(concertId)),
      headers: _headers,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }

    // Este endpoint devuelve array plano (sin paginación)
    final List<dynamic> json = jsonDecode(response.body);
    return json.map((item) => ConcertPhotoModel.fromJson(item)).toList();
  }

  Future<List<ConcertPhotoModel>> getFeed({
    int page = 1,
    int limit = 50,
  }) async {
    final uri = Uri.parse(
      ApiConfig.photosFeedEndpoint,
    ).replace(queryParameters: {'page': '$page', 'limit': '$limit'});

    final response = await http.get(uri, headers: _headers);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }

    // El back ahora devuelve { data: [...], meta: {...} }
    final Map<String, dynamic> body = jsonDecode(response.body);
    final List<dynamic> items = body['data'];

    return items.map((item) => ConcertPhotoModel.fromJson(item)).toList();
  }

  Future<ConcertPhotoModel> addPhoto({
    required String concertId,
    required String imageUrl,
    String caption = '',
  }) async {
    final model = ConcertPhotoModel(
      id: '',
      concertId: concertId,
      imageUrl: imageUrl,
      caption: caption,
    );

    final response = await http.post(
      Uri.parse(ApiConfig.concertPhotosEndpoint(concertId)),
      headers: _headers,
      body: jsonEncode(model.toCreateJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }

    return ConcertPhotoModel.fromJson(jsonDecode(response.body));
  }

  Future<void> deletePhoto(String photoId) async {
    final response = await http.delete(
      Uri.parse(ApiConfig.photoEndpoint(photoId)),
      headers: _headers,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
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
