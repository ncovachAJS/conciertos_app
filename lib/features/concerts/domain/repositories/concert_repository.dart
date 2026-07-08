import '../entities/concert.dart';

abstract class ConcertRepository {
  Future<List<Concert>> getConcerts();

  Future<void> addConcert(Concert concert);

  Future<void> updateConcert(Concert concert);

  Future<void> deleteConcert(String id);
}
