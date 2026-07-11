import 'package:conciertos_app/features/recommendations/presentation/pages/domain/entities/recommended_event.dart';

class RecommendedEventModel extends RecommendedEvent {
  const RecommendedEventModel({
    required super.id,
    required super.artist,
    required super.venue,
    required super.city,
    required super.country,
    required super.date,
    required super.imageUrl,
    required super.ticketUrl,
  });

  factory RecommendedEventModel.fromJson(Map<String, dynamic> json) {
    return RecommendedEventModel(
      id: json['id'],
      artist: json['artist'],
      venue: json['venue'],
      city: json['city'],
      country: json['country'],
      date: DateTime.parse(json['date']),
      imageUrl: json['imageUrl'],
      ticketUrl: json['ticketUrl'],
    );
  }
}
