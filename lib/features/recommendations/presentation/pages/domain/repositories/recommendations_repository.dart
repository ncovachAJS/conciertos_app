import '../entities/recommended_event.dart';

abstract class RecommendationsRepository {
  Future<List<RecommendedEvent>> getRecommendations(List<String> artists);
}
