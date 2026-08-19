import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const _kPlaylistId = '4kqsEp7um2ySvyzW7L0sNI';

/// Tarjeta verde del dashboard que abre el embed de Spotify al pulsarla.
class DashboardSpotifyEmbed extends StatelessWidget {
  const DashboardSpotifyEmbed({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () => context.push('/spotify-embed', extra: {
          'playlistId': _kPlaylistId,
          'title': 'Tus canciones favoritas',
        }),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          decoration: BoxDecoration(
            color: const Color(0xFF1DB954).withValues(alpha: .12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF1DB954).withValues(alpha: .35),
            ),
          ),
          child: Row(
            children: [
              // Icono circular verde
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFF1DB954),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.headphones_rounded,
                  color: Colors.black,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              // Textos
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tus canciones más escuchadas',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Escucha tu playlist directamente en la app',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white38,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
