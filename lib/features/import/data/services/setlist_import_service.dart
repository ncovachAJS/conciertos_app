import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/setlist_concert_model.dart';

typedef SetlistSearchResult = ({
  List<SetlistConcertModel> concerts,
  int total,
  int page,
  int itemsPerPage,
});

class SetlistImportService {
  static const _baseUrl = 'https://api.setlist.fm/rest/1.0';
  static const _timeout = Duration(seconds: 10);

  String get _apiKey => dotenv.env['SETLIST_API_KEY'] ?? '';

  /// Busca todos los conciertos de un festival en setlist.fm.
  /// Usa el parámetro festivalName de la API.
  Future<SetlistSearchResult> searchFestivalConcerts(
    String festivalName, {
    int page = 1,
  }) async {
    if (festivalName.trim().isEmpty) {
      return (
        concerts: <SetlistConcertModel>[],
        total: 0,
        page: 1,
        itemsPerPage: 20,
      );
    }

    final uri = Uri.parse(
      '$_baseUrl/search/setlists'
      '?tourName=${Uri.encodeComponent(festivalName.trim())}'
      '&p=$page',
    );

    final response = await http
        .get(
          uri,
          headers: {
            'Accept': 'application/json',
            'Accept-Language': 'es',
            'x-api-key': _apiKey,
          },
        )
        .timeout(_timeout);

    if (response.statusCode == 404) {
      return (
        concerts: <SetlistConcertModel>[],
        total: 0,
        page: 1,
        itemsPerPage: 20,
      );
    }

    if (response.statusCode != 200) {
      throw Exception('setlist.fm error \${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
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

  /// Busca todos los conciertos de un artista en setlist.fm.
  /// [page] empieza en 1. Devuelve la lista + metadatos de paginación.
  Future<SetlistSearchResult> searchArtistConcerts(
    String artistName, {
    int page = 1,
  }) async {
    if (artistName.trim().isEmpty) {
      return (
        concerts: <SetlistConcertModel>[],
        total: 0,
        page: 1,
        itemsPerPage: 20,
      );
    }

    final uri = Uri.parse(
      '$_baseUrl/search/setlists'
      '?artistName=${Uri.encodeComponent(artistName.trim())}'
      '&p=$page',
    );

    final response = await http
        .get(
          uri,
          headers: {
            'Accept': 'application/json',
            'Accept-Language': 'es',
            'x-api-key': _apiKey,
          },
        )
        .timeout(_timeout);

    if (response.statusCode == 404) {
      return (
        concerts: <SetlistConcertModel>[],
        total: 0,
        page: 1,
        itemsPerPage: 20,
      );
    }

    if (response.statusCode != 200) {
      throw Exception('setlist.fm error ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final rawList = (json['setlist'] as List<dynamic>?) ?? [];

    final concerts = rawList
        .whereType<Map<String, dynamic>>()
        .map(SetlistConcertModel.fromJson)
        // Filtramos los que no tienen venue (borradores / sin info)
        .where((c) => c.venue.isNotEmpty)
        .toList();

    return (
      concerts: concerts,
      total: (json['total'] as int?) ?? concerts.length,
      page: (json['page'] as int?) ?? page,
      itemsPerPage: (json['itemsPerPage'] as int?) ?? 20,
    );
  }
}
