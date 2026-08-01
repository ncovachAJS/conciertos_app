import 'package:conciertos_app/l10n/generated/app_localizations.dart';
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
  final _searchController = TextEditingController();

  List<RecommendedEventModel> _events = [];
  String _selectedCountry = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final artistQuery = _searchController.text.trim();

    List<String> artists;
    if (artistQuery.isNotEmpty) {
      artists = [artistQuery];
    } else {
      artists = (ref.read(concertsProvider).asData?.value ?? [])
          .where((c) => c.liked && c.artist.trim().isNotEmpty)
          .map((c) => c.artist.trim())
          .toSet()
          .toList()
        ..sort();
      if (artists.isEmpty) return;
    }

    setState(() {
      _loading = true;
      _events = [];
    });

    try {
      for (final artist in artists) {
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
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text(l.recommendedTitle),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    labelText: l.artistLabel,
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: ListenableBuilder(
                      listenable: _searchController,
                      builder: (_, __) => _searchController.text.isEmpty
                          ? const SizedBox.shrink()
                          : IconButton(
                              icon: const Icon(Icons.clear_rounded),
                              onPressed: () {
                                _searchController.clear();
                                _load();
                              },
                            ),
                    ),
                  ),
                  onSubmitted: (_) => _load(),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedCountry,
                  decoration: InputDecoration(labelText: l.country),
                  items: localizedCountries(Localizations.localeOf(context).languageCode).entries
                      .map(
                        (e) => DropdownMenuItem(value: e.value, child: Text(e.key)),
                      )
                      .toList(),
                  onChanged: (value) {
                    _selectedCountry = value ?? '';
                    _load();
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _events.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        l.noLikesForRecommendations,
                        style: const TextStyle(color: Colors.white54, fontSize: 15),
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
