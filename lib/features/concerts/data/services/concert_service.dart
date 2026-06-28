import '../../domain/entities/concert.dart';

class ConcertService {
  List<Concert> getConcerts() {
    return [
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
  }
}
