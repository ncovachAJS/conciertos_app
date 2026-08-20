import 'dart:io';

import 'package:conciertos_app/l10n/generated/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/tutorial/tutorial_content.dart';
import '../../../../core/tutorial/tutorial_overlay.dart';
import '../../../../core/tutorial/tutorial_service.dart';
import '../../../../shared/widgets/skeletons/generic_page_skeleton.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../concerts/data/models/concert_model.dart';
import '../../../concerts/data/services/concert_api_service.dart';
import '../../../concerts/domain/entities/concert.dart';
import '../../../concerts/presentation/providers/concerts_provider.dart';
import '../../../../core/config/pro_config.dart';
import '../../../../shared/widgets/pro_paywall_sheet.dart';
import '../../data/models/setlist_concert_model.dart';
import '../../data/services/artist_image_service.dart';
import '../../data/services/backup_import_service.dart';
import '../../data/services/setlist_import_service.dart';
import '../../../spotify/data/services/spotify_search_service.dart';

// ─────────────────────────────────────────────────────────────────────────────

class ImportPage extends ConsumerStatefulWidget {
  const ImportPage({super.key});

  @override
  ConsumerState<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends ConsumerState<ImportPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => _showTutorialIfNeeded());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _showTutorialIfNeeded() async {
    final should = await TutorialService.shouldShow(TutorialService.import_);
    if (!should || !mounted) return;
    await TutorialService.markShown(TutorialService.import_);
    if (!mounted) return;
    await TutorialOverlay.show(
      context,
      steps: TutorialContent.import_(AppLocalizations.of(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.importTitle),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.search_rounded), text: 'Setlist.fm'),
            Tab(icon: Icon(Icons.restore_rounded), text: 'Copia de seguridad'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _SetlistTab(tabController: _tabController),
          const _BackupTab(),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TAB 1 — Setlist.fm
// ═══════════════════════════════════════════════════════════════════════════════

class _SetlistTab extends ConsumerStatefulWidget {
  final TabController tabController;
  const _SetlistTab({required this.tabController});

  @override
  ConsumerState<_SetlistTab> createState() => _SetlistTabState();
}

class _SetlistTabState extends ConsumerState<_SetlistTab> {
  final _searchController = TextEditingController();
  final _setlistService   = SetlistImportService();
  final _imageService     = ArtistImageService();
  final _spotifyService   = SpotifySearchService();

  String _detectedGenre = '';

  List<SetlistConcertModel> _concerts = [];
  final Set<String> _selected = {};

  bool _searching  = false;
  int  _searchId   = 0;
  bool _importing  = false;
  bool _hasMore    = false;
  int  _page       = 1;
  int  _total      = 0;
  int  _artistYear = 0;
  int  _importedCount = 0;
  int  _importTotal   = 0;
  String _importingCurrent = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    if (_searchController.text.isEmpty && _searching) {
      _searchId++;
      setState(() {
        _searching = false;
        _concerts  = [];
        _selected.clear();
        _total = 0;
      });
    }
  }

  Future<void> _search({bool more = false}) async {
    final q = _searchController.text.trim();
    if (q.isEmpty) return;

    _searchId++;
    final currentId = _searchId;

    setState(() {
      _searching = true;
      if (!more) {
        _concerts = [];
        _selected.clear();
        _page  = 1;
        _total = 0;
        _detectedGenre = '';
      }
    });

    if (!more) {
      _spotifyService.searchArtist(q).then((artist) {
        if (!mounted) return;
        if (artist != null && artist.genres.isNotEmpty) {
          final genre = artist.genres.first
              .split(' ')
              .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
              .join(' ');
          setState(() => _detectedGenre = genre);
        }
      }).catchError((_) {});
    }

    try {
      if (_artistYear == 0) {
        final r = await _setlistService.searchArtistConcerts(
          q,
          page: more ? _page + 1 : 1,
        );
        if (!mounted || _searchId != currentId) return;
        setState(() {
          _concerts = more ? [..._concerts, ...r.concerts] : r.concerts;
          _total    = r.total;
          _page     = r.page;
          _hasMore  = _concerts.length < _total && r.concerts.isNotEmpty;
        });
      } else {
        int page = more ? _page + 1 : 1;
        final found = <SetlistConcertModel>[];
        bool hasMore = true;
        int safetyLimit = 15;

        while (hasMore && safetyLimit > 0) {
          final r = await _setlistService.searchArtistConcerts(q, page: page);
          if (r.concerts.isEmpty) break;
          for (final c in r.concerts) {
            if (c.date.year == _artistYear) found.add(c);
          }
          final hasOlder = r.concerts.any((c) => c.date.year < _artistYear);
          hasMore = !hasOlder && r.page * r.itemsPerPage < r.total;
          await Future.delayed(const Duration(milliseconds: 500));
          page++;
          safetyLimit--;
          if (hasOlder || _searchId != currentId) break;
        }

        if (!mounted || _searchId != currentId) return;
        setState(() {
          _concerts = more ? [..._concerts, ...found] : found;
          _total    = found.length;
          _page     = page - 1;
          _hasMore  = hasMore;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppLocalizations.of(context).error}: $e')),
      );
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  Future<void> _importSelected() async {
    if (_selected.isEmpty) return;
    final toImport = _concerts.where((c) => _selected.contains(c.id)).toList();

    setState(() {
      _importing      = true;
      _importTotal    = toImport.length;
      _importedCount  = 0;
    });

    Concert? lastCreated;

    try {
      final img = await _imageService.getImage(toImport.first.artist) ?? '';
      for (final c in toImport) {
        if (!mounted) return;
        setState(() {
          _importingCurrent = '${c.venue} · ${c.city}';
          _importedCount++;
        });
        lastCreated = await ConcertApiService().addConcert(
          ConcertModel(
            id: '',
            name: c.artist,
            artist: c.artist,
            festival: '',
            date: c.date,
            venue: c.venue,
            city: c.city,
            imageUrl: img,
            rating: 0,
            liked: false,
            favorite: false,
            genre: _detectedGenre,
          ),
        );
      }

      ref.read(concertsProvider.notifier).reload().ignore();
      if (!mounted) return;
      setState(() => _selected.clear());

      if (toImport.length == 1 && lastCreated != null) {
        if (context.mounted) context.push('/concert-detail', extra: lastCreated);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).importSuccess(toImport.length),
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppLocalizations.of(context).error}: $e')),
      );
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l  = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final years = [
      0,
      ...List.generate(
        DateTime.now().year - 1989,
        (i) => DateTime.now().year - i,
      ),
    ];

    return Stack(
      fit: StackFit.expand,
      children: [
        // ── FAB ────────────────────────────────────────────────────────────────
        // Necesitamos el FAB dentro del tab para que funcione con el TabBarView
        Positioned.fill(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButton: _selected.isNotEmpty && !_importing
                ? FloatingActionButton.extended(
                    onPressed: _importSelected,
                    icon: const Icon(Icons.download_rounded),
                    label: Text(l.importButton(_selected.length)),
                    backgroundColor: const Color(0xFFE53935),
                    foregroundColor: Colors.white,
                  )
                : null,
            body: CustomScrollView(
              slivers: [
                // Cabecera
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.importSearchArtist,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l.importFromSetlist,
                          style: TextStyle(
                            color: cs.onSurface.withValues(alpha: .54),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Banner Spotify
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                    child: InkWell(
                      onTap: () => context.push('/spotify-import'),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1DB954).withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFF1DB954).withValues(alpha: .3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36, height: 36,
                              decoration: const BoxDecoration(
                                color: Color(0xFF1DB954),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.music_note_rounded,
                                  color: Colors.black, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Importar desde Spotify',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: cs.onSurface,
                                    ),
                                  ),
                                  Text(
                                    'Conecta tu cuenta y ve tus artistas favoritos',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: cs.onSurface.withValues(alpha: .6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded,
                                color: cs.onSurface.withValues(alpha: .4)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Buscador + año + botón
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                    child: LayoutBuilder(
                      builder: (ctx, bc) {
                        const yw = 110.0, bw = 88.0, sp = 10.0;
                        final aw = bc.maxWidth - yw - bw - sp * 2;
                        return Row(
                          children: [
                            SizedBox(
                              width: aw,
                              child: ListenableBuilder(
                                listenable: _searchController,
                                builder: (_, __) => TextField(
                                  controller: _searchController,
                                  onSubmitted: (_) => _search(),
                                  textInputAction: TextInputAction.search,
                                  style: TextStyle(color: cs.onSurface),
                                  decoration: InputDecoration(
                                    hintText: l.artistHint,
                                    hintStyle: TextStyle(
                                        color: cs.onSurface.withValues(alpha: .4)),
                                    prefixIcon: Icon(Icons.search,
                                        color: cs.onSurface.withValues(alpha: .6)),
                                    suffixIcon: _searchController.text.isNotEmpty
                                        ? IconButton(
                                            icon: const Icon(Icons.clear_rounded),
                                            onPressed: _searchController.clear,
                                          )
                                        : null,
                                    filled: true,
                                    fillColor: cs.surfaceContainerHighest,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: sp),
                            SizedBox(
                              width: yw,
                              child: DropdownButtonFormField<int>(
                                value: _artistYear,
                                style: TextStyle(
                                    color: cs.onSurface, fontSize: 14),
                                dropdownColor: cs.surface,
                                decoration: InputDecoration(
                                  labelText: l.year,
                                  labelStyle: TextStyle(
                                      color: cs.onSurface.withValues(alpha: .6)),
                                  filled: true,
                                  fillColor: cs.surfaceContainerHighest,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 14),
                                ),
                                items: years
                                    .map((y) => DropdownMenuItem(
                                          value: y,
                                          child: Text(y == 0 ? l.all : '$y',
                                              style: TextStyle(
                                                  color: cs.onSurface)),
                                        ))
                                    .toList(),
                                onChanged: (y) {
                                  _searchId++;
                                  setState(() {
                                    _artistYear = y ?? 0;
                                    if (_searching) {
                                      _searching = false;
                                      _concerts  = [];
                                      _selected.clear();
                                      _total = 0;
                                    }
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: sp),
                            SizedBox(
                              width: bw,
                              child: FilledButton(
                                onPressed: _searching ? null : _search,
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFFE53935),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: _searching
                                    ? const SizedBox(
                                        width: 18, height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(l.search,
                                        maxLines: 1,
                                        overflow: TextOverflow.clip),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                // Contador
                if (_total > 0)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                      child: Row(
                        children: [
                          Text(
                            l.importFoundCount(_total),
                            style: TextStyle(
                                color: cs.onSurface.withValues(alpha: .54),
                                fontSize: 13),
                          ),
                          const Spacer(),
                          if (_selected.isNotEmpty)
                            Text(
                              l.importSelectedCount(_selected.length),
                              style: const TextStyle(
                                color: Color(0xFFE53935),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                // Lista
                if (_searching && _concerts.isEmpty)
                  const SliverFillRemaining(
                    child: GenericPageSkeleton(itemCount: 5),
                  )
                else if (_concerts.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.queue_music,
                              size: 72,
                              color: cs.onSurface.withValues(alpha: .2)),
                          const SizedBox(height: 16),
                          Text(
                            l.importSearchPrompt,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: cs.onSurface.withValues(alpha: .54),
                                fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverList.builder(
                    itemCount: _concerts.length + (_hasMore ? 1 : 0),
                    itemBuilder: (_, i) {
                      if (i == _concerts.length) {
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: OutlinedButton(
                            onPressed: _searching ? null : () => _search(more: true),
                            child: Text(l.loadMore),
                          ),
                        );
                      }
                      final c   = _concerts[i];
                      final sel = _selected.contains(c.id);
                      return InkWell(
                        onTap: () => setState(() =>
                            sel ? _selected.remove(c.id) : _selected.add(c.id)),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: sel
                                ? const Color(0xFFE53935).withValues(alpha: .08)
                                : cs.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: sel
                                  ? const Color(0xFFE53935).withValues(alpha: .4)
                                  : cs.onSurface.withValues(alpha: .08),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40, height: 40,
                                decoration: BoxDecoration(
                                  color: c.isPast
                                      ? const Color(0xFFE53935)
                                          .withValues(alpha: .12)
                                      : const Color(0xFF42A5F5)
                                          .withValues(alpha: .12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  c.isPast ? Icons.music_note : Icons.event,
                                  color: c.isPast
                                      ? const Color(0xFFE53935)
                                      : const Color(0xFF42A5F5),
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c.artist,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: cs.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      '${c.formattedDate}  ·  ${c.venue}, ${c.city}',
                                      style: TextStyle(
                                        color: cs.onSurface.withValues(alpha: .54),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 24, height: 24,
                                decoration: BoxDecoration(
                                  color: sel
                                      ? const Color(0xFFE53935)
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: sel
                                        ? const Color(0xFFE53935)
                                        : cs.onSurface.withValues(alpha: .3),
                                    width: 2,
                                  ),
                                ),
                                child: sel
                                    ? const Icon(Icons.check,
                                        color: Colors.white, size: 14)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        ),

        // Overlay importando
        if (_importing)
          Container(
            color: Colors.black87,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: Color(0xFFE53935)),
                  const SizedBox(height: 24),
                  Text(
                    AppLocalizations.of(context).importing,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 260,
                    child: LinearProgressIndicator(
                      value: _importTotal == 0
                          ? 0
                          : _importedCount / _importTotal,
                      color: const Color(0xFFE53935),
                      backgroundColor: Colors.white24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('$_importedCount / $_importTotal',
                      style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  Text(
                    _importingCurrent,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TAB 2 — Copia de seguridad
// ═══════════════════════════════════════════════════════════════════════════════

class _BackupTab extends ConsumerStatefulWidget {
  const _BackupTab();

  @override
  ConsumerState<_BackupTab> createState() => _BackupTabState();
}

class _BackupTabState extends ConsumerState<_BackupTab> {
  /// Conciertos propios del usuario (userId vacío o coincide con el actual)
  List<ConcertModel> _ownConcerts    = [];
  /// Conciertos de amigos/compartidos — no se pueden restaurar
  List<ConcertModel> _sharedConcerts = [];

  final Set<int> _selectedIdx   = {};   // índices de _ownConcerts seleccionados
  List<ConcertModel> _failed    = [];   // los que fallaron en el último intento
  int  _restoredCount           = 0;
  bool _importing               = false;
  int  _importedCount           = 0;
  int  _importTotal             = 0;
  String _importingCurrent      = '';
  String? _errorMsg;
  String? _fileName;

  // Retrocompat: para que el resto del código siga funcionando
  List<ConcertModel> get _parsed => _ownConcerts;

  Future<void> _pickFile() async {
    setState(() {
      _ownConcerts    = [];
      _sharedConcerts = [];
      _failed        = [];
      _restoredCount = 0;
      _errorMsg      = null;
      _fileName      = null;
    });

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: false,
      withReadStream: false,
    );

    if (result == null || result.files.isEmpty) return;

    final path = result.files.single.path;
    if (path == null) return;

    try {
      final content  = await File(path).readAsString();
      final concerts = BackupImportService.parse(content);
      final currentUserId = AuthController.instance.user?.id ?? '';

      // Separamos propios (se pueden restaurar) de compartidos (no se pueden)
      final own    = concerts
          .where((c) => c.userId.isEmpty || c.userId == currentUserId)
          .toList();
      final shared = concerts
          .where((c) => c.userId.isNotEmpty && c.userId != currentUserId)
          .toList();

      setState(() {
        _ownConcerts    = own;
        _sharedConcerts = shared;
        _fileName = result.files.single.name;
        _errorMsg = null;
        // Solo los propios se preseleccionan
        _selectedIdx
          ..clear()
          ..addAll(List.generate(own.length, (i) => i));
      });
    } catch (e) {
      setState(() => _errorMsg = e.toString());
    }
  }

  /// Intenta subir [toImport]. Devuelve la lista de los que fallaron.
  Future<List<ConcertModel>> _runImport(List<ConcertModel> toImport) async {
    setState(() {
      _importing     = true;
      _importTotal   = toImport.length;
      _importedCount = 0;
      _importingCurrent = '';
    });

    final failed = <ConcertModel>[];

    for (final concert in toImport) {
      if (!mounted) return failed;
      setState(() {
        _importingCurrent =
            '${concert.artist}${concert.venue.isNotEmpty ? ' · ${concert.venue}' : ''}';
        _importedCount++;
      });

      try {
        await ConcertApiService().addConcert(concert);
      } catch (_) {
        failed.add(concert);
      }
    }

    ref.read(concertsProvider.notifier).reload().ignore();
    if (mounted) setState(() => _importing = false);
    return failed;
  }

  Future<void> _restore() async {
    if (_parsed.isEmpty || _selectedIdx.isEmpty) return;

    // ── Comprobación límite gratuito ────────────────────────────────────────
    final isPro        = AuthController.instance.user?.isPro ?? false;
    final currentCount = ref.read(ownConcertsCountProvider);
    final limit        = ProConfig.freeConcertLimit;
    final hueco        = limit - currentCount; // cuántos caben hasta el límite

    List<ConcertModel> toImport = [
      for (int i = 0; i < _parsed.length; i++)
        if (_selectedIdx.contains(i)) _parsed[i],
    ];

    if (!isPro && toImport.length > hueco) {
      // Mostrar diálogo de aviso
      if (!mounted) return;
      final action = await _showLimitDialog(
        selected:  toImport.length,
        hueco:     hueco.clamp(0, limit),
        currentCount: currentCount,
      );

      switch (action) {
        case _LimitAction.importFirst:
          // Reducir selección a los primeros que caben
          if (hueco <= 0) return;
          final indices = _selectedIdx.toList()..sort();
          final kept = indices.take(hueco).toSet();
          setState(() => _selectedIdx
            ..clear()
            ..addAll(kept));
          toImport = [
            for (int i = 0; i < _parsed.length; i++)
              if (_selectedIdx.contains(i)) _parsed[i],
          ];
        case _LimitAction.selectManually:
          // Volvemos sin importar, el usuario elige
          return;
        case _LimitAction.goPro:
          if (mounted) ProPaywallSheet.showPaywall(context);
          return;
        case null:
          return; // cancelado
      }
    }
    // ───────────────────────────────────────────────────────────────────────

    final failed = await _runImport(toImport);
    if (!mounted) return;

    final restored = toImport.length - failed.length;
    setState(() {
      _failed         = failed;
      _restoredCount  = restored;
      _ownConcerts    = [];
      _sharedConcerts = [];
      _selectedIdx.clear();
    });
  }

  /// Devuelve la acción que el usuario elige ante el límite gratuito.
  Future<_LimitAction?> _showLimitDialog({
    required int selected,
    required int hueco,
    required int currentCount,
  }) {
    final cs = Theme.of(context).colorScheme;
    return showModalBottomSheet<_LimitAction>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: cs.onSurface.withValues(alpha: .2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF8F00),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.warning_amber_rounded,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Límite de conciertos gratuito',
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'Tienes $currentCount conciertos de un máximo de ${ProConfig.freeConcertLimit} '
              'en la versión gratuita. Has seleccionado $selected conciertos para importar'
              '${hueco > 0 ? ', pero solo caben $hueco más.' : ' y ya has alcanzado el límite.'}',
              style: TextStyle(
                  fontSize: 14,
                  color: cs.onSurface.withValues(alpha: .7),
                  height: 1.5),
            ),
            const SizedBox(height: 20),
            if (hueco > 0) ...[
              _LimitOption(
                icon: Icons.filter_list_rounded,
                color: const Color(0xFF1E88E5),
                title: 'Importar los primeros $hueco',
                subtitle: 'Se importarán los primeros $hueco conciertos seleccionados',
                onTap: () => Navigator.pop(context, _LimitAction.importFirst),
              ),
              const SizedBox(height: 10),
            ],
            _LimitOption(
              icon: Icons.checklist_rounded,
              color: const Color(0xFF43A047),
              title: 'Elegir manualmente',
              subtitle: 'Vuelve a la lista y selecciona solo los que quieras',
              onTap: () => Navigator.pop(context, _LimitAction.selectManually),
            ),
            const SizedBox(height: 10),
            _LimitOption(
              icon: Icons.workspace_premium_rounded,
              color: const Color(0xFF7C3AED),
              title: 'Hazte Pro',
              subtitle: 'Sin límite de conciertos y más funciones',
              onTap: () => Navigator.pop(context, _LimitAction.goPro),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _retryFailed() async {
    if (_failed.isEmpty) return;
    final toRetry = List<ConcertModel>.from(_failed);

    final stillFailed = await _runImport(toRetry);
    if (!mounted) return;

    final restored = toRetry.length - stillFailed.length;
    setState(() {
      _failed        = stillFailed;
      _restoredCount = restored;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Cabecera ──────────────────────────────────────────────────
              Text(
                'Restaurar copia de seguridad',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Selecciona el archivo JSON generado desde Ajustes → Exportar mis conciertos para recuperar todos tus conciertos.',
                style: TextStyle(
                  fontSize: 14,
                  color: cs.onSurface.withValues(alpha: .55),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // ── Info de cómo exportar ─────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: cs.primary.withValues(alpha: .2),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded,
                        color: cs.primary, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Para crear una copia de seguridad ve a Ajustes → "Exportar mis conciertos" y elige JSON. El archivo incluye todos los datos e imágenes.',
                        style: TextStyle(
                          fontSize: 13,
                          color: cs.onSurface.withValues(alpha: .7),
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ── Botón seleccionar archivo ─────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _importing ? null : _pickFile,
                  icon: const Icon(Icons.folder_open_rounded),
                  label: Text(
                    _fileName != null
                        ? _fileName!
                        : 'Seleccionar archivo JSON',
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              // Error
              if (_errorMsg != null) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cs.error.withValues(alpha: .08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: cs.error.withValues(alpha: .25)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline_rounded,
                          color: cs.error, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Archivo no válido: $_errorMsg',
                          style: TextStyle(
                              color: cs.error, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // ── Lista previa: conciertos a restaurar ─────────────────────
              if (_ownConcerts.isNotEmpty || _sharedConcerts.isNotEmpty) ...[
                const SizedBox(height: 24),

                // Banner de compartidos (solo si hay)
                if (_sharedConcerts.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: .08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.amber.withValues(alpha: .3)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.group_off_outlined,
                            color: Colors.amber, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${_sharedConcerts.length} concierto${_sharedConcerts.length == 1 ? '' : 's'} compartido${_sharedConcerts.length == 1 ? '' : 's'} de amigos no se pueden restaurar — solo puedes recuperar tus propios conciertos.',
                            style: TextStyle(
                              fontSize: 13,
                              color: cs.onSurface.withValues(alpha: .75),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ],

              if (_parsed.isNotEmpty) ...[
                if (_sharedConcerts.isEmpty) const SizedBox(height: 24),
                // Cabecera con contador y toggle seleccionar todo
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${_parsed.length} conciertos propios',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => setState(() {
                        if (_selectedIdx.length == _parsed.length) {
                          _selectedIdx.clear();
                        } else {
                          _selectedIdx.addAll(
                              List.generate(_parsed.length, (i) => i));
                        }
                      }),
                      child: Text(
                        _selectedIdx.length == _parsed.length
                            ? 'Deseleccionar todo'
                            : 'Seleccionar todo',
                        style: const TextStyle(
                            color: Color(0xFFE53935), fontSize: 13),
                      ),
                    ),
                  ],
                ),
                if (_selectedIdx.isNotEmpty) ...[
                  Text(
                    '${_selectedIdx.length} seleccionado${_selectedIdx.length == 1 ? '' : 's'}',
                    style: TextStyle(
                      fontSize: 13,
                      color: const Color(0xFFE53935).withValues(alpha: .8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: (_importing || _selectedIdx.isEmpty)
                        ? null
                        : _restore,
                    icon: const Icon(Icons.restore_rounded, size: 18),
                    label: Text(
                      _selectedIdx.length == _parsed.length
                          ? 'Restaurar todo'
                          : 'Restaurar ${_selectedIdx.length} seleccionado${_selectedIdx.length == 1 ? '' : 's'}',
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFE53935),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                ...List.generate(
                  _parsed.length,
                  (i) => _concertTile(_parsed[i], cs, index: i),
                ),

                // ── Compartidos (solo visual, no seleccionables) ───────────
                if (_sharedConcerts.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    '${_sharedConcerts.length} compartido${_sharedConcerts.length == 1 ? '' : 's'} (no restaurables)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface.withValues(alpha: .45),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._sharedConcerts.map((c) => _sharedTile(c, cs)),
                ],
              ],

              // ── Resultado: fallidos con reintento ────────────────────────
              if (_failed.isNotEmpty || (_restoredCount > 0 && _parsed.isEmpty)) ...[
                const SizedBox(height: 24),

                // Resumen
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _failed.isEmpty
                        ? Colors.green.withValues(alpha: .1)
                        : Colors.orange.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _failed.isEmpty
                          ? Colors.green.withValues(alpha: .3)
                          : Colors.orange.withValues(alpha: .3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _failed.isEmpty
                            ? Icons.check_circle_rounded
                            : Icons.warning_amber_rounded,
                        color: _failed.isEmpty ? Colors.green : Colors.orange,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _failed.isEmpty
                              ? '$_restoredCount conciertos restaurados correctamente ✅'
                              : '$_restoredCount restaurados · ${_failed.length} fallaron',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Lista de fallidos + botón reintentar
                if (_failed.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Conciertos que fallaron:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface.withValues(alpha: .7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._failed.map((c) => _concertTile(c, cs, isError: true)),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _importing ? null : _retryFailed,
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text('Reintentar ${_failed.length} fallidos'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange,
                        side: const BorderSide(color: Colors.orange),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),

        // Overlay mientras importa
        if (_importing)
          Container(
            color: Colors.black87,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                      color: Color(0xFFE53935)),
                  const SizedBox(height: 24),
                  const Text(
                    'Restaurando...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 260,
                    child: LinearProgressIndicator(
                      value: _importTotal == 0
                          ? 0
                          : _importedCount / _importTotal,
                      color: const Color(0xFFE53935),
                      backgroundColor: Colors.white24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$_importedCount / $_importTotal',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _importingCurrent,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _concertTile(
    ConcertModel c,
    ColorScheme cs, {
    bool isError = false,
    int? index,
  }) {
    final dt = c.date;
    final dateStr =
        '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';

    // Si tenemos índice, es un tile seleccionable (lista previa)
    final isSelectable = index != null;
    final isSelected = isSelectable && _selectedIdx.contains(index);

    Widget tile = Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isError
            ? Colors.orange.withValues(alpha: .07)
            : isSelected
                ? const Color(0xFFE53935).withValues(alpha: .07)
                : cs.surfaceContainerHighest.withValues(alpha: .5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isError
              ? Colors.orange.withValues(alpha: .3)
              : isSelected
                  ? const Color(0xFFE53935).withValues(alpha: .4)
                  : cs.outline.withValues(alpha: .1),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: c.imageUrl.isNotEmpty
                ? Image.network(
                    c.imageUrl,
                    width: 44, height: 44,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(c.artist, cs),
                  )
                : _placeholder(c.artist, cs),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.artist,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '$dateStr${c.venue.isNotEmpty ? '  ·  ${c.venue}' : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    color: cs.onSurface.withValues(alpha: .55),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Trailing: checkbox (seleccionable), error icon, o rating
          if (isSelectable)
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 24, height: 24,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFE53935)
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFE53935)
                      : cs.onSurface.withValues(alpha: .3),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 14)
                  : null,
            )
          else if (isError)
            const Icon(Icons.error_outline_rounded,
                size: 18, color: Colors.orange)
          else if (c.rating > 0)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                const SizedBox(width: 2),
                Text('${c.rating}',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
        ],
      ),
    );

    if (isSelectable) {
      return GestureDetector(
        onTap: () => setState(() {
          if (_selectedIdx.contains(index)) {
            _selectedIdx.remove(index);
          } else {
            _selectedIdx.add(index);
          }
        }),
        child: tile,
      );
    }
    return tile;
  }

  /// Tile de solo lectura para conciertos compartidos (no restaurables)
  Widget _sharedTile(ConcertModel c, ColorScheme cs) {
    final dt = c.date;
    final dateStr =
        '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    return Opacity(
      opacity: 0.45,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withValues(alpha: .3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outline.withValues(alpha: .08)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: c.imageUrl.isNotEmpty
                  ? Image.network(c.imageUrl,
                      width: 44, height: 44,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(c.artist, cs))
                  : _placeholder(c.artist, cs),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.artist,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(
                    '$dateStr${c.venue.isNotEmpty ? '  ·  ${c.venue}' : ''}',
                    style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurface.withValues(alpha: .55)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (c.userName.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      'De: ${c.userName}',
                      style: TextStyle(
                          fontSize: 11,
                          color: cs.onSurface.withValues(alpha: .4)),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.group_rounded, size: 16, color: Colors.amber),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(String artist, ColorScheme cs) {

    final hue = artist.isNotEmpty
        ? (artist.codeUnitAt(0) * 137.5) % 360
        : 0.0;
    final bg = HSLColor.fromAHSL(1, hue, 0.4, 0.25).toColor();
    return Container(
      width: 44, height: 44,
      color: bg,
      child: Center(
        child: Text(
          artist.isNotEmpty ? artist[0].toUpperCase() : '?',
          style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Enum y widget auxiliar para el diálogo de límite Pro
// ─────────────────────────────────────────────────────────────────────────────

enum _LimitAction { importFirst, selectManually, goPro }

class _LimitOption extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _LimitOption({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: .2)),
        ),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurface.withValues(alpha: .55))),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: cs.onSurface.withValues(alpha: .3)),
          ],
        ),
      ),
    );
  }
}
