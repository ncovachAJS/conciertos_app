import '../../domain/entities/song.dart';

class SongModel extends Song {
  const SongModel({
    required super.name,
    super.isTape,
    super.coverOf,
    super.withArtist,
    super.info,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      name: json['name']?.toString() ?? '',
      isTape: json['tape'] == true,
      coverOf: json['cover']?['name']?.toString(),
      withArtist: json['with']?['name']?.toString(),
      info: json['info']?.toString(),
    );
  }
}
