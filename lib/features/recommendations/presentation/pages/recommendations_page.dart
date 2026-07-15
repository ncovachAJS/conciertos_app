import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/countries.dart';
import '../../../concerts/presentation/providers/concerts_provider.dart';
import '../../data/models/recommended_event_model.dart';
import '../../data/services/recommendations_api_service.dart';
import '../widgets/recommendation_card.dart';

class RecommendationsPage extends ConsumerStatefulWidget {
  const RecommendationsPage({super.key});

  @override
  ConsumerState<RecommendationsPage> createState() =>
      _RecommendationsPageState();
}

class _RecommendationsPageState extends ConsumerState<RecommendationsPage> {
  final _api = RecommendationsApiService();

  List<RecommendedEventModel> _events = [];
  String _selectedCountry = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // Cargamos tras el primer frame para tener acceso al ref
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    // Leemos los artistas que el usuario ha marcado con "me gusta"
    // directamente del provider — sin llamada extra a la API.
    final likedArtists =
        (ref.read(concertsProvider).asData?.value ?? [])
            .where((c) => c.liked && c.artist.trim().isNotEmpty)
            .map((c) => c.artist.trim())
            .toSet()
            .toList()
          ..sort();

    if (likedArtists.isEmpty) return;

    setState(() {
      _loading = true;
      _events = [];
    });

    try {
      for (final artist in likedArtists) {
        final result = await _api.getRecommendations(
          artist: artist,
          countryCode: _selectedCountry,
        );

        if (!mounted) return;

        setState(() => _events.addAll(result));
      }
    } catch (e) {
      debugPrint('Recommendations error: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: const Text('Recomendados'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: DropdownButtonFormField<String>(
              value: _selectedCountry,
              decoration: const InputDecoration(labelText: 'País'),
              items: countries.entries
                  .map(
                    (e) => DropdownMenuItem(value: e.value, child: Text(e.key)),
                  )
                  .toList(),
              onChanged: (value) {
                _selectedCountry = value ?? '';
                _load();
              },
            ),
          ),

          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _events.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        'Marca artistas con "me gusta" para recibir recomendaciones.',
                        style: TextStyle(color: Colors.white54, fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 32),
                    itemCount: _events.length,
                    itemBuilder: (_, index) =>
                        RecommendationCard(event: _events[index]),
                  ),
          ),
        ],
      ),
    );
  }
}
