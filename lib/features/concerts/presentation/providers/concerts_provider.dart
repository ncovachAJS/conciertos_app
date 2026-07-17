import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/concert_api_service.dart';
import '../../domain/entities/concert.dart';

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class ConcertsNotifier extends AsyncNotifier<List<Concert>> {
  final _api = ConcertApiService();

  @override
  Future<List<Concert>> build() => _fetchSorted();

  Future<List<Concert>> _fetchSorted() async {
    final list = await _api.getConcerts();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  /// Recarga completa desde la API.
  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchSorted);
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

    state = AsyncData(prev.where((c) => c.id != id).toList());

    try {
      await _api.deleteConcert(id);
    } catch (e) {
      state = AsyncData(prev);
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

  if (favArtists.isNotEmpty) return favArtists..sort();

  final likedArtists = concerts
      .where((c) => c.liked && c.artist.trim().isNotEmpty)
      .map((c) => c.artist.trim())
      .toSet()
      .toList();

  if (likedArtists.isNotEmpty) return likedArtists..sort();

  return concerts
      .map((c) => c.artist.trim())
      .where((a) => a.isNotEmpty)
      .toSet()
      .take(5)
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
  final concerts = ref.watch(concertsProvider).asData?.value ?? [];

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
