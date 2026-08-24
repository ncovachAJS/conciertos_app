import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/services/spotify_auth_service.dart';
import '../../data/services/spotify_api_service.dart';
import '../../domain/entities/spotify_track.dart';
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

/// El servicio se recrea cada vez que cambia el usuario de la app para que
/// el prefijo de almacenamiento (_userPrefix) sea siempre el correcto.
/// Al recrearse con un userId real, migra automáticamente los tokens que
/// pudieran haberse guardado bajo el prefijo "anonymous".
final spotifyAuthServiceProvider = Provider<SpotifyAuthService>((ref) {
  final userId = ref.watch(authUserIdProvider);
  final svc = SpotifyAuthService(userId: userId);
  if (userId != null) {
    // Migración silenciosa: si había tokens anónimos (race condition al
    // cargar sesión mientras el OAuth estaba en marcha), se mueven al
    // prefijo correcto del usuario.
    svc.migrateAnonymousTokens();
  }
  return svc;
});

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
    // Abortar si el usuario de la app aún no se ha cargado.
    final userId = ref.read(authUserIdProvider);
    if (userId == null) {
      state = AsyncValue.error(
        Exception('Debes iniciar sesión en la app antes de conectar Spotify.'),
        StackTrace.current,
      );
      return;
    }

    // Capturar los servicios ANTES de cualquier await para que ambas
    // operaciones (authorize + getTopArtists) usen la misma instancia
    // del servicio con el mismo prefijo de usuario, evitando la race
    // condition que ocurre cuando Riverpod reconstruye los providers
    // durante el flujo OAuth.
    final authSvc = ref.read(spotifyAuthServiceProvider);
    final apiSvc  = SpotifyApiService(authSvc);

    state = const AsyncValue.loading();
    try {
      await authSvc.authorize();
      final artists = await apiSvc.getTopArtists();
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

// ─────────────────────────────────────────── Top canciones del usuario

/// Canciones más escuchadas del usuario autenticado en Spotify.
/// Se reconstruye cuando cambia el usuario de la app o el estado de sesión.
final spotifyUserTopTracksProvider = FutureProvider<List<SpotifyTrack>>((ref) async {
  ref.watch(authUserIdProvider);
  final loggedIn = await ref.watch(spotifyAuthServiceProvider).isLoggedIn;
  if (!loggedIn) return [];
  return ref.read(spotifyApiServiceProvider).getUserTopTracks();
});

final spotifyTopArtistsProvider =
    AsyncNotifierProvider<SpotifyTopArtistsNotifier, List<SpotifyArtist>>(
  SpotifyTopArtistsNotifier.new,
);
