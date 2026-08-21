import 'package:conciertos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../core/tutorial/tutorial_content.dart';
import '../../../../core/tutorial/tutorial_overlay.dart';
import '../../../../core/tutorial/tutorial_service.dart';
import '../../../../shared/widgets/app_page.dart';
import '../../../../shared/widgets/concert_card.dart';
import '../../../../shared/widgets/concert_grid_card.dart';
import '../../../../shared/widgets/pro_paywall_sheet.dart';
import '../../data/models/concert_model.dart';
import '../../../../shared/widgets/skeletons/concerts_skeleton.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../domain/entities/concert.dart';
import '../providers/concerts_provider.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../widgets/concert_calendar_view.dart';

enum _ViewMode { list, grid, calendar }

// ── Modelo de filtros activos ────────────────────────────────────────────────
class _ConcertFilter {
  final int? year;
  final String? genre;
  final String? city;
  final int? minRating;
  final bool onlyFavorites;
  final bool onlyLiked;

  const _ConcertFilter({
    this.year,
    this.genre,
    this.city,
    this.minRating,
    this.onlyFavorites = false,
    this.onlyLiked = false,
  });

  bool get hasAny =>
      year != null ||
      genre != null ||
      city != null ||
      minRating != null ||
      onlyFavorites ||
      onlyLiked;

  _ConcertFilter copyWith({
    Object? year = _sentinel,
    Object? genre = _sentinel,
    Object? city = _sentinel,
    Object? minRating = _sentinel,
    bool? onlyFavorites,
    bool? onlyLiked,
  }) {
    return _ConcertFilter(
      year: year == _sentinel ? this.year : year as int?,
      genre: genre == _sentinel ? this.genre : genre as String?,
      city: city == _sentinel ? this.city : city as String?,
      minRating: minRating == _sentinel ? this.minRating : minRating as int?,
      onlyFavorites: onlyFavorites ?? this.onlyFavorites,
      onlyLiked: onlyLiked ?? this.onlyLiked,
    );
  }
}

const _sentinel = Object();

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
  _ConcertFilter _filter = const _ConcertFilter();

  // ── Selección múltiple ───────────────────────────────────────────────────
  bool _selectionMode = false;
  final Set<String> _selectedIds = {};

  bool get _gridView => _viewMode == _ViewMode.grid;

  int get _filterCount {
    int n = 0;
    if (_filter.year != null) n++;
    if (_filter.genre != null) n++;
    if (_filter.city != null) n++;
    if (_filter.minRating != null) n++;
    if (_filter.onlyFavorites) n++;
    if (_filter.onlyLiked) n++;
    return n;
  }

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
    var result = all;

    // Búsqueda de texto
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((c) {
        return c.artist.toLowerCase().contains(q) ||
            c.festival.toLowerCase().contains(q) ||
            c.name.toLowerCase().contains(q) ||
            c.city.toLowerCase().contains(q) ||
            c.venue.toLowerCase().contains(q);
      }).toList();
    }

    // Filtros adicionales
    if (_filter.year != null) {
      result = result.where((c) => c.date.year == _filter.year).toList();
    }
    if (_filter.genre != null && _filter.genre!.isNotEmpty) {
      result = result
          .where((c) =>
              c.genre.toLowerCase().contains(_filter.genre!.toLowerCase()))
          .toList();
    }
    if (_filter.city != null && _filter.city!.isNotEmpty) {
      result = result
          .where((c) =>
              c.city.toLowerCase().contains(_filter.city!.toLowerCase()))
          .toList();
    }
    if (_filter.minRating != null) {
      result = result
          .where((c) => c.rating >= _filter.minRating!)
          .toList();
    }
    if (_filter.onlyFavorites) {
      result = result.where((c) => c.favorite).toList();
    }
    if (_filter.onlyLiked) {
      result = result.where((c) => c.liked).toList();
    }

    return result;
  }

  void _enterSelection(String id) {
    HapticFeedback.mediumImpact();
    setState(() {
      _selectionMode = true;
      _selectedIds.add(id);
    });
  }

  void _exitSelection() => setState(() {
        _selectionMode = false;
        _selectedIds.clear();
      });

  void _toggleSelect(String id) => setState(() {
        if (_selectedIds.contains(id)) {
          _selectedIds.remove(id);
          if (_selectedIds.isEmpty) _selectionMode = false;
        } else {
          _selectedIds.add(id);
        }
      });

  void _selectAll(List<Concert> concerts) =>
      setState(() => _selectedIds.addAll(concerts.map((c) => c.id)));

  Future<void> _deleteSelected() async {
    final ids = Set<String>.from(_selectedIds);
    final count = ids.length;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar conciertos'),
        content: Text(
          '¿Eliminar $count concierto${count == 1 ? '' : 's'}?\nEsta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    HapticFeedback.heavyImpact();
    setState(() => _deleting = true);

    int deleted = 0;
    for (final id in ids) {
      try {
        await ref.read(concertsProvider.notifier).delete(id);
        deleted++;
      } catch (_) {}
    }

    if (!mounted) return;
    _exitSelection();
    setState(() => _deleting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$deleted concierto${deleted == 1 ? '' : 's'} eliminado${deleted == 1 ? '' : 's'}',
        ),
      ),
    );
  }

  Future<void> _openFilters(List<Concert> allConcerts) async {
    final result = await showModalBottomSheet<_ConcertFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FilterSheet(
        current: _filter,
        allConcerts: allConcerts,
      ),
    );
    if (result != null) setState(() => _filter = result);
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

    HapticFeedback.heavyImpact();
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
      title: _selectionMode && _selectedIds.isNotEmpty
          ? '${_selectedIds.length} seleccionado${_selectedIds.length == 1 ? '' : 's'}'
          : l.concertsTitle,
      actions: _selectionMode
          ? [
              // Seleccionar todo (se calcula más abajo con allVisible)
              TextButton(
                onPressed: () {
                  final allVisible = concertsAsync.asData?.value ?? [];
                  final currentUserId = AuthController.instance.user?.id ?? '';
                  final mine = _filtered(allVisible)
                      .where((c) =>
                          c.userId == currentUserId || c.userId.isEmpty)
                      .toList();
                  _selectAll(mine);
                },
                child: const Text(
                  'Todo',
                  style: TextStyle(color: Color(0xFFE53935)),
                ),
              ),
              // Eliminar seleccionados
              IconButton(
                icon: const Icon(Icons.delete_rounded),
                color: const Color(0xFFE53935),
                tooltip: 'Eliminar seleccionados',
                onPressed: _selectedIds.isEmpty ? null : _deleteSelected,
              ),
              // Salir de selección
              IconButton(
                icon: const Icon(Icons.close_rounded),
                tooltip: 'Cancelar selección',
                onPressed: _exitSelection,
              ),
            ]
          : [
              // Entrar en modo selección
              if (_viewMode != _ViewMode.calendar)
                IconButton(
                  icon: const Icon(Icons.checklist_rounded),
                  tooltip: 'Seleccionar',
                  onPressed: () => setState(() => _selectionMode = true),
                ),
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
            loading: () => const SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ConcertsSkeleton(),
            ),
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
                  // ── Buscador + filtro ─────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
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
                      ),
                      const SizedBox(width: 10),
                      // Botón de filtro
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Material(
                            color: _filter.hasAny
                                ? const Color(0xFFE53935)
                                : cs.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => _openFilters(concerts),
                              child: Container(
                                width: 48,
                                height: 48,
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.tune_rounded,
                                  color: _filter.hasAny
                                      ? Colors.white
                                      : cs.onSurface,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                          if (_filter.hasAny)
                            Positioned(
                              top: -4,
                              right: -4,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    _filterCount.toString(),
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFFE53935),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),

                  // ── Chips de filtros activos ───────────────────────────
                  if (_filter.hasAny) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        // Solo los chips se desplazan horizontalmente
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                if (_filter.year != null)
                                  _ActiveChip(
                                    label: '${_filter.year}',
                                    onRemove: () => setState(
                                        () => _filter = _filter.copyWith(year: null)),
                                  ),
                                if (_filter.genre != null)
                                  _ActiveChip(
                                    label: _filter.genre!,
                                    onRemove: () => setState(() =>
                                        _filter = _filter.copyWith(genre: null)),
                                  ),
                                if (_filter.city != null)
                                  _ActiveChip(
                                    label: _filter.city!,
                                    onRemove: () => setState(
                                        () => _filter = _filter.copyWith(city: null)),
                                  ),
                                if (_filter.minRating != null)
                                  _ActiveChip(
                                    label: '${'⭐' * _filter.minRating!}+',
                                    onRemove: () => setState(() =>
                                        _filter = _filter.copyWith(minRating: null)),
                                  ),
                                if (_filter.onlyFavorites)
                                  _ActiveChip(
                                    label: '⭐ Favoritos',
                                    onRemove: () => setState(() => _filter =
                                        _filter.copyWith(onlyFavorites: false)),
                                  ),
                                if (_filter.onlyLiked)
                                  _ActiveChip(
                                    label: '❤️ Me gustan',
                                    onRemove: () => setState(() => _filter =
                                        _filter.copyWith(onlyLiked: false)),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        // "Limpiar" siempre visible, fuera del scroll
                        TextButton(
                          onPressed: () =>
                              setState(() => _filter = const _ConcertFilter()),
                          child: const Text(
                            'Limpiar',
                            style: TextStyle(color: Color(0xFFE53935)),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),

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
                          selectionMode: _selectionMode,
                          selectedIds: _selectedIds,
                          onToggleSelect: _toggleSelect,
                          onEnterSelection: _enterSelection,
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
                          selectionMode: _selectionMode,
                          selectedIds: _selectedIds,
                          onToggleSelect: _toggleSelect,
                          onEnterSelection: _enterSelection,
                        ),
                        // Pestaña 2 — Compartidos (sin selección: no son propios)
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
  // Selección múltiple
  final bool selectionMode;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggleSelect;
  final ValueChanged<String> onEnterSelection;

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
    this.selectionMode = false,
    this.selectedIds = const {},
    this.onToggleSelect = _noop,
    this.onEnterSelection = _noop,
  });

  static void _noop(dynamic _) {}

  String _emptyEmoji(IconData icon) {
    if (icon == Icons.history_rounded) return '🎸';
    if (icon == Icons.calendar_month_rounded) return '📅';
    if (icon == Icons.group_outlined) return '👥';
    return '🎵';
  }

  String? _emptySubtitle(IconData icon) {
    if (icon == Icons.history_rounded) {
      return 'Tus conciertos pasados aparecerán aquí';
    }
    if (icon == Icons.calendar_month_rounded) {
      return 'Añade un concierto futuro para no perderte nada';
    }
    if (icon == Icons.group_outlined) {
      return 'Cuando tus amigos compartan conciertos, los verás aquí';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (concerts.isEmpty) {
      return EmptyState(
        emoji: _emptyEmoji(emptyIcon),
        title: emptyText,
        subtitle: _emptySubtitle(emptyIcon),
        accentColor: const Color(0xFFE53935),
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
              selectionMode: selectionMode,
              selectedIds: selectedIds,
              onToggleSelect: onToggleSelect,
              onEnterSelection: onEnterSelection,
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
              selectionMode: selectionMode,
              selectedIds: selectedIds,
              onToggleSelect: onToggleSelect,
              onEnterSelection: onEnterSelection,
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
  final bool selectionMode;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggleSelect;
  final ValueChanged<String> onEnterSelection;

  const _GridView({
    super.key,
    required this.concerts,
    required this.onEdit,
    required this.onDelete,
    this.readOnly = false,
    this.scrollController,
    this.selectionMode = false,
    this.selectedIds = const {},
    this.onToggleSelect = _noop,
    this.onEnterSelection = _noop,
  });

  static void _noop(dynamic _) {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadingMore = ref.watch(concertsLoadingMoreProvider);
    return GridView.builder(
      controller: scrollController,
      padding: EdgeInsets.zero,
      // +1 para el spinner de carga al pie cuando loadingMore
      itemCount: concerts.length + (loadingMore ? 1 : 0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.gridColumns(context, phone: 2, tablet: 3),
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
        final isSelected = selectedIds.contains(concert.id);
        return GestureDetector(
          onLongPress: selectionMode ? null : () => onEnterSelection(concert.id),
          onTap: selectionMode ? () => onToggleSelect(concert.id) : null,
          child: Stack(
            children: [
              // La tarjeta original — ignoramos sus toques cuando estamos en selección
              IgnorePointer(
                ignoring: selectionMode,
                child: ConcertGridCard(
                  concert: concert,
                  onTap: () => context.push('/concert-detail', extra: concert),
                  onEdit: readOnly ? null : () => onEdit(concert),
                  onDelete: readOnly ? null : () => onDelete(concert),
                ),
              ),
              // Overlay de selección
              if (selectionMode)
                Positioned.fill(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFE53935).withValues(alpha: .18)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: isSelected
                          ? Border.all(color: const Color(0xFFE53935), width: 2)
                          : null,
                    ),
                  ),
                ),
              // Checkbox en la esquina superior izquierda
              if (selectionMode)
                Positioned(
                  top: 8,
                  left: 8,
                  child: _SelectionDot(selected: isSelected),
                ),
            ],
          ),
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
  final bool selectionMode;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggleSelect;
  final ValueChanged<String> onEnterSelection;

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
    this.selectionMode = false,
    this.selectedIds = const {},
    this.onToggleSelect = _noop,
    this.onEnterSelection = _noop,
  });

  static void _noop(dynamic _) {}

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
        final isSelected = selectedIds.contains(concert.id);
        return GestureDetector(
          onLongPress: selectionMode ? null : () => onEnterSelection(concert.id),
          onTap: selectionMode ? () => onToggleSelect(concert.id) : null,
          child: Stack(
            children: [
              // Tarjeta original — desactivamos sus gestos al estar en selección
              IgnorePointer(
                ignoring: selectionMode,
                child: ConcertCard(
                  concert: concert,
                  onImageTap: () => context.push('/concert-detail', extra: concert),
                  onLike: () => onLike(concert),
                  onFavorite: () => onFavorite(concert),
                  onRatingChanged: (r) => onRatingChanged(concert, r),
                  onEdit: readOnly ? null : () => onEdit(concert),
                  onDelete: readOnly ? null : () => onDelete(concert),
                ),
              ),
              // Overlay de selección
              if (selectionMode)
                Positioned.fill(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFE53935).withValues(alpha: .15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: isSelected
                          ? Border.all(color: const Color(0xFFE53935), width: 2)
                          : Border.all(color: Colors.transparent, width: 2),
                    ),
                  ),
                ),
              // Checkbox arriba a la derecha
              if (selectionMode)
                Positioned(
                  top: 12,
                  right: 12,
                  child: _SelectionDot(selected: isSelected),
                ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Indicador visual de selección (círculo con check)
// ---------------------------------------------------------------------------

class _SelectionDot extends StatelessWidget {
  final bool selected;
  const _SelectionDot({required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? const Color(0xFFE53935) : Colors.black45,
        border: Border.all(
          color: selected ? const Color(0xFFE53935) : Colors.white54,
          width: 2,
        ),
      ),
      child: selected
          ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
          : null,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Chip de filtro activo
// ─────────────────────────────────────────────────────────────────────────────

class _ActiveChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _ActiveChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label, style: const TextStyle(fontSize: 13)),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onRemove,
        backgroundColor: const Color(0xFFE53935).withValues(alpha: .12),
        side: const BorderSide(color: Color(0xFFE53935), width: 0.8),
        deleteIconColor: const Color(0xFFE53935),
        labelStyle: const TextStyle(color: Color(0xFFE53935)),
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom sheet de filtros
// ─────────────────────────────────────────────────────────────────────────────

class _FilterSheet extends StatefulWidget {
  final _ConcertFilter current;
  final List<Concert> allConcerts;

  const _FilterSheet({required this.current, required this.allConcerts});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late _ConcertFilter _f;

  @override
  void initState() {
    super.initState();
    _f = widget.current;
  }

  List<int> get _years {
    final ys = widget.allConcerts.map((c) => c.date.year).toSet().toList()
      ..sort((a, b) => b.compareTo(a));
    return ys;
  }

  List<String> get _genres {
    final gs = widget.allConcerts
        .map((c) => c.genre.trim())
        .where((g) => g.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    return gs;
  }

  List<String> get _cities {
    final cities = widget.allConcerts
        .map((c) => c.city.trim())
        .where((c) => c.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    return cities;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 4),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.onSurface.withValues(alpha: .2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Row(
                children: [
                  const Text(
                    'Filtrar conciertos',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => setState(() => _f = const _ConcertFilter()),
                    child: const Text('Limpiar',
                        style: TextStyle(color: Color(0xFFE53935))),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  _FilterSection(
                    title: 'Año',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _years.map((y) {
                        final selected = _f.year == y;
                        return ChoiceChip(
                          label: Text('$y'),
                          selected: selected,
                          onSelected: (_) => setState(
                              () => _f = _f.copyWith(year: selected ? null : y)),
                          selectedColor: const Color(0xFFE53935).withValues(alpha: .2),
                          side: selected
                              ? const BorderSide(color: Color(0xFFE53935))
                              : null,
                        );
                      }).toList(),
                    ),
                  ),
                  if (_genres.isNotEmpty)
                    _FilterSection(
                      title: 'Género',
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _genres.map((g) {
                          final selected = _f.genre == g;
                          return ChoiceChip(
                            label: Text(g),
                            selected: selected,
                            onSelected: (_) => setState(
                                () => _f = _f.copyWith(genre: selected ? null : g)),
                            selectedColor: const Color(0xFFE53935).withValues(alpha: .2),
                            side: selected
                                ? const BorderSide(color: Color(0xFFE53935))
                                : null,
                          );
                        }).toList(),
                      ),
                    ),
                  if (_cities.isNotEmpty)
                    _FilterSection(
                      title: 'Ciudad',
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _cities.take(20).map((c) {
                          final selected = _f.city == c;
                          return ChoiceChip(
                            label: Text(c),
                            selected: selected,
                            onSelected: (_) => setState(
                                () => _f = _f.copyWith(city: selected ? null : c)),
                            selectedColor: const Color(0xFFE53935).withValues(alpha: .2),
                            side: selected
                                ? const BorderSide(color: Color(0xFFE53935))
                                : null,
                          );
                        }).toList(),
                      ),
                    ),
                  _FilterSection(
                    title: 'Valoración mínima',
                    child: Row(
                      children: List.generate(5, (i) {
                        final stars = i + 1;
                        return GestureDetector(
                          onTap: () => setState(() => _f = _f.copyWith(
                              minRating: _f.minRating == stars ? null : stars)),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Icon(
                              i < (_f.minRating ?? 0)
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              color: Colors.amber,
                              size: 32,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  _FilterSection(
                    title: 'Mostrar solo',
                    child: Column(
                      children: [
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Favoritos'),
                          value: _f.onlyFavorites,
                          activeColor: const Color(0xFFE53935),
                          onChanged: (v) =>
                              setState(() => _f = _f.copyWith(onlyFavorites: v)),
                        ),
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Me gustan'),
                          value: _f.onlyLiked,
                          activeColor: const Color(0xFFE53935),
                          onChanged: (v) =>
                              setState(() => _f = _f.copyWith(onlyLiked: v)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => Navigator.pop(context, _f),
                  child: const Text('Aplicar filtros',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  final String title;
  final Widget child;
  const _FilterSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
