import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../config/api_config.dart';

class UploadService {
  /// Margen amplio para tolerar el arranque en frío de Render, pero sin colgar
  /// la app indefinidamente.
  static const Duration _timeout = Duration(seconds: 60);

  Future<String> uploadImage(String imagePath) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConfig.uploadsEndpoint),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        imagePath,
      ),
    );

    final response = await request.send().timeout(_timeout);

    if (response.statusCode != 201 && response.statusCode != 200) {
      final errorBody = await response.stream.bytesToString();

      throw Exception(
        'Error ${response.statusCode}: $errorBody',
      );
    }

    final body = await response.stream.bytesToString();

    final json = jsonDecode(body) as Map<String, dynamic>;

    final imageUrl = json['imageUrl'];

    if (imageUrl is! String || imageUrl.isEmpty) {
      throw Exception('La respuesta del servidor no incluye la URL de la imagen');
    }

    return imageUrl;
  }
}