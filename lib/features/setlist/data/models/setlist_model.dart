import '../../domain/entities/setlist.dart';
import '../../domain/entities/setlist_set.dart';
import 'song_model.dart';

class SetlistModel extends Setlist {
  const SetlistModel({
    required super.artist,
    required super.venue,
    required super.city,
    required super.eventDate,
    required super.sets,
  });

  factory SetlistModel.fromJson(Map<String, dynamic> json) {
    final rawSets = json['sets']?['set'] as List<dynamic>? ?? [];

    int encoreCount = 0;

    final sets = rawSets.map((rawSet) {
      final rawSongs = rawSet['song'] as List<dynamic>? ?? [];
      final songs = rawSongs
          .map((s) => SongModel.fromJson(s as Map<String, dynamic>))
          .where((s) => s.name.isNotEmpty)
          .toList();

      // La API devuelve "encore": 1 para los encores.
      final isEncore = rawSet['encore'] != null;
      String? setName;

      if (isEncore) {
        encoreCount++;
        setName = encoreCount == 1 ? 'Encore' : 'Encore $encoreCount';
      }

      return SetlistSet(name: setName, songs: songs);
    }).toList();

    return SetlistModel(
      artist: json['artist']?['name']?.toString() ?? '',
      venue: json['venue']?['name']?.toString() ?? '',
      city: json['venue']?['city']?['name']?.toString() ?? '',
      eventDate: json['eventDate']?.toString() ?? '',
      sets: sets,
    );
  }
}
