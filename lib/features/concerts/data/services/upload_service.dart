import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../config/api_config.dart';

class UploadService {
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

    final response = await request.send();

    if (response.statusCode != 201 && response.statusCode != 200) {
      final errorBody = await response.stream.bytesToString();

      throw Exception(
        'Error ${response.statusCode}: $errorBody',
      );
    }

    final body = await response.stream.bytesToString();

    final json = jsonDecode(body);

    return json['imageUrl'];
  }
}