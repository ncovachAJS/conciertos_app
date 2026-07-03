import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ArtistImageService {
  static const _baseUrl = 'https://www.theaudiodb.com/api/v1/json/2/search.php';
  static const Duration _timeout = Duration(seconds: 8);
  static final Map<String, Future<String?>> _cache = {};

  Future<String?> getImage(String artist) async {
    final cacheKey = artist.trim().toLowerCase();

    if (cacheKey.isEmpty) {
      return null;
    }

    return _cache.putIfAbsent(cacheKey, () => _fetchImage(artist));
  }

  Future<String?> _fetchImage(String artist) async {
    try {
      final uri = Uri.parse('$_baseUrl?s=${Uri.encodeQueryComponent(artist)}');

      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode != 200) {
        return null;
      }

      final Map<String, dynamic> json = jsonDecode(response.body);

      final artists = json['artists'];

      if (artists == null || artists.isEmpty) {
        return null;
      }

      final first = artists.first as Map<String, dynamic>;

      return first['strArtistThumb'];
    } catch (e) {
      debugPrint('Error buscando imagen de $artist: $e');

      return null;
    }
  }
}
