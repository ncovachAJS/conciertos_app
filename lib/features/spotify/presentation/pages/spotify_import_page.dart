import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/spotify_artist.dart';
import '../providers/spotify_provider.dart';

// ID de la playlist "Top canciones" embebida de Spotify
const _topSongsPlaylistId = '4kqsEp7um2ySvyzW7L0sNI';

/// Página de importación desde Spotify.
/// El usuario conecta su cuenta y ve sus artistas más escuchados;
/// al pulsar uno se abre AddConcertPage con el nombre pre-rellenado.
class SpotifyImportPage extends ConsumerWidget {
  const SpotifyImportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artistsAsync = ref.watch(spotifyTopArtistsProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SpotifyLogo(size: 22),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                'Importar desde Spotify',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          artistsAsync.maybeWhen(
            data: (artists) => artists.isNotEmpty
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
      body: Column(
        children: [
          // Banner "Tus canciones más escuchadas"
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: InkWell(
              onTap: () => context.push('/spotify-embed', extra: {
                'playlistId': _topSongsPlaylistId,
                'title': 'Tus canciones favoritas',
              }),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1DB954).withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF1DB954).withValues(alpha: .3)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1DB954),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.headphones_rounded, color: Colors.black, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tus canciones más escuchadas',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            'Escucha tu playlist directamente en la app',
                            style: TextStyle(fontSize: 12, color: Colors.white54),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: Colors.white38),
                  ],
                ),
              ),
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          Expanded(
            child: artistsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => _ErrorState(
                message: e.toString(),
                onRetry: () => ref.invalidate(spotifyTopArtistsProvider),
              ),
              data: (artists) {
                if (artists.isEmpty) {
                  return _ConnectPrompt(
                    onConnect: () =>
                        ref.read(spotifyTopArtistsProvider.notifier).login(),
                  );
                }
                return _ArtistGrid(artists: artists, cs: cs);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────── Pantalla de conexión

class _ConnectPrompt extends StatefulWidget {
  final VoidCallback onConnect;
  const _ConnectPrompt({required this.onConnect});

  @override
  State<_ConnectPrompt> createState() => _ConnectPromptState();
}

class _ConnectPromptState extends State<_ConnectPrompt> {
  bool _loading = false;

  Future<void> _tap() async {
    setState(() => _loading = true);
    widget.onConnect();
    // El provider maneja el estado; soltamos el spinner local en el próximo frame
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SpotifyLogo(size: 72),
            const SizedBox(height: 28),
            Text(
              'Conecta tu cuenta de Spotify',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Verás tus artistas más escuchados y podrás añadir conciertos con un toque.',
              style: TextStyle(
                fontSize: 15,
                color: cs.onSurface.withValues(alpha: .6),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 36),
            FilledButton.icon(
              onPressed: _loading ? null : _tap,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1DB954), // Spotify green
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black54,
                      ),
                    )
                  : _SpotifyLogo(size: 20),
              label: Text(
                _loading ? 'Conectando…' : 'Conectar con Spotify',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────── Grid de artistas

class _ArtistGrid extends StatelessWidget {
  final List<SpotifyArtist> artists;
  final ColorScheme cs;

  const _ArtistGrid({required this.artists, required this.cs});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tus artistas favoritos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Toca un artista para añadir un concierto',
                  style: TextStyle(
                    fontSize: 14,
                    color: cs.onSurface.withValues(alpha: .55),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.78,
            ),
            itemCount: artists.length,
            itemBuilder: (context, i) =>
                _ArtistCard(artist: artists[i], cs: cs),
          ),
        ),
      ],
    );
  }
}

class _ArtistCard extends StatelessWidget {
  final SpotifyArtist artist;
  final ColorScheme cs;

  const _ArtistCard({required this.artist, required this.cs});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/add', extra: artist.name),
      child: Column(
        children: [
          // Foto del artista
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: artist.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: artist.imageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (_, __) => Container(
                        color: cs.surfaceContainerHighest,
                        child: const Icon(Icons.person_rounded, size: 40),
                      ),
                      errorWidget: (_, __, ___) =>
                          _ArtistPlaceholder(name: artist.name, cs: cs),
                    )
                  : _ArtistPlaceholder(name: artist.name, cs: cs),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            artist.name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ArtistPlaceholder extends StatelessWidget {
  final String name;
  final ColorScheme cs;

  const _ArtistPlaceholder({required this.name, required this.cs});

  @override
  Widget build(BuildContext context) {
    // Color basado en el primer carácter del nombre
    final hue = (name.codeUnitAt(0) * 137.5) % 360;
    final bg = HSLColor.fromAHSL(1, hue, 0.4, 0.25).toColor();

    return Container(
      color: bg,
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────── Error state

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

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
                size: 56, color: cs.error.withValues(alpha: .7)),
            const SizedBox(height: 16),
            Text(
              'No se pudo conectar con Spotify',
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
                  fontSize: 13, color: cs.onSurface.withValues(alpha: .55)),
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

// ──────────────────────────────────────────────────────── Logo de Spotify (SVG inline)

class _SpotifyLogo extends StatelessWidget {
  final double size;
  const _SpotifyLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    // Logo de Spotify en verde, usando solo Flutter widgets para evitar imports externos
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFF1DB954),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.music_note_rounded,
        size: size * 0.58,
        color: Colors.black,
      ),
    );
  }
}
