import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/tutorial/tutorial_content.dart';
import '../../../../core/tutorial/tutorial_overlay.dart';
import '../../../../core/tutorial/tutorial_service.dart';
import '../../../concerts/domain/entities/concert.dart';
import '../../../concerts/presentation/providers/concerts_provider.dart';
import '../../../ticketmaster/presentation/widgets/recommended_concerts.dart';
import '../../artist/presentation/pages/artist_page.dart';
import '../widgets/dashboard_favorites.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_on_this_day.dart';
import '../widgets/dashboard_quick_actions.dart';
import '../widgets/dashboard_rate_pending.dart';
import '../widgets/dashboard_recent_concerts.dart';
import '../widgets/dashboard_section_title.dart';
import '../widgets/dashboard_stats.dart';
import '../widgets/dashboard_streak.dart';
import '../widgets/dashboard_upcoming_concerts.dart';

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  bool _tutorialTriggered = false;

  Future<void> _updateBackground(Concert concert) async {
    // palette_generator puede usarse aquí si se desea
  }

  Future<void> _showTutorialIfNeeded() async {
    final should = await TutorialService.shouldShow(TutorialService.dashboard);
    if (!should || !mounted) return;
    await TutorialService.markShown(TutorialService.dashboard);
    if (!mounted) return;
    await TutorialOverlay.show(context, steps: TutorialContent.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    final concertsAsync = ref.watch(concertsProvider);

    return concertsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(
          'Error al cargar: $e',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54),
          ),
        ),
      ),
      data: (_) {
        // Lanzamos el tutorial una sola vez cuando los datos ya están disponibles
        if (!_tutorialTriggered) {
          _tutorialTriggered = true;
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) _showTutorialIfNeeded();
          });
        }
        final concerts = ref.watch(concertsProvider).asData?.value ?? [];
        final upcoming = ref.watch(upcomingConcertsProvider);
        final favorites = ref.watch(favoriteConcertsProvider);
        final recent = ref.watch(recentConcertsProvider);
        final stats = ref.watch(concertStatsProvider);
        final favoriteArtists = ref.watch(recommendedArtistsProvider);

        // "En tal día como hoy" — día exacto primero, luego esta semana
        final now = DateTime.now();
        final todayMidnight = DateTime(now.year, now.month, now.day);

        final onThisDay =
            concerts.where((c) {
              if (c.date.year >= now.year) return false;
              final concertDay = DateTime(
                c.date.year,
                c.date.month,
                c.date.day,
              );
              // Mismo día y mes (aniversario exacto)
              if (c.date.day == now.day && c.date.month == now.month)
                return true;
              // Dentro de los últimos 3 días o próximos 3 días del año actual
              final thisYearDate = DateTime(now.year, c.date.month, c.date.day);
              final diff = thisYearDate.difference(todayMidnight).inDays.abs();
              return diff <= 3;
            }).toList()..sort((a, b) {
              // Aniversarios exactos primero, luego por cercanía
              final aExact = a.date.day == now.day && a.date.month == now.month;
              final bExact = b.date.day == now.day && b.date.month == now.month;
              if (aExact && !bExact) return -1;
              if (!aExact && bExact) return 1;
              return b.date.year.compareTo(a.date.year);
            });

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DashboardHeader(),
              const SizedBox(height: 24),

              const DashboardQuickActions(),
              const SizedBox(height: 20),

              // ── Racha ────────────────────────────────────────────────────
              DashboardStreak(concerts: concerts),
              if (concerts.isNotEmpty) const SizedBox(height: 20),

              // ── Valorar pendiente ─────────────────────────────────────────
              const DashboardRatePending(),
              const SizedBox(height: 28),

              // ── En tal día como hoy ──────────────────────────────────────
              if (onThisDay.isNotEmpty) ...[
                const DashboardSectionTitle(
                  icon: Icons.cake_rounded,
                  title: 'EN TAL DÍA COMO HOY',
                ),
                const SizedBox(height: 14),
                DashboardOnThisDay(concerts: onThisDay),
                const SizedBox(height: 36),
              ],

              // ── Próximos conciertos ──────────────────────────────────────
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

              // ── Estadísticas ─────────────────────────────────────────────
              const DashboardSectionTitle(
                icon: Icons.bar_chart,
                title: 'ESTADÍSTICAS',
              ),
              const SizedBox(height: 18),
              DashboardStats(stats: stats),
              const SizedBox(height: 36),

              // ── Recomendados ─────────────────────────────────────────────
              const DashboardSectionTitle(
                icon: Icons.local_fire_department,
                title: 'RECOMENDADOS',
              ),
              const SizedBox(height: 18),
              RecommendedConcerts(favoriteArtists: favoriteArtists),
              const SizedBox(height: 36),

              // ── Favoritos ────────────────────────────────────────────────
              const DashboardSectionTitle(
                icon: Icons.favorite,
                title: 'TUS FAVORITOS',
              ),
              const SizedBox(height: 18),
              DashboardFavorites(concerts: favorites),
              const SizedBox(height: 36),

              // ── Últimos añadidos ─────────────────────────────────────────
              const DashboardSectionTitle(
                icon: Icons.history,
                title: 'ÚLTIMOS AÑADIDOS',
              ),
              const SizedBox(height: 18),
              DashboardRecentConcerts(concerts: recent),
            ],
          ),
        );
      },
    );
  }
}
