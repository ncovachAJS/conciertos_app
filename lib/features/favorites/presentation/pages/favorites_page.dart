import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/app_page.dart';
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Agrupa los conciertos favoritos por artista.
  /// Devuelve un mapa artista → lista de sus conciertos favoritos.
  Map<String, List<Concert>> _groupByArtist(List<Concert> favorites) {
    final map = <String, List<Concert>>{};
    for (final c in favorites) {
      final artist = c.artist.trim();
      if (artist.isEmpty) continue;
      map.putIfAbsent(artist, () => []).add(c);
    }
    return map;
  }

  List<MapEntry<String, List<Concert>>> _filtered(
    Map<String, List<Concert>> grouped,
  ) {
    final entries = grouped.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    if (_searchQuery.trim().isEmpty) return entries;
    final q = _searchQuery.toLowerCase();
    return entries.where((e) => e.key.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final concertsAsync = ref.watch(concertsProvider);
    final favorites = ref.watch(favoriteConcertsProvider);
    final grouped = _groupByArtist(favorites);
    final filtered = _filtered(grouped);
    final cs = Theme.of(context).colorScheme;

    return AppPage(
      title: 'Favoritos',
      child: concertsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.wifi_off,
                size: 48,
                color: cs.onSurface.withOpacity(0.38),
              ),
              const SizedBox(height: 12),
              Text(
                'Error al cargar favoritos',
                style: TextStyle(color: cs.onSurface.withOpacity(0.54)),
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
            // Buscador
            TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Buscar artista...',
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
              '${filtered.length} artista${filtered.length != 1 ? "s" : ""}',
              style: TextStyle(
                color: cs.onSurface.withOpacity(0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),

            // Grid de artistas
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'Todavía no tienes favoritos.',
                        style: TextStyle(
                          color: cs.onSurface.withOpacity(0.54),
                          fontSize: 16,
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: filtered.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.75,
                          ),
                      itemBuilder: (_, index) {
                        final entry = filtered[index];
                        final artist = entry.key;
                        final concerts = entry.value;
                        // Usamos la imagen del concierto más reciente
                        concerts.sort((a, b) => b.date.compareTo(a.date));
                        final imageUrl = concerts.first.imageUrl;

                        return _ArtistCard(
                          artist: artist,
                          imageUrl: imageUrl,
                          concertCount: concerts.length,
                          onTap: () =>
                              _openArtistConcerts(context, artist, concerts),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _openArtistConcerts(
    BuildContext context,
    String artist,
    List<Concert> concerts,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) =>
          _ArtistConcertsSheet(artist: artist, concerts: concerts),
    );
  }
}

// ── Tarjeta de artista ────────────────────────────────────────────────────────

class _ArtistCard extends StatelessWidget {
  final String artist;
  final String imageUrl;
  final int concertCount;
  final VoidCallback onTap;

  const _ArtistCard({
    required this.artist,
    required this.imageUrl,
    required this.concertCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen cuadrada
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      fadeInDuration: Duration.zero,
                      errorWidget: (_, __, ___) => Container(
                        color: cs.surfaceContainerHighest,
                        child: Icon(
                          Icons.music_note,
                          size: 48,
                          color: cs.onSurface.withOpacity(0.2),
                        ),
                      ),
                    ),
                    // Badge de conciertos
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$concertCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Nombre
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '$concertCount concierto${concertCount != 1 ? "s" : ""}',
                    style: TextStyle(
                      color: cs.onSurface.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bottom sheet con los conciertos del artista ───────────────────────────────

class _ArtistConcertsSheet extends StatelessWidget {
  final String artist;
  final List<Concert> concerts;

  const _ArtistConcertsSheet({required this.artist, required this.concerts});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.92,
      minChildSize: 0.3,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: cs.onSurface.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(Icons.music_note, color: Color(0xFFE53935)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      artist,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${concerts.length} concierto${concerts.length != 1 ? "s" : ""}',
                    style: TextStyle(
                      color: cs.onSurface.withOpacity(0.5),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: concerts.length,
                itemBuilder: (_, i) {
                  final c = concerts[i];
                  return ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/concert-detail', extra: c);
                    },
                    leading: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935).withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.music_note,
                        color: Color(0xFFE53935),
                        size: 20,
                      ),
                    ),
                    title: Text(
                      c.venue,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      '${c.date.day}/${c.date.month}/${c.date.year} · ${c.city}',
                      style: TextStyle(
                        color: cs.onSurface.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                    trailing: c.rating > 0
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              c.rating,
                              (_) => const Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 14,
                              ),
                            ),
                          )
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
