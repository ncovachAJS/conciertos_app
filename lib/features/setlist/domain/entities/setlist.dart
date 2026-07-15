import 'setlist_set.dart';
import 'song.dart';

class Setlist {
  final String artist;
  final String venue;
  final String city;
  final String eventDate;

  /// Todos los bloques: set principal + encores.
  final List<SetlistSet> sets;

  const Setlist({
    required this.artist,
    required this.venue,
    required this.city,
    required this.eventDate,
    required this.sets,
  });

  /// Todas las canciones de todos los sets, en orden.
  List<Song> get allSongs => sets.expand((s) => s.songs).toList();

  int get totalSongs => allSongs.length;
}
