import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/ticketmaster_event_model.dart';

class TicketmasterService {
  static const String _baseUrl =
      'https://app.ticketmaster.com/discovery/v2/events.json';
  static const Duration _timeout = Duration(seconds: 10);
  static const Duration _cacheDuration = Duration(minutes: 15);
  static const int _batchSize = 4;

  static final Map<String, _CachedEvents> _cache = {};

  String get apiKey => dotenv.env['TICKETMASTER_API_KEY']!;

  Future<List<TicketmasterEventModel>> getRecommendedEvents(
    List<String> artists,
  ) async {
    final List<TicketmasterEventModel> events = [];
    final uniqueArtists = artists
        .map((artist) => artist.trim())
        .where((artist) => artist.isNotEmpty)
        .toSet()
        .toList();

    for (var index = 0; index < uniqueArtists.length; index += _batchSize) {
      final batch = uniqueArtists.skip(index).take(_batchSize);
      final batchEvents = await Future.wait(
        batch.map(_getEventsForArtist),
        eagerError: false,
      );

      for (final artistEvents in batchEvents) {
        events.addAll(artistEvents);
      }
    }

    // Eliminar duplicados
    final unique = <String, TicketmasterEventModel>{};

    for (final event in events) {
      unique[event.id] = event;
    }

    final result = unique.values.toList();

    // Solo conciertos futuros
    final now = DateTime.now();

    result.removeWhere(
      (event) => event.date.isBefore(DateTime(now.year, now.month, now.day)),
    );

    // Ordenar por fecha
    result.sort((a, b) => a.date.compareTo(b.date));

    return result;
  }

  Future<List<TicketmasterEventModel>> _getEventsForArtist(
    String artist,
  ) async {
    final cacheKey = artist.toLowerCase();
    final cached = _cache[cacheKey];

    if (cached != null &&
        DateTime.now().difference(cached.createdAt) < _cacheDuration) {
      return cached.events;
    }

    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'apikey': apiKey,
        'keyword': artist,
        'countryCode': 'ES',
        'classificationName': 'music',
        'size': '5',
        'sort': 'date,asc',
      },
    );

    try {
      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode != 200) {
        return const [];
      }

      final json = jsonDecode(response.body);

      if (json['_embedded'] == null) {
        return const [];
      }

      final List list = json['_embedded']['events'];
      final events = list
          .map((e) => TicketmasterEventModel.fromJson(e, artist: artist))
          .toList();

      _cache[cacheKey] = _CachedEvents(events, DateTime.now());

      return events;
    } catch (_) {
      return const [];
    }
  }
}

class _CachedEvents {
  const _CachedEvents(this.events, this.createdAt);

  final List<TicketmasterEventModel> events;
  final DateTime createdAt;
}
