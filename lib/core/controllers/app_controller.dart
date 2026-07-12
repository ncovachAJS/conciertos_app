import 'package:flutter/foundation.dart';

import '../../features/concerts/data/services/concert_api_service.dart';
import '../../features/concerts/domain/entities/concert.dart';

class AppController extends ChangeNotifier {
  AppController._();

  static final AppController instance = AppController._();

  final ConcertApiService _api = ConcertApiService();

  bool loading = false;

  List<Concert> _concerts = [];

  List<Concert> get concerts => _concerts;

  Future<void> loadConcerts({bool forceRefresh = false}) async {
    if (_concerts.isNotEmpty && !forceRefresh) return;

    loading = true;
    notifyListeners();

    _concerts = await _api.getConcerts();

    _concerts.sort((a, b) => b.date.compareTo(a.date));

    loading = false;
    notifyListeners();
  }

  Concert? get nextConcert {
    final now = DateTime.now();

    try {
      return _concerts.firstWhere(
        (c) => !c.date.isBefore(DateTime(now.year, now.month, now.day)),
      );
    } catch (_) {
      return null;
    }
  }

  List<Concert> get favorites => _concerts.where((c) => c.favorite).toList();

  List<String> get favoriteArtists =>
      favorites
          .map((c) => c.artist.trim())
          .where((e) => e.isNotEmpty)
          .toSet()
          .toList()
        ..sort();

  List<Concert> get latest =>
      [..._concerts]..sort((a, b) => b.date.compareTo(a.date));

  int get totalConcerts => _concerts.length;

  int get totalFavorites => favorites.length;

  double get averageRating {
    if (_concerts.isEmpty) return 0;

    final total = _concerts.fold<int>(0, (sum, c) => sum + c.rating);

    return total / _concerts.length;
  }
}
