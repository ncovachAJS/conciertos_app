import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../../concerts/domain/entities/concert.dart';
import '../../../concerts/presentation/providers/concerts_provider.dart';
import '../../../ticketmaster/presentation/widgets/recommended_concerts.dart';
import '../widgets/dashboard_favorites.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_recent_concerts.dart';
import '../widgets/dashboard_section_title.dart';
import '../widgets/dashboard_stats.dart';
import '../widgets/dashboard_upcoming_concerts.dart';
import '../widgets/dashboard_quick_actions.dart';

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  Color _backgroundColor = Colors.black;

  Future<void> _updateBackground(Concert concert) async {
    if (concert.imageUrl.isEmpty) return;

    try {
      final palette = await PaletteGenerator.fromImageProvider(
        NetworkImage(concert.imageUrl),
      );

      final color =
          palette.darkVibrantColor?.color ??
          palette.darkMutedColor?.color ??
          palette.vibrantColor?.color ??
          palette.dominantColor?.color ??
          const Color(0xFF121212);

      if (!mounted) return;

      setState(() => _backgroundColor = color);
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    // Escuchamos una vez para disparar la actualización de fondo en cuanto
    // lleguen los datos. Usamos addPostFrameCallback para tener ref disponible.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final upcoming = ref.read(upcomingConcertsProvider);
      if (upcoming.isNotEmpty) {
        _updateBackground(upcoming.first);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final concertsAsync = ref.watch(concertsProvider);

    return concertsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(
          'Error al cargar: $e',
          style: const TextStyle(color: Colors.white54),
        ),
      ),
      data: (_) {
        final upcoming = ref.watch(upcomingConcertsProvider);
        final favorites = ref.watch(favoriteConcertsProvider);
        final recent = ref.watch(recentConcertsProvider);
        final stats = ref.watch(concertStatsProvider);
        final favoriteArtists = ref.watch(favoriteArtistsProvider);

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DashboardHeader(),
                  const SizedBox(height: 24),

                  const DashboardQuickActions(),
                  const SizedBox(height: 28),

                  const DashboardSectionTitle(
                    icon: Icons.calendar_month_rounded,
                    title: 'PRÓXIMOS CONCIERTOS',
                  ),
                  const SizedBox(height: 24),

                  DashboardUpcomingConcerts(
                    concerts: upcoming,
                    onConcertChanged: (index) {
                      if (index < upcoming.length) {
                        _updateBackground(upcoming[index]);
                      }
                    },
                  ),

                  const SizedBox(height: 36),

                  const DashboardSectionTitle(
                    icon: Icons.bar_chart,
                    title: 'ESTADÍSTICAS',
                  ),
                  const SizedBox(height: 18),

                  DashboardStats(stats: stats),

                  const SizedBox(height: 36),

                  const DashboardSectionTitle(
                    icon: Icons.local_fire_department,
                    title: 'RECOMENDADOS',
                  ),
                  const SizedBox(height: 18),

                  RecommendedConcerts(favoriteArtists: favoriteArtists),

                  const SizedBox(height: 36),

                  const DashboardSectionTitle(
                    icon: Icons.favorite,
                    title: 'TUS FAVORITOS',
                  ),
                  const SizedBox(height: 18),

                  DashboardFavorites(concerts: favorites),

                  const SizedBox(height: 36),

                  const DashboardSectionTitle(
                    icon: Icons.history,
                    title: 'ÚLTIMOS AÑADIDOS',
                  ),
                  const SizedBox(height: 18),

                  DashboardRecentConcerts(concerts: recent),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
