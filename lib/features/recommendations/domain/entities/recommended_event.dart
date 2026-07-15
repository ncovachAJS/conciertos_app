class RecommendedEvent {
  final String id;
  final String artist;
  final String venue;
  final String city;
  final String country;
  final DateTime date;
  final String imageUrl;
  final String ticketUrl;

  const RecommendedEvent({
    required this.id,
    required this.artist,
    required this.venue,
    required this.city,
    required this.country,
    required this.date,
    required this.imageUrl,
    required this.ticketUrl,
  });
}
