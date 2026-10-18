enum RecordFormat { vinyl, cd, other }

extension RecordFormatApi on RecordFormat {
  String get apiValue => switch (this) {
        RecordFormat.vinyl => 'VINYL',
        RecordFormat.cd => 'CD',
        RecordFormat.other => 'OTHER',
      };

  static RecordFormat parse(String? value) => switch (value) {
        'VINYL' => RecordFormat.vinyl,
        'CD' => RecordFormat.cd,
        _ => RecordFormat.other,
      };
}

enum RecordStatus { owned, wishlist }

extension RecordStatusApi on RecordStatus {
  String get apiValue => this == RecordStatus.wishlist ? 'WISHLIST' : 'OWNED';

  static RecordStatus parse(String? value) =>
      value == 'WISHLIST' ? RecordStatus.wishlist : RecordStatus.owned;
}

/// Estado físico del disco (escala Goldmine). Se guarda el código tal cual.
const kRecordConditions = ['M', 'NM', 'VG+', 'VG', 'G', 'P'];

/// Disco de la colección del usuario (vinilo o CD).
/// Se llama AlbumRecord para no chocar con el tipo `Record` de Dart 3.
class AlbumRecord {
  final String id;
  final String title;
  final String artist;
  final RecordFormat format;
  final int? year;
  final String? label;
  final String? country;
  final String? coverUrl;
  final int? discogsId;
  final String? notes;
  final RecordStatus status;
  final String? condition;
  final int rating; // 0 = sin valorar
  final double? price;

  const AlbumRecord({
    required this.id,
    required this.title,
    required this.artist,
    required this.format,
    this.year,
    this.label,
    this.country,
    this.coverUrl,
    this.discogsId,
    this.notes,
    this.status = RecordStatus.owned,
    this.condition,
    this.rating = 0,
    this.price,
  });

  /// Copia con otro estado (p. ej. para añadir un resultado de búsqueda
  /// a la lista de deseos).
  AlbumRecord withStatus(RecordStatus status) => AlbumRecord(
        id: id,
        title: title,
        artist: artist,
        format: format,
        year: year,
        label: label,
        country: country,
        coverUrl: coverUrl,
        discogsId: discogsId,
        notes: notes,
        status: status,
        condition: condition,
        rating: rating,
        price: price,
      );
}

class RecordTrack {
  final String position;
  final String title;
  final String duration;

  const RecordTrack({
    required this.position,
    required this.title,
    required this.duration,
  });
}

/// Datos ampliados de Discogs (canciones, géneros...). Solo para discos
/// que tienen discogsId.
class RecordDetail {
  final List<RecordTrack> tracklist;
  final List<String> genres;
  final List<String> styles;
  final String? discogsUrl;

  const RecordDetail({
    this.tracklist = const [],
    this.genres = const [],
    this.styles = const [],
    this.discogsUrl,
  });

  factory RecordDetail.fromJson(Map<String, dynamic> json) => RecordDetail(
        tracklist: (json['tracklist'] as List<dynamic>? ?? [])
            .map((t) => RecordTrack(
                  position: t['position'] as String? ?? '',
                  title: t['title'] as String? ?? '',
                  duration: t['duration'] as String? ?? '',
                ))
            .toList(),
        genres: List<String>.from(json['genres'] as List<dynamic>? ?? []),
        styles: List<String>.from(json['styles'] as List<dynamic>? ?? []),
        discogsUrl: json['discogsUrl'] as String?,
      );
}
