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
    final rawImages = json['images'] as List?;
    // Ordena por anchura descendente y coge la de mayor resolución
    final images = rawImages != null
        ? (List<Map<String, dynamic>>.from(rawImages)
          ..sort((a, b) =>
              ((b['width'] as num?)?.toInt() ?? 0)
                  .compareTo((a['width'] as num?)?.toInt() ?? 0)))
        : null;
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

  /// Constructor para el formato devuelto por el backend proxy (/recommendations).
  factory TicketmasterEventModel.fromBackendJson(
    Map<String, dynamic> json, {
    required String artist,
  }) {
    return TicketmasterEventModel(
      id: json['id']?.toString() ?? '',
      // El backend mapea el título del evento en el campo 'artist'
      name: json['artist']?.toString() ?? '',
      image: json['imageUrl']?.toString() ?? '',
      venue: json['venue']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      url: json['ticketUrl']?.toString() ?? '',
      recommendedBecause: artist,
    );
  }
}
