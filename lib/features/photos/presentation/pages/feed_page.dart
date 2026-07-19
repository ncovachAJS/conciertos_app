import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_page.dart';
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
    final count = _selected.length;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar fotos'),
        content: Text(
          '¿Seguro que quieres eliminar $count ${count == 1 ? 'foto' : 'fotos'}?\nEsta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

    setState(() => _deleting = true);
    final toDelete = List<String>.from(_selected);

    for (final id in toDelete) {
      try {
        await _service.deletePhoto(id);
      } catch (_) {}
    }

    if (!mounted) return;
    setState(() {
      _photos = _photos.where((p) => !toDelete.contains(p.id)).toList();
      _selected.clear();
      _deleting = false;
    });
  }

  void _openPhoto(List<ConcertPhotoModel> photos, int index) {
    if (_selecting) return; // en selección el tap selecciona, no abre
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PhotoViewerPage(photos: photos, initialIndex: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_loading) {
      return const AppPage(
        title: 'Recuerdos',
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_photos.isEmpty) {
      return AppPage(
        title: 'Recuerdos',
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
                  'Aún no hay recuerdos.\nAñade fotos desde el detalle de un concierto.',
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

    final byYear = groupBy<ConcertPhotoModel, int>(
      _photos,
      (p) => p.concert?.date.year ?? 0,
    );
    final years = byYear.keys.toList()..sort((a, b) => b.compareTo(a));

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
                      ? Text(
                          '${_selected.length} seleccionada${_selected.length == 1 ? '' : 's'}',
                        )
                      : const Text('Recuerdos'),
                  leading: _selecting
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: _cancelSelection,
                        )
                      : null,
                  actions: [
                    if (_selecting)
                      IconButton(
                        tooltip: 'Eliminar selección',
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                        ),
                        onPressed: _deleteSelected,
                      )
                    else ...[
                      IconButton(
                        tooltip: _timelineMode
                            ? 'Ver en cuadrícula'
                            : 'Ver en timeline',
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
                          year == 0 ? 'Sin fecha' : '$year',
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
                                        photo.imageUrl,
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
                                year == 0 ? 'Sin fecha' : '$year',
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
                          final yearPhotos = byYear[year]!;
                          final byConcert = groupBy<ConcertPhotoModel, String>(
                            yearPhotos,
                            (p) => p.concertId,
                          );
                          final concertIds = byConcert.keys.toList();
                          concertIds.sort((a, b) {
                            final da =
                                byConcert[a]!.first.concert?.date ??
                                DateTime(0);
                            final db =
                                byConcert[b]!.first.concert?.date ??
                                DateTime(0);
                            return db.compareTo(da);
                          });

                          if (i >= concertIds.length) return null;

                          final concertId = concertIds[i];
                          final concertPhotos = byConcert[concertId]!;
                          final ref = concertPhotos.first.concert;
                          final isLast = i == concertIds.length - 1;
                          final globalStart = yearPhotos.indexWhere(
                            (p) => p.concertId == concertId,
                          );

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
                                          height: concertPhotos.length == 1
                                              ? 180
                                              : 140,
                                          child: concertPhotos.length == 1
                                              ? _SinglePhoto(
                                                  photo: concertPhotos.first,
                                                  onTap: () => _openPhoto(
                                                    yearPhotos,
                                                    globalStart,
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
                                                          yearPhotos,
                                                          globalStart + j,
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
                        childCount: groupBy<ConcertPhotoModel, String>(
                          byYear[year]!,
                          (p) => p.concertId,
                        ).length,
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
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Eliminando fotos...',
                    style: TextStyle(color: Colors.white, fontSize: 16),
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

// ── Foto única (más grande) ────────────────────────────────────────────────

class _SinglePhoto extends StatelessWidget {
  final ConcertPhotoModel photo;
  final VoidCallback onTap;

  const _SinglePhoto({required this.photo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: photo.id,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: photo.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            placeholder: (_, __) => Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            errorWidget: (_, __, ___) => Container(
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
            imageUrl: photo.imageUrl,
            fit: BoxFit.cover,
            width: 120,
            height: 140,
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
