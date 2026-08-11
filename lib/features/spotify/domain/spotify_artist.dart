class SpotifyArtist {
  final String id;
  final String name;
  final String? imageUrl;
  final List<String> genres;
  final int popularity; // 0-100

  const SpotifyArtist({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.genres,
    required this.popularity,
  });

  factory SpotifyArtist.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as List<dynamic>? ?? [];
    // Spotify devuelve las imágenes de mayor a menor resolución
    final imageUrl = images.isNotEmpty
        ? (images.first['url'] as String?)
        : null;

    return SpotifyArtist(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: imageUrl,
      genres: (json['genres'] as List<dynamic>? ?? [])
          .map((g) => g as String)
          .toList(),
      popularity: json['popularity'] as int? ?? 0,
    );
  }
}
