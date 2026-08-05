import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

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

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    // Declarar el content-type explícitamente para que el backend
    // no reciba application/octet-stream por defecto
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      imagePath,
      contentType: MediaType.parse(_mimeFromPath(imagePath)),
    ));

    final response = await request.send().timeout(_timeout);

    if (response.statusCode != 201 && response.statusCode != 200) {
      final errorBody = await response.stream.bytesToString();
      throw Exception('Error ${response.statusCode}: $errorBody');
    }

    final body = await response.stream.bytesToString();
    final json = jsonDecode(body) as Map<String, dynamic>;

    final imageUrl = json['url']?.toString() ?? '';

    if (imageUrl.isEmpty) {
      throw Exception(
        'La respuesta del servidor no incluye la URL de la imagen',
      );
    }

    return imageUrl;
  }

  /// Determina el MIME type por extensión del archivo.
  /// Flutter/iOS a veces envía application/octet-stream si no se especifica.
  static String _mimeFromPath(String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'heic':
        return 'image/heic';
      case 'heif':
        return 'image/heif';
      default:
        // Si la extensión no es reconocida, asumir jpeg (lo más común de la galería)
        return 'image/jpeg';
    }
  }
}
