import 'package:conciertos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/responsive/responsive.dart';
import '../../../../core/tutorial/tutorial_content.dart';
import '../../../../core/tutorial/tutorial_overlay.dart';
import '../../../../core/tutorial/tutorial_service.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/skeletons/dashboard_skeleton.dart';
import '../../../concerts/domain/entities/concert.dart';
import '../../../concerts/presentation/providers/concerts_provider.dart';
import '../../../ticketmaster/presentation/widgets/recommended_concerts.dart';
import '../../data/dashboard_layout_service.dart';
import '../../domain/dashboard_section.dart';
import '../providers/dashboard_layout_provider.dart';
import '../widgets/dashboard_annual_goal.dart';
import '../widgets/dashboard_favorites.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_on_this_day.dart';
import '../widgets/dashboard_quick_actions.dart';
import '../widgets/dashboard_rate_pending.dart';
import '../widgets/dashboard_recent_concerts.dart';
import '../widgets/dashboard_section_title.dart';
import '../widgets/dashboard_stats.dart';
import '../widgets/dashboard_streak.dart';
import '../widgets/dashboard_spotify_embed.dart';
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
    await TutorialOverlay.show(
      context,
      steps: TutorialContent.dashboard(AppLocalizations.of(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final concertsAsync = ref.watch(concertsProvider);

    return concertsAsync.when(
      loading: () => const DashboardSkeleton(),
      error: (e, _) => AppErrorWidget(
        error: e,
        onRetry: () => ref.invalidate(concertsProvider),
      ),
      data: (_) {
        final l = AppLocalizations.of(context);

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
        final layout = ref.watch(dashboardLayoutProvider).asData?.value;

        // "En tal día como hoy" — día exacto primero, luego esta semana
        final now = DateTime.now();
        final todayMidnight = DateTime(now.year, now.month, now.day);

        final onThisDay =
            concerts.where((c) {
              if (c.date.year >= now.year) return false;
              if (c.date.day == now.day && c.date.month == now.month) {
                return true;
              }
              final thisYearDate =
                  DateTime(now.year, c.date.month, c.date.day);
              final diff =
                  thisYearDate.difference(todayMidnight).inDays.abs();
              return diff <= 3;
            }).toList()..sort((a, b) {
              final aExact =
                  a.date.day == now.day && a.date.month == now.month;
              final bExact =
                  b.date.day == now.day && b.date.month == now.month;
              if (aExact && !bExact) return -1;
              if (!aExact && bExact) return 1;
              return b.date.year.compareTo(a.date.year);
            });

        // ── Builder por sección ──────────────────────────────────────────────
        List<Widget> widgetsFor(DashboardSectionId id) {
          return switch (id) {
            DashboardSectionId.streak => concerts.isNotEmpty
                ? [
                    DashboardStreak(concerts: concerts),
                    const SizedBox(height: 20),
                  ]
                : [],

            DashboardSectionId.annualGoal => [
                DashboardAnnualGoal(concerts: concerts),
                const SizedBox(height: 20),
              ],

            DashboardSectionId.ratePending => [
                const DashboardRatePending(),
                const SizedBox(height: 28),
              ],

            DashboardSectionId.onThisDay => onThisDay.isNotEmpty
                ? [
                    DashboardSectionTitle(
                      icon: Icons.cake_rounded,
                      title: l.onThisDay,
                    ),
                    const SizedBox(height: 14),
                    DashboardOnThisDay(concerts: onThisDay),
                    const SizedBox(height: 36),
                  ]
                : [],

            DashboardSectionId.upcoming => [
                DashboardSectionTitle(
                  icon: Icons.calendar_month_rounded,
                  title: l.upcomingConcerts,
                  action: 'Calendario',
                  onAction: () =>
                      context.go('/concerts?view=calendar'),
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
              ],

            DashboardSectionId.stats => [
                DashboardSectionTitle(
                  icon: Icons.bar_chart,
                  title: l.statisticsSection,
                ),
                const SizedBox(height: 18),
                DashboardStats(stats: stats),
                const SizedBox(height: 36),
              ],

            DashboardSectionId.recommended => [
                DashboardSectionTitle(
                  icon: Icons.local_fire_department,
                  title: l.recommendedSection,
                ),
                const SizedBox(height: 18),
                RecommendedConcerts(favoriteArtists: favoriteArtists),
                const SizedBox(height: 36),
              ],

            DashboardSectionId.favorites => [
                DashboardSectionTitle(
                  icon: Icons.favorite,
                  title: l.yourFavorites,
                ),
                const SizedBox(height: 18),
                DashboardFavorites(concerts: favorites),
                const SizedBox(height: 36),
              ],

            DashboardSectionId.recent => [
                DashboardSectionTitle(
                  icon: Icons.history,
                  title: l.recentlyAdded,
                ),
                const SizedBox(height: 18),
                DashboardRecentConcerts(concerts: recent),
                const SizedBox(height: 36),
              ],

            DashboardSectionId.spotifyEmbed => [
                DashboardSectionTitle(
                  icon: Icons.headphones_rounded,
                  title: 'Tus canciones favoritas',
                ),
                const SizedBox(height: 14),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: DashboardSpotifyEmbed(),
                ),
                const SizedBox(height: 36),
              ],
          };
        }

        final sections = layout ?? DashboardLayoutService.defaults;
        final visibleSections = sections.where((s) => s.visible).toList();

        final isTablet = Responsive.isTablet(context);

        // ── Layout ───────────────────────────────────────────────────────────
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(4, 4, 4, isTablet ? 32 : 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DashboardHeader(),
              const SizedBox(height: 24),
              const DashboardQuickActions(),
              const SizedBox(height: 20),

              // En iPad usamos un layout de 2 columnas para las secciones
              // que encajan bien en media pantalla (cards, stats, etc.).
              // Las secciones con carruseles horizontales siempre van a ancho completo.
              if (isTablet)
                _TabletDashboardLayout(
                  sections: visibleSections,
                  widgetsFor: widgetsFor,
                )
              else
                ...visibleSections.expand((s) => widgetsFor(s.id)),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Layout de 2 columnas para el dashboard en iPad
// ---------------------------------------------------------------------------

/// Secciones que ocupan ancho completo (carruseles, grids propios, embeds).
/// - stats: necesita todo el ancho para mostrar 4 columnas en iPad
/// - upcoming / favorites / recommended: carruseles horizontales
/// - spotifyEmbed: embed de Spotify
const _fullWidthSections = {
  DashboardSectionId.upcoming,
  DashboardSectionId.favorites,
  DashboardSectionId.recommended,
  DashboardSectionId.spotifyEmbed,
  DashboardSectionId.stats,
};

class _TabletDashboardLayout extends StatelessWidget {
  final List<DashboardSection> sections;
  final List<Widget> Function(DashboardSectionId) widgetsFor;

  const _TabletDashboardLayout({
    required this.sections,
    required this.widgetsFor,
  });

  @override
  Widget build(BuildContext context) {
    const gap = 20.0;
    final result = <Widget>[];
    // Cola de secciones que caben en media columna
    final halfQueue = <DashboardSection>[];

    void flushQueue() {
      if (halfQueue.isEmpty) return;
      if (halfQueue.length == 1) {
        // Sola: ocupa ancho completo igualmente
        result.addAll(widgetsFor(halfQueue[0].id));
      } else {
        // Par: lado a lado
        result.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widgetsFor(halfQueue[0].id),
                ),
              ),
              const SizedBox(width: gap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widgetsFor(halfQueue[1].id),
                ),
              ),
            ],
          ),
        );
        result.add(const SizedBox(height: gap));
      }
      halfQueue.clear();
    }

    for (final section in sections) {
      if (_fullWidthSections.contains(section.id)) {
        // Antes de colocar la sección ancho-completo, vaciamos la cola
        flushQueue();
        result.addAll(widgetsFor(section.id));
      } else {
        halfQueue.add(section);
        if (halfQueue.length == 2) flushQueue();
      }
    }
    // Vaciamos lo que quede al final
    flushQueue();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: result,
    );
  }
}
