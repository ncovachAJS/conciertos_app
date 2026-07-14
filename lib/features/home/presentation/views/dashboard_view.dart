import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../../concerts/domain/entities/concert.dart';
import '../../../ticketmaster/presentation/widgets/recommended_concerts.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/dashboard_favorites.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_recent_concerts.dart';
import '../widgets/dashboard_section_title.dart';
import '../widgets/dashboard_stats.dart';
import '../widgets/dashboard_upcoming_concerts.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final DashboardController controller = DashboardController();

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

      setState(() {
        _backgroundColor = color;
      });
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();

    controller.load().then((_) {
      if (controller.upcomingConcerts.isNotEmpty) {
        _updateBackground(controller.upcomingConcerts.first);
      }

      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (controller.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        // Dashboard
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DashboardHeader(),

              const SizedBox(height: 24),

              const DashboardSectionTitle(
                icon: Icons.calendar_month_rounded,
                title: 'PRÓXIMOS CONCIERTOS',
              ),

              const SizedBox(height: 24),

              DashboardUpcomingConcerts(
                controller: controller,
                onConcertChanged: (index) {
                  _updateBackground(controller.upcomingConcerts[index]);
                },
              ),

              const SizedBox(height: 36),

              const DashboardSectionTitle(
                icon: Icons.bar_chart,
                title: 'ESTADÍSTICAS',
              ),

              const SizedBox(height: 18),

              DashboardStats(controller: controller),

              const SizedBox(height: 36),

              const DashboardSectionTitle(
                icon: Icons.local_fire_department,
                title: 'RECOMENDADOS',
              ),

              const SizedBox(height: 18),

              RecommendedConcerts(controller: controller),

              const SizedBox(height: 36),

              const DashboardSectionTitle(
                icon: Icons.favorite,
                title: 'TUS FAVORITOS',
              ),

              const SizedBox(height: 18),

              DashboardFavorites(controller: controller),

              const SizedBox(height: 36),

              const DashboardSectionTitle(
                icon: Icons.history,
                title: 'ÚLTIMOS AÑADIDOS',
              ),

              const SizedBox(height: 18),

              DashboardRecentConcerts(controller: controller),
            ],
          ),
        ),
      ],
    );
  }
}
