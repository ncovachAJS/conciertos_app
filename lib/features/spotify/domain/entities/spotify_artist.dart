class SpotifyArtist {
  final String id;
  final String name;
  final String url;

  const SpotifyArtist({
    required this.id,
    required this.name,
    required this.url,
  });

  factory SpotifyArtist.fromJson(Map<String, dynamic> json) {
    return SpotifyArtist(id: json['id'], name: json['name'], url: json['url']);
  }
}
