import 'package:flutter/material.dart';

import '../../data/repositories/concert_repository_impl.dart';
import '../../domain/entities/concert.dart';
import '../../domain/repositories/concert_repository.dart';

class ConcertsController extends ChangeNotifier {
  final ConcertRepository _repository = ConcertRepositoryImpl();

  List<Concert> concerts = [];

  List<Concert> filteredConcerts = [];

  bool loading = false;

  bool deleting = false;

  Future<void> loadConcerts() async {
    loading = true;

    notifyListeners();

    try {
      concerts = await _repository.getConcerts();

      concerts.sort((a, b) => b.date.compareTo(a.date));

      filteredConcerts = List.from(concerts);
    } finally {
      loading = false;

      notifyListeners();
    }
  }

  void filterConcerts(String value) {
    if (value.trim().isEmpty) {
      filteredConcerts = List.from(concerts);

      notifyListeners();

      return;
    }

    final query = value.toLowerCase();

    filteredConcerts = concerts.where((concert) {
      return concert.artist.toLowerCase().contains(query) ||
          concert.festival.toLowerCase().contains(query) ||
          concert.city.toLowerCase().contains(query);
    }).toList();

    notifyListeners();
  }

  Future<void> deleteConcert(String id) async {
    deleting = true;

    notifyListeners();

    try {
      await _repository.deleteConcert(id);

      await loadConcerts();
    } finally {
      deleting = false;

      notifyListeners();
    }
  }
}
