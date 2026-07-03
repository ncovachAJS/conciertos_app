class TicketmasterEvent {
  final String id;
  final String name;
  final String image;
  final String venue;
  final String city;
  final DateTime date;
  final String url;
  final String recommendedBecause;

  const TicketmasterEvent({
    required this.id,
    required this.name,
    required this.image,
    required this.venue,
    required this.city,
    required this.date,
    required this.url,
    required this.recommendedBecause,
  });
}
