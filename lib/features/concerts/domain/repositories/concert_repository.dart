import '../entities/concert.dart';

abstract class ConcertRepository {
  List<Concert> getConcerts();

  void addConcert(Concert concert);
}
