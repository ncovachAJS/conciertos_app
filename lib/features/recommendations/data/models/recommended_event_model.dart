import '../../domain/entities/recommended_event.dart';

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
      id: json['id']?.toString() ?? '',
      artist: json['artist']?.toString() ?? '',
      venue: json['venue']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      imageUrl: json['imageUrl']?.toString() ?? '',
      ticketUrl: json['ticketUrl']?.toString() ?? '',
    );
  }
}
