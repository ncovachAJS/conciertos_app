import '../../domain/entities/song.dart';

class SongModel extends Song {
  const SongModel({required super.name});

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(name: json['name']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}
