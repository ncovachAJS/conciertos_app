import 'package:flutter/foundation.dart';

import '../../../concerts/data/services/concert_api_service.dart';
import '../../../concerts/domain/entities/concert.dart';

class ProfileController extends ChangeNotifier {
  final ConcertApiService _api = ConcertApiService();

  bool loading = true;

  List<Concert> concerts = [];

  Future<void> load() async {
    loading = true;
    notifyListeners();

    concerts = await _api.getConcerts();

    loading = false;
    notifyListeners();
  }

  int get totalConcerts => concerts.length;

  int get totalFavorites => concerts.where((c) => c.favorite).length;
}
