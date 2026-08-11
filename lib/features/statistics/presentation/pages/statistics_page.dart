import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:conciertos_app/l10n/generated/app_localizations.dart';
import '../../../../core/tutorial/tutorial_content.dart';
import '../../../../core/tutorial/tutorial_overlay.dart';
import '../../../../core/tutorial/tutorial_service.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../concerts/domain/entities/concert.dart';
import '../../../concerts/presentation/providers/concerts_provider.dart';

// ---------------------------------------------------------------------------
// Modelo de estadísticas
// ---------------------------------------------------------------------------

class _Stats {
  final List<Concert> concerts;

  _Stats(this.concerts);

  int get total => concerts.length;

  int get uniqueArtists => concerts
      .map((c) => c.artist.trim())
      .where((a) => a.isNotEmpty)
      .toSet()
      .length;

  int get uniqueFestivals => concerts
      .map((c) => c.festival.trim())
      .where((f) => f.isNotEmpty)
      .toSet()
      .length;

  int get activeYears => concerts.map((c) => c.date.year).toSet().length;

  double get avgRating {
    final rated = concerts.where((c) => c.rating > 0).toList();
    if (rated.isEmpty) return 0;
    return rated.fold<int>(0, (s, c) => s + c.rating) / rated.length;
  }

  Map<int, int> get byYear {
    final map = <int, int>{};
    for (final c in concerts) {
      map[c.date.year] = (map[c.date.year] ?? 0) + 1;
    }
    return Map.fromEntries(
      map.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  List<MapEntry<String, int>> get topArtists =>
      _top(concerts.map((c) => c.artist.trim()).where((a) => a.isNotEmpty));

  List<MapEntry<String, int>> get topFestivals {
    final uniqueVisits = <String>{};

    for (final concert in concerts) {
      if (concert.festival.trim().isEmpty) continue;

      uniqueVisits.add('${concert.festival.trim()}_${concert.date.year}');
    }

    final counts = <String, int>{};

    for (final visit in uniqueVisits) {
      final festival = visit.substring(0, visit.lastIndexOf('_'));
      counts[festival] = (counts[festival] ?? 0) + 1;
    }

    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(5).toList();
  }

  List<MapEntry<String, int>> get topCities {
    final counts = <String, int>{};
    final countedFestivals = <String>{};

    for (final concert in concerts) {
      if (concert.city.trim().isEmpty) continue;

      if (concert.festival.trim().isNotEmpty) {
        final festivalVisit =
            '${concert.festival.trim()}_${concert.date.year}_${concert.city.trim()}';

        if (countedFestivals.contains(festivalVisit)) {
          continue;
        }

        countedFestivals.add(festivalVisit);
      }

      counts[concert.city] = (counts[concert.city] ?? 0) + 1;
    }

    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(5).toList();
  }

  Map<int, int> get byRating {
    final map = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final c in concerts.where((c) => c.rating > 0)) {
      map[c.rating] = (map[c.rating] ?? 0) + 1;
    }
    return map;
  }

  int? get favoriteMonthIndex {
    final map = <int, int>{};
    for (final c in concerts) {
      map[c.date.month] = (map[c.date.month] ?? 0) + 1;
    }
    if (map.isEmpty) return null;
    return map.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  double get totalSpent {
    var total = 0.0;
    final countedFestivals = <String>{};
    for (final c in concerts) {
      final fest = c.festival.trim();
      if (fest.isNotEmpty) {
        final key = '${fest}_${c.date.year}';
        if (!countedFestivals.contains(key)) {
          final festMax = concerts
              .where((f) => f.festival.trim() == fest && f.date.year == c.date.year)
              .fold(0.0, (max, f) => f.price > max ? f.price : max);
          total += festMax;
          countedFestivals.add(key);
        }
      } else {
        total += c.price;
      }
    }
    return total;
  }

  int get concertsWithPrice {
    final countedFestivals = <String>{};
    var count = 0;
    for (final c in concerts) {
      final fest = c.festival.trim();
      if (fest.isNotEmpty) {
        final key = '${fest}_${c.date.year}';
        if (!countedFestivals.contains(key)) {
          final hasPrice = concerts.any((f) =>
              f.festival.trim() == fest && f.date.year == c.date.year && f.price > 0);
          if (hasPrice) count++;
          countedFestivals.add(key);
        }
      } else if (c.price > 0) {
        count++;
      }
    }
    return count;
  }

  List<MapEntry<String, int>> _top(Iterable<String> values, {int take = 5}) {
    final map = <String, int>{};
    for (final v in values) {
      map[v] = (map[v] ?? 0) + 1;
    }
    final sorted = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(take).toList();
  }

  // ── Nuevas métricas ────────────────────────────────────────────────────────

  /// Conciertos por mes (1-12), todos los años juntos.
  Map<int, int> get byMonth {
    final map = <int, int>{for (int i = 1; i <= 12; i++) i: 0};
    for (final c in concerts) {
      map[c.date.month] = (map[c.date.month] ?? 0) + 1;
    }
    return map;
  }

  /// Conciertos por día de la semana (1=lunes … 7=domingo).
  Map<int, int> get byDayOfWeek {
    final map = <int, int>{for (int i = 1; i <= 7; i++) i: 0};
    for (final c in concerts) {
      map[c.date.weekday] = (map[c.date.weekday] ?? 0) + 1;
    }
    return map;
  }

  /// Top géneros musicales.
  List<MapEntry<String, int>> get topGenres => _top(
        concerts.map((c) => c.genre.trim()).where((g) => g.isNotEmpty),
        take: 8,
      );

  /// Top recintos.
  List<MapEntry<String, int>> get topVenues => _top(
        concerts.map((c) => c.venue.trim()).where((v) => v.isNotEmpty),
      );

  /// Número de conciertos en festival.
  int get festivalCount =>
      concerts.where((c) => c.festival.trim().isNotEmpty).length;

  /// Número de conciertos individuales (sin festival).
  int get soloCount =>
      concerts.where((c) => c.festival.trim().isEmpty).length;

  /// % de conciertos de artistas que ya se han visto antes.
  double get repeatArtistPercent {
    if (concerts.isEmpty) return 0;
    final counts = <String, int>{};
    for (final c in concerts) {
      final a = c.artist.trim();
      if (a.isNotEmpty) counts[a] = (counts[a] ?? 0) + 1;
    }
    final repeated = counts.values
        .where((v) => v > 1)
        .fold<int>(0, (s, v) => s + v);
    return repeated / concerts.length * 100;
  }

  /// Precio medio de entrada (solo conciertos con precio > 0).
  double get avgPrice {
    final w = concerts.where((c) => c.price > 0).toList();
    if (w.isEmpty) return 0;
    return w.fold<double>(0, (s, c) => s + c.price) / w.length;
  }

  Concert? get mostExpensive {
    final w = concerts.where((c) => c.price > 0).toList();
    if (w.isEmpty) return null;
    return w.reduce((a, b) => a.price > b.price ? a : b);
  }

  Concert? get cheapest {
    final w = concerts.where((c) => c.price > 0).toList();
    if (w.isEmpty) return null;
    return w.reduce((a, b) => a.price < b.price ? a : b);
  }

  /// Valoración media por año (solo años con al menos 1 valoración).
  Map<int, double> get avgRatingByYear {
    final map = <int, List<int>>{};
    for (final c in concerts.where((c) => c.rating > 0)) {
      (map[c.date.year] ??= []).add(c.rating);
    }
    return map.map((y, r) =>
        MapEntry(y, r.fold<int>(0, (s, v) => s + v) / r.length));
  }

  /// Artistas vistos >= 2 veces, ordenados por valoración media.
  List<MapEntry<String, double>> get topRatedArtists {
    final map = <String, List<int>>{};
    for (final c in concerts.where(
        (c) => c.rating > 0 && c.artist.trim().isNotEmpty)) {
      (map[c.artist.trim()] ??= []).add(c.rating);
    }
    return (map.entries
            .where((e) => e.value.length >= 2)
            .map((e) => MapEntry(
                  e.key,
                  e.value.fold<int>(0, (s, r) => s + r) / e.value.length,
                ))
            .toList()
          ..sort((a, b) => b.value.compareTo(a.value)))
        .take(5)
        .toList();
  }

  /// Racha más larga de meses consecutivos con al menos 1 concierto.
  int get longestStreakMonths {
    if (concerts.isEmpty) return 0;
    final months = concerts
        .map((c) => c.date.year * 12 + c.date.month)
        .toSet()
        .toList()
      ..sort();
    int maxS = 1, cur = 1;
    for (int i = 1; i < months.length; i++) {
      if (months[i] == months[i - 1] + 1) {
        cur++;
        if (cur > maxS) maxS = cur;
      } else {
        cur = 1;
      }
    }
    return maxS;
  }

  /// Mayor hueco en días entre dos conciertos consecutivos.
  int get longestGapDays {
    if (concerts.length < 2) return 0;
    final sorted = concerts
        .map((c) => DateTime(c.date.year, c.date.month, c.date.day))
        .toList()
      ..sort();
    int maxG = 0;
    for (int i = 1; i < sorted.length; i++) {
      final g = sorted[i].difference(sorted[i - 1]).inDays;
      if (g > maxG) maxG = g;
    }
    return maxG;
  }
}

// ---------------------------------------------------------------------------
// Helper de localización de mes
// ---------------------------------------------------------------------------

String _monthName(AppLocalizations l, int? index) {
  if (index == null) return l.noDataDash;
  switch (index) {
    case 1: return l.monthJanuary;
    case 2: return l.monthFebruary;
    case 3: return l.monthMarch;
    case 4: return l.monthApril;
    case 5: return l.monthMay;
    case 6: return l.monthJune;
    case 7: return l.monthJuly;
    case 8: return l.monthAugust;
    case 9: return l.monthSeptember;
    case 10: return l.monthOctober;
    case 11: return l.monthNovember;
    case 12: return l.monthDecember;
    default: return l.noDataDash;
  }
}

// ---------------------------------------------------------------------------
// Página
// ---------------------------------------------------------------------------

class StatisticsPage extends ConsumerStatefulWidget {
  const StatisticsPage({super.key});

  @override
  ConsumerState<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends ConsumerState<StatisticsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _showTutorialIfNeeded(),
    );
  }

  Future<void> _showTutorialIfNeeded() async {
    final should = await TutorialService.shouldShow(TutorialService.statistics);
    if (!should || !mounted) return;
    await TutorialService.markShown(TutorialService.statistics);
    if (!mounted) return;
    await TutorialOverlay.show(
      context,
      steps: TutorialContent.statistics(AppLocalizations.of(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final concertsAsync = ref.watch(concertsProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text(l.statisticsTitle),
      ),
      body: concertsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.wifi_off,
                size: 48,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withOpacity(0.38),
              ),
              const SizedBox(height: 12),
              Text(
                l.error,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.54),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.invalidate(concertsProvider),
                child: Text(l.retry),
              ),
            ],
          ),
        ),
        data: (concerts) {
          if (concerts.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.bar_chart,
                      size: 64,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.24),
                    ),
                    SizedBox(height: 16),
                    Text(
                      l.addConcertsForStats,
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.54),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final currentUserId =
              AuthController.instance.user?.id ?? '';

          final pastAll = concerts
              .where((c) => !c.date.isAfter(today))
              .toList();

          final myDates = pastAll
              .where((c) => c.userId == currentUserId || c.userId.isEmpty)
              .map((c) => DateTime(c.date.year, c.date.month, c.date.day))
              .toSet();

          final past = pastAll
              .where(
                (c) =>
                    c.userId == currentUserId ||
                    c.userId.isEmpty ||
                    !myDates.contains(
                      DateTime(c.date.year, c.date.month, c.date.day),
                    ),
              )
              .toList();

          if (past.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.bar_chart,
                      size: 64,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.24),
                    ),
                    SizedBox(height: 16),
                    Text(
                      l.addConcertsForStats,
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.54),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final stats = _Stats(past);

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            children: [
              _SummaryGrid(stats: stats),
              const SizedBox(height: 32),

              if (stats.byYear.length > 1) ...[
                _SectionTitle(
                  icon: Icons.calendar_month,
                  title: l.concertsByYear,
                ),
                const SizedBox(height: 16),
                _YearBarChart(byYear: stats.byYear),
                const SizedBox(height: 32),
              ],

              // ── Conciertos por mes ──────────────────────────────────────
              _SectionTitle(
                icon: Icons.calendar_view_month_rounded,
                title: 'Conciertos por mes',
              ),
              const SizedBox(height: 16),
              _MonthBars(byMonth: stats.byMonth),
              const SizedBox(height: 32),

              // ── Día de la semana ────────────────────────────────────────
              _SectionTitle(
                icon: Icons.view_week_outlined,
                title: 'Día de la semana favorito',
              ),
              const SizedBox(height: 16),
              _WeekdayBars(byDow: stats.byDayOfWeek),
              const SizedBox(height: 32),

              if (stats.topArtists.isNotEmpty) ...[
                _SectionTitle(icon: Icons.person, title: l.topArtists),
                const SizedBox(height: 16),
                _HorizontalBars(
                  entries: stats.topArtists,
                  color: const Color(0xFFE53935),
                ),
                const SizedBox(height: 32),
              ],

              // ── Géneros ─────────────────────────────────────────────────
              if (stats.topGenres.isNotEmpty) ...[
                _SectionTitle(
                  icon: Icons.library_music_outlined,
                  title: 'Géneros musicales',
                ),
                const SizedBox(height: 16),
                _HorizontalBars(
                  entries: stats.topGenres,
                  color: const Color(0xFFAB47BC),
                ),
                const SizedBox(height: 32),
              ],

              if (stats.topFestivals.isNotEmpty) ...[
                _SectionTitle(
                  icon: Icons.festival,
                  title: l.topFestivals,
                ),
                const SizedBox(height: 16),
                _HorizontalBars(
                  entries: stats.topFestivals,
                  color: const Color(0xFF42A5F5),
                ),
                const SizedBox(height: 32),
              ],

              if (stats.topCities.isNotEmpty) ...[
                _SectionTitle(
                  icon: Icons.location_city,
                  title: l.favoriteCities,
                ),
                const SizedBox(height: 16),
                _HorizontalBars(
                  entries: stats.topCities,
                  color: const Color(0xFF66BB6A),
                ),
                const SizedBox(height: 32),
              ],

              // ── Recintos más visitados ──────────────────────────────────
              if (stats.topVenues.isNotEmpty) ...[
                _SectionTitle(
                  icon: Icons.stadium_rounded,
                  title: 'Recintos más visitados',
                ),
                const SizedBox(height: 16),
                _HorizontalBars(
                  entries: stats.topVenues,
                  color: const Color(0xFFFF7043),
                ),
                const SizedBox(height: 32),
              ],

              // ── Festival vs. individual ─────────────────────────────────
              _SectionTitle(
                icon: Icons.compare_arrows_rounded,
                title: 'Festival vs. individual',
              ),
              const SizedBox(height: 16),
              _FestivalSplit(
                  festival: stats.festivalCount, solo: stats.soloCount),
              const SizedBox(height: 32),

              // ── Valoraciones ─────────────────────────────────────────────
              _SectionTitle(
                icon: Icons.star_rounded,
                title: l.ratingDistribution,
              ),
              const SizedBox(height: 16),
              _RatingBars(byRating: stats.byRating),
              const SizedBox(height: 32),

              // ── Valoración media por año ────────────────────────────────
              if (stats.avgRatingByYear.length > 1) ...[
                _SectionTitle(
                  icon: Icons.trending_up_rounded,
                  title: 'Valoración media por año',
                ),
                const SizedBox(height: 16),
                _AvgRatingByYear(data: stats.avgRatingByYear),
                const SizedBox(height: 32),
              ],

              // ── Artistas mejor valorados ────────────────────────────────
              if (stats.topRatedArtists.isNotEmpty) ...[
                _SectionTitle(
                  icon: Icons.emoji_events_rounded,
                  title: 'Artistas mejor valorados',
                ),
                const SizedBox(height: 16),
                _TopRatedArtistsBars(entries: stats.topRatedArtists),
                const SizedBox(height: 32),
              ],

              // ── Precio de las entradas ──────────────────────────────────
              if (stats.concertsWithPrice > 0) ...[
                _SectionTitle(
                  icon: Icons.euro_rounded,
                  title: 'Precio de las entradas',
                ),
                const SizedBox(height: 16),
                _PriceStats(stats: stats),
                const SizedBox(height: 32),
              ],

              const SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Grid de tarjetas resumen — usa Wrap para evitar constraints infinitas
// ---------------------------------------------------------------------------

class _SummaryGrid extends StatelessWidget {
  final _Stats stats;

  const _SummaryGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final items = [
      _CardData(
        '${stats.total}',
        l.totalConcertsLabel,
        Icons.music_note_rounded,
        const Color(0xFFE53935),
      ),
      _CardData(
        '${stats.uniqueArtists}',
        l.uniqueArtistsLabel,
        Icons.person_rounded,
        const Color(0xFF42A5F5),
      ),
      _CardData(
        '${stats.uniqueFestivals}',
        l.uniqueFestivalsLabel,
        Icons.festival_rounded,
        const Color(0xFF66BB6A),
      ),
      _CardData(
        stats.avgRating > 0 ? stats.avgRating.toStringAsFixed(1) : l.noDataDash,
        l.avgRatingLabel,
        Icons.star_rounded,
        const Color(0xFFFFC107),
      ),
      _CardData(
        '${stats.activeYears}',
        stats.activeYears == 1 ? l.activeYearLabel : l.activeYearsLabel,
        Icons.timeline_rounded,
        const Color(0xFFAB47BC),
      ),
      _CardData(
        _monthName(l, stats.favoriteMonthIndex),
        l.favoriteMonthLabel,
        Icons.calendar_today_rounded,
        const Color(0xFFFF7043),
      ),
      if (stats.concertsWithPrice > 0)
        _CardData(
          '${stats.totalSpent.toStringAsFixed(0)} €',
          'Gasto total',
          Icons.euro_rounded,
          const Color(0xFF26A69A),
        ),
      if (stats.longestStreakMonths > 1)
        _CardData(
          '${stats.longestStreakMonths} meses',
          'Racha más larga',
          Icons.local_fire_department_rounded,
          const Color(0xFFFF7043),
        ),
      if (stats.longestGapDays > 0)
        _CardData(
          '${stats.longestGapDays} días',
          'Mayor hueco',
          Icons.hourglass_empty_rounded,
          const Color(0xFF78909C),
        ),
      _CardData(
        '${stats.repeatArtistPercent.toStringAsFixed(0)} %',
        'Artistas repetidos',
        Icons.replay_rounded,
        const Color(0xFF8D6E63),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 14) / 2;
        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: items
              .map(
                (d) => SizedBox(
                  width: cardWidth,
                  height: cardWidth * 0.72,
                  child: _SummaryCard(data: d),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _CardData {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _CardData(this.value, this.label, this.icon, this.color);
}

class _SummaryCard extends StatelessWidget {
  final _CardData data;

  const _SummaryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: data.color.withOpacity(.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(data.icon, color: data.color, size: 20),
          ),
          const Spacer(),
          Text(
            data.value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            data.label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Título de sección
// ---------------------------------------------------------------------------

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54),
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54),
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Gráfica de barras verticales por año
// ---------------------------------------------------------------------------

class _YearBarChart extends StatefulWidget {
  final Map<int, int> byYear;

  const _YearBarChart({required this.byYear});

  @override
  State<_YearBarChart> createState() => _YearBarChartState();
}

class _YearBarChartState extends State<_YearBarChart> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Después del primer frame, salta al final (años más recientes)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final byYear = widget.byYear;
    final maxVal = byYear.values.reduce((a, b) => a > b ? a : b);
    // Orden cronológico: los más antiguos a la izquierda, los recientes a la derecha
    final entries = byYear.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // Ancho fijo por barra para que haya espacio aunque haya muchos años
    const barWidth = 36.0;
    const barSpacing = 10.0;
    final totalWidth = entries.length * (barWidth + barSpacing);

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          width: totalWidth,
          child: Column(
            children: [
              SizedBox(
                height: 130,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (int i = 0; i < entries.length; i++) ...[
                      if (i > 0) const SizedBox(width: barSpacing),
                      SizedBox(
                        width: barWidth,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${entries[i].value}',
                              style: const TextStyle(
                                color: Color(0xFFE53935),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              height: maxVal > 0
                                  ? (entries[i].value / maxVal * 90).clamp(
                                      4,
                                      90,
                                    )
                                  : 4,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE53935),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  for (int i = 0; i < entries.length; i++) ...[
                    if (i > 0) const SizedBox(width: barSpacing),
                    SizedBox(
                      width: barWidth,
                      child: Text(
                        '${entries[i].key}',
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.54),
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Barras horizontales
// ---------------------------------------------------------------------------

class _HorizontalBars extends StatelessWidget {
  final List<MapEntry<String, int>> entries;
  final Color color;

  const _HorizontalBars({required this.entries, required this.color});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();
    final maxVal = entries.first.value;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          for (int i = 0; i < entries.length; i++) ...[
            if (i > 0) const SizedBox(height: 14),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    entries[i].key,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final ratio = maxVal > 0
                          ? entries[i].value / maxVal
                          : 0.0;
                      return Stack(
                        children: [
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Container(
                            height: 8,
                            width:
                                constraints.maxWidth * ratio.clamp(0.03, 1.0),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 24,
                  child: Text(
                    '${entries[i].value}',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Barras por mes (enero–diciembre, siempre 12)
// ---------------------------------------------------------------------------

class _MonthBars extends StatelessWidget {
  final Map<int, int> byMonth;
  const _MonthBars({required this.byMonth});

  static const _labels = ['E','F','M','A','M','J','J','A','S','O','N','D'];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final maxVal = byMonth.values.isEmpty
        ? 1
        : byMonth.values.reduce((a, b) => a > b ? a : b).clamp(1, 999);
    const gap = 6.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 110,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (int m = 1; m <= 12; m++) ...[
                  if (m > 1) const SizedBox(width: gap),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if ((byMonth[m] ?? 0) > 0)
                          Text(
                            '${byMonth[m]}',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFE53935),
                            ),
                          ),
                        const SizedBox(height: 3),
                        Container(
                          height: maxVal > 0
                              ? ((byMonth[m] ?? 0) / maxVal * 80).clamp(3, 80)
                              : 3,
                          decoration: BoxDecoration(
                            color: (byMonth[m] ?? 0) > 0
                                ? const Color(0xFFE53935)
                                : cs.onSurface.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (int m = 1; m <= 12; m++) ...[
                if (m > 1) const SizedBox(width: gap),
                Expanded(
                  child: Text(
                    _labels[m - 1],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 9,
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Barras por día de la semana
// ---------------------------------------------------------------------------

class _WeekdayBars extends StatelessWidget {
  final Map<int, int> byDow;
  const _WeekdayBars({required this.byDow});

  static const _labels = ['Lun','Mar','Mié','Jue','Vie','Sáb','Dom'];
  static const _weekend = {6, 7};

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final maxVal =
        byDow.values.isEmpty ? 1 : byDow.values.reduce((a, b) => a > b ? a : b).clamp(1, 999);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (int d = 1; d <= 7; d++) ...[
                  if (d > 1) const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if ((byDow[d] ?? 0) > 0)
                          Text(
                            '${byDow[d]}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF42A5F5),
                            ),
                          ),
                        const SizedBox(height: 3),
                        Container(
                          height: maxVal > 0
                              ? ((byDow[d] ?? 0) / maxVal * 72).clamp(3, 72)
                              : 3,
                          decoration: BoxDecoration(
                            color: _weekend.contains(d)
                                ? const Color(0xFFE53935)
                                : (byDow[d] ?? 0) > 0
                                    ? const Color(0xFF42A5F5)
                                    : cs.onSurface.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (int d = 1; d <= 7; d++) ...[
                if (d > 1) const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _labels[d - 1],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: _weekend.contains(d)
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: _weekend.contains(d)
                          ? const Color(0xFFE53935)
                          : cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Festival vs. individual
// ---------------------------------------------------------------------------

class _FestivalSplit extends StatelessWidget {
  final int festival;
  final int solo;
  const _FestivalSplit({required this.festival, required this.solo});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final total = festival + solo;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _SplitTile(
                icon: Icons.festival_rounded,
                label: 'Festivales',
                count: festival,
                color: const Color(0xFF42A5F5),
              ),
              const SizedBox(width: 16),
              _SplitTile(
                icon: Icons.music_note_rounded,
                label: 'Individuales',
                count: solo,
                color: const Color(0xFFE53935),
              ),
            ],
          ),
          if (total > 0) ...[
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Row(
                children: [
                  Flexible(
                    flex: festival,
                    child: Container(height: 8, color: const Color(0xFF42A5F5)),
                  ),
                  Flexible(
                    flex: solo,
                    child: Container(height: 8, color: const Color(0xFFE53935)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SplitTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;
  const _SplitTile(
      {required this.icon,
      required this.label,
      required this.count,
      required this.color});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Valoración media por año
// ---------------------------------------------------------------------------

class _AvgRatingByYear extends StatefulWidget {
  final Map<int, double> data;
  const _AvgRatingByYear({required this.data});

  @override
  State<_AvgRatingByYear> createState() => _AvgRatingByYearState();
}

class _AvgRatingByYearState extends State<_AvgRatingByYear> {
  final _sc = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_sc.hasClients) _sc.jumpTo(_sc.position.maxScrollExtent);
    });
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final entries = widget.data.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    const barW = 36.0, gap = 10.0;
    final totalW = entries.length * (barW + gap);

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: SingleChildScrollView(
        controller: _sc,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          width: totalW,
          child: Column(
            children: [
              SizedBox(
                height: 120,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (int i = 0; i < entries.length; i++) ...[
                      if (i > 0) const SizedBox(width: gap),
                      SizedBox(
                        width: barW,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              entries[i].value.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Color(0xFFFFC107),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              height: (entries[i].value / 5 * 80).clamp(4, 80),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFC107),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  for (int i = 0; i < entries.length; i++) ...[
                    if (i > 0) const SizedBox(width: gap),
                    SizedBox(
                      width: barW,
                      child: Text(
                        '${entries[i].key}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: cs.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Artistas mejor valorados (vistos >= 2 veces)
// ---------------------------------------------------------------------------

class _TopRatedArtistsBars extends StatelessWidget {
  final List<MapEntry<String, double>> entries;
  const _TopRatedArtistsBars({required this.entries});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          for (int i = 0; i < entries.length; i++) ...[
            if (i > 0) const SizedBox(height: 14),
            Row(
              children: [
                SizedBox(
                  width: 110,
                  child: Text(
                    entries[i].key,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: LayoutBuilder(
                    builder: (_, c) => Stack(children: [
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: cs.onSurface.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        height: 8,
                        width: c.maxWidth * (entries[i].value / 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC107),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(width: 10),
                Row(
                  children: List.generate(
                    5,
                    (s) => Icon(
                      s < entries[i].value.round()
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 12,
                      color: s < entries[i].value.round()
                          ? const Color(0xFFFFC107)
                          : cs.onSurface.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Precio de las entradas
// ---------------------------------------------------------------------------

class _PriceStats extends StatelessWidget {
  final _Stats stats;
  const _PriceStats({required this.stats});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final expensive = stats.mostExpensive;
    final cheap     = stats.cheapest;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _PriceTile(
                label: 'Precio medio',
                value: '${stats.avgPrice.toStringAsFixed(0)} €',
                icon: Icons.euro_rounded,
                color: const Color(0xFF26A69A),
              ),
              const SizedBox(width: 12),
              _PriceTile(
                label: 'Más cara',
                value: expensive != null
                    ? '${expensive.price.toStringAsFixed(0)} €'
                    : '—',
                sub: expensive?.artist,
                icon: Icons.arrow_upward_rounded,
                color: const Color(0xFFEF5350),
              ),
              const SizedBox(width: 12),
              _PriceTile(
                label: 'Más barata',
                value: cheap != null
                    ? '${cheap.price.toStringAsFixed(0)} €'
                    : '—',
                sub: cheap?.artist,
                icon: Icons.arrow_downward_rounded,
                color: const Color(0xFF66BB6A),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceTile extends StatelessWidget {
  final String label;
  final String value;
  final String? sub;
  final IconData icon;
  final Color color;
  const _PriceTile(
      {required this.label,
      required this.value,
      this.sub,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: cs.onSurface.withValues(alpha: 0.55),
              ),
            ),
            if (sub != null && sub!.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                sub!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9,
                  color: cs.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Distribución de valoraciones
// ---------------------------------------------------------------------------

class _RatingBars extends StatelessWidget {
  final Map<int, int> byRating;

  const _RatingBars({required this.byRating});

  @override
  Widget build(BuildContext context) {
    final maxVal = byRating.values.isEmpty
        ? 1
        : byRating.values.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          for (int star = 5; star >= 1; star--) ...[
            if (star < 5) const SizedBox(height: 12),
            Row(
              children: [
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < star
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: i < star
                          ? const Color(0xFFFFC107)
                          : Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.24),
                      size: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final ratio = maxVal > 0
                          ? ((byRating[star] ?? 0) / maxVal).clamp(0.0, 1.0)
                          : 0.0;
                      return Stack(
                        children: [
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Container(
                            height: 8,
                            width: constraints.maxWidth * ratio,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFC107),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 24,
                  child: Text(
                    '${byRating[star] ?? 0}',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
