class SpotifyArtist {
  final String id;
  final String name;
  final String url;
  final String? image;
  final int followers;
  final List<String> genres;

  const SpotifyArtist({
    required this.id,
    required this.name,
    required this.url,
    this.image,
    this.followers = 0,
    this.genres = const [],
  });

  factory SpotifyArtist.fromJson(Map<String, dynamic> json) {
    return SpotifyArtist(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      image: json['image']?.toString(),
      followers: json['followers'] as int? ?? 0,
      genres:
          (json['genres'] as List<dynamic>?)
              ?.map((g) => g.toString())
              .toList() ??
          [],
    );
  }
}
