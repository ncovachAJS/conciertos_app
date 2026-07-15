class SetlistConcertModel {
  final String id;
  final String artist;
  final String venue;
  final String city;
  final String country;
  final DateTime date;

  const SetlistConcertModel({
    required this.id,
    required this.artist,
    required this.venue,
    required this.city,
    required this.country,
    required this.date,
  });

  bool get isPast => date.isBefore(DateTime.now());

  String get formattedDate {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  factory SetlistConcertModel.fromJson(Map<String, dynamic> json) {
    // setlist.fm devuelve la fecha como "DD-MM-YYYY"
    final rawDate = json['eventDate']?.toString() ?? '';
    final parts = rawDate.split('-');
    DateTime date = DateTime.now();
    if (parts.length == 3) {
      date = DateTime(
        int.tryParse(parts[2]) ?? DateTime.now().year,
        int.tryParse(parts[1]) ?? 1,
        int.tryParse(parts[0]) ?? 1,
      );
    }

    return SetlistConcertModel(
      id: json['id']?.toString() ?? '',
      artist: json['artist']?['name']?.toString() ?? '',
      venue: json['venue']?['name']?.toString() ?? '',
      city: json['venue']?['city']?['name']?.toString() ?? '',
      country: json['venue']?['city']?['country']?['name']?.toString() ?? '',
      date: date,
    );
  }
}
