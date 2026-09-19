import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../../../core/tutorial/tutorial_content.dart';
import '../../../../core/tutorial/tutorial_overlay.dart';
import '../../../../core/tutorial/tutorial_service.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../providers/spotify_provider.dart';

/// Página que muestra el embed de Spotify con la playlist personal del usuario.
/// Obtiene el ID de playlist a través de la API de Spotify usando el token OAuth
/// del usuario → cada usuario ve su propia playlist.
class SpotifyPlaylistEmbedPage extends ConsumerStatefulWidget {
  const SpotifyPlaylistEmbedPage({super.key});

  @override
  ConsumerState<SpotifyPlaylistEmbedPage> createState() =>
      _SpotifyPlaylistEmbedPageState();
}

class _SpotifyPlaylistEmbedPageState
    extends ConsumerState<SpotifyPlaylistEmbedPage> {
  bool _connecting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showTutorialIfNeeded());
  }

  Future<void> _showTutorialIfNeeded() async {
    final should = await TutorialService.shouldShow(TutorialService.spotifyPlaylist);
    if (!should || !mounted) return;
    await TutorialService.markShown(TutorialService.spotifyPlaylist);
    if (!mounted) return;
    await TutorialOverlay.show(
      context,
      steps: TutorialContent.spotifyPlaylist(AppLocalizations.of(context)),
    );
  }

  Future<void> _connectSpotify() async {
    setState(() => _connecting = true);
    try {
      await ref.read(spotifyTopArtistsProvider.notifier).login();

      // login() atrapa sus propios errores en el estado del provider en vez
      // de relanzarlos — hay que revisarlo explícitamente para poder avisar
      // al usuario si la vinculación falló (si no, el botón vuelve a
      // "Conectar" sin explicación, como si no hubiera pasado nada).
      final result = ref.read(spotifyTopArtistsProvider);
      if (result.hasError && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_friendlySpotifyError(result.error)),
            duration: const Duration(seconds: 6),
          ),
        );
      }

      // Forzar recarga de la playlist tras el login
      ref.invalidate(spotifyLoggedInProvider);
      ref.invalidate(spotifyUserPlaylistProvider);
    } finally {
      if (mounted) setState(() => _connecting = false);
    }
  }

  /// Traduce errores comunes de la vinculación con Spotify a un mensaje
  /// entendible. El más frecuente en usuarios que no son tú: la app de
  /// Spotify está en "Development Mode" y solo permite hasta 25 usuarios
  /// añadidos a mano en el Dashboard de developer.spotify.com.
  String _friendlySpotifyError(Object? error) {
    final msg = error.toString();
    if (msg.contains('not authorized') ||
        msg.toLowerCase().contains('403') ||
        msg.toLowerCase().contains('forbidden')) {
      return 'Spotify rechazó el acceso a esta cuenta. Puede que la app '
          'esté en modo de desarrollo y esta cuenta no esté en la lista '
          'de usuarios permitidos.';
    }
    return 'No se pudo vincular Spotify: $msg';
  }

  @override
  Widget build(BuildContext context) {
    final loggedInAsync = ref.watch(spotifyLoggedInProvider);
    final playlistAsync = ref.watch(spotifyUserPlaylistProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SpotifyDot(),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                'Tus canciones favoritas',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: loggedInAsync.when(
        // Mientras comprueba si hay sesión → spinner (evita flash de "conectar")
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF1DB954)),
        ),
        error: (_, __) => _ConnectView(
          connecting: _connecting,
          onConnect: _connectSpotify,
        ),
        data: (loggedIn) {
          if (!loggedIn) {
            return _ConnectView(
              connecting: _connecting,
              onConnect: _connectSpotify,
            );
          }
          return playlistAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: Color(0xFF1DB954)),
            ),
            error: (e, _) => _ErrorView(
              onRetry: () => ref.invalidate(spotifyUserPlaylistProvider),
            ),
            data: (playlist) {
              if (playlist == null || playlist.id.isEmpty) {
                return _RelinkView(onRelink: _connectSpotify);
              }
              return _EmbedView(
                  playlistId: playlist.id, title: playlist.name);
            },
          );
        },
      ),
    );
  }
}

// ── Embed de Spotify ──────────────────────────────────────────────────────────

class _EmbedView extends StatefulWidget {
  final String playlistId;
  final String title;
  const _EmbedView({required this.playlistId, required this.title});

  @override
  State<_EmbedView> createState() => _EmbedViewState();
}

class _EmbedViewState extends State<_EmbedView> {
  late final WebViewController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _controller = _buildController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
        ),
      )
      ..loadHtmlString(_buildHtml());
  }

  WebViewController _buildController() {
    if (Platform.isIOS) {
      final params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
      return WebViewController.fromPlatformCreationParams(params)
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.black);
    }
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black);
  }

  String _buildHtml() => '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    html, body { width: 100%; height: 100%; background: #000; }
    iframe { width: 100%; height: 100%; min-height: 100vh; border: none; display: block; }
  </style>
</head>
<body>
  <iframe
    title="${widget.title}"
    src="https://open.spotify.com/embed/playlist/${widget.playlistId}?utm_source=generator&theme=0"
    width="100%"
    height="100%"
    frameBorder="0"
    allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture"
    loading="lazy"
  ></iframe>
</body>
</html>
''';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_loading)
          const Center(
            child: CircularProgressIndicator(color: Color(0xFF1DB954)),
          ),
      ],
    );
  }
}

// ── "Conecta Spotify" ─────────────────────────────────────────────────────────

class _ConnectView extends StatelessWidget {
  final VoidCallback onConnect;
  final bool connecting;
  const _ConnectView({required this.onConnect, this.connecting = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _SpotifyDot(size: 72),
            const SizedBox(height: 28),
            Text(
              'Conecta tu cuenta de Spotify',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Vincula Spotify para ver aquí tu playlist de canciones favoritas.',
              style: TextStyle(
                  fontSize: 15,
                  color: cs.onSurface.withValues(alpha: .6),
                  height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 36),
            if (connecting)
              const CircularProgressIndicator(color: Color(0xFF1DB954))
            else
              FilledButton.icon(
                onPressed: onConnect,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1DB954),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                ),
                icon: const _SpotifyDot(size: 20),
                label: const Text('Conectar con Spotify',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Sin playlist: pedir re-vincular ──────────────────────────────────────────

/// Se muestra cuando el token de Spotify no tiene el permiso playlist-read-private
/// o el usuario no tiene playlists. Invita a re-vincular para conceder el scope.
class _RelinkView extends StatelessWidget {
  final VoidCallback onRelink;
  const _RelinkView({required this.onRelink});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _SpotifyDot(size: 64),
            const SizedBox(height: 24),
            Text(
              'Actualiza tu conexión con Spotify',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Para ver tu playlist necesitamos un permiso adicional. '
              'Desconecta y vuelve a conectar tu cuenta de Spotify.',
              style: TextStyle(
                fontSize: 14,
                color: cs.onSurface.withValues(alpha: .6),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: onRelink,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1DB954),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
              icon: const Icon(Icons.sync_rounded),
              label: const Text(
                'Re-vincular Spotify',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error ─────────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded,
              size: 52, color: cs.error.withValues(alpha: .7)),
          const SizedBox(height: 16),
          const Text('No se pudo cargar tu playlist',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _SpotifyDot extends StatelessWidget {
  final double size;
  const _SpotifyDot({this.size = 22});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
          color: Color(0xFF1DB954), shape: BoxShape.circle),
      child: Icon(Icons.music_note_rounded,
          size: size * 0.55, color: Colors.black),
    );
  }
}
