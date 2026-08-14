import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../shared/widgets/shimmer_box.dart';
import '../../data/services/spotify_client_service.dart';
import '../../domain/entities/spotify_artist.dart';
import '../../domain/entities/spotify_track.dart';

/// Sección de "Canciones populares" que aparece en el detalle del concierto
/// cuando hay un artista de Spotify vinculado.
class SpotifyTopTracksSection extends StatefulWidget {
  final SpotifyArtist artist;

  const SpotifyTopTracksSection({super.key, required this.artist});

  @override
  State<SpotifyTopTracksSection> createState() => _SpotifyTopTracksSectionState();
}

class _SpotifyTopTracksSectionState extends State<SpotifyTopTracksSection> {
  final _service = SpotifyClientService();
  final _player = AudioPlayer();

  List<SpotifyTrack>? _tracks;
  bool _loading = true;
  String? _playingId;   // ID de la canción reproduciendo preview

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

  Future<void> _openSpotify(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loading && (_tracks == null || _tracks!.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────
            Row(
              children: [
                // Logo Spotify (SVG inline como icono pintado)
                _SpotifyIcon(size: 22),
                const SizedBox(width: 10),
                const Text(
                  'Canciones populares',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              widget.artist.name,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),

            // ── Lista ────────────────────────────────────────────────────
            if (_loading)
              _TracksSkeleton()
            else
              Column(
                children: _tracks!.asMap().entries.map((entry) {
                  final i = entry.key;
                  final track = entry.value;
                  final isPlaying = _playingId == track.id;
                  return _TrackRow(
                    index: i + 1,
                    track: track,
                    isPlaying: isPlaying,
                    onTap: () => _openSpotify(track.spotifyUrl),
                    onPreviewTap: track.previewUrl != null
                        ? () => _togglePreview(track)
                        : null,
                  );
                }).toList(),
              ),

            // ── Footer: abrir artista en Spotify ─────────────────────────
            if (!_loading && _tracks != null && _tracks!.isNotEmpty) ...[
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => _openSpotify(widget.artist.url),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Ver en Spotify',
                      style: TextStyle(
                        color: const Color(0xFF1DB954),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.open_in_new_rounded, size: 13, color: Color(0xFF1DB954)),
                  ],
                ),
              ),
            ],
          ],
        ),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            // Número o estado de reproducción
            SizedBox(
              width: 24,
              child: Text(
                '$index',
                style: TextStyle(
                  color: isPlaying
                      ? const Color(0xFF1DB954)
                      : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.35),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 10),

            // Artwork del álbum
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: track.albumImageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: track.albumImageUrl!,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      placeholder: (ctx, _) => const ShimmerBox(width: 44, height: 44, borderRadius: 6),
                      errorWidget: (ctx, _, __) => _AlbumPlaceholder(),
                    )
                  : _AlbumPlaceholder(),
            ),
            const SizedBox(width: 12),

            // Nombre y álbum
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isPlaying ? const Color(0xFF1DB954) : null,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    track.albumName,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Duración
            Text(
              track.durationFormatted,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),

            // Botón preview 30s
            if (onPreviewTap != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onPreviewTap,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: isPlaying
                        ? const Color(0xFF1DB954)
                        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
                    size: 18,
                    color: isPlaying ? Colors.black : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            ShimmerBox(width: 20, height: 14, borderRadius: 4),
            const SizedBox(width: 12),
            ShimmerBox(width: 44, height: 44, borderRadius: 6),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: double.infinity, height: 13, borderRadius: 6),
                  const SizedBox(height: 5),
                  ShimmerBox(width: 100.0 + i * 14, height: 11, borderRadius: 5),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const ShimmerBox(width: 30, height: 11, borderRadius: 5),
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
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Icon(Icons.music_note_rounded, size: 20, color: Colors.white24),
    );
  }
}

/// Logo de Spotify pintado como icono simple (verde característico).
class _SpotifyIcon extends StatelessWidget {
  final double size;
  const _SpotifyIcon({this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFF1DB954),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.music_note_rounded, size: size * 0.6, color: Colors.black),
    );
  }
}
