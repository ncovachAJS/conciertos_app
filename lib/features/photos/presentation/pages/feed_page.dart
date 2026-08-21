import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:conciertos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../core/tutorial/tutorial_content.dart';
import '../../../../core/tutorial/tutorial_overlay.dart';
import '../../../../core/tutorial/tutorial_service.dart';

import '../../../../core/utils/cloudinary_utils.dart';
import '../../../../shared/widgets/app_page.dart';
import '../../../../shared/widgets/skeletons/generic_page_skeleton.dart';
import '../../data/models/concert_photo_model.dart';
import '../../data/services/photo_api_service.dart';
import 'photo_viewer_page.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage>
    with AutomaticKeepAliveClientMixin {
  final PhotoApiService _service = PhotoApiService();
  List<ConcertPhotoModel> _photos = [];
  bool _loading = true;
  bool _timelineMode = false;

  // Selección múltiple — solo en modo cuadrícula
  final Set<String> _selected = {};
  bool get _selecting => _selected.isNotEmpty;
  bool _deleting = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _load();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _showTutorialIfNeeded(),
    );
  }

  Future<void> _showTutorialIfNeeded() async {
    final should = await TutorialService.shouldShow(TutorialService.feed);
    if (!should || !mounted) return;
    await TutorialService.markShown(TutorialService.feed);
    if (!mounted) return;
    await TutorialOverlay.show(
      context,
      steps: TutorialContent.feed(AppLocalizations.of(context)),
    );
  }

  Future<void> _load() async {
    try {
      final photos = await _service.getFeed();
      if (!mounted) return;
      setState(() {
        _photos = photos;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  void _toggleSelect(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else {
        _selected.add(id);
      }
    });
  }

  void _cancelSelection() => setState(() => _selected.clear());

  Future<void> _deleteSelected() async {
    final l = AppLocalizations.of(context);
    final count = _selected.length;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.deletePhotosTitle),
        content: Text(l.deletePhotosConfirm(count)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.delete),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

    setState(() => _deleting = true);
    final toDelete = List<String>.from(_selected);

    await Future.wait(
      toDelete.map((id) => _service.deletePhoto(id).catchError((_) {})),
    );

    if (!mounted) return;
    setState(() {
      _photos = _photos.where((p) => !toDelete.contains(p.id)).toList();
      _selected.clear();
      _deleting = false;
    });
  }

  void _openPhoto(List<ConcertPhotoModel> photos, int index) {
    if (_selecting) return; // en selección el tap selecciona, no abre
    Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => PhotoViewerPage(
          photos: photos,
          initialIndex: index,
          onDelete: (p) async {
            await _service.deletePhoto(p.id);
          },
          onTagFriend: (p, friendId) async {
            return await _service.tagFriend(p.id, friendId);
          },
          onUntagFriend: (p, friendId) async {
            return await _service.untagFriend(p.id, friendId);
          },
        ),
      ),
    ).then((deletedId) {
      if (deletedId != null && mounted) {
        setState(() => _photos = _photos.where((p) => p.id != deletedId).toList());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l = AppLocalizations.of(context);

    if (_loading) {
      return AppPage(
        title: l.memoriesTitle,
        child: const GenericGridSkeleton(itemCount: 12),
      );
    }

    if (_photos.isEmpty) {
      return AppPage(
        title: l.memoriesTitle,
        child: RefreshIndicator(
          onRefresh: _load,
          child: ListView(
            children: [
              const SizedBox(height: 120),
              Icon(
                Icons.photo_library_outlined,
                size: 80,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withOpacity(0.15),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  l.noMemories,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.4),
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Deduplicar por id — el backend puede devolver la misma foto varias veces
    // si el usuario es dueño del concierto y además está etiquetado
    final seen = <String>{};
    final uniquePhotos = _photos.where((p) => seen.add(p.id)).toList();

    // Clave para fusionar conciertos del mismo artista y día aunque tengan distinto ID
    String concertKey(ConcertPhotoModel p) {
      final artist = (p.concert?.artist ?? '').toLowerCase().trim();
      final date = p.concert?.date;
      if (artist.isEmpty || date == null) return p.concertId;
      return '$artist|${date.year}-${date.month}-${date.day}';
    }

    final byYear = groupBy<ConcertPhotoModel, int>(
      uniquePhotos,
      (p) => p.concert?.date.year ?? 0,
    );
    final years = byYear.keys.toList()..sort((a, b) => b.compareTo(a));

    // Agrupación por concierto para el modo timeline, precalculada una vez por
    // año (antes se recalculaba dentro de cada itemBuilder).
    final concertGroupsByYear = <int, List<List<ConcertPhotoModel>>>{
      for (final year in years)
        year: groupBy<ConcertPhotoModel, String>(byYear[year]!, concertKey)
            .values
            .toList()
          ..sort((a, b) {
            final da = a.first.concert?.date ?? DateTime(0);
            final db = b.first.concert?.date ?? DateTime(0);
            return db.compareTo(da);
          }),
    };

    final cs = Theme.of(context).colorScheme;
    const lineColor = Color(0xFFE53935);
    const dotSize = 14.0;
    const lineWidth = 2.0;
    const leftPad = 24.0;
    const dotToContent = 16.0;

    return Stack(
      children: [
        Scaffold(
          body: RefreshIndicator(
            onRefresh: _selecting ? () async {} : _load,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── AppBar ──────────────────────────────────────────────
                SliverAppBar(
                  floating: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  title: _selecting
                      ? Text(l.selectedCount(_selected.length))
                      : Text(l.memoriesTitle),
                  leading: _selecting
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: _cancelSelection,
                        )
                      : null,
                  actions: [
                    if (_selecting)
                      IconButton(
                        tooltip: l.deleteSelection,
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                        ),
                        onPressed: _deleteSelected,
                      )
                    else ...[
                      IconButton(
                        tooltip: _timelineMode
                            ? l.gridView
                            : l.timelineView,
                        icon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            _timelineMode
                                ? Icons.grid_view_rounded
                                : Icons.view_timeline_outlined,
                            key: ValueKey(_timelineMode),
                          ),
                        ),
                        onPressed: () => setState(() {
                          _timelineMode = !_timelineMode;
                          _selected.clear();
                        }),
                      ),
                    ],
                  ],
                ),

                // ── Modo cuadrícula ──────────────────────────────────────
                if (!_timelineMode)
                  for (final year in years) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                        child: Text(
                          year == 0 ? l.noDate : '$year',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate((_, j) {
                          final yearPhotos = byYear[year]!;
                          final photo = yearPhotos[j];
                          final isSelected = _selected.contains(photo.id);

                          return GestureDetector(
                            onTap: _selecting
                                ? () => _toggleSelect(photo.id)
                                : () => _openPhoto(yearPhotos, j),
                            onLongPress: !_selecting
                                ? () => _toggleSelect(photo.id)
                                : null,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              decoration: isSelected
                                  ? BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xFFE53935),
                                        width: 3,
                                      ),
                                    )
                                  : null,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Hero(
                                    tag: photo.id,
                                    child: Image(
                                      image: CachedNetworkImageProvider(
                                        cloudinaryThumbnail(photo.imageUrl, width: 400),
                                        maxWidth: 400,
                                      ),
                                      fit: BoxFit.cover,
                                      gaplessPlayback: true,
                                      frameBuilder:
                                          (_, child, frame, wasSyncLoaded) {
                                            if (wasSyncLoaded || frame != null)
                                              return child;
                                            return Container(
                                              color: cs.surfaceContainerHighest,
                                            );
                                          },
                                      errorBuilder: (_, __, ___) => Container(
                                        color: cs.surfaceContainerHighest,
                                        child: Icon(
                                          Icons.broken_image_outlined,
                                          color: cs.onSurface.withOpacity(0.2),
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Overlay oscuro + check cuando está seleccionada
                                  if (isSelected)
                                    Container(
                                      color: Colors.black.withOpacity(0.4),
                                      child: const Center(
                                        child: Icon(
                                          Icons.check_circle_rounded,
                                          color: Color(0xFFE53935),
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                  // Hint de pulsación larga cuando no se está seleccionando
                                  if (_selecting && !isSelected)
                                    Container(color: Colors.transparent),
                                ],
                              ),
                            ),
                          );
                        }, childCount: byYear[year]!.length),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 2,
                              childAspectRatio: 1,
                            ),
                      ),
                    ),
                  ],

                // ── Modo timeline ────────────────────────────────────────
                if (_timelineMode)
                  for (final year in years) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 32, 16, 8),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: lineColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                year == 0 ? l.noDate : '$year',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Divider(
                                color: cs.onSurface.withOpacity(0.12),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          final groups = concertGroupsByYear[year]!;
                          if (i >= groups.length) return null;

                          final concertPhotos = groups[i];
                          final ref = concertPhotos.first.concert;
                          final isLast = i == groups.length - 1;

                          return IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: leftPad + dotSize,
                                  child: Stack(
                                    alignment: Alignment.topCenter,
                                    children: [
                                      Positioned(
                                        top: 0,
                                        bottom: isLast ? dotSize / 2 : 0,
                                        left: leftPad - lineWidth / 2,
                                        child: Container(
                                          width: lineWidth,
                                          color: lineColor.withOpacity(0.3),
                                        ),
                                      ),
                                      Positioned(
                                        top: 16,
                                        left: leftPad - dotSize / 2,
                                        child: Container(
                                          width: dotSize,
                                          height: dotSize,
                                          decoration: BoxDecoration(
                                            color: lineColor,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: cs.surface,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                      dotToContent,
                                      10,
                                      16,
                                      isLast ? 16 : 24,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (ref != null) ...[
                                          Text(
                                            ref.artist.isNotEmpty
                                                ? ref.artist
                                                : ref.name,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: cs.onSurface,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            [
                                              if (ref.venue.isNotEmpty)
                                                ref.venue,
                                              if (ref.city.isNotEmpty) ref.city,
                                            ].join(' · '),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: cs.onSurface.withOpacity(
                                                0.5,
                                              ),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            _formatDate(ref.date),
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: lineColor.withOpacity(0.8),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                        SizedBox(
                                          height: 140,
                                          child: concertPhotos.length == 1
                                              ? Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: _ThumbPhoto(
                                                    photo: concertPhotos.first,
                                                    onTap: () => _openPhoto(
                                                        concertPhotos, 0),
                                                  ),
                                                )
                                              : ListView.separated(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      concertPhotos.length,
                                                  separatorBuilder: (_, __) =>
                                                      const SizedBox(width: 6),
                                                  itemBuilder: (_, j) =>
                                                      _ThumbPhoto(
                                                        photo: concertPhotos[j],
                                                        onTap: () => _openPhoto(
                                                          concertPhotos,
                                                          j,
                                                        ),
                                                      ),
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        childCount: concertGroupsByYear[year]!.length,
                      ),
                    ),
                  ],

                const SliverToBoxAdapter(child: SizedBox(height: 48)),
              ],
            ),
          ),
        ),

        // ── Overlay de carga al borrar ─────────────────────────────────
        if (_deleting)
          Container(
            color: Colors.black54,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    l.deletingPhotos,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}

// ── Miniatura en fila horizontal ───────────────────────────────────────────

class _ThumbPhoto extends StatelessWidget {
  final ConcertPhotoModel photo;
  final VoidCallback onTap;

  const _ThumbPhoto({required this.photo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: photo.id,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: cloudinaryThumbnail(photo.imageUrl, width: 240),
            fit: BoxFit.cover,
            width: 120,
            height: 140,
            memCacheWidth: 240,
            fadeInDuration: Duration.zero,
            placeholder: (_, __) => Container(
              width: 120,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            errorWidget: (_, __, ___) => Container(
              width: 120,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Icon(
                Icons.broken_image_outlined,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
