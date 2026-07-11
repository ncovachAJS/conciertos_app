import 'package:flutter/material.dart';

import '../controllers/dashboard_controller.dart';
import '../widgets/dashboard_favorites.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_next_concert.dart';
import '../widgets/dashboard_quick_actions.dart';
import '../widgets/dashboard_recent_concerts.dart';
import '../widgets/dashboard_section_title.dart';
import '../widgets/dashboard_stats.dart';
import '../../../ticketmaster/presentation/widgets/recommended_concerts.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final DashboardController controller = DashboardController();

  @override
  void initState() {
    super.initState();

    controller.load().then((_) {
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

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DashboardHeader(),

          const SizedBox(height: 30),

          const DashboardSectionTitle(
            icon: Icons.event,
            title: 'Próximo concierto',
          ),

          const SizedBox(height: 18),

          DashboardNextConcert(controller: controller),

          const SizedBox(height: 36),

          const DashboardSectionTitle(
            icon: Icons.bar_chart,
            title: 'Estadísticas',
          ),

          const SizedBox(height: 18),

          DashboardStats(controller: controller),

          const SizedBox(height: 36),

          const DashboardSectionTitle(
            icon: Icons.local_fire_department,
            title: 'Recomendados',
          ),

          const SizedBox(height: 18),

          RecommendedConcerts(controller: controller),

          const SizedBox(height: 36),

          const DashboardSectionTitle(
            icon: Icons.favorite,
            title: 'Tus favoritos',
          ),

          const SizedBox(height: 18),

          DashboardFavorites(controller: controller),

          const SizedBox(height: 36),

          const DashboardSectionTitle(
            icon: Icons.history,
            title: 'Últimos añadidos',
          ),

          const SizedBox(height: 18),

          DashboardRecentConcerts(controller: controller),

          const SizedBox(height: 36),

          const DashboardSectionTitle(
            icon: Icons.flash_on,
            title: 'Accesos rápidos',
          ),

          const SizedBox(height: 18),

          const DashboardQuickActions(),
        ],
      ),
    );
  }
}
