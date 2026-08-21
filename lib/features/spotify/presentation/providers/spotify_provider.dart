import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/services/spotify_auth_service.dart';
import '../../data/services/spotify_api_service.dart';
import '../../domain/spotify_artist.dart';

// ─────────────────────────────────────────── Auth (para invalidar al cambiar usuario)

/// Notifier que observa AuthController (ChangeNotifier) y expone el userId
/// actual como estado Riverpod. Cuando el usuario de la app cambia
/// (login / logout), todos los providers que lo observen se reconstruyen.
class _AuthUserIdNotifier extends Notifier<String?> {
  @override
  String? build() {
    final controller = AuthController.instance;

    void _onAuthChanged() => state = controller.user?.id;

    controller.addListener(_onAuthChanged);
    ref.onDispose(() => controller.removeListener(_onAuthChanged));

    return controller.user?.id;
  }
}

final authUserIdProvider = NotifierProvider<_AuthUserIdNotifier, String?>(
  _AuthUserIdNotifier.new,
);

// ─────────────────────────────────────────── Servicios singleton

final spotifyAuthServiceProvider = Provider<SpotifyAuthService>(
  (_) => SpotifyAuthService(),
);

final spotifyApiServiceProvider = Provider<SpotifyApiService>((ref) {
  return SpotifyApiService(ref.watch(spotifyAuthServiceProvider));
});

// ─────────────────────────────────────────── Estado de sesión

final spotifyLoggedInProvider = FutureProvider<bool>((ref) async {
  // Se invalida cuando cambia el usuario de la app.
  ref.watch(authUserIdProvider);
  return ref.watch(spotifyAuthServiceProvider).isLoggedIn;
});

// ─────────────────────────────────────────── Top artistas

class SpotifyTopArtistsNotifier extends AsyncNotifier<List<SpotifyArtist>> {
  @override
  Future<List<SpotifyArtist>> build() async {
    // Observar el userId hace que este notifier se reconstruya cuando el
    // usuario de la app cambia (login/logout), evitando que un usuario
    // vea los artistas de Spotify del usuario anterior.
    // Reconstruye cuando cambia el usuario de la app.
    ref.watch(authUserIdProvider);

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
