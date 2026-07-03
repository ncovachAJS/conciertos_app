import 'song.dart';

class Setlist {
  final String artist;
  final String venue;
  final String city;
  final String eventDate;
  final List<Song> songs;

  const Setlist({
    required this.artist,
    required this.venue,
    required this.city,
    required this.eventDate,
    required this.songs,
  });
}
