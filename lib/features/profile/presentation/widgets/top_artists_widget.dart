import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../concerts/domain/entities/concert.dart';
import '../../../spotify/data/services/spotify_search_service.dart';
import '../../../spotify/domain/entities/spotify_artist.dart';

/// Artistas más presentes en el historial del usuario,
/// enriquecidos con foto y datos de Spotify.
class TopArtistsWidget extends StatefulWidget {
  final List<Concert> concerts;

  const TopArtistsWidget({super.key, required this.concerts});

  @override
  State<TopArtistsWidget> createState() => _TopArtistsWidgetState();
}

class _TopArtistsWidgetState extends State<TopArtistsWidget> {
  final _spotifyService = SpotifySearchService();

  /// artista → datos enriquecidos (puede ser null si Spotify no lo encuentra)
  final Map<String, SpotifyArtist?> _spotifyData = {};
  List<_ArtistScore> _ranked = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _compute();
  }

  @override
  void didUpdateWidget(TopArtistsWidget old) {
    super.didUpdateWidget(old);
    if (old.concerts != widget.concerts) _compute();
  }

  void _compute() {
    final now = DateTime.now();
    final past = widget.concerts.where((c) => c.date.isBefore(now)).toList();

    // Conteo y suma de valoraciones por artista
    final count = <String, int>{};
    final ratingSum = <String, double>{};
    final ratingCnt = <String, int>{};
    final imageByArtist = <String, String>{};

    for (final c in past) {
      final a = c.artist.trim();
      if (a.isEmpty) continue;
      count[a] = (count[a] ?? 0) + 1;
      if (c.hasDetailedRating) {
        ratingSum[a] = (ratingSum[a] ?? 0) + c.detailedAvg;
        ratingCnt[a] = (ratingCnt[a] ?? 0) + 1;
      }
      if (imageByArtist[a] == null && c.imageUrl.isNotEmpty) {
        imageByArtist[a] = c.imageUrl;
      }
    }

    // Score = veces_visto * 2 + media_valoracion (si existe)
    final scores = count.entries.map((e) {
      final a = e.key;
      final avg = ratingCnt.containsKey(a)
          ? ratingSum[a]! / ratingCnt[a]!
          : 0.0;
      return _ArtistScore(
        name: a,
        count: e.value,
        avgRating: avg,
        score: e.value * 2.0 + avg,
        concertImage: imageByArtist[a] ?? '',
      );
    }).toList()
      ..sort((a, b) => b.score.compareTo(a.score));

    _ranked = scores.take(6).toList();
    _fetchSpotify();
  }

  Future<void> _fetchSpotify() async {
    if (!mounted) return;
    setState(() => _loading = true);

    await Future.wait(_ranked.map((s) async {
      if (_spotifyData.containsKey(s.name)) return;
      try {
        final artist = await _spotifyService.searchArtist(s.name);
        if (mounted) _spotifyData[s.name] = artist;
      } catch (_) {
        if (mounted) _spotifyData[s.name] = null;
      }
    }));

    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_ranked.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ─────────────────────────────────────────
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF1DB954).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text('🎤', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mis artistas',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Por conciertos y valoración',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // ── Carrusel horizontal ─────────────────────────────
        SizedBox(
          height: 160,
          child: _loading
              ? ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _ranked.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) => _SkeletonCard(),
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _ranked.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) {
                    final s = _ranked[i];
                    final spotify = _spotifyData[s.name];
                    return _ArtistCard(score: s, spotify: spotify, rank: i + 1);
                  },
                ),
        ),
      ],
    );
  }
}

// ── Tarjeta de artista ───────────────────────────────────────────────────────

class _ArtistCard extends StatelessWidget {
  final _ArtistScore score;
  final SpotifyArtist? spotify;
  final int rank;

  const _ArtistCard({
    required this.score,
    required this.spotify,
    required this.rank,
  });

  String get _imageUrl =>
      (spotify?.image?.isNotEmpty == true)
          ? spotify!.image!
          : score.concertImage;

  String _fmtFollowers(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(0)}K';
    return n.toString();
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = _imageUrl.isNotEmpty;

    return SizedBox(
      width: 120,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Fondo — foto del artista
            if (hasImage)
              CachedNetworkImage(
                imageUrl: _imageUrl,
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 300),
                errorWidget: (_, __, ___) => _gradient(),
              )
            else
              _gradient(),

            // Gradiente oscuro sobre la foto
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0xCC000000),
                  ],
                  stops: [0.35, 1.0],
                ),
              ),
            ),

            // Número de ranking
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: rank == 1
                      ? const Color(0xFFFFD700)
                      : rank == 2
                          ? const Color(0xFFC0C0C0)
                          : rank == 3
                              ? const Color(0xFFCD7F32)
                              : Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: TextStyle(
                      color: rank <= 3 ? Colors.black : Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),

            // Info inferior
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    score.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      shadows: [Shadow(blurRadius: 6, color: Colors.black)],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.music_note_rounded,
                          color: Colors.white70, size: 11),
                      const SizedBox(width: 2),
                      Text(
                        '${score.count}×',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                      if (score.avgRating > 0) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.star_rounded,
                            color: Color(0xFFFFD700), size: 11),
                        const SizedBox(width: 2),
                        Text(
                          score.avgRating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Color(0xFFFFD700),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (spotify != null && spotify!.followers > 0) ...[
                    const SizedBox(height: 2),
                    Text(
                      '${_fmtFollowers(spotify!.followers)} seguidores',
                      style: const TextStyle(
                        color: Color(0xFF1DB954),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gradient() => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Icon(Icons.person_rounded, size: 48, color: Colors.white24),
        ),
      );
}

// ── Skeleton ─────────────────────────────────────────────────────────────────

class _SkeletonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(color: Colors.white.withOpacity(0.07)),
      ),
    );
  }
}

// ── Modelo interno ───────────────────────────────────────────────────────────

class _ArtistScore {
  final String name;
  final int count;
  final double avgRating;
  final double score;
  final String concertImage;

  const _ArtistScore({
    required this.name,
    required this.count,
    required this.avgRating,
    required this.score,
    required this.concertImage,
  });
}
