import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../config/api_config.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class UploadService {
  static const Duration _timeout = Duration(seconds: 60);

  Future<String> uploadImage(String imagePath) async {
    final token = AuthController.instance.token;

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConfig.uploadsEndpoint),
    );

    // ✅ Fix 1: JWT token en el header
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.files.add(await http.MultipartFile.fromPath('file', imagePath));

    final response = await request.send().timeout(_timeout);

    if (response.statusCode != 201 && response.statusCode != 200) {
      final errorBody = await response.stream.bytesToString();
      throw Exception('Error ${response.statusCode}: $errorBody');
    }

    final body = await response.stream.bytesToString();
    final json = jsonDecode(body) as Map<String, dynamic>;

    // ✅ Fix 2: el back devuelve { url: '...' }, no imageUrl
    final imageUrl = json['url']?.toString() ?? '';

    if (imageUrl.isEmpty) {
      throw Exception(
        'La respuesta del servidor no incluye la URL de la imagen',
      );
    }

    return imageUrl;
  }
}
