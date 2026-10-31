import '../../domain/entities/album_record.dart';

class AlbumRecordModel extends AlbumRecord {
  const AlbumRecordModel({
    required super.id,
    required super.title,
    required super.artist,
    required super.format,
    super.year,
    super.label,
    super.country,
    super.coverUrl,
    super.discogsId,
    super.notes,
    super.status,
    super.condition,
    super.rating,
    super.price,
  });

  /// Disco guardado en la colección (respuesta de /records).
  factory AlbumRecordModel.fromJson(Map<String, dynamic> json) =>
      AlbumRecordModel(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        artist: json['artist'] as String? ?? '',
        format: RecordFormatApi.parse(json['format'] as String?),
        year: json['year'] as int?,
        label: json['label'] as String?,
        country: json['country'] as String?,
        coverUrl: json['coverUrl'] as String?,
        discogsId: json['discogsId'] as int?,
        notes: json['notes'] as String?,
        status: RecordStatusApi.parse(json['status'] as String?),
        condition: json['condition'] as String?,
        rating: json['rating'] as int? ?? 0,
        price: (json['price'] as num?)?.toDouble(),
      );

  /// Resultado de búsqueda en Discogs (/records/search): aún no tiene id propio.
  factory AlbumRecordModel.fromSearchJson(Map<String, dynamic> json) =>
      AlbumRecordModel(
        id: '',
        title: json['title'] as String? ?? '',
        artist: json['artist'] as String? ?? '',
        format: RecordFormatApi.parse(json['format'] as String?),
        year: json['year'] as int?,
        label: json['label'] as String?,
        country: json['country'] as String?,
        coverUrl: json['coverUrl'] as String?,
        discogsId: json['discogsId'] as int?,
      );

  static Map<String, dynamic> toCreateJson(AlbumRecord r) => {
        'title': r.title,
        'artist': r.artist,
        'format': r.format.apiValue,
        'status': r.status.apiValue,
        if (r.year != null) 'year': r.year,
        if (r.label != null) 'label': r.label,
        if (r.country != null) 'country': r.country,
        if (r.coverUrl != null) 'coverUrl': r.coverUrl,
        if (r.discogsId != null) 'discogsId': r.discogsId,
        if (r.notes != null) 'notes': r.notes,
        if (r.condition != null) 'condition': r.condition,
        if (r.rating > 0) 'rating': r.rating,
        if (r.price != null) 'price': r.price,
      };
}
