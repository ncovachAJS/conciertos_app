import 'dart:convert';

import 'package:conciertos_app/features/concerts/domain/entities/concert.dart';
import 'package:conciertos_app/features/import/data/models/festival_model.dart';
import 'package:conciertos_app/features/import/data/services/artist_image_service.dart';
import 'package:flutter/services.dart';

class FestivalImportService {
  static const int _imageBatchSize = 6;

  final ArtistImageService _artistImageService = ArtistImageService();

  /// Lee el listado plano de conciertos y los agrupa por festival + año,
  /// devolviendo una tarjeta por festival.
  Future<List<FestivalModel>> getFestivals() async {
    final jsonString = await rootBundle.loadString(
      'assets/imports/festivals.json',
    );

    final List<dynamic> json = jsonDecode(jsonString);
    final items = json.whereType<Map<String, dynamic>>().toList();

    final groups = <String, List<Map<String, dynamic>>>{};

    for (final item in items) {
      final festival = item['festival']?.toString() ?? '';
      final year = _yearFromDate(item['date']?.toString());
      final key = '$festival|$year';

      groups.putIfAbsent(key, () => []).add(item);
    }

    final festivals = groups.entries.map((entry) {
      final concerts = entry.value;
      final first = concerts.first;

      final festival = first['festival']?.toString() ?? '';
      final year = _yearFromDate(first['date']?.toString());

      return FestivalModel(
        id: '$festival $year',
        title: festival,
        year: year,
        city: first['city']?.toString(),
        venue: first['venue']?.toString(),
        concerts: concerts,
      );
    }).toList();

    // Más recientes primero.
    festivals.sort((a, b) => b.year.compareTo(a.year));

    return festivals;
  }

  Future<List<Concert>> loadFestivalModel(FestivalModel festival) async {
    if (festival.concerts.isEmpty) {
      return const [];
    }

    return _concertsFromJson(festival.concerts);
  }

  Future<List<Concert>> _concertsFromJson(
    List<Map<String, dynamic>> json,
  ) async {
    final concerts = <Concert>[];

    for (var index = 0; index < json.length; index += _imageBatchSize) {
      final batch = json.skip(index).take(_imageBatchSize);
      final batchConcerts = await Future.wait(batch.map(_concertFromJson));

      concerts.addAll(batchConcerts);
    }

    return concerts;
  }

  Future<Concert> _concertFromJson(Map<String, dynamic> item) async {
    final artist = item['artist']?.toString() ?? '';
    String imageUrl = item['imageUrl']?.toString() ?? '';

    if (imageUrl.isEmpty) {
      imageUrl = await _artistImageService.getImage(artist) ?? '';
    }

    return Concert(
      id: '${DateTime.now().microsecondsSinceEpoch}$artist',
      artist: artist,
      festival: item['festival']?.toString() ?? '',
      name: item['name']?.toString() ?? '',
      city: item['city']?.toString() ?? '',
      venue: item['venue']?.toString() ?? '',
      date: DateTime.parse(item['date']?.toString() ?? ''),
      imageUrl: imageUrl,
      rating: int.tryParse((item['rating'] ?? 0).toString()) ?? 0,
      liked: item['liked'] == true || item['liked'].toString() == 'true',
    );
  }

  int _yearFromDate(String? date) {
    if (date == null || date.isEmpty) {
      return DateTime.now().year;
    }

    return DateTime.tryParse(date)?.year ?? DateTime.now().year;
  }
}
