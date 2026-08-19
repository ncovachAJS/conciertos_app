import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class SpotifyEmbedPage extends StatefulWidget {
  /// ID de la playlist de Spotify a embeber.
  final String playlistId;
  final String title;

  const SpotifyEmbedPage({
    super.key,
    required this.playlistId,
    this.title = 'Tus canciones favoritas',
  });

  @override
  State<SpotifyEmbedPage> createState() => _SpotifyEmbedPageState();
}

class _SpotifyEmbedPageState extends State<SpotifyEmbedPage> {
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
      // Permite reproducción inline de audio en iOS (necesario para Spotify)
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
    iframe {
      width: 100%;
      height: 100%;
      min-height: 100vh;
      border: none;
      display: block;
    }
  </style>
</head>
<body>
  <iframe
    src="https://open.spotify.com/embed/playlist/${widget.playlistId}?utm_source=generator&theme=0"
    allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture"
    loading="lazy"
  ></iframe>
</body>
</html>
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SpotifyDot(),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                widget.title,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFF1DB954)),
            ),
        ],
      ),
    );
  }
}

class _SpotifyDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 22,
        height: 22,
        decoration: const BoxDecoration(
          color: Color(0xFF1DB954),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.music_note_rounded,
            color: Colors.black, size: 13),
      );
}
