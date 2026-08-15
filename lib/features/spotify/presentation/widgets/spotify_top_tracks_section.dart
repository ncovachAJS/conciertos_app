import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../shared/widgets/shimmer_box.dart';
import '../../data/services/spotify_client_service.dart';
import '../../domain/entities/spotify_artist.dart';
import '../../domain/entities/spotify_track.dart';

/// Sección completa de Spotify: hero del artista + géneros + canciones populares.
class SpotifyTopTracksSection extends StatefulWidget {
  final SpotifyArtist artist;
  final VoidCallback? onChangeTap;

  const SpotifyTopTracksSection({
    super.key,
    required this.artist,
    this.onChangeTap,
  });

  @override
  State<SpotifyTopTracksSection> createState() => _SpotifyTopTracksSectionState();
}

class _SpotifyTopTracksSectionState extends State<SpotifyTopTracksSection> {
  final _service = SpotifyClientService();
  final _player = AudioPlayer();

  List<SpotifyTrack>? _tracks;
  bool _loading = true;
  String? _playingId;

  @override
  void initState() {
    super.initState();
    _loadTracks();
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _playingId = null);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _loadTracks() async {
    final tracks = await _service.getTopTracks(
      widget.artist.id,
      artistName: widget.artist.name,
    );
    if (mounted) setState(() { _tracks = tracks; _loading = false; });
  }

  Future<void> _togglePreview(SpotifyTrack track) async {
    if (track.previewUrl == null) return;
    if (_playingId == track.id) {
      await _player.stop();
      setState(() => _playingId = null);
    } else {
      await _player.stop();
      await _player.play(UrlSource(track.previewUrl!));
      setState(() => _playingId = track.id);
    }
  }

  Future<void> _openUrl(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  String _fmtFollowers(int n) {
    if (n >= 1000000) {
      final m = n / 1000000;
      return '${m.toStringAsFixed(m >= 10 ? 0 : 1)}M';
    }
    if (n >= 1000) return '${(n / 1000).round()}K';
    return n.toString();
  }

  @override
  Widget build(BuildContext context) {
    final artist = widget.artist;
    final cs = Theme.of(context).colorScheme;
    final hasImage = (artist.image ?? '').isNotEmpty;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Hero ─────────────────────────────────────────────────────────
          SizedBox(
            height: 110,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (hasImage)
                  CachedNetworkImage(
                    imageUrl: artist.image!,
                    fit: BoxFit.cover,
                    color: Colors.black.withValues(alpha: 0.5),
                    colorBlendMode: BlendMode.darken,
                    placeholder: (_, __) => Container(color: cs.surfaceContainerHighest),
                    errorWidget: (_, __, ___) => Container(color: cs.surfaceContainerHighest),
                  )
                else
                  Container(color: cs.surfaceContainerHighest),

                // gradiente inferior
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.72)],
                      ),
                    ),
                  ),
                ),

                // Nombre + seguidores + lápiz + botón Abrir (parte inferior)
                Positioned(
                  left: 0, right: 0, bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  _SpotifyDot(),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      artist.name,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              if (artist.followers > 0) ...[
                                const SizedBox(height: 3),
                                Text(
                                  '${_fmtFollowers(artist.followers)} seguidores',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Lápiz a la izquierda del botón Abrir
                        if (widget.onChangeTap != null) ...[
                          GestureDetector(
                            onTap: widget.onChangeTap,
                            child: Container(
                              width: 32, height: 32,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.35),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white24, width: 0.5),
                              ),
                              child: const Icon(Icons.edit_rounded, size: 14, color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        GestureDetector(
                          onTap: () => _openUrl(artist.url),
                          child: Container(
                            height: 32,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1DB954),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.open_in_new_rounded, size: 13, color: Colors.black),
                                SizedBox(width: 4),
                                Text(
                                  'Abrir',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Géneros ───────────────────────────────────────────────────────
          if (artist.genres.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: artist.genres.take(4).map((g) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: cs.outlineVariant.withValues(alpha: 0.4),
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    g,
                    style: TextStyle(
                      fontSize: 11,
                      color: cs.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                )).toList(),
              ),
            ),

          // ── Label canciones ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
            child: Text(
              'CANCIONES POPULARES',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: cs.onSurface.withValues(alpha: 0.35),
                letterSpacing: 0.8,
              ),
            ),
          ),

          // ── Lista ─────────────────────────────────────────────────────────
          if (_loading)
            _TracksSkeleton()
          else if (_tracks == null || _tracks!.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 4, 14, 16),
              child: Text(
                'No se encontraron canciones en Spotify.',
                style: TextStyle(fontSize: 13, color: cs.onSurface.withValues(alpha: 0.4)),
              ),
            )
          else
            Column(
              children: _tracks!.asMap().entries.map((e) {
                final track = e.value;
                final isPlaying = _playingId == track.id;
                return _TrackRow(
                  index: e.key + 1,
                  track: track,
                  isPlaying: isPlaying,
                  onTap: () => _openUrl(track.spotifyUrl),
                  onPreviewTap: track.previewUrl != null
                      ? () => _togglePreview(track)
                      : null,
                );
              }).toList(),
            ),

          // Espacio inferior
          if (!_loading && (_tracks?.isNotEmpty ?? false))
            const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Fila de canción ──────────────────────────────────────────────────────────

class _TrackRow extends StatelessWidget {
  final int index;
  final SpotifyTrack track;
  final bool isPlaying;
  final VoidCallback onTap;
  final VoidCallback? onPreviewTap;

  const _TrackRow({
    required this.index,
    required this.track,
    required this.isPlaying,
    required this.onTap,
    this.onPreviewTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
        child: Row(
          children: [
            // Número / equalizer
            SizedBox(
              width: 20,
              child: isPlaying
                  ? const Icon(Icons.equalizer_rounded,
                      size: 16, color: Color(0xFF1DB954))
                  : Text(
                      '$index',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurface.withValues(alpha: 0.35),
                      ),
                    ),
            ),
            const SizedBox(width: 10),

            // Artwork
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: track.albumImageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: track.albumImageUrl!,
                      width: 40, height: 40,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          const ShimmerBox(width: 40, height: 40, borderRadius: 6),
                      errorWidget: (_, __, ___) => _AlbumPlaceholder(),
                    )
                  : _AlbumPlaceholder(),
            ),
            const SizedBox(width: 10),

            // Nombre + álbum
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isPlaying
                          ? const Color(0xFF1DB954)
                          : cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (track.isExplicit) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: cs.onSurface.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(
                            'E',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: cs.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                      ],
                      Flexible(
                        child: Text(
                          track.albumName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: cs.onSurface.withValues(alpha: 0.45),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Barra popularidad
            SizedBox(
              width: 32,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: track.popularity / 100.0,
                  minHeight: 3,
                  backgroundColor: cs.onSurface.withValues(alpha: 0.1),
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF1DB954)),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Duración
            Text(
              track.durationFormatted,
              style: TextStyle(
                fontSize: 11,
                color: cs.onSurface.withValues(alpha: 0.4),
              ),
            ),

            // Botón play preview
            if (onPreviewTap != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onPreviewTap,
                child: Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: isPlaying
                        ? const Color(0xFF1DB954)
                        : cs.onSurface.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
                    size: 16,
                    color: isPlaying
                        ? Colors.black
                        : cs.onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Skeleton ─────────────────────────────────────────────────────────────────

class _TracksSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(5, (i) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
        child: Row(
          children: [
            ShimmerBox(width: 20, height: 12, borderRadius: 4),
            const SizedBox(width: 10),
            ShimmerBox(width: 40, height: 40, borderRadius: 6),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: double.infinity, height: 13, borderRadius: 5),
                  const SizedBox(height: 5),
                  ShimmerBox(width: 80.0 + i * 12, height: 11, borderRadius: 4),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const ShimmerBox(width: 32, height: 3, borderRadius: 2),
            const SizedBox(width: 8),
            const ShimmerBox(width: 28, height: 11, borderRadius: 4),
          ],
        ),
      )),
    );
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────

class _AlbumPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40, height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        Icons.music_note_rounded, size: 18,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.25),
      ),
    );
  }
}

class _SpotifyDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18, height: 18,
      decoration: const BoxDecoration(
        color: Color(0xFF1DB954),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.music_note_rounded, size: 11, color: Colors.black),
    );
  }
}
