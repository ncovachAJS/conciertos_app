import '../../domain/entities/concert.dart';

class ConcertService {
  ConcertService._();

  static final ConcertService instance = ConcertService._();

  final List<Concert> _concerts = [
    Concert(
      id: '1',
      artist: 'Iron Maiden',
      festival: 'Madrid Arena',
      city: 'Madrid',
      date: DateTime(2026, 7, 15),
    ),
    Concert(
      id: '2',
      artist: 'Ghost',
      festival: 'Resurrection Fest',
      city: 'Viveiro',
      date: DateTime(2026, 7, 2),
    ),
    Concert(
      id: '3',
      artist: 'La Renga',
      festival: 'Palacio Vistalegre',
      city: 'Madrid',
      date: DateTime(2026, 10, 10),
    ),
    Concert(
      id: '4',
      artist: 'Metallica',
      festival: 'Mad Cool',
      city: 'Madrid',
      date: DateTime(2026, 8, 22),
    ),
  ];

  List<Concert> getConcerts() {
    return List.unmodifiable(_concerts);
  }

  void addConcert(Concert concert) {
    _concerts.add(concert);
  }

  void deleteConcert(String id) {
    _concerts.removeWhere((concert) => concert.id == id);
  }

  void updateConcert(Concert updatedConcert) {
    final index = _concerts.indexWhere(
      (concert) => concert.id == updatedConcert.id,
    );

    if (index != -1) {
      _concerts[index] = updatedConcert;
    }
  }
}
