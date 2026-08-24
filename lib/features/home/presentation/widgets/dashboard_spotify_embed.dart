import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../features/spotify/presentation/providers/spotify_provider.dart';

/// Tarjeta verde del dashboard que abre el embed de la playlist personal
/// del usuario en Spotify. Si no tiene Spotify vinculado, invita a conectarlo.
class DashboardSpotifyEmbed extends ConsumerWidget {
  const DashboardSpotifyEmbed({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loggedIn = ref.watch(spotifyLoggedInProvider).asData?.value ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () => context.push('/spotify-playlist-embed'),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tus canciones favoritas',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      loggedIn
                          ? 'Escucha tu playlist directamente en la app'
                          : 'Conecta Spotify para verlas aquí',
                      style: const TextStyle(
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
