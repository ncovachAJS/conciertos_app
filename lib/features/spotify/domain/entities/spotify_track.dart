/// Canción de Spotify devuelta por el endpoint de top-tracks de un artista.
class SpotifyTrack {
  final String id;
  final String name;
  final int durationMs;
  final String? previewUrl;
  final String albumName;
  final String? albumImageUrl;
  final String spotifyUrl;
  final int popularity;

  const SpotifyTrack({
    required this.id,
    required this.name,
    required this.durationMs,
    required this.albumName,
    required this.spotifyUrl,
    required this.popularity,
    this.previewUrl,
    this.albumImageUrl,
  });

  String get durationFormatted {
    final total = durationMs ~/ 1000;
    final min = total ~/ 60;
    final sec = (total % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  factory SpotifyTrack.fromJson(Map<String, dynamic> json) {
    final album = json['album'] as Map<String, dynamic>? ?? {};
    final images = album['images'] as List<dynamic>? ?? [];
    final externalUrls = json['external_urls'] as Map<String, dynamic>? ?? {};

    return SpotifyTrack(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      durationMs: json['duration_ms'] as int? ?? 0,
      previewUrl: json['preview_url']?.toString(),
      albumName: album['name']?.toString() ?? '',
      albumImageUrl: images.isNotEmpty
          ? (images.last['url'] as String?)   // la más pequeña (64px)
          : null,
      spotifyUrl: externalUrls['spotify']?.toString() ?? '',
      popularity: json['popularity'] as int? ?? 0,
    );
  }
}
