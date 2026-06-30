import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/app_page.dart';
import '../../../../shared/widgets/concert_card.dart';
import '../../data/services/concert_api_service.dart';
import '../../domain/entities/concert.dart';

class ConcertsPage extends StatefulWidget {
  const ConcertsPage({super.key});

  @override
  State<ConcertsPage> createState() => _ConcertsPageState();
}

class _ConcertsPageState extends State<ConcertsPage> {
  final TextEditingController _searchController = TextEditingController();

  List<Concert> concerts = [];
  List<Concert> filteredConcerts = [];

  bool loading = true;
  bool deleting = false;

  @override
  void initState() {
    super.initState();
    _loadConcerts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadConcerts() async {
    setState(() => loading = true);

    try {
      concerts = await ConcertApiService().getConcerts();
      filteredConcerts = List.from(concerts);
    } catch (e) {
      debugPrint(e.toString());
    }

    if (!mounted) return;

    setState(() => loading = false);
  }

  void _filterConcerts(String value) {
    setState(() {
      if (value.trim().isEmpty) {
        filteredConcerts = List.from(concerts);
        return;
      }

      final query = value.toLowerCase();

      filteredConcerts = concerts.where((concert) {
        return concert.artist.toLowerCase().contains(query) ||
            concert.festival.toLowerCase().contains(query) ||
            concert.city.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Conciertos',

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        elevation: 8,
        icon: const Icon(Icons.add),
        label: const Text(
          'Nuevo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () async {
          final result = await context.push('/add');

          if (result == true) {
            await _loadConcerts();
          }
        },
      ),

      child: Stack(
        children: [
          loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _searchController,
                      onChanged: _filterConcerts,
                      decoration: InputDecoration(
                        hintText: 'Buscar artista, festival o ciudad...',
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
                      '${filteredConcerts.length} conciertos',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: Colors.white70),
                    ),

                    const SizedBox(height: 20),

                    Expanded(
                      child: ListView.separated(
                        itemCount: filteredConcerts.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 24),
                        itemBuilder: (context, index) {
                          final concert = filteredConcerts[index];

                          return ConcertCard(
                            concert: concert,
                            onTap: () {
                              context.go('/concert-detail', extra: concert);
                            },
                            onEdit: () async {
                              final result = await context.push(
                                '/add',
                                extra: concert,
                              );

                              if (result == true) {
                                await _loadConcerts();
                              }
                            },
                            onDelete: () async {
                              final eliminar = await showDialog<bool>(
                                context: context,
                                builder: (dialogContext) => AlertDialog(
                                  title: const Text('Eliminar concierto'),
                                  content: Text(
                                    '¿Seguro que quieres eliminar "${concert.artist}"?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(
                                        dialogContext,
                                      ).pop(false),
                                      child: const Text('Cancelar'),
                                    ),
                                    FilledButton(
                                      onPressed: () =>
                                          Navigator.of(dialogContext).pop(true),
                                      child: const Text('Eliminar'),
                                    ),
                                  ],
                                ),
                              );

                              if (eliminar != true) return;

                              setState(() {
                                deleting = true;
                              });

                              try {
                                await ConcertApiService().deleteConcert(
                                  concert.id,
                                );

                                await _loadConcerts();

                                if (!mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${concert.artist} eliminado',
                                    ),
                                  ),
                                );
                              } catch (e) {
                                debugPrint(e.toString());
                              } finally {
                                if (mounted) {
                                  setState(() {
                                    deleting = false;
                                  });
                                }
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),

          if (deleting)
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
