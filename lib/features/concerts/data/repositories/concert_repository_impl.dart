import '../../domain/entities/concert.dart';
import '../../domain/repositories/concert_repository.dart';
import '../services/concert_api_service.dart';

class ConcertRepositoryImpl implements ConcertRepository {
  final ConcertApiService _apiService;

  ConcertRepositoryImpl({ConcertApiService? apiService})
    : _apiService = apiService ?? ConcertApiService();

  @override
  Future<List<Concert>> getConcerts() {
    return _apiService.getConcerts();
  }

  @override
  Future<void> addConcert(Concert concert) {
    return _apiService.addConcert(concert);
  }

  @override
  Future<void> updateConcert(Concert concert) {
    return _apiService.updateConcert(concert);
  }

  @override
  Future<void> deleteConcert(String id) {
    return _apiService.deleteConcert(id);
  }
}
