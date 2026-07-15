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

  /// Recarga completa desde la API (p. ej. tras volver de AddConcertPage).
  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchSorted);
  }

  /// Crea un concierto y recarga la lista.
  Future<void> add(Concert concert) async {
    await _api.addConcert(concert);
    await reload();
  }

  /// Actualiza un campo (favorite, liked, rating…) con optimistic update.
  /// Si la API falla hace rollback automático y relanza la excepción para
  /// que la página pueda mostrar un snackbar.
  Future<void> updateOne(Concert updated) async {
    final prev = state.asData?.value ?? [];

    // Optimistic: sustituimos el concierto en el estado local de inmediato.
    state = AsyncData(
      prev.map((c) => c.id == updated.id ? updated : c).toList(),
    );

    try {
      await _api.updateConcert(updated);
    } catch (e) {
      state = AsyncData(prev); // rollback
      rethrow;
    }
  }

  /// Borra un concierto con optimistic update.
  Future<void> delete(String id) async {
    final prev = state.asData?.value ?? [];

    state = AsyncData(prev.where((c) => c.id != id).toList());

    try {
      await _api.deleteConcert(id);
    } catch (e) {
      state = AsyncData(prev); // rollback
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
// Providers derivados — se calculan a partir del estado del provider principal
// sin tocar la red. Se actualizan automáticamente cuando cambia concertsProvider.
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

/// Últimos 10 conciertos añadidos (más reciente primero).
final recentConcertsProvider = Provider<List<Concert>>((ref) {
  // La lista ya viene ordenada desc por fecha del notifier.
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
