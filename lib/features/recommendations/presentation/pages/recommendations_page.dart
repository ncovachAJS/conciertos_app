import 'package:conciertos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../core/tutorial/tutorial_content.dart';
import '../../../../core/tutorial/tutorial_overlay.dart';
import '../../../../core/tutorial/tutorial_service.dart';
import '../../../../shared/widgets/skeletons/generic_page_skeleton.dart';

import '../../../../core/constants/countries.dart';
import '../../../concerts/presentation/providers/concerts_provider.dart';
import '../../data/models/recommended_event_model.dart';
import '../../data/services/recommendations_api_service.dart';
import '../../data/services/want_to_attend_api_service.dart';
import '../../domain/entities/recommended_event.dart';
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
  final _wantToAttendApi = WantToAttendApiService();
  final _searchController = TextEditingController();

  List<RecommendedEventModel> _events = [];
  final Set<String> _wantToAttendIds = {};
  List<RecommendedEvent> _savedEvents = [];
  String _selectedCountry = '';
  bool _loading = false;
  bool _isCompact = false;

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
    _loadSaved();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _showTutorialIfNeeded(),
    );
  }

  Future<void> _showTutorialIfNeeded() async {
    final should = await TutorialService.shouldShow(TutorialService.recs);
    if (!should || !mounted) return;
    await TutorialService.markShown(TutorialService.recs);
    if (!mounted) return;
    await TutorialOverlay.show(
      context,
      steps: TutorialContent.recommendations(AppLocalizations.of(context)),
    );
  }

  Future<void> _loadSaved() async {
    try {
      final saved = await _wantToAttendApi.getAll();
      if (mounted) {
        setState(() {
          _savedEvents = saved;
          _wantToAttendIds.addAll(saved.map((e) => e.id));
        });
      }
    } catch (e) {
      debugPrint('Error cargando quiero ir: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _toggleWantToAttend(RecommendedEvent event) async {
    final id = event.id;
    try {
      final added = await _wantToAttendApi.toggle(event);
      if (!mounted) return;
      setState(() {
        if (added) {
          _wantToAttendIds.add(id);
          _savedEvents.add(event);
        } else {
          _wantToAttendIds.remove(id);
          _savedEvents.removeWhere((e) => e.id == id);
        }
      });
    } catch (e) {
      debugPrint('Error toggling quiero ir: $e');
    }
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
      for (int i = 0; i < artists.length; i++) {
        if (i > 0) await Future.delayed(const Duration(milliseconds: 300));
        final result = await _api.getRecommendations(
          artist: artists[i],
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
    final wantList = _savedEvents;

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
                ? const GenericPageSkeleton(itemCount: 4)
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _EventList(
                        events: _events,
                        wantToAttendIds: _wantToAttendIds,
                        isCompact: _isCompact,
                        onToggle: _toggleWantToAttend,
                        emptyText: l.noLikesForRecommendations,
                      ),
                      _EventList(
                        events: wantList,
                        wantToAttendIds: _wantToAttendIds,
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
  final List<RecommendedEvent> events;
  final Set<String> wantToAttendIds;
  final bool isCompact;
  final Future<void> Function(RecommendedEvent event) onToggle;
  final String emptyText;

  const _EventList({
    required this.events,
    required this.wantToAttendIds,
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

    final isTablet = Responsive.isTablet(context);

    // ── Modo compacto ────────────────────────────────────────────────────────
    if (isCompact) {
      final cs = Theme.of(context).colorScheme;
      if (isTablet) {
        // En iPad: dos listas compactas lado a lado
        final left = [for (int i = 0; i < events.length; i += 2) events[i]];
        final right = [for (int i = 1; i < events.length; i += 2) events[i]];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(top: 8, bottom: 32),
                itemCount: left.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: cs.onSurface.withValues(alpha: 0.08),
                ),
                itemBuilder: (_, i) => RecommendationCard(
                  event: left[i],
                  isCompact: true,
                  wantToAttend: wantToAttendIds.contains(left[i].id),
                  onToggleWantToAttend: () => onToggle(left[i]),
                ),
              ),
            ),
            VerticalDivider(
              width: 1,
              color: cs.onSurface.withValues(alpha: 0.08),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(top: 8, bottom: 32),
                itemCount: right.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: cs.onSurface.withValues(alpha: 0.08),
                ),
                itemBuilder: (_, i) => RecommendationCard(
                  event: right[i],
                  isCompact: true,
                  wantToAttend: wantToAttendIds.contains(right[i].id),
                  onToggleWantToAttend: () => onToggle(right[i]),
                ),
              ),
            ),
          ],
        );
      }
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
          wantToAttend: wantToAttendIds.contains(events[i].id),
          onToggleWantToAttend: () => onToggle(events[i]),
        ),
      );
    }

    // ── Modo tarjeta ─────────────────────────────────────────────────────────
    if (isTablet) {
      // En iPad: grid de 2 columnas
      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 32),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          childAspectRatio: 1.05,
        ),
        itemCount: events.length,
        itemBuilder: (_, i) => RecommendationCard(
          event: events[i],
          wantToAttend: wantToAttendIds.contains(events[i].id),
          onToggleWantToAttend: () => onToggle(events[i]),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 32),
      itemCount: events.length,
      itemBuilder: (_, i) => RecommendationCard(
        event: events[i],
        wantToAttend: wantToAttendIds.contains(events[i].id),
        onToggleWantToAttend: () => onToggle(events[i]),
      ),
    );
  }
}
