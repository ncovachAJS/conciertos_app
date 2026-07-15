class Song {
  final String name;

  /// true si la canción se reproduce desde cinta (no en directo).
  final bool isTape;

  /// Nombre del artista original si es una versión.
  final String? coverOf;

  /// Artista invitado en esta canción.
  final String? withArtist;

  /// Nota adicional (p. ej. "acoustic", "snippet").
  final String? info;

  const Song({
    required this.name,
    this.isTape = false,
    this.coverOf,
    this.withArtist,
    this.info,
  });

  bool get isCover => coverOf != null;
  bool get hasGuest => withArtist != null;
}
