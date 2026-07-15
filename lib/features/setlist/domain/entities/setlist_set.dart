import 'song.dart';

/// Un bloque dentro de un setlist: el set principal o un encore.
class SetlistSet {
  /// null → set principal. 'Encore 1', 'Encore 2'... → encores.
  final String? name;

  final List<Song> songs;

  const SetlistSet({this.name, required this.songs});

  bool get isEncore => name != null;
}
