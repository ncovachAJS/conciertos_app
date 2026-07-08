import 'dart:convert';

import 'package:conciertos_app/features/concerts/domain/entities/concert.dart';
import 'package:conciertos_app/features/import/data/models/festival_model.dart';
import 'package:conciertos_app/features/import/data/services/artist_image_service.dart';
import 'package:flutter/services.dart';

class FestivalImportService {
  static const int _imageBatchSize = 6;

  final ArtistImageService _artistImageService = ArtistImageService();

  Future<List<FestivalModel>> getFestivals() async {
    final jsonString = await rootBundle.loadString(
      'assets/imports/festivals.json',
    );

    final List<dynamic> json = jsonDecode(jsonString);

    return json.map((e) => FestivalModel.fromJson(e)).toList();
  }

  Future<List<Concert>> loadFestival(String fileName) async {
    final jsonString = await rootBundle.loadString('assets/imports/$fileName');

    final List<dynamic> json = jsonDecode(jsonString);

    return _concertsFromJson(json.cast<Map<String, dynamic>>());
  }

  Future<List<Concert>> loadFestivalModel(FestivalModel festival) async {
    if (festival.concerts.isNotEmpty) {
      return _concertsFromJson(
        festival.concerts.map((concert) {
          return {
            'festival': festival.title,
            'city': festival.city ?? '',
            'venue': festival.venue ?? '',
            ...concert,
          };
        }).toList(),
      );
    }

    final file = festival.file;

    if (file == null || file.isEmpty) {
      return const [];
    }

    return loadFestival(file);
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
      name: item['name']?.toString() ??
      item['city']?.toString() ??
      '',
      venue: item['venue']?.toString() ?? '',
      date: DateTime.parse(item['date']?.toString() ?? ''),
      imageUrl: imageUrl,
      rating: int.tryParse((item['rating'] ?? 0).toString()) ?? 0,
      liked: item['liked'] == true || item['liked'].toString() == 'true',
    );
  }
}
