import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../config/api_config.dart';
import '../models/setlist_concert_model.dart';

typedef SetlistSearchResult = ({
  List<SetlistConcertModel> concerts,
  int total,
  int page,
  int itemsPerPage,
});

/// Servicio de importación de conciertos desde setlist.fm.
///
/// Las llamadas van al backend propio (proxy) en lugar de a setlist.fm
/// directamente, para no exponer la API key en el APK/IPA.
class SetlistImportService {
  static const _timeout = Duration(seconds: 15);

  final _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _headers() async {
    final token = await _storage.read(key: 'token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  SetlistSearchResult _empty(int page) => (
        concerts: <SetlistConcertModel>[],
        total: 0,
        page: page,
        itemsPerPage: 20,
      );

  SetlistSearchResult _parse(Map<String, dynamic> json, int page) {
    final rawList = (json['setlist'] as List<dynamic>?) ?? [];
    final concerts = rawList
        .whereType<Map<String, dynamic>>()
        .map(SetlistConcertModel.fromJson)
        .where((c) => c.venue.isNotEmpty)
        .toList();
    return (
      concerts: concerts,
      total: (json['total'] as int?) ?? concerts.length,
      page: (json['page'] as int?) ?? page,
      itemsPerPage: (json['itemsPerPage'] as int?) ?? 20,
    );
  }

  Future<SetlistSearchResult> _search(
    Map<String, String> params,
    int page,
  ) async {
    final uri = Uri.parse(ApiConfig.setlistSearchEndpoint)
        .replace(queryParameters: {...params, 'p': '$page'});

    final response = await http
        .get(uri, headers: await _headers())
        .timeout(_timeout);

    if (response.statusCode == 404) return _empty(page);

    if (response.statusCode != 200) {
      throw Exception('setlist error ${response.statusCode}');
    }

    return _parse(jsonDecode(response.body) as Map<String, dynamic>, page);
  }

  /// Busca conciertos de un festival/tour en setlist.fm (vía backend proxy).
  Future<SetlistSearchResult> searchFestivalConcerts(
    String festivalName, {
    int page = 1,
  }) async {
    if (festivalName.trim().isEmpty) return _empty(page);
    return _search({'tourName': festivalName.trim()}, page);
  }

  /// Busca conciertos de un artista en setlist.fm (vía backend proxy).
  /// [page] empieza en 1. Devuelve la lista + metadatos de paginación.
  Future<SetlistSearchResult> searchArtistConcerts(
    String artistName, {
    int page = 1,
  }) async {
    if (artistName.trim().isEmpty) return _empty(page);
    return _search({'artistName': artistName.trim()}, page);
  }
}
