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

class _RecommendationsPageState extends ConsumerState<RecommendationsPage>
    with SingleTickerProviderStateMixin {
  final _api = RecommendationsApiService();
  final _searchController = TextEditingController();

  List<RecommendedEventModel> _events = [];
  final Set<String> _wantToAttend = {};
  String _selectedCountry = '';
  bool _loading = false;
  bool _isCompact = false;

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _toggleWantToAttend(String id) {
    setState(() {
      if (_wantToAttend.contains(id)) {
        _wantToAttend.remove(id);
      } else {
        _wantToAttend.add(id);
      }
    });
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
    final wantList = _events.where((e) => _wantToAttend.contains(e.id)).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text(l.recommendedTitle),
        actions: [
          IconButton(
            icon: Icon(_isCompact ? Icons.grid_view_rounded : Icons.view_list_rounded),
            tooltip: _isCompact ? 'Vista tarjeta' : 'Vista compacta',
            onPressed: () => setState(() => _isCompact = !_isCompact),
          ),
        ],
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
                              onPressed: () => _searchController.clear(),
                            ),
                    ),
                  ),
                  onSubmitted: (_) => _load(),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedCountry,
                  decoration: InputDecoration(labelText: l.country),
                  items: localizedCountries(
                          Localizations.localeOf(context).languageCode)
                      .entries
                      .map((e) =>
                          DropdownMenuItem(value: e.value, child: Text(e.key)))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _selectedCountry = value ?? '');
                  },
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _loading ? null : _load,
                    icon: const Icon(Icons.search_rounded),
                    label: Text(l.search),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Resultados${_events.isNotEmpty ? ' (${_events.length})' : ''}'),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        size: 16, color: Colors.greenAccent),
                    const SizedBox(width: 6),
                    Text('Quiero ir${wantList.isNotEmpty ? ' (${wantList.length})' : ''}'),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _EventList(
                        events: _events,
                        wantToAttend: _wantToAttend,
                        isCompact: _isCompact,
                        onToggle: _toggleWantToAttend,
                        emptyText: l.noLikesForRecommendations,
                      ),
                      _EventList(
                        events: wantList,
                        wantToAttend: _wantToAttend,
                        isCompact: _isCompact,
                        onToggle: _toggleWantToAttend,
                        emptyText: 'Aún no has marcado ningún concierto.',
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _EventList extends StatelessWidget {
  final List<RecommendedEventModel> events;
  final Set<String> wantToAttend;
  final bool isCompact;
  final void Function(String id) onToggle;
  final String emptyText;

  const _EventList({
    required this.events,
    required this.wantToAttend,
    required this.isCompact,
    required this.onToggle,
    required this.emptyText,
  });

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            emptyText,
            style: const TextStyle(color: Colors.white54, fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (isCompact) {
      final cs = Theme.of(context).colorScheme;
      return ListView.separated(
        padding: const EdgeInsets.only(top: 8, bottom: 32),
        itemCount: events.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          indent: 16,
          endIndent: 16,
          color: cs.onSurface.withValues(alpha: 0.08),
        ),
        itemBuilder: (_, i) => RecommendationCard(
          event: events[i],
          isCompact: true,
          wantToAttend: wantToAttend.contains(events[i].id),
          onToggleWantToAttend: () => onToggle(events[i].id),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 32),
      itemCount: events.length,
      itemBuilder: (_, i) => RecommendationCard(
        event: events[i],
        wantToAttend: wantToAttend.contains(events[i].id),
        onToggleWantToAttend: () => onToggle(events[i].id),
      ),
    );
  }
}
