import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/app_page.dart';
import '../../../../shared/widgets/concert_card.dart';
import '../../../../shared/widgets/concert_grid_card.dart';
import '../../data/models/concert_model.dart';
import '../../domain/entities/concert.dart';
import '../providers/concerts_provider.dart';

class ConcertsPage extends ConsumerStatefulWidget {
  const ConcertsPage({super.key});

  @override
  ConsumerState<ConcertsPage> createState() => _ConcertsPageState();
}

class _ConcertsPageState extends ConsumerState<ConcertsPage> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  bool _gridView = false;
  bool _deleting = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filtramos la lista del provider en tiempo real, sin estado local duplicado.
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
    final updated = ConcertModel.fromEntity(
      concert.copyWith(favorite: !concert.favorite),
    );
    try {
      await ref.read(concertsProvider.notifier).updateOne(updated);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo actualizar el favorito')),
      );
    }
  }

  Future<void> _toggleLike(Concert concert) async {
    final updated = ConcertModel.fromEntity(
      concert.copyWith(liked: !concert.liked),
    );
    try {
      await ref.read(concertsProvider.notifier).updateOne(updated);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo actualizar "Me gusta"')),
      );
    }
  }

  Future<void> _updateRating(Concert concert, int rating) async {
    final updated = ConcertModel.fromEntity(concert.copyWith(rating: rating));
    try {
      await ref.read(concertsProvider.notifier).updateOne(updated);
    } catch (_) {
      // Fallo silencioso para el rating — el rollback lo hace el notifier.
    }
  }

  Future<void> _deleteConcert(Concert concert) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar concierto'),
        content: Text('¿Seguro que quieres eliminar "${concert.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Eliminar'),
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
      ).showSnackBar(SnackBar(content: Text('"${concert.name}" eliminado')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo eliminar el concierto')),
      );
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final concertsAsync = ref.watch(concertsProvider);

    return AppPage(
      title: 'Conciertos',
      actions: [
        IconButton(
          tooltip: _gridView ? 'Vista lista' : 'Vista tarjetas',
          onPressed: () => setState(() => _gridView = !_gridView),
          icon: Icon(
            _gridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () async {
              final result = await context.push('/add');
              if (result == true) {
                await ref.read(concertsProvider.notifier).reload();
              }
            },
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
                  const Icon(Icons.wifi_off, size: 48, color: Colors.white38),
                  const SizedBox(height: 12),
                  const Text(
                    'Error al cargar conciertos',
                    style: TextStyle(color: Colors.white54),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => ref.invalidate(concertsProvider),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
            data: (concerts) {
              final filtered = _filtered(concerts);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'Artista, festival, ciudad, recinto...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: const Icon(Icons.tune),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${filtered.length} conciertos',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      child: _gridView
                          ? _GridView(
                              key: const ValueKey('grid'),
                              concerts: filtered,
                              onEdit: (c) async {
                                final result = await context.push(
                                  '/add',
                                  extra: c,
                                );
                                if (result == true) {
                                  await ref
                                      .read(concertsProvider.notifier)
                                      .reload();
                                }
                              },
                              onDelete: _deleteConcert,
                            )
                          : _ListView(
                              key: const ValueKey('list'),
                              concerts: filtered,
                              onLike: _toggleLike,
                              onFavorite: _toggleFavorite,
                              onRatingChanged: _updateRating,
                              onEdit: (c) async {
                                final result = await context.push(
                                  '/add',
                                  extra: c,
                                );
                                if (result == true) {
                                  await ref
                                      .read(concertsProvider.notifier)
                                      .reload();
                                }
                              },
                              onDelete: _deleteConcert,
                            ),
                    ),
                  ),
                ],
              );
            },
          ),
          if (_deleting)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text(
                      'Eliminando concierto...',
                      style: TextStyle(color: Colors.white, fontSize: 18),
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
// Sub-widgets internos para reducir el build method
// ---------------------------------------------------------------------------

class _GridView extends StatelessWidget {
  final List<Concert> concerts;
  final ValueChanged<Concert> onEdit;
  final ValueChanged<Concert> onDelete;

  const _GridView({
    super.key,
    required this.concerts,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      itemCount: concerts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        mainAxisExtent: 307,
      ),
      itemBuilder: (context, index) {
        final concert = concerts[index];
        return ConcertGridCard(
          concert: concert,
          onTap: () => context.push('/concert-detail', extra: concert),
          onEdit: () => onEdit(concert),
          onDelete: () => onDelete(concert),
        );
      },
    );
  }
}

class _ListView extends StatelessWidget {
  final List<Concert> concerts;
  final ValueChanged<Concert> onLike;
  final ValueChanged<Concert> onFavorite;
  final void Function(Concert, int) onRatingChanged;
  final ValueChanged<Concert> onEdit;
  final ValueChanged<Concert> onDelete;

  const _ListView({
    super.key,
    required this.concerts,
    required this.onLike,
    required this.onFavorite,
    required this.onRatingChanged,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: concerts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 24),
      itemBuilder: (context, index) {
        final concert = concerts[index];
        return ConcertCard(
          concert: concert,
          onImageTap: () => context.push('/concert-detail', extra: concert),
          onLike: () => onLike(concert),
          onFavorite: () => onFavorite(concert),
          onRatingChanged: (r) => onRatingChanged(concert, r),
          onEdit: () => onEdit(concert),
          onDelete: () => onDelete(concert),
        );
      },
    );
  }
}
