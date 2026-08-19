import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../shared/widgets/skeletons/generic_page_skeleton.dart';
import '../../../spotify/presentation/providers/spotify_provider.dart';
import '../../data/models/recommended_event_model.dart';
import '../../data/services/recommendations_api_service.dart';
import '../../data/services/want_to_attend_api_service.dart';
import '../../domain/entities/recommended_event.dart';
import '../widgets/recommendation_card.dart';

class NearbyConsertsTab extends ConsumerStatefulWidget {
  const NearbyConsertsTab({super.key});

  @override
  ConsumerState<NearbyConsertsTab> createState() => _NearbyConsertsTabState();
}

class _NearbyConsertsTabState extends ConsumerState<NearbyConsertsTab>
    with AutomaticKeepAliveClientMixin {
  final _api = RecommendationsApiService();
  final _wantToAttendApi = WantToAttendApiService();

  List<RecommendedEventModel> _events = [];
  final Set<String> _wantToAttendIds = {};
  bool _loading = false;
  bool _loaded = false;
  String? _error;
  double _radiusKm = 50;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final artists = ref.read(spotifyTopArtistsProvider).asData?.value ?? [];
    if (artists.isEmpty) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final position = await _getLocation();
      if (position == null) {
        setState(() {
          _loading = false;
          _error = 'No se pudo obtener tu ubicación. Comprueba los permisos.';
        });
        return;
      }

      final artistNames = artists.map((a) => a.name).take(10).toList();

      final results = <RecommendedEventModel>[];
      for (int i = 0; i < artistNames.length; i++) {
        if (i > 0) await Future.delayed(const Duration(milliseconds: 200));
        final r = await _api.getNearbyRecommendations(
          artist: artistNames[i],
          lat: position.latitude,
          lng: position.longitude,
          radiusKm: _radiusKm.round(),
        );
        results.addAll(r);
      }

      // Deduplicar por id y ordenar por fecha
      final seen = <String>{};
      final unique = results.where((e) => seen.add(e.id)).toList()
        ..sort((a, b) => a.date.compareTo(b.date));

      // Cargar quiero-ir
      final saved = await _wantToAttendApi.getAll();
      final savedIds = saved.map((e) => e.id).toSet();

      if (mounted) {
        setState(() {
          _events = unique;
          _wantToAttendIds
            ..clear()
            ..addAll(savedIds);
          _loaded = true;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'Error al cargar eventos: $e';
        });
      }
    }
  }

  Future<Position?> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low, // suficiente para buscar conciertos
        timeLimit: Duration(seconds: 10),
      ),
    );
  }

  Future<void> _toggleWantToAttend(RecommendedEvent event) async {
    try {
      final added = await _wantToAttendApi.toggle(event);
      if (!mounted) return;
      setState(() {
        if (added) {
          _wantToAttendIds.add(event.id);
        } else {
          _wantToAttendIds.remove(event.id);
        }
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final cs = Theme.of(context).colorScheme;
    final artistsAsync = ref.watch(spotifyTopArtistsProvider);

    // Sin Spotify conectado
    final artists = artistsAsync.asData?.value ?? [];
    if (!artistsAsync.isLoading && artists.isEmpty) {
      return _SpotifyPrompt(
        onConnect: () => ref.read(spotifyTopArtistsProvider.notifier).login(),
      );
    }

    return Column(
      children: [
        // Control de radio
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: [
              const Icon(Icons.radar_rounded, size: 18),
              const SizedBox(width: 8),
              Text(
                'Radio: ${_radiusKm.round()} km',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              Expanded(
                child: Slider(
                  value: _radiusKm,
                  min: 10,
                  max: 200,
                  divisions: 19,
                  onChanged: (v) => setState(() => _radiusKm = v),
                  onChangeEnd: (_) => _load(),
                ),
              ),
            ],
          ),
        ),

        // Lista
        Expanded(
          child: _loading
              ? const GenericPageSkeleton(itemCount: 4)
              : _error != null
                  ? _ErrorState(message: _error!, onRetry: _load)
                  : _loaded && _events.isEmpty
                      ? _EmptyState(radiusKm: _radiusKm.round())
                      : ListView.builder(
                          padding: const EdgeInsets.only(top: 8, bottom: 100),
                          itemCount: _events.length,
                          itemBuilder: (_, i) => RecommendationCard(
                            event: _events[i],
                            wantToAttend: _wantToAttendIds.contains(_events[i].id),
                            onToggleWantToAttend: () =>
                                _toggleWantToAttend(_events[i]),
                          ),
                        ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────── Prompt conectar Spotify

class _SpotifyPrompt extends StatefulWidget {
  final VoidCallback onConnect;
  const _SpotifyPrompt({required this.onConnect});

  @override
  State<_SpotifyPrompt> createState() => _SpotifyPromptState();
}

class _SpotifyPromptState extends State<_SpotifyPrompt> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFF1DB954),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.music_note_rounded,
                  color: Colors.black, size: 40),
            ),
            const SizedBox(height: 24),
            Text(
              'Conecta Spotify para ver\nconciertos cerca de ti',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Buscamos conciertos de tus artistas más\nescuchados en tu zona.',
              style: TextStyle(
                fontSize: 14,
                color: cs.onSurface.withValues(alpha: .55),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _loading
                  ? null
                  : () async {
                      setState(() => _loading = true);
                      widget.onConnect();
                      await Future.delayed(const Duration(milliseconds: 300));
                      if (mounted) setState(() => _loading = false);
                    },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1DB954),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.black54),
                    )
                  : const Icon(Icons.music_note_rounded),
              label: Text(
                _loading ? 'Conectando…' : 'Conectar con Spotify',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────── Estados vacío / error

class _EmptyState extends StatelessWidget {
  final int radiusKm;
  const _EmptyState({required this.radiusKm});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_off_rounded,
                size: 64, color: cs.onSurface.withValues(alpha: .2)),
            const SizedBox(height: 16),
            Text(
              'Sin conciertos en $radiusKm km',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: cs.onSurface.withValues(alpha: .7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Prueba a ampliar el radio de búsqueda.',
              style: TextStyle(
                  fontSize: 14, color: cs.onSurface.withValues(alpha: .45)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded,
                size: 56, color: cs.error.withValues(alpha: .7)),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14, color: cs.onSurface.withValues(alpha: .6)),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
