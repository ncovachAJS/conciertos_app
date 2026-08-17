import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../config/api_config.dart';
import '../../../../features/auth/presentation/controllers/auth_controller.dart';
import '../models/setlist_model.dart';

class SetlistService {
  static const Duration _timeout = Duration(seconds: 15);
  static const Duration _cacheDuration = Duration(hours: 6);

  static final Map<String, _CachedSetlist> _cache = {};

  Future<SetlistModel?> searchSetlist({
    required String artist,
    required DateTime date,
    required String city,
    String? venue,
  }) async {
    final cacheKey = [
      artist.trim().toLowerCase(),
      DateTime(date.year, date.month, date.day).toIso8601String(),
      city.trim().toLowerCase(),
      venue?.trim().toLowerCase() ?? '',
    ].join('|');

    final cached = _cache[cacheKey];
    if (cached != null &&
        DateTime.now().difference(cached.createdAt) < _cacheDuration) {
      return cached.setlist;
    }

    final formattedDate =
        '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';

    final uri = Uri.parse(ApiConfig.setlistSearchEndpoint).replace(
      queryParameters: {
        'artistName': artist.trim(),
        'date': formattedDate,
        'p': '1',
      },
    );

    final token = AuthController.instance.token;

    final response = await http
        .get(
          uri,
          headers: {
            'Accept': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        )
        .timeout(_timeout);

    if (response.statusCode == 404) {
      // setlist.fm devuelve 404 cuando no encuentra nada — no es un error
      _cache[cacheKey] = _CachedSetlist(null, DateTime.now());
      return null;
    }

    if (response.statusCode != 200) {
      throw Exception('Setlist (${response.statusCode})\n${response.body}');
    }

    final json = jsonDecode(response.body);

    if (json['setlist'] == null) {
      _cache[cacheKey] = _CachedSetlist(null, DateTime.now());
      return null;
    }

    final List list = json['setlist'];

    if (list.isEmpty) {
      _cache[cacheKey] = _CachedSetlist(null, DateTime.now());
      return null;
    }

    debugPrint('[SetlistService] encontrado: ${list.first['id']}');
    final setlist = SetlistModel.fromJson(list.first);
    _cache[cacheKey] = _CachedSetlist(setlist, DateTime.now());

    return setlist;
  }
}

class _CachedSetlist {
  const _CachedSetlist(this.setlist, this.createdAt);

  final SetlistModel? setlist;
  final DateTime createdAt;
}
