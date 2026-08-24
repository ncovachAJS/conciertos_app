import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../features/spotify/domain/entities/spotify_track.dart';
import '../../../../features/spotify/presentation/providers/spotify_provider.dart';

/// Tarjeta del dashboard que muestra las canciones más escuchadas
/// del usuario en Spotify (datos reales de su cuenta, vía OAuth).
///
/// • Si no tiene Spotify vinculado → botón para ir a conectarlo.
/// • Si tiene Spotify → mini-lista de sus top canciones.
class DashboardSpotifyEmbed extends ConsumerWidget {
  const DashboardSpotifyEmbed({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracksAsync = ref.watch(spotifyUserTopTracksProvider);
    final loggedInAsync = ref.watch(spotifyLoggedInProvider);

    return tracksAsync.when(
      loading: () => _Shell(child: _LoadingSkeleton()),
      error: (_, __) => _Shell(child: _ConnectCard()),
      data: (tracks) {
        // Si no está conectado a Spotify o no hay canciones todavía
        final isConnected = loggedInAsync.asData?.value ?? false;
        if (!isConnected || tracks.isEmpty) return _Shell(child: _ConnectCard());
        return _Shell(child: _TrackList(tracks: tracks.take(5).toList()));
      },
    );
  }
}

// ── Contenedor con borde verde ────────────────────────────────────────────────

class _Shell extends StatelessWidget {
  final Widget child;
  const _Shell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1DB954).withValues(alpha: .08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF1DB954).withValues(alpha: .3),
          ),
        ),
        child: child,
      ),
    );
  }
}

// ── Tarjeta "Conecta Spotify" ─────────────────────────────────────────────────

class _ConnectCard extends StatelessWidget {
  const _ConnectCard();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/spotify-import'),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFF1DB954),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.headphones_rounded,
                  color: Colors.black, size: 26),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tus canciones más escuchadas',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Conecta Spotify para verlas aquí',
                    style:
                        TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white38),
          ],
        ),
      ),
    );
  }
}

// ── Lista compacta de canciones ───────────────────────────────────────────────

class _TrackList extends StatelessWidget {
  final List<SpotifyTrack> tracks;
  const _TrackList({required this.tracks});

  Future<void> _open(SpotifyTrack t) async {
    if (t.spotifyUrl.isEmpty) return;
    final uri = Uri.parse(t.spotifyUrl);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cabecera
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Color(0xFF1DB954),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.headphones_rounded,
                    color: Colors.black, size: 16),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Tus canciones más escuchadas',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              Text(
                'Spotify',
                style: TextStyle(
                  fontSize: 11,
                  color: cs.onSurface.withValues(alpha: .35),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, indent: 16, endIndent: 16),
        // Canciones
        ...tracks.asMap().entries.map((e) =>
            _TrackRow(index: e.key + 1, track: e.value, onTap: _open)),
        const SizedBox(height: 6),
      ],
    );
  }
}

class _TrackRow extends StatelessWidget {
  final int index;
  final SpotifyTrack track;
  final void Function(SpotifyTrack) onTap;

  const _TrackRow(
      {required this.index, required this.track, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => onTap(track),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Número
            SizedBox(
              width: 18,
              child: Text(
                '$index',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: cs.onSurface.withValues(alpha: .35),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Carátula
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: track.albumImageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: track.albumImageUrl!,
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          _Placeholder(size: 36),
                      errorWidget: (_, __, ___) =>
                          _Placeholder(size: 36),
                    )
                  : _Placeholder(size: 36),
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
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    track.albumName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
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
          ],
        ),
      ),
    );
  }
}

// ── Skeleton de carga ─────────────────────────────────────────────────────────

class _LoadingSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          3,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 12,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 10,
                        width: 100,
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Placeholder de carátula ───────────────────────────────────────────────────

class _Placeholder extends StatelessWidget {
  final double size;
  const _Placeholder({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.music_note_rounded,
        size: size * 0.45,
        color: Theme.of(context)
            .colorScheme
            .onSurface
            .withValues(alpha: .25),
      ),
    );
  }
}
