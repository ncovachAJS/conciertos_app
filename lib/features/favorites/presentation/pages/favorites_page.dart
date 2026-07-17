import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/app_page.dart';
import '../../../../shared/widgets/concert_card.dart';
import '../../../../shared/widgets/concert_grid_card.dart';
import '../../../concerts/data/models/concert_model.dart';
import '../../../concerts/domain/entities/concert.dart';
import '../../../concerts/presentation/providers/concerts_provider.dart';

class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({super.key});

  @override
  ConsumerState<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends ConsumerState<FavoritesPage> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  bool _gridView = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Concert> _filtered(List<Concert> all) {
    if (_searchQuery.trim().isEmpty) return all;
    final q = _searchQuery.toLowerCase();
    return all.where((c) {
      return c.artist.toLowerCase().contains(q) ||
          c.festival.toLowerCase().contains(q) ||
          c.name.toLowerCase().contains(q);
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
    } catch (_) {}
  }

  Future<void> _updateRating(Concert concert, int rating) async {
    final updated = ConcertModel.fromEntity(concert.copyWith(rating: rating));
    try {
      await ref.read(concertsProvider.notifier).updateOne(updated);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    // favoriteConcertsProvider ya filtra por c.favorite == true
    final concertsAsync = ref.watch(concertsProvider);
    final favorites = ref.watch(favoriteConcertsProvider);
    final filtered = _filtered(favorites);

    return AppPage(
      title: 'Favoritos',
      actions: [
        IconButton(
          tooltip: _gridView ? 'Vista lista' : 'Vista tarjetas',
          onPressed: () => setState(() => _gridView = !_gridView),
          icon: Icon(
            _gridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
          ),
        ),
      ],
      child: concertsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, size: 48, color: Colors.white38),
              const SizedBox(height: 12),
              const Text(
                'Error al cargar favoritos',
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
        data: (_) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Buscar favorito...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${filtered.length} favoritos',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(
                      child: Text(
                        'Todavía no tienes favoritos.',
                        style: TextStyle(color: Colors.white54, fontSize: 16),
                      ),
                    )
                  : AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _gridView
                          ? GridView.builder(
                              key: const ValueKey('grid'),
                              padding: EdgeInsets.zero,
                              itemCount: filtered.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 18,
                                    mainAxisSpacing: 18,
                                    childAspectRatio: .62,
                                  ),
                              itemBuilder: (_, index) {
                                final concert = filtered[index];
                                return ConcertGridCard(
                                  concert: concert,
                                  onTap: () => context.push(
                                    '/concert-detail',
                                    extra: concert,
                                  ),
                                  onEdit: () async {
                                    final result = await context.push(
                                      '/add',
                                      extra: concert,
                                    );
                                    if (result == true) {
                                      await ref
                                          .read(concertsProvider.notifier)
                                          .reload();
                                    }
                                  },
                                  onDelete: () {},
                                );
                              },
                            )
                          : ListView.separated(
                              key: const ValueKey('list'),
                              itemCount: filtered.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 24),
                              itemBuilder: (_, index) {
                                final concert = filtered[index];
                                return ConcertCard(
                                  concert: concert,
                                  onImageTap: () => context.push(
                                    '/concert-detail',
                                    extra: concert,
                                  ),
                                  onLike: () => _toggleLike(concert),
                                  onFavorite: () => _toggleFavorite(concert),
                                  onRatingChanged: (r) =>
                                      _updateRating(concert, r),
                                  onEdit: () async {
                                    final result = await context.push(
                                      '/add',
                                      extra: concert,
                                    );
                                    if (result == true) {
                                      await ref
                                          .read(concertsProvider.notifier)
                                          .reload();
                                    }
                                  },
                                  onDelete: () {},
                                );
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
