class FestivalModel {
  final String id;
  final String title;
  final int year;
  final String? city;
  final String? venue;
  final String? file;
  final List<Map<String, dynamic>> concerts;

  const FestivalModel({
    required this.id,
    required this.title,
    required this.year,
    this.city,
    this.venue,
    this.file,
    this.concerts = const [],
  });

  factory FestivalModel.fromJson(Map<String, dynamic> json) {
    return FestivalModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      year: int.tryParse(json['year'].toString()) ?? DateTime.now().year,
      city: json['city']?.toString(),
      venue: json['venue']?.toString(),
      file: json['file']?.toString(),
      concerts: (json['concerts'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'year': year,
      'city': city,
      'venue': venue,
      'file': file,
      'concerts': concerts,
    };
  }
}
