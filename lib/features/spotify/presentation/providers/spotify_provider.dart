import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/spotify_auth_service.dart';
import '../../data/services/spotify_api_service.dart';
import '../../domain/spotify_artist.dart';

// ─────────────────────────────────────────── Servicios singleton

final spotifyAuthServiceProvider = Provider<SpotifyAuthService>(
  (_) => SpotifyAuthService(),
);

final spotifyApiServiceProvider = Provider<SpotifyApiService>((ref) {
  return SpotifyApiService(ref.watch(spotifyAuthServiceProvider));
});

// ─────────────────────────────────────────── Estado de sesión

final spotifyLoggedInProvider = FutureProvider<bool>((ref) async {
  return ref.watch(spotifyAuthServiceProvider).isLoggedIn;
});

// ─────────────────────────────────────────── Top artistas

class SpotifyTopArtistsNotifier extends AsyncNotifier<List<SpotifyArtist>> {
  @override
  Future<List<SpotifyArtist>> build() async {
    final loggedIn = await ref.watch(spotifyAuthServiceProvider).isLoggedIn;
    if (!loggedIn) return [];
    return ref.read(spotifyApiServiceProvider).getTopArtists();
  }

  Future<void> login() async {
    state = const AsyncValue.loading();
    try {
      await ref.read(spotifyAuthServiceProvider).authorize();
      final artists = await ref.read(spotifyApiServiceProvider).getTopArtists();
      state = AsyncValue.data(artists);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
    // Invalida el provider de sesión para que se refresque
    ref.invalidate(spotifyLoggedInProvider);
  }

  Future<void> logout() async {
    await ref.read(spotifyAuthServiceProvider).logout();
    state = const AsyncValue.data([]);
    ref.invalidate(spotifyLoggedInProvider);
  }
}

final spotifyTopArtistsProvider =
    AsyncNotifierProvider<SpotifyTopArtistsNotifier, List<SpotifyArtist>>(
  SpotifyTopArtistsNotifier.new,
);
