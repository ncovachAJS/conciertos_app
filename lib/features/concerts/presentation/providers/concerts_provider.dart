import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/models/concert_model.dart';
import '../../data/services/concert_api_service.dart';
import '../../data/services/concert_cache_service.dart';
import '../../domain/entities/concert.dart';

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

/// Provider separado para el estado de "cargando más páginas".
/// Lo actualiza el notifier para que los widgets se rebuild automáticamente.
class _LoadingMoreNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  // ignore: use_setters_to_change_properties
  void setValue(bool value) => state = value;
}

final _loadingMoreState = NotifierProvider<_LoadingMoreNotifier, bool>(
  _LoadingMoreNotifier.new,
);

class ConcertsNotifier extends AsyncNotifier<List<Concert>> {
  final _api = ConcertApiService();
  final _cache = ConcertCacheService();

  static const _pageSize = 5000;
  int _page = 1;
  bool _hasMore = true;

  bool get hasMore => _hasMore;
  bool get loadingMore => ref.read(_loadingMoreState);

  @override
  Future<List<Concert>> build() async {
    // 1. Cargamos el caché primero para respuesta instantánea.
    final cached = await _cache.load();
    if (cached.isNotEmpty) {
      // Mostramos el caché de inmediato sin bloquear al usuario.
      state = AsyncData(_sorted(cached));
      // Actualizamos desde la API en segundo plano.
      _refreshFromApi().ignore();
      return _sorted(cached);
    }
    // Sin caché: cargamos normalmente desde la API.
    return _fetchPage(page: 1, reset: true);
  }

  /// Actualiza silenciosamente desde la API y guarda en caché.
  Future<void> _refreshFromApi() async {
    try {
      final list = await _api.getConcerts(page: 1, limit: _pageSize);
      _page = 1;
      _hasMore = list.length >= _pageSize;
      final sorted = _sorted(list);
      state = AsyncData(sorted);
      await _cache.save(list);
    } catch (_) {
      // Error silencioso: ya mostramos el caché, no hace falta nada.
    }
  }

  List<Concert> _sorted(List<ConcertModel> list) =>
      (list..sort((a, b) => b.date.compareTo(a.date))).toList();

  Future<List<Concert>> _fetchPage({
    required int page,
    bool reset = false,
  }) async {
    final list = await _api.getConcerts(page: page, limit: _pageSize);
    if (reset) {
      _page = 1;
      // Guardamos en caché la primera página completa.
      _cache.save(list).ignore();
    }
    _hasMore = list.length >= _pageSize;
    final current = reset ? <Concert>[] : (state.asData?.value ?? <Concert>[]);
    final merged = [...current, ...list]
      ..sort((a, b) => b.date.compareTo(a.date));
    return merged;
  }

  /// Recarga completa desde la API (página 1).
  Future<void> reload() async {
    _page = 1;
    _hasMore = true;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchPage(page: 1, reset: true));
  }

  /// Carga la siguiente página (para infinite scroll).
  Future<void> loadMore() async {
    final loading = ref.read(_loadingMoreState);
    if (loading || !_hasMore) return;
    ref.read(_loadingMoreState.notifier).setValue(true);
    try {
      _page++;
      final next = await _api.getConcerts(page: _page, limit: _pageSize);
      _hasMore = next.length >= _pageSize;
      if (next.isNotEmpty) {
        final current = state.asData?.value ?? [];
        final merged = [...current, ...next]
          ..sort((a, b) => b.date.compareTo(a.date));
        state = AsyncData(merged);
      }
    } catch (_) {
      _page--; // revertir si falló
    } finally {
      ref.read(_loadingMoreState.notifier).setValue(false);
    }
  }

  /// Crea un concierto:
  /// 1. Lo añade optimistamente a la lista para que aparezca de inmediato.
  /// 2. Lanza reload en background para sincronizar con el backend.
  /// Esto evita que el usuario vea nada y lo intente añadir de nuevo.
  Future<Concert> add(Concert concert) async {
    final created = await _api.addConcert(concert);

    // Actualización optimista — sin esperar al reload
    final current = state.asData?.value ?? [];
    final alreadyExists = current.any((c) => c.id == created.id);
    if (!alreadyExists) {
      final updated = [created, ...current]
        ..sort((a, b) => b.date.compareTo(a.date));
      state = AsyncData(updated);
      // Actualizar caché con la nueva lista.
      final models = updated.whereType<ConcertModel>().toList();
      _cache.save(models).ignore();
    }

    // Reload en background para sincronizar estado completo
    reload().ignore();

    return created;
  }

  /// Actualiza un campo con optimistic update + rollback automático si falla.
  Future<void> updateOne(Concert updated) async {
    final prev = state.asData?.value ?? [];

    state = AsyncData(
      prev.map((c) => c.id == updated.id ? updated : c).toList(),
    );

    try {
      await _api.updateConcert(updated);
    } catch (e) {
      state = AsyncData(prev);
      rethrow;
    }
  }

  /// Borra un concierto con optimistic update + rollback si falla.
  Future<void> delete(String id) async {
    final prev = state.asData?.value ?? [];
    final newList = prev.where((c) => c.id != id).toList();

    state = AsyncData(newList);
    // Actualizar caché optimistamente
    final models = newList.whereType<ConcertModel>().toList();
    _cache.save(models).ignore();

    try {
      await _api.deleteConcert(id);
    } catch (e) {
      state = AsyncData(prev);
      // Revertir caché
      final prevModels = prev.whereType<ConcertModel>().toList();
      _cache.save(prevModels).ignore();
      rethrow;
    }
  }
}

// ---------------------------------------------------------------------------
// Provider principal
// ---------------------------------------------------------------------------

final concertsProvider = AsyncNotifierProvider<ConcertsNotifier, List<Concert>>(
  ConcertsNotifier.new,
);

/// True mientras se carga la siguiente página (para mostrar spinner al pie).
final concertsLoadingMoreProvider = Provider<bool>((ref) {
  return ref.watch(_loadingMoreState);
});

// ---------------------------------------------------------------------------
// Providers derivados
// ---------------------------------------------------------------------------

/// Próximos conciertos ordenados de más cercano a más lejano.
final upcomingConcertsProvider = Provider<List<Concert>>((ref) {
  final concerts = ref.watch(concertsProvider).asData?.value ?? [];
  final today = DateTime.now();
  final todayMidnight = DateTime(today.year, today.month, today.day);

  return concerts.where((c) => !c.date.isBefore(todayMidnight)).toList()
    ..sort((a, b) => a.date.compareTo(b.date));
});

/// El concierto más próximo (o null si no hay ninguno).
final nextConcertProvider = Provider<Concert?>((ref) {
  final upcoming = ref.watch(upcomingConcertsProvider);
  return upcoming.isEmpty ? null : upcoming.first;
});

/// Conciertos marcados como favorito.
final favoriteConcertsProvider = Provider<List<Concert>>((ref) {
  return (ref.watch(concertsProvider).asData?.value ?? [])
      .where((c) => c.favorite)
      .toList();
});

/// Artistas favoritos (únicos, ordenados alfabéticamente).
final favoriteArtistsProvider = Provider<List<String>>((ref) {
  return ref
      .watch(favoriteConcertsProvider)
      .map((c) => c.artist.trim())
      .where((a) => a.isNotEmpty)
      .toSet()
      .toList()
    ..sort();
});

/// Artistas para recomendaciones: favoritos primero, luego liked, luego recientes.
final recommendedArtistsProvider = Provider<List<String>>((ref) {
  final concerts = ref.watch(concertsProvider).asData?.value ?? [];

  final favArtists = concerts
      .where((c) => c.favorite && c.artist.trim().isNotEmpty)
      .map((c) => c.artist.trim())
      .toSet()
      .toList();

  if (favArtists.isNotEmpty) {
    return (favArtists..sort()).take(5).toList();
  }

  final likedArtists = concerts
      .where((c) => c.liked && c.artist.trim().isNotEmpty)
      .map((c) => c.artist.trim())
      .toSet()
      .toList();

  if (likedArtists.isNotEmpty) {
    return (likedArtists..sort()).take(5).toList();
  }

  // Sin favoritos ni likes: top 5 por número de conciertos
  final countMap = <String, int>{};
  for (final c in concerts) {
    final a = c.artist.trim();
    if (a.isNotEmpty) countMap[a] = (countMap[a] ?? 0) + 1;
  }
  return (countMap.entries.toList()..sort((a, b) => b.value.compareTo(a.value)))
      .take(5)
      .map((e) => e.key)
      .toList();
});

/// Últimos 10 conciertos añadidos (más reciente primero).
final recentConcertsProvider = Provider<List<Concert>>((ref) {
  return (ref.watch(concertsProvider).asData?.value ?? []).take(10).toList();
});

/// Estadísticas del dashboard.
typedef ConcertStats = ({
  int total,
  int festivals,
  int liked,
  double avgRating,
});

final concertStatsProvider = Provider<ConcertStats>((ref) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final currentUserId = AuthController.instance.user?.id ?? '';

  final all = (ref.watch(concertsProvider).asData?.value ?? [])
      .where((c) => !c.date.isAfter(today))
      .toList();

  final myDates = all
      .where((c) => c.userId == currentUserId || c.userId.isEmpty)
      .map((c) => DateTime(c.date.year, c.date.month, c.date.day))
      .toSet();

  final concerts = all
      .where(
        (c) =>
            c.userId == currentUserId ||
            c.userId.isEmpty ||
            !myDates.contains(DateTime(c.date.year, c.date.month, c.date.day)),
      )
      .toList();

  final total = concerts.length;
  final festivals = concerts
      .where((c) => c.festival.trim().isNotEmpty)
      .map((c) => c.festival.trim())
      .toSet()
      .length;
  final liked = concerts.where((c) => c.liked).length;
  final avgRating = total == 0
      ? 0.0
      : concerts.fold<int>(0, (sum, c) => sum + c.rating) / total;

  return (
    total: total,
    festivals: festivals,
    liked: liked,
    avgRating: avgRating,
  );
});
