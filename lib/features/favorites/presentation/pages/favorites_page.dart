import 'package:conciertos_app/shared/widgets/concert_grid_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/app_page.dart';
import '../../../../shared/widgets/concert_card_v2.dart';
import '../../../concerts/data/services/concert_api_service.dart';
import '../../../concerts/domain/entities/concert.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final TextEditingController _searchController = TextEditingController();

  List<Concert> favorites = [];
  List<Concert> filteredFavorites = [];

  bool loading = true;
  bool gridView = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      loading = true;
    });

    try {
      final concerts = await ConcertApiService().getConcerts();

      favorites = concerts.where((c) => c.liked).toList()
        ..sort((a, b) => b.date.compareTo(a.date));

      filteredFavorites = List.from(favorites);
    } catch (e) {
      debugPrint(e.toString());
    }

    if (!mounted) return;

    setState(() {
      loading = false;
    });
  }

  void _filterFavorites(String value) {
    setState(() {
      if (value.trim().isEmpty) {
        filteredFavorites = List.from(favorites);
        return;
      }

      final query = value.toLowerCase();

      filteredFavorites = favorites.where((concert) {
        return concert.artist.toLowerCase().contains(query) ||
            concert.festival.toLowerCase().contains(query) ||
            concert.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Favoritos',
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              gridView = !gridView;
            });
          },
          icon: Icon(gridView ? Icons.view_list : Icons.grid_view),
        ),
      ],
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : favorites.isEmpty
          ? const Center(
              child: Text(
                'Todavía no tienes conciertos favoritos',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: _filterFavorites,
                  decoration: InputDecoration(
                    hintText: 'Buscar artista, festival o ciudad...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  '${filteredFavorites.length} favoritos',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white70),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadFavorites,
                    child: gridView
                        ? GridView.builder(
                            padding: const EdgeInsets.only(bottom: 20),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: .68,
                                ),
                            itemCount: filteredFavorites.length,
                            itemBuilder: (context, index) {
                              final concert = filteredFavorites[index];

                              return ConcertGridCard(
                                concert: concert,
                                onTap: () {
                                  context.push(
                                    '/concert-detail',
                                    extra: concert,
                                  );
                                },
                                onEdit: () async {
                                  final result = await context.push(
                                    '/add',
                                    extra: concert,
                                  );

                                  if (result == true) {
                                    await _loadFavorites();
                                  }
                                },
                                onDelete: () async {},
                              );
                            },
                          )
                        : ListView.separated(
                            itemCount: filteredFavorites.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 24),
                            itemBuilder: (context, index) {
                              final concert = filteredFavorites[index];

                              return ConcertCardV2(
                                concert: concert,
                                onTap: () {
                                  context.push(
                                    '/concert-detail',
                                    extra: concert,
                                  );
                                },
                                onEdit: () async {
                                  final result = await context.push(
                                    '/add',
                                    extra: concert,
                                  );

                                  if (result == true) {
                                    await _loadFavorites();
                                  }
                                },
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
    );
  }
}
