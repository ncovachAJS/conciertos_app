import '../../../../shared/models/concert.dart';

class ConcertService {
  List<Concert> getConcerts() {
    return [
      Concert(
        id: "1",
        artist: "Iron Maiden",
        festival: "Madrid Arena",
        city: "Madrid",
        date: DateTime(2026, 7, 15),
      ),

      Concert(
        id: "2",
        artist: "Metallica",
        festival: "Mad Cool",
        city: "Madrid",
        date: DateTime(2026, 8, 22),
      ),

      Concert(
        id: "3",
        artist: "Ghost",
        festival: "Resurrection Fest",
        city: "Lugo",
        date: DateTime(2026, 7, 2),
      ),
    ];
  }
}
