import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/recommended_event.dart';

class WishlistNotifier extends AsyncNotifier<List<RecommendedEvent>> {
  static const _key = 'wishlist_events';

  @override
  Future<List<RecommendedEvent>> build() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list.map((e) => _fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> toggle(RecommendedEvent event) async {
    final current = state.asData?.value ?? [];
    final updated = current.any((e) => e.id == event.id)
        ? current.where((e) => e.id != event.id).toList()
        : [...current, event];
    state = AsyncData(updated);
    await _save(updated);
  }

  bool contains(String id) =>
      state.asData?.value.any((e) => e.id == id) ?? false;

  Future<void> _save(List<RecommendedEvent> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(list.map(_toJson).toList()));
  }

  static Map<String, dynamic> _toJson(RecommendedEvent e) => {
        'id': e.id,
        'artist': e.artist,
        'venue': e.venue,
        'city': e.city,
        'country': e.country,
        'date': e.date.toIso8601String(),
        'imageUrl': e.imageUrl,
        'ticketUrl': e.ticketUrl,
      };

  static RecommendedEvent _fromJson(Map<String, dynamic> j) => RecommendedEvent(
        id: j['id']?.toString() ?? '',
        artist: j['artist']?.toString() ?? '',
        venue: j['venue']?.toString() ?? '',
        city: j['city']?.toString() ?? '',
        country: j['country']?.toString() ?? '',
        date: DateTime.tryParse(j['date']?.toString() ?? '') ?? DateTime.now(),
        imageUrl: j['imageUrl']?.toString() ?? '',
        ticketUrl: j['ticketUrl']?.toString() ?? '',
      );
}

final wishlistProvider =
    AsyncNotifierProvider<WishlistNotifier, List<RecommendedEvent>>(
  WishlistNotifier.new,
);
