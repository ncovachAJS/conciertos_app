import '../../domain/entities/ticketmaster_event.dart';

class TicketmasterEventModel extends TicketmasterEvent {
  const TicketmasterEventModel({
    required super.id,
    required super.name,
    required super.image,
    required super.venue,
    required super.city,
    required super.date,
    required super.url,
    required super.recommendedBecause,
  });

  factory TicketmasterEventModel.fromJson(
    Map<String, dynamic> json, {
    required String artist,
  }) {
    final images = json['images'] as List?;
    final embedded = json['_embedded'] as Map<String, dynamic>?;

    final venues = embedded?['venues'] as List?;
    final venue = venues != null && venues.isNotEmpty ? venues.first : null;

    return TicketmasterEventModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: images != null && images.isNotEmpty
          ? images.first['url'] ?? ''
          : '',
      venue: venue?['name'] ?? '',
      city: venue?['city']?['name'] ?? '',
      date:
          DateTime.tryParse(json['dates']?['start']?['localDate'] ?? '') ??
          DateTime.now(),
      url: json['url'] ?? '',
      recommendedBecause: artist,
    );
  }
}
