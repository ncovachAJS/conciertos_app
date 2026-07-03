import '../../domain/entities/setlist.dart';
import '../../domain/entities/song.dart';
import 'song_model.dart';

class SetlistModel extends Setlist {
  const SetlistModel({
    required super.artist,
    required super.venue,
    required super.city,
    required super.eventDate,
    required super.songs,
  });

  factory SetlistModel.fromJson(Map<String, dynamic> json) {
    final sets = json['sets'];

    final List<Song> songs = [];

    if (sets != null &&
        sets['set'] != null &&
        (sets['set'] as List).isNotEmpty) {
      final firstSet = sets['set'][0];

      if (firstSet['song'] != null) {
        for (final item in firstSet['song']) {
          songs.add(SongModel.fromJson(item));
        }
      }
    }

    return SetlistModel(
      artist: json['artist']?['name'] ?? '',
      venue: json['venue']?['name'] ?? '',
      city: json['venue']?['city']?['name'] ?? '',
      eventDate: json['eventDate'] ?? '',
      songs: songs,
    );
  }
}
