import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/current_user_provider.dart';
import '../../data/services/records_api_service.dart';
import '../../domain/artist_match.dart';
import '../../domain/entities/album_record.dart';

class RecordsNotifier extends AsyncNotifier<List<AlbumRecord>> {
  final _api = RecordsApiService();

  @override
  Future<List<AlbumRecord>> build() {
    ref.watch(currentUserIdProvider);
    return _api.getAll();
  }

  /// Añade un disco. Lanza [RecordAlreadyExistsException] si ya estaba.
  Future<void> add(AlbumRecord record) async {
    final saved = await _api.add(record);
    state = AsyncData([saved, ...state.value ?? const []]);
  }

  /// Actualiza campos sueltos (notes, status, condition, rating, price).
  Future<void> patch(String id, Map<String, dynamic> fields) async {
    final saved = await _api.update(id, fields);
    state = AsyncData([
      for (final r in state.value ?? const <AlbumRecord>[])
        if (r.id == id) saved else r,
    ]);
  }

  /// Borrado optimista con rollback si el backend falla.
  Future<void> remove(String id) async {
    final previous = state.value ?? const <AlbumRecord>[];
    state = AsyncData(previous.where((r) => r.id != id).toList());
    try {
      await _api.delete(id);
    } catch (_) {
      state = AsyncData(previous);
      rethrow;
    }
  }
}

final recordsProvider =
    AsyncNotifierProvider<RecordsNotifier, List<AlbumRecord>>(
  RecordsNotifier.new,
);

final recordsSearchServiceProvider = Provider((_) => RecordsApiService());

/// Canciones, géneros y estilos de un disco (se piden a Discogs bajo demanda).
final recordDetailProvider = FutureProvider.family<RecordDetail, int>(
  (ref, discogsId) =>
      ref.read(recordsSearchServiceProvider).getDiscogsDetail(discogsId),
);

/// Discos que ya tiene el usuario (excluye la lista de deseos).
final ownedRecordsProvider = Provider<List<AlbumRecord>>((ref) {
  final all = ref.watch(recordsProvider).value ?? const <AlbumRecord>[];
  return all.where((r) => r.status == RecordStatus.owned).toList();
});

/// Lista de deseos.
final wishlistRecordsProvider = Provider<List<AlbumRecord>>((ref) {
  final all = ref.watch(recordsProvider).value ?? const <AlbumRecord>[];
  return all.where((r) => r.status == RecordStatus.wishlist).toList();
});

/// Discos propios de un artista (comparación sin mayúsculas ni espacios extra).
final artistRecordsProvider =
    Provider.family<List<AlbumRecord>, String>((ref, artist) {
  final key = normalizeArtist(artist);
  if (key.isEmpty) return const [];
  return ref
      .watch(ownedRecordsProvider)
      .where((r) => normalizeArtist(r.artist) == key)
      .toList();
});
