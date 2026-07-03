import 'package:flutter/foundation.dart';

import '../../../concerts/data/services/concert_api_service.dart';
import '../../../concerts/domain/entities/concert.dart';

class DashboardController extends ChangeNotifier {
  final ConcertApiService _api = ConcertApiService();

  bool loading = true;

  List<Concert> concerts = [];

  Future<void> load() async {
    loading = true;
    notifyListeners();

    concerts = await _api.getConcerts();

    concerts.sort((a, b) => b.date.compareTo(a.date));

    loading = false;
    notifyListeners();
  }

  Concert? get nextConcert {
    final now = DateTime.now();

    try {
      return concerts.firstWhere(
        (c) => !c.date.isBefore(DateTime(now.year, now.month, now.day)),
      );
    } catch (_) {
      return null;
    }
  }

  List<Concert> get favorites => concerts.where((c) => c.liked).toList();

  List<String> get favoriteArtists {
    final artists = concerts
        .map((c) => c.artist.trim())
        .where((artist) => artist.isNotEmpty)
        .toSet()
        .toList();

    artists.sort();

    return artists;
  }

  List<Concert> get latest {
    final list = [...concerts];

    list.sort((a, b) => b.date.compareTo(a.date));

    return list.take(10).toList();
  }

  int get totalConcerts => concerts.length;

  int get totalFestivals => concerts.map((e) => e.festival).toSet().length;

  int get totalRecommended => concerts.where((e) => e.liked).length;

  double get averageRating {
    if (concerts.isEmpty) return 0;

    final total = concerts.fold<int>(0, (sum, c) => sum + c.rating);

    return total / concerts.length;
  }
}
