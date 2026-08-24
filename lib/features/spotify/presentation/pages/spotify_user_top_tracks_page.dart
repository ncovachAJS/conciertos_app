import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/spotify_track.dart';
import '../providers/spotify_provider.dart';

/// Página con las canciones más escuchadas del usuario en Spotify.
/// • Si no tiene Spotify vinculado → botón para conectarlo.
/// • Si está conectado → lista completa de sus top canciones.
class SpotifyUserTopTracksPage extends ConsumerWidget {
  const SpotifyUserTopTracksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracksAsync = ref.watch(spotifyUserTopTracksProvider);
    final loggedInAsync = ref.watch(spotifyLoggedInProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SpotifyDot(size: 22),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                'Mis canciones favoritas',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          // Botón de desconectar si está vinculado
          loggedInAsync.maybeWhen(
            data: (connected) => connected
                ? IconButton(
                    icon: const Icon(Icons.logout_rounded),
                    tooltip: 'Desconectar Spotify',
                    onPressed: () =>
                        ref.read(spotifyTopArtistsProvider.notifier).logout(),
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: tracksAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF1DB954)),
        ),
        error: (e, _) => _ErrorView(
          message: e.toString(),
          onRetry: () => ref.invalidate(spotifyUserTopTracksProvider),
        ),
        data: (tracks) {
          final isConnected = loggedInAsync.asData?.value ?? false;
          if (!isConnected || tracks.isEmpty) {
            return _ConnectView(
              onConnect: () => context.push('/spotify-import'),
            );
          }
          return _TrackListView(tracks: tracks);
        },
      ),
    );
  }
}

// ── Vista "Conecta Spotify" ───────────────────────────────────────────────────

class _ConnectView extends StatelessWidget {
  final VoidCallback onConnect;
  const _ConnectView({required this.onConnect});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SpotifyDot(size: 72),
            const SizedBox(height: 28),
            Text(
              'Tus canciones más escuchadas',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Conecta tu cuenta de Spotify para ver aquí tus canciones favoritas.',
              style: TextStyle(
                fontSize: 15,
                color: cs.onSurface.withValues(alpha: .6),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 36),
            FilledButton.icon(
              onPressed: onConnect,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1DB954),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              icon: _SpotifyDot(size: 20),
              label: const Text(
                'Conectar con Spotify',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Lista de canciones ────────────────────────────────────────────────────────

class _TrackListView extends StatefulWidget {
  final List<SpotifyTrack> tracks;
  const _TrackListView({required this.tracks});

  @override
  State<_TrackListView> createState() => _TrackListViewState();
}

class _TrackListViewState extends State<_TrackListView> {
  final _player = AudioPlayer();
  String? _playingId;

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _playingId = null);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
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

  /// Abre el embed de Spotify para escuchar la canción dentro de la app.
  void _openEmbed(BuildContext context, SpotifyTrack track) {
    context.push('/spotify-embed', extra: {
      'trackId': track.id,
      'type': 'track',
      'title': track.name,
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Tus ${widget.tracks.length} canciones más escuchadas',
                    style: TextStyle(
                      fontSize: 14,
                      color: cs.onSurface.withValues(alpha: .5),
                    ),
                  ),
                ),
                Text(
                  'Datos de Spotify',
                  style: TextStyle(
                    fontSize: 11,
                    color: cs.onSurface.withValues(alpha: .3),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverList.separated(
          itemCount: widget.tracks.length,
          separatorBuilder: (_, __) => Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: cs.outlineVariant.withValues(alpha: .4),
          ),
          itemBuilder: (context, i) {
            final track = widget.tracks[i];
            final isPlaying = _playingId == track.id;
            return _TrackRow(
              index: i + 1,
              track: track,
              isPlaying: isPlaying,
              // Tocar la fila abre el embed de Spotify para esa canción
              onTap: () => _openEmbed(context, track),
              // El botón ▶ reproduce el preview de 30s si está disponible
              onPreviewTap:
                  track.previewUrl != null ? () => _togglePreview(track) : null,
            );
          },
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }
}

// ── Fila de canción ───────────────────────────────────────────────────────────

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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          children: [
            // Número / equalizer
            SizedBox(
              width: 22,
              child: isPlaying
                  ? const Icon(Icons.equalizer_rounded,
                      size: 16, color: Color(0xFF1DB954))
                  : Text(
                      '$index',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurface.withValues(alpha: .35),
                      ),
                    ),
            ),
            const SizedBox(width: 10),
            // Carátula
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: track.albumImageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: track.albumImageUrl!,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => _AlbumPlaceholder(),
                      errorWidget: (_, __, ___) => _AlbumPlaceholder(),
                    )
                  : _AlbumPlaceholder(),
            ),
            const SizedBox(width: 12),
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
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isPlaying
                          ? const Color(0xFF1DB954)
                          : cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    track.albumName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: cs.onSurface.withValues(alpha: .45),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Duración
            Text(
              track.durationFormatted,
              style: TextStyle(
                fontSize: 11,
                color: cs.onSurface.withValues(alpha: .4),
              ),
            ),
            // Botón preview
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
                        : cs.onSurface.withValues(alpha: .08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPlaying
                        ? Icons.stop_rounded
                        : Icons.play_arrow_rounded,
                    size: 17,
                    color: isPlaying
                        ? Colors.black
                        : cs.onSurface.withValues(alpha: .55),
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

// ── Vista de error ────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded,
                size: 52, color: cs.error.withValues(alpha: .7)),
            const SizedBox(height: 16),
            Text(
              'No se pudo cargar',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                  fontSize: 13,
                  color: cs.onSurface.withValues(alpha: .55)),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _AlbumPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.music_note_rounded,
        size: 20,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .25),
      ),
    );
  }
}

class _SpotifyDot extends StatelessWidget {
  final double size;
  const _SpotifyDot({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFF1DB954),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.music_note_rounded,
          size: size * 0.55, color: Colors.black),
    );
  }
}
