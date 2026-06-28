class Concert {
  final String id;
  final String artist;
  final String festival;
  final DateTime date;
  final String city;
  final bool favorite;

  const Concert({
    required this.id,
    required this.artist,
    required this.festival,
    required this.date,
    required this.city,
    this.favorite = false,
  });
}
