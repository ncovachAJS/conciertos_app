import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/setlist_model.dart';

class SetlistService {
  static const String _baseUrl = 'https://api.setlist.fm/rest/1.0';
  static const Duration _timeout = Duration(seconds: 10);
  static const Duration _cacheDuration = Duration(hours: 6);

  static final Map<String, _CachedSetlist> _cache = {};

  String get apiKey => dotenv.env['SETLIST_API_KEY']!;

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

    final uri = Uri.parse(
      '$_baseUrl/search/setlists'
      '?artistName=${Uri.encodeComponent(artist)}'
      '&date=$formattedDate'
      '&p=1',
    );

    final response = await http
        .get(
          uri,
          headers: {
            'Accept': 'application/json',
            'Accept-Language': 'es',
            'x-api-key': apiKey,
          },
        )
        .timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception('Setlist.fm (${response.statusCode})\n${response.body}');
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
