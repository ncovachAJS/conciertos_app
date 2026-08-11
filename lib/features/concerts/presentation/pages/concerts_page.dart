import 'package:conciertos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/tutorial/tutorial_content.dart';
import '../../../../core/tutorial/tutorial_overlay.dart';
import '../../../../core/tutorial/tutorial_service.dart';
import '../../../../shared/widgets/app_page.dart';
import '../../../../shared/widgets/concert_card.dart';
import '../../../../shared/widgets/concert_grid_card.dart';
import '../../../../shared/widgets/pro_paywall_sheet.dart';
import '../../data/models/concert_model.dart';
import '../../domain/entities/concert.dart';
import '../providers/concerts_provider.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../widgets/concert_calendar_view.dart';

enum _ViewMode { list, grid, calendar }

class ConcertsPage extends ConsumerStatefulWidget {
  /// Si es `true`, la página se abre directamente en modo calendario.
  final bool openCalendar;

  const ConcertsPage({super.key, this.openCalendar = false});

  @override
  ConsumerState<ConcertsPage> createState() => _ConcertsPageState();
}

class _ConcertsPageState extends ConsumerState<ConcertsPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final TabController _tabController;

  String _searchQuery = '';
  late _ViewMode _viewMode;
  bool _deleting = false;

  bool get _gridView => _viewMode == _ViewMode.grid;

  @override
  void initState() {
    super.initState();
    _viewMode =
        widget.openCalendar ? _ViewMode.calendar : _ViewMode.list;
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _showTutorialIfNeeded(),
    );
  }

  Future<void> _showTutorialIfNeeded() async {
    final should = await TutorialService.shouldShow(TutorialService.concerts);
    if (!should || !mounted) return;
    await TutorialService.markShown(TutorialService.concerts);
    if (!mounted) return;
    await TutorialOverlay.show(
      context,
      steps: TutorialContent.concerts(AppLocalizations.of(context)),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      ref.read(concertsProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  List<Concert> _filtered(List<Concert> all) {
    if (_searchQuery.trim().isEmpty) return all;
    final q = _searchQuery.toLowerCase();
    return all.where((c) {
      return c.artist.toLowerCase().contains(q) ||
          c.festival.toLowerCase().contains(q) ||
          c.name.toLowerCase().contains(q) ||
          c.city.toLowerCase().contains(q) ||
          c.venue.toLowerCase().contains(q);
    }).toList();
  }

  Future<void> _toggleFavorite(Concert concert) async {
    final l = AppLocalizations.of(context);
    final updated = ConcertModel.fromEntity(
      concert.copyWith(favorite: !concert.favorite),
    );
    try {
      await ref.read(concertsProvider.notifier).updateOne(updated);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.couldNotUpdateFavorite)),
      );
    }
  }

  Future<void> _toggleLike(Concert concert) async {
    final l = AppLocalizations.of(context);
    final updated = ConcertModel.fromEntity(
      concert.copyWith(liked: !concert.liked),
    );
    try {
      await ref.read(concertsProvider.notifier).updateOne(updated);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.couldNotUpdateLike)),
      );
    }
  }

  Future<void> _updateRating(Concert concert, int rating) async {
    final updated = ConcertModel.fromEntity(concert.copyWith(rating: rating));
    try {
      await ref.read(concertsProvider.notifier).updateOne(updated);
    } catch (_) {}
  }

  Future<void> _deleteConcert(Concert concert) async {
    final l = AppLocalizations.of(context);
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.deleteConcert),
        content: Text(l.deleteConcertConfirm(concert.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l.delete),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    setState(() => _deleting = true);
    try {
      await ref.read(concertsProvider.notifier).delete(concert.id);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.concertDeleted(concert.name))));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.concertDeleteFailed)),
      );
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  Future<void> _onEdit(Concert c) async {
    final result = await context.push('/add', extra: c);
    if (result == true) {
      await ref.read(concertsProvider.notifier).reload();
    }
  }

  Future<void> _onAdd() async {
    final count = ref.read(ownConcertsCountProvider);
    final isPro = AuthController.instance.user?.isPro ?? false;
    final allowed = await ProPaywallSheet.checkLimit(context, count, isPro);
    if (!allowed || !mounted) return;
    final result = await context.push('/add');
    if (result == true) {
      await ref.read(concertsProvider.notifier).reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final concertsAsync = ref.watch(concertsProvider);
    final cs = Theme.of(context).colorScheme;

    return AppPage(
      title: l.concertsTitle,
      actions: [
        _ViewToggle(
          current: _viewMode,
          onChanged: (m) => setState(() => _viewMode = m),
        ),
        if (_viewMode != _ViewMode.calendar)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: _onAdd,
              child: Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  color: Color(0xFFE53935),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ),
      ],
      child: Stack(
        children: [
          concertsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.wifi_off,
                    size: 48,
                    color: cs.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l.error,
                    style: TextStyle(color: cs.onSurface.withOpacity(0.5)),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => ref.invalidate(concertsProvider),
                    child: Text(l.retry),
                  ),
                ],
              ),
            ),
            data: (concerts) {
              final currentUserId = AuthController.instance.user?.id ?? '';
              final filtered = _filtered(concerts);

              // Mis conciertos: creados por mí
              final mine = filtered
                  .where((c) => c.userId == currentUserId || c.userId.isEmpty)
                  .toList();
              // Compartidos: creados por otro usuario (amigos)
              final shared = filtered
                  .where((c) => c.userId.isNotEmpty && c.userId != currentUserId)
                  .toList();

              final past = mine.where((c) => c.isPastConcert).toList()
                ..sort((a, b) => b.date.compareTo(a.date));
              final upcoming = mine.where((c) => !c.isPastConcert).toList()
                ..sort((a, b) => a.date.compareTo(b.date));
              final sharedSorted = shared.toList()
                ..sort((a, b) => b.date.compareTo(a.date));

              // ── Vista Calendario ────────────────────────────────────
              if (_viewMode == _ViewMode.calendar) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Buscador también disponible en vista calendario
                    TextField(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _searchQuery = v),
                      decoration: InputDecoration(
                        hintText: l.searchConcertsHint,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded),
                                onPressed: () => setState(() {
                                  _searchController.clear();
                                  _searchQuery = '';
                                }),
                              )
                            : null,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ConcertCalendarView(
                        concerts: _filtered(concerts),
                        onAddConcert: (date) async {
                          final count = ref.read(ownConcertsCountProvider);
                          final isPro = AuthController.instance.user?.isPro ?? false;
                          final allowed = await ProPaywallSheet.checkLimit(context, count, isPro);
                          if (!allowed || !mounted) return;
                          final result =
                              await context.push('/add', extra: date);
                          if (result == true && mounted) {
                            await ref
                                .read(concertsProvider.notifier)
                                .reload();
                          }
                        },
                      ),
                    ),
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Buscador ──────────────────────────────────────────
                  TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: l.searchConcertsHint,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded),
                              onPressed: () => setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              }),
                            )
                          : null,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Pestañas ──────────────────────────────────────────
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: const Color(0xFFE53935),
                    unselectedLabelColor: cs.onSurface.withOpacity(0.5),
                    indicatorColor: const Color(0xFFE53935),
                    indicatorWeight: 2,
                    dividerColor: cs.onSurface.withOpacity(0.08),
                    tabs: [
                      Tab(text: '${l.tabPast} (${past.length})'),
                      Tab(text: '${l.tabUpcoming} (${upcoming.length})'),
                      Tab(text: '${l.tabShared} (${sharedSorted.length})'),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ── Contenido de cada pestaña ─────────────────────────
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Pestaña 0 — Pasados
                        _TabContent(
                          concerts: past,
                          gridView: _gridView,
                          emptyIcon: Icons.history_rounded,
                          emptyText: l.noPastConcerts,
                          onLike: _toggleLike,
                          onFavorite: _toggleFavorite,
                          onRatingChanged: _updateRating,
                          onEdit: _onEdit,
                          onDelete: _deleteConcert,
                          scrollController: _scrollController,
                        ),
                        // Pestaña 1 — Próximos
                        _TabContent(
                          concerts: upcoming,
                          gridView: _gridView,
                          emptyIcon: Icons.calendar_month_rounded,
                          emptyText: l.noUpcomingConcertsAdd,
                          onLike: _toggleLike,
                          onFavorite: _toggleFavorite,
                          onRatingChanged: _updateRating,
                          onEdit: _onEdit,
                          onDelete: _deleteConcert,
                          scrollController: _scrollController,
                        ),
                        // Pestaña 2 — Compartidos
                        _TabContent(
                          concerts: sharedSorted,
                          gridView: _gridView,
                          emptyIcon: Icons.group_outlined,
                          emptyText: l.noSharedConcerts,
                          onLike: _toggleLike,
                          onFavorite: _toggleFavorite,
                          onRatingChanged: _updateRating,
                          onEdit: _onEdit,
                          onDelete: _deleteConcert,
                          readOnly: true,
                          scrollController: _scrollController,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          if (_deleting)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    Text(
                      l.deletingConcert,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Toggle de vista: lista / grid / calendario
// ---------------------------------------------------------------------------

class _ViewToggle extends StatelessWidget {
  final _ViewMode current;
  final ValueChanged<_ViewMode> onChanged;

  const _ViewToggle({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget btn(_ViewMode mode, IconData icon, String tooltip) {
      final selected = current == mode;
      return Tooltip(
        message: tooltip,
        child: GestureDetector(
          onTap: () => onChanged(mode),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFFE53935).withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: selected
                  ? const Color(0xFFE53935)
                  : cs.onSurface.withValues(alpha: 0.45),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          btn(_ViewMode.list,     Icons.view_list_rounded,    'Lista'),
          const SizedBox(width: 2),
          btn(_ViewMode.grid,     Icons.grid_view_rounded,    'Cuadrícula'),
          const SizedBox(width: 2),
          btn(_ViewMode.calendar, Icons.calendar_month_rounded, 'Calendario'),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Contenido de una pestaña (lista o grid + estado vacío)
// ---------------------------------------------------------------------------

class _TabContent extends StatelessWidget {
  final List<Concert> concerts;
  final bool gridView;
  final IconData emptyIcon;
  final String emptyText;
  final ValueChanged<Concert> onLike;
  final ValueChanged<Concert> onFavorite;
  final void Function(Concert, int) onRatingChanged;
  final ValueChanged<Concert> onEdit;
  final ValueChanged<Concert> onDelete;
  final bool readOnly;
  final ScrollController? scrollController;

  const _TabContent({
    required this.concerts,
    required this.gridView,
    required this.emptyIcon,
    required this.emptyText,
    required this.onLike,
    required this.onFavorite,
    required this.onRatingChanged,
    required this.onEdit,
    required this.onDelete,
    this.readOnly = false,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (concerts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(emptyIcon, size: 64, color: cs.onSurface.withOpacity(0.15)),
            const SizedBox(height: 16),
            Text(
              emptyText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: cs.onSurface.withOpacity(0.4),
                fontSize: 15,
              ),
            ),
          ],
        ),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: gridView
          ? _GridView(
              key: const ValueKey('grid'),
              concerts: concerts,
              onEdit: onEdit,
              onDelete: onDelete,
              readOnly: readOnly,
              scrollController: scrollController,
            )
          : _ListView(
              key: const ValueKey('list'),
              concerts: concerts,
              onLike: onLike,
              onFavorite: onFavorite,
              onRatingChanged: onRatingChanged,
              onEdit: onEdit,
              onDelete: onDelete,
              readOnly: readOnly,
              scrollController: scrollController,
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Vista grid
// ---------------------------------------------------------------------------

class _GridView extends ConsumerWidget {
  final List<Concert> concerts;
  final ValueChanged<Concert> onEdit;
  final ValueChanged<Concert> onDelete;
  final bool readOnly;
  final ScrollController? scrollController;

  const _GridView({
    super.key,
    required this.concerts,
    required this.onEdit,
    required this.onDelete,
    this.readOnly = false,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadingMore = ref.watch(concertsLoadingMoreProvider);
    return GridView.builder(
      controller: scrollController,
      padding: EdgeInsets.zero,
      // +1 para el spinner de carga al pie cuando loadingMore
      itemCount: concerts.length + (loadingMore ? 1 : 0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        mainAxisExtent: 307,
      ),
      itemBuilder: (context, index) {
        if (index == concerts.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }
        final concert = concerts[index];
        return ConcertGridCard(
          concert: concert,
          onTap: () => context.push('/concert-detail', extra: concert),
          onEdit: readOnly ? null : () => onEdit(concert),
          onDelete: readOnly ? null : () => onDelete(concert),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Vista lista
// ---------------------------------------------------------------------------

class _ListView extends ConsumerWidget {
  final List<Concert> concerts;
  final ValueChanged<Concert> onLike;
  final ValueChanged<Concert> onFavorite;
  final void Function(Concert, int) onRatingChanged;
  final ValueChanged<Concert> onEdit;
  final ValueChanged<Concert> onDelete;
  final bool readOnly;
  final ScrollController? scrollController;

  const _ListView({
    super.key,
    required this.concerts,
    required this.onLike,
    required this.onFavorite,
    required this.onRatingChanged,
    required this.onEdit,
    required this.onDelete,
    this.readOnly = false,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadingMore = ref.watch(concertsLoadingMoreProvider);
    return ListView.separated(
      controller: scrollController,
      // +1 para el spinner al pie cuando loadingMore
      itemCount: concerts.length + (loadingMore ? 1 : 0),
      separatorBuilder: (_, i) => const SizedBox(height: 24),
      itemBuilder: (context, index) {
        if (index == concerts.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final concert = concerts[index];
        return ConcertCard(
          concert: concert,
          onImageTap: () => context.push('/concert-detail', extra: concert),
          onLike: () => onLike(concert),
          onFavorite: () => onFavorite(concert),
          onRatingChanged: (r) => onRatingChanged(concert, r),
          onEdit: readOnly ? null : () => onEdit(concert),
          onDelete: readOnly ? null : () => onDelete(concert),
        );
      },
    );
  }
}
