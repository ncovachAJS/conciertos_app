import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

/// ID de la playlist embebida (las más escuchadas).
const _kPlaylistId = '4kqsEp7um2ySvyzW7L0sNI';

/// Widget del dashboard que muestra el embed de Spotify inline.
class DashboardSpotifyEmbed extends StatefulWidget {
  const DashboardSpotifyEmbed({super.key});

  @override
  State<DashboardSpotifyEmbed> createState() => _DashboardSpotifyEmbedState();
}

class _DashboardSpotifyEmbedState extends State<DashboardSpotifyEmbed>
    with AutomaticKeepAliveClientMixin {
  late final WebViewController _controller;
  bool _loading = true;

  @override
  bool get wantKeepAlive => true; // evita recrear el WebView al hacer scroll

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
    iframe { width: 100%; height: 100%; border: none; display: block; }
  </style>
</head>
<body>
  <iframe
    src="https://open.spotify.com/embed/playlist/$_kPlaylistId?utm_source=generator&theme=0"
    allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture"
    loading="lazy"
  ></iframe>
</body>
</html>
''';

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 352,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFF1DB954).withValues(alpha: .25),
          ),
        ),
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_loading)
              const Center(
                child: CircularProgressIndicator(color: Color(0xFF1DB954)),
              ),
            // Botón "ver en pantalla completa" (esquina superior derecha)
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => context.push('/spotify-embed', extra: {
                    'playlistId': _kPlaylistId,
                    'title': 'Tus canciones favoritas',
                  }),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.open_in_full_rounded,
                      size: 16,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
