import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../concerts/domain/entities/concert.dart';
import '../../../concerts/presentation/providers/concerts_provider.dart';
import '../../../photos/data/models/concert_photo_model.dart';
import '../../../photos/data/services/photo_api_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Modelo de datos del resumen anual
// ─────────────────────────────────────────────────────────────────────────────

class _YearSummary {
  final int year;
  final int total;
  final String topArtist;
  final int topArtistCount;
  final double topArtistRating;
  final String topArtistImageUrl;
  final String topCity;
  final int topCityCount;
  final String topVenue;
  final String topMonth;
  final int topMonthIdx;
  final int topMonthCount;
  final double avgRating;
  final int festivals;
  final int liked;
  final int uniqueArtists;
  final int uniqueCities;
  final Map<int, int> monthCounts;

  const _YearSummary({
    required this.year,
    required this.total,
    required this.topArtist,
    required this.topArtistCount,
    required this.topArtistRating,
    required this.topArtistImageUrl,
    required this.topCity,
    required this.topCityCount,
    required this.topVenue,
    required this.topMonth,
    required this.topMonthIdx,
    required this.topMonthCount,
    required this.avgRating,
    required this.festivals,
    required this.liked,
    required this.uniqueArtists,
    required this.uniqueCities,
    required this.monthCounts,
  });

  static _YearSummary from(
    List<Concert> concerts,
    int year,
    String currentUserId,
  ) {
    // Deduplicar igual que concertStatsProvider:
    // Un concierto compartido por un amigo aparece dos veces en el provider
    // (una vez con userId=yo y otra con userId=amigo). Prioritizamos el
    // propio: recogemos las fechas de nuestros conciertos y descartamos
    // entradas de otros usuarios cuya fecha ya está cubierta.
    final allYear = concerts.where((x) => x.date.year == year).toList();
    final myDates = allYear
        .where((x) => x.userId == currentUserId || x.userId.isEmpty)
        .map((x) => DateTime(x.date.year, x.date.month, x.date.day))
        .toSet();
    final c = allYear
        .where(
          (x) =>
              x.userId == currentUserId ||
              x.userId.isEmpty ||
              !myDates.contains(DateTime(x.date.year, x.date.month, x.date.day)),
        )
        .toList();

    Map<String, int> countMap(Iterable<String> vals) {
      final m = <String, int>{};
      for (final v in vals) {
        if (v.isEmpty) continue;
        m[v] = (m[v] ?? 0) + 1;
      }
      return m;
    }

    String topKey(Map<String, int> m) {
      if (m.isEmpty) return '—';
      return m.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
    }

    int topVal(Map<String, int> m) {
      if (m.isEmpty) return 0;
      return m.values.fold(0, math.max);
    }

    // Artista del año: el de mayor valoración media (sub-valoraciones).
    // Si no hay ninguno valorado, cae de vuelta al más visto.
    final artistRatingSum = <String, double>{};
    final artistRatingCount = <String, int>{};
    final artistVisitCount = <String, int>{};
    for (final x in c) {
      final a = x.artist.trim();
      if (a.isEmpty) continue;
      artistVisitCount[a] = (artistVisitCount[a] ?? 0) + 1;
      if (x.hasDetailedRating) {
        artistRatingSum[a] = (artistRatingSum[a] ?? 0) + x.detailedAvg;
        artistRatingCount[a] = (artistRatingCount[a] ?? 0) + 1;
      }
    }
    // Media por artista (solo los que tienen al menos una valoración detallada)
    final artistAvg = {
      for (final a in artistRatingSum.keys)
        a: artistRatingSum[a]! / artistRatingCount[a]!,
    };
    final String bestArtist;
    final double bestArtistRating;
    if (artistAvg.isNotEmpty) {
      final best = artistAvg.entries.reduce((a, b) => a.value >= b.value ? a : b);
      bestArtist = best.key;
      bestArtistRating = best.value;
    } else {
      // Sin valoraciones: artista más visto
      bestArtist = artistVisitCount.isEmpty
          ? '—'
          : artistVisitCount.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
      bestArtistRating = 0.0;
    }
    final int bestArtistCount = artistVisitCount[bestArtist] ?? 0;

    final artistMap = countMap(c.map((x) => x.artist.trim()));
    final cityMap = countMap(c.map((x) => x.city.trim()));
    final venueMap = countMap(c.map((x) => x.venue.trim()));

    final monthCounts = <int, int>{};
    for (final x in c) {
      monthCounts[x.date.month] = (monthCounts[x.date.month] ?? 0) + 1;
    }
    final topMonthEntry = monthCounts.isEmpty
        ? null
        : monthCounts.entries.reduce((a, b) => a.value >= b.value ? a : b);

    const monthNames = [
      '', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
    ];

    final rated = c.where((x) => x.hasDetailedRating).toList();
    final avg = rated.isEmpty
        ? 0.0
        : rated.fold<double>(0, (s, x) => s + x.detailedAvg) / rated.length;

    final festivalSet = <String>{};
    for (final x in c) {
      if (x.festival.trim().isNotEmpty) festivalSet.add(x.festival.trim());
    }

    return _YearSummary(
      year: year,
      total: c.length,
      topArtist: bestArtist,
      topArtistCount: bestArtistCount,
      topArtistRating: bestArtistRating,
      topArtistImageUrl: bestArtist == '—' ? '' : c
          .where((x) => x.artist.trim().toLowerCase() == bestArtist.toLowerCase() && x.imageUrl.isNotEmpty)
          .map((x) => x.imageUrl)
          .firstOrNull ?? '',
      topCity: topKey(cityMap),
      topCityCount: topVal(cityMap),
      topVenue: topKey(venueMap),
      topMonth: topMonthEntry == null ? '—' : monthNames[topMonthEntry.key],
      topMonthIdx: topMonthEntry?.key ?? 0,
      topMonthCount: topMonthEntry?.value ?? 0,
      avgRating: avg,
      festivals: festivalSet.length,
      liked: c.where((x) => x.liked).length,
      uniqueArtists: artistMap.length,
      uniqueCities: cityMap.length,
      monthCounts: monthCounts,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Página principal
// ─────────────────────────────────────────────────────────────────────────────

class AnnualSummaryPage extends ConsumerStatefulWidget {
  final int? initialYear;
  const AnnualSummaryPage({super.key, this.initialYear});

  @override
  ConsumerState<AnnualSummaryPage> createState() => _AnnualSummaryPageState();
}

class _AnnualSummaryPageState extends ConsumerState<AnnualSummaryPage> {
  final _pageController = PageController();
  int _currentSlide = 0;
  int _selectedYear = DateTime.now().year;
  final _shareKey = GlobalKey();
  bool _sharing = false;
  List<ConcertPhotoModel> _allPhotos = [];
  // Orden barajado de fotos para el año seleccionado — se fija al cargar/cambiar año.
  List<String> _shuffledBgs = [];

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialYear ?? DateTime.now().year;
    _loadPhotos();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _reshuffleBgs() {
    final urls = _photosForYear(_selectedYear);
    _shuffledBgs = List<String>.from(urls)..shuffle();
  }

  Future<void> _loadPhotos() async {
    try {
      final photos = await PhotoApiService().getFeed();
      if (mounted) setState(() { _allPhotos = photos; _reshuffleBgs(); });
    } catch (_) {
    }
  }

  List<String> _photosForYear(int year) => _allPhotos
      .where((p) => p.concert?.date.year == year)
      .map((p) => p.imageUrl)
      .where((u) => u.isNotEmpty)
      .toList();



  List<int> _availableYears(List<Concert> concerts) {
    final years = concerts.map((c) => c.date.year).toSet().toList()
      ..sort((a, b) => b.compareTo(a));
    if (!years.contains(DateTime.now().year)) years.insert(0, DateTime.now().year);
    return years;
  }

  Future<void> _share() async {
    setState(() => _sharing = true);
    try {
      await Future.delayed(80.ms);
      final boundary = _shareKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;
      final bytes = byteData.buffer.asUint8List();
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/wrapped_$_selectedYear.png');
      await file.writeAsBytes(bytes);
      await SharePlus.instance.share(ShareParams(
        files: [XFile(file.path)],
        text: '🎸 Mi Wrapped $_selectedYear | La Vida en Directo',
      ));
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  void _changeYear(int y) {
    setState(() { _selectedYear = y; _currentSlide = 0; _reshuffleBgs(); });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) _pageController.jumpToPage(0);
    });
  }

  List<Widget> _buildSlides(_YearSummary s, List<int> years, List<String> imgs) {
    void next() => _pageController.nextPage(duration: 350.ms, curve: Curves.easeInOut);
    void prev() => _pageController.previousPage(duration: 350.ms, curve: Curves.easeInOut);

    // Usa el orden barajado fijo (calculado al cargar/cambiar año) para que
    // no cambie en cada rebuild. Cada slide toma la siguiente foto sin repetir.
    int bgIdx = 0;
    String? bg() => bgIdx < _shuffledBgs.length ? _shuffledBgs[bgIdx++] : null;

    return [
      _IntroSlide(key: ValueKey('intro_$_selectedYear'), summary: s, years: years, selectedYear: _selectedYear, onYearChanged: _changeYear, onNext: next, bgImageUrl: bg()),
      _TotalSlide(key: ValueKey('total_$_selectedYear'), summary: s, onNext: next, onPrev: prev, bgImageUrl: bg()),
      if (s.topArtist != '—')
        // El artista usa su propia portada de concierto; si no la tiene, cae a recuerdos.
        _ArtistSlide(key: ValueKey('artist_$_selectedYear'), summary: s, onNext: next, onPrev: prev),
      _VarietySlide(key: ValueKey('variety_$_selectedYear'), summary: s, onNext: next, onPrev: prev, bgImageUrl: bg()),
      if (s.topCity != '—')
        _CitySlide(key: ValueKey('city_$_selectedYear'), summary: s, onNext: next, onPrev: prev, bgImageUrl: bg()),
      if (s.topMonth != '—' && s.monthCounts.isNotEmpty)
        _MonthSlide(key: ValueKey('month_$_selectedYear'), summary: s, onNext: next, onPrev: prev, bgImageUrl: bg()),
      if (s.avgRating > 0)
        _RatingSlide(key: ValueKey('rating_$_selectedYear'), summary: s, onNext: next, onPrev: prev, bgImageUrl: bg()),
      if (imgs.isNotEmpty)
        _PhotosSlide(key: ValueKey('photos_$_selectedYear'), imageUrls: imgs, year: _selectedYear, onNext: next, onPrev: prev),
      _ClosingSlide(key: ValueKey('closing_$_selectedYear'), summary: s, shareKey: _shareKey, sharing: _sharing, onShare: _share, onPrev: prev),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Si el año seleccionado es el año actual y aún no es diciembre → teaser.
    final now = DateTime.now();
    if (_selectedYear == now.year && now.month < 12) {
      return _WrapTeaser(year: _selectedYear, onClose: () => context.pop());
    }

    final concertsAsync = ref.watch(concertsProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      body: concertsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFE53935))),
        error: (err, _) => const Center(child: Text('Error cargando conciertos', style: TextStyle(color: Colors.white54))),
        data: (concerts) {
          final years = _availableYears(concerts);
          final currentUserId = AuthController.instance.user?.id ?? '';
          final summary = _YearSummary.from(concerts, _selectedYear, currentUserId);
          // Solo fotos de recuerdos subidas por el usuario, no portadas de concierto.
          final allImgs = _photosForYear(_selectedYear);
          final slides = _buildSlides(summary, years, allImgs);

          return Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentSlide = i),
                itemCount: slides.length,
                itemBuilder: (_, i) => slides[i],
              ),
              // Progress + close
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _StoryProgress(total: slides.length, current: _currentSlide),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 32, height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Progress de historia (barras tipo Instagram)
// ─────────────────────────────────────────────────────────────────────────────

class _StoryProgress extends StatelessWidget {
  final int total;
  final int current;
  const _StoryProgress({required this.total, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < total - 1 ? 4 : 0),
            height: 3,
            decoration: BoxDecoration(
              color: i <= current ? Colors.white : Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Base de cada slide con gradiente + tap navigation
// ─────────────────────────────────────────────────────────────────────────────

class _SlideBase extends StatelessWidget {
  final List<Color> colors;
  final Widget child;
  final VoidCallback? onNext;
  final VoidCallback? onPrev;
  /// URL de imagen opcional para mostrar difuminada sobre el gradiente.
  final String? imageUrl;

  const _SlideBase({
    required this.colors,
    required this.child,
    this.onNext,
    this.onPrev,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final hasImg = imageUrl != null && imageUrl!.isNotEmpty;
    return Stack(
      children: [
        // Gradient background — also tap zone
        GestureDetector(
          onTapUp: (d) {
            if (d.localPosition.dx < w * 0.35) {
              onPrev?.call();
            } else {
              onNext?.call();
            }
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Base gradient (siempre presente como fallback de color)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: colors,
                  ),
                ),
              ),
              // Foto difuminada encima del gradiente
              if (hasImg) ...[
                ImageFiltered(
                  imageFilter: ui.ImageFilter.blur(sigmaX: 2, sigmaY: 2, tileMode: TileMode.clamp),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: (ctx, url) => const SizedBox.shrink(),
                    errorWidget: (ctx, url, err) => const SizedBox.shrink(),
                  ),
                ),
                // Overlay oscuro para que el texto siga legible
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xCC000000), Color(0xB3000000)],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        // Slide content (buttons here absorb their own taps first)
        child,
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SLIDE 0 — Intro
// ─────────────────────────────────────────────────────────────────────────────

class _IntroSlide extends StatelessWidget {
  final _YearSummary summary;
  final List<int> years;
  final int selectedYear;
  final ValueChanged<int> onYearChanged;
  final VoidCallback onNext;
  final String? bgImageUrl;

  const _IntroSlide({
    super.key,
    required this.summary,
    required this.years,
    required this.selectedYear,
    required this.onYearChanged,
    required this.onNext,
    this.bgImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return _SlideBase(
      colors: const [Color(0xFF0D0005), Color(0xFF3A0010), Color(0xFF1A000A)],
      imageUrl: bgImageUrl,
      onNext: onNext,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 64, 32, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Year chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: years.map((y) {
                    final sel = y == selectedYear;
                    return GestureDetector(
                      onTap: () => onYearChanged(y),
                      child: AnimatedContainer(
                        duration: 200.ms,
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                        decoration: BoxDecoration(
                          color: sel ? const Color(0xFFE53935) : Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: sel ? Colors.transparent : Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text('$y', style: TextStyle(
                          color: sel ? Colors.white : Colors.white60,
                          fontWeight: sel ? FontWeight.w800 : FontWeight.w500,
                          fontSize: 15,
                        )),
                      ),
                    );
                  }).toList(),
                ),
              ).animate().fadeIn(delay: 200.ms),

              const Spacer(),

              // Big emoji
              const Text('🎸', style: TextStyle(fontSize: 64))
                  .animate().scale(begin: const Offset(0.5, 0.5), duration: 600.ms, curve: Curves.elasticOut),

              const SizedBox(height: 24),

              Text(
                'Tu año\nen conciertos',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 52,
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                  letterSpacing: -1,
                ),
              ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.3),

              const SizedBox(height: 16),

              Text(
                '$selectedYear',
                style: TextStyle(
                  color: const Color(0xFFE53935).withValues(alpha: 0.9),
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ).animate(delay: 350.ms).fadeIn(),

              const Spacer(),

              // Tap to start
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Empieza', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13)),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, color: Colors.white.withValues(alpha: 0.5), size: 18),
                ],
              ).animate(delay: 800.ms).fadeIn(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SLIDE 1 — Total de conciertos
// ─────────────────────────────────────────────────────────────────────────────

class _TotalSlide extends StatelessWidget {
  final _YearSummary summary;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final String? bgImageUrl;

  const _TotalSlide({super.key, required this.summary, required this.onNext, required this.onPrev, this.bgImageUrl});

  @override
  Widget build(BuildContext context) {
    return _SlideBase(
      colors: const [Color(0xFF08001F), Color(0xFF1A0050), Color(0xFF0D0030)],
      imageUrl: bgImageUrl,
      onNext: onNext, onPrev: onPrev,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text('Este año fuiste a', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 20, fontWeight: FontWeight.w400))
                  .animate().fadeIn().slideY(begin: 0.3),
              const SizedBox(height: 8),
              Text('${summary.total}', style: const TextStyle(color: Colors.white, fontSize: 120, fontWeight: FontWeight.w900, height: 1, letterSpacing: -4))
                  .animate(delay: 150.ms).fadeIn().scale(begin: const Offset(0.7, 0.7), curve: Curves.elasticOut, duration: 700.ms),
              Text('conciertos', style: const TextStyle(color: Color(0xFFB39DFF), fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: 0.5))
                  .animate(delay: 300.ms).fadeIn().slideX(begin: -0.2),
              const SizedBox(height: 32),
              if (summary.total > 0) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    summary.total >= 50 ? '🔥 ¡Año legendario!' :
                    summary.total >= 20 ? '🎉 ¡Gran año en directo!' :
                    summary.total >= 10 ? '👏 Muy buen año' :
                    '🎵 Empezando fuerte',
                    style: const TextStyle(color: Colors.white70, fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ).animate(delay: 500.ms).fadeIn(),
              ],
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SLIDE 2 — Artista del año
// ─────────────────────────────────────────────────────────────────────────────

class _ArtistSlide extends StatelessWidget {
  final _YearSummary summary;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final String? bgImageUrl;

  const _ArtistSlide({super.key, required this.summary, required this.onNext, required this.onPrev, this.bgImageUrl});

  @override
  Widget build(BuildContext context) {
    final rating = summary.topArtistRating;
    final times = summary.topArtistCount;
    // Construye la fila de estrellas (valoración media sobre 5)
    final fullStars = rating.floor();
    final hasHalf = (rating - fullStars) >= 0.4;

    return _SlideBase(
      colors: const [Color(0xFF00050F), Color(0xFF001A4A), Color(0xFF001030)],
      imageUrl: bgImageUrl ?? summary.topArtistImageUrl,
      onNext: onNext, onPrev: onPrev,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text('Tu artista del año', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 18, fontWeight: FontWeight.w400))
                  .animate().fadeIn(),
              const SizedBox(height: 16),
              Text(
                summary.topArtist.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 52, fontWeight: FontWeight.w900, height: 1.05, letterSpacing: -1),
              ).animate(delay: 150.ms).fadeIn().slideY(begin: 0.4, curve: Curves.easeOutCubic),
              const SizedBox(height: 24),
              // Valoración media con estrellas
              if (rating > 0) ...[
                Row(
                  children: [
                    ...List.generate(5, (i) {
                      IconData icon;
                      if (i < fullStars) {
                        icon = Icons.star_rounded;
                      } else if (i == fullStars && hasHalf) {
                        icon = Icons.star_half_rounded;
                      } else {
                        icon = Icons.star_outline_rounded;
                      }
                      return Icon(icon, color: const Color(0xFF64B5F6), size: 28)
                          .animate(delay: (350 + i * 80).ms).fadeIn().scale(begin: const Offset(0.4, 0.4));
                    }),
                    const SizedBox(width: 10),
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(color: Color(0xFF64B5F6), fontSize: 22, fontWeight: FontWeight.w700),
                    ).animate(delay: 750.ms).fadeIn(),
                  ],
                ),
                if (times > 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Lo viste $times veces',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 15),
                    ).animate(delay: 850.ms).fadeIn(),
                  ),
              ] else ...[
                Text(
                  times > 1 ? 'Lo viste $times veces' : 'Fue especial',
                  style: const TextStyle(color: Color(0xFF64B5F6), fontSize: 20, fontWeight: FontWeight.w600),
                ).animate(delay: 350.ms).fadeIn(),
              ],
              const SizedBox(height: 32),
              Text('♩ ♪ ♫ ♬', style: TextStyle(color: Colors.white.withValues(alpha: 0.15), fontSize: 32))
                  .animate(delay: 900.ms).fadeIn(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SLIDE 3 — Variedad
// ─────────────────────────────────────────────────────────────────────────────

class _VarietySlide extends StatelessWidget {
  final _YearSummary summary;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final String? bgImageUrl;

  const _VarietySlide({super.key, required this.summary, required this.onNext, required this.onPrev, this.bgImageUrl});

  @override
  Widget build(BuildContext context) {
    return _SlideBase(
      colors: const [Color(0xFF000F0F), Color(0xFF00352A), Color(0xFF001A15)],
      imageUrl: bgImageUrl,
      onNext: onNext, onPrev: onPrev,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text('Nunca te cansas', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 18))
                  .animate().fadeIn(),
              const SizedBox(height: 32),
              // Artists stat
              _BigStat(
                value: '${summary.uniqueArtists}',
                label: 'artistas distintos',
                color: const Color(0xFF4DB6AC),
                delay: 150.ms,
              ),
              const SizedBox(height: 28),
              // Cities stat
              _BigStat(
                value: '${summary.uniqueCities}',
                label: summary.uniqueCities == 1 ? 'ciudad' : 'ciudades diferentes',
                color: const Color(0xFF80CBC4),
                delay: 350.ms,
              ),
              if (summary.festivals > 0) ...[
                const SizedBox(height: 28),
                _BigStat(
                  value: '${summary.festivals}',
                  label: summary.festivals == 1 ? 'festival' : 'festivales',
                  color: const Color(0xFFB2DFDB),
                  delay: 500.ms,
                ),
              ],
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _BigStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final Duration delay;

  const _BigStat({required this.value, required this.label, required this.color, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 64, fontWeight: FontWeight.w900, height: 1, letterSpacing: -2))
            .animate(delay: delay).fadeIn().scale(begin: const Offset(0.6, 0.6), curve: Curves.elasticOut, duration: 600.ms),
        const SizedBox(width: 12),
        Flexible(child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.w500, height: 1.2)))
            .animate(delay: delay + 100.ms).fadeIn().slideX(begin: -0.2),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SLIDE 4 — Ciudad favorita
// ─────────────────────────────────────────────────────────────────────────────

class _CitySlide extends StatelessWidget {
  final _YearSummary summary;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final String? bgImageUrl;

  const _CitySlide({super.key, required this.summary, required this.onNext, required this.onPrev, this.bgImageUrl});

  @override
  Widget build(BuildContext context) {
    return _SlideBase(
      colors: const [Color(0xFF100500), Color(0xFF3D1200), Color(0xFF1A0800)],
      imageUrl: bgImageUrl,
      onNext: onNext, onPrev: onPrev,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text('Tu ciudad favorita', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 18))
                  .animate().fadeIn(),
              const SizedBox(height: 16),
              Text('📍', style: const TextStyle(fontSize: 48))
                  .animate(delay: 100.ms).scale(begin: const Offset(0.5, 0.5), duration: 500.ms, curve: Curves.elasticOut),
              const SizedBox(height: 12),
              Text(
                summary.topCity.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.w900, height: 1.05, letterSpacing: -1),
              ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.4, curve: Curves.easeOutCubic),
              const SizedBox(height: 16),
              Text(
                summary.topCityCount == 1 ? '1 concierto' : '${summary.topCityCount} conciertos',
                style: const TextStyle(color: Color(0xFFFFAB76), fontSize: 20, fontWeight: FontWeight.w600),
              ).animate(delay: 400.ms).fadeIn(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SLIDE 5 — Mes más activo
// ─────────────────────────────────────────────────────────────────────────────

class _MonthSlide extends StatelessWidget {
  final _YearSummary summary;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final String? bgImageUrl;

  const _MonthSlide({super.key, required this.summary, required this.onNext, required this.onPrev, this.bgImageUrl});

  @override
  Widget build(BuildContext context) {
    final counts = summary.monthCounts;
    final maxVal = counts.values.fold(0, math.max);

    const monthShort = ['', 'E', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];

    return _SlideBase(
      colors: const [Color(0xFF100800), Color(0xFF3D2200), Color(0xFF1E1000)],
      imageUrl: bgImageUrl,
      onNext: onNext, onPrev: onPrev,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text('Tu mes más activo', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 18))
                  .animate().fadeIn(),
              const SizedBox(height: 12),
              Text(
                summary.topMonth.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 56, fontWeight: FontWeight.w900, height: 1, letterSpacing: -1),
              ).animate(delay: 150.ms).fadeIn().slideY(begin: 0.3, curve: Curves.easeOutCubic),
              const SizedBox(height: 8),
              Text('${summary.topMonthCount} ${summary.topMonthCount == 1 ? "concierto" : "conciertos"}',
                  style: const TextStyle(color: Color(0xFFFFD180), fontSize: 18, fontWeight: FontWeight.w600))
                  .animate(delay: 300.ms).fadeIn(),
              const SizedBox(height: 40),
              // Mini bar chart
              SizedBox(
                height: 96,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(12, (i) {
                    final month = i + 1;
                    final count = counts[month] ?? 0;
                    final ratio = maxVal > 0 ? count / maxVal : 0.0;
                    final isTop = month == summary.topMonthIdx;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AnimatedContainer(
                              duration: 600.ms,
                              curve: Curves.easeOutCubic,
                              height: math.max(4.0, 72 * ratio),
                              decoration: BoxDecoration(
                                color: isTop ? const Color(0xFFFFD180) : const Color(0xFFFFD180).withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              monthShort[month],
                              style: TextStyle(
                                color: isTop ? const Color(0xFFFFD180) : Colors.white.withValues(alpha: 0.3),
                                fontSize: 9,
                                fontWeight: isTop ? FontWeight.w700 : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ).animate(delay: 400.ms).fadeIn(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SLIDE 6 — Valoración media
// ─────────────────────────────────────────────────────────────────────────────

class _RatingSlide extends StatelessWidget {
  final _YearSummary summary;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final String? bgImageUrl;

  const _RatingSlide({super.key, required this.summary, required this.onNext, required this.onPrev, this.bgImageUrl});

  @override
  Widget build(BuildContext context) {
    final rating = summary.avgRating;
    return _SlideBase(
      colors: const [Color(0xFF0F0C00), Color(0xFF3D3000), Color(0xFF1F1800)],
      imageUrl: bgImageUrl,
      onNext: onNext, onPrev: onPrev,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text('Tu valoración media', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 18))
                  .animate().fadeIn(),
              const SizedBox(height: 32),
              // Stars
              Row(
                children: List.generate(5, (i) {
                  final filled = (i + 1) <= rating;
                  final half = !filled && i < rating;
                  return Icon(
                    half ? Icons.star_half_rounded : (filled ? Icons.star_rounded : Icons.star_outline_rounded),
                    color: const Color(0xFFFFC107),
                    size: 44,
                  ).animate(delay: (i * 80).ms).scale(begin: const Offset(0.3, 0.3), curve: Curves.elasticOut, duration: 500.ms);
                }),
              ),
              const SizedBox(height: 20),
              Text(
                rating.toStringAsFixed(1),
                style: const TextStyle(color: Colors.white, fontSize: 96, fontWeight: FontWeight.w900, height: 1, letterSpacing: -3),
              ).animate(delay: 500.ms).fadeIn().scale(begin: const Offset(0.6, 0.6), curve: Curves.easeOutBack),
              const SizedBox(height: 8),
              Text('sobre 5', style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 18, fontWeight: FontWeight.w400))
                  .animate(delay: 600.ms).fadeIn(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SLIDE 7 — Collage de fotos
// ─────────────────────────────────────────────────────────────────────────────

class _PhotosSlide extends StatelessWidget {
  final List<String> imageUrls;
  final int year;
  final VoidCallback onNext;
  final VoidCallback onPrev;

  const _PhotosSlide({super.key, required this.imageUrls, required this.year, required this.onNext, required this.onPrev});

  @override
  Widget build(BuildContext context) {
    final photos = imageUrls.take(9).toList();
    // Slight rotation angles for each photo cell
    const angles = [-0.03, 0.02, -0.01, 0.04, -0.02, 0.03, -0.01, 0.02, -0.03];

    return _SlideBase(
      colors: const [Color(0xFF060606), Color(0xFF0F0F0F), Color(0xFF060606)],
      onNext: onNext, onPrev: onPrev,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 64, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tus memorias', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 18, fontWeight: FontWeight.w400))
                  .animate().fadeIn(),
              const SizedBox(height: 4),
              Text('$year', style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900))
                  .animate(delay: 100.ms).fadeIn(),
              const SizedBox(height: 24),

              // Photo grid
              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: photos.length <= 4 ? 2 : 3,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                  ),
                  itemCount: photos.length,
                  itemBuilder: (_, i) {
                    final angle = i < angles.length ? angles[i] : 0.0;
                    return Transform.rotate(
                      angle: angle,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1.5),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: photos[i],
                            fit: BoxFit.cover,
                            fadeInDuration: Duration.zero,
                            placeholder: (ctx, url) => Container(color: Colors.white.withValues(alpha: 0.05)),
                            errorWidget: (ctx, url, err) => Container(
                              color: Colors.white.withValues(alpha: 0.05),
                              child: const Icon(Icons.music_note_rounded, color: Colors.white12, size: 32),
                            ),
                          ),
                        ),
                      ),
                    ).animate(delay: (i * 80).ms).fadeIn().scale(begin: const Offset(0.7, 0.7), curve: Curves.easeOutBack);
                  },
                ),
              ),

              const SizedBox(height: 16),
              Text(
                '${imageUrls.length} ${imageUrls.length == 1 ? "recuerdo" : "recuerdos"} este año',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 13),
              ).animate(delay: 800.ms).fadeIn(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SLIDE 8 — Cierre + tarjeta compartible
// ─────────────────────────────────────────────────────────────────────────────

class _ClosingSlide extends StatelessWidget {
  final _YearSummary summary;
  final GlobalKey shareKey;
  final bool sharing;
  final VoidCallback onShare;
  final VoidCallback onPrev;

  const _ClosingSlide({
    super.key,
    required this.summary,
    required this.shareKey,
    required this.sharing,
    required this.onShare,
    required this.onPrev,
  });

  @override
  Widget build(BuildContext context) {
    return _SlideBase(
      colors: const [Color(0xFF0D0005), Color(0xFF2D0010), Color(0xFF1A000A)],
      onPrev: onPrev,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 64, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tu resumen', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 18))
                  .animate().fadeIn(),
              Text('${summary.year}', style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900))
                  .animate(delay: 100.ms).fadeIn(),
              const SizedBox(height: 24),

              // ── Tarjeta compartible ──────────────────────────
              RepaintBoundary(
                key: shareKey,
                child: _ShareCard(summary: summary),
              ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.2),

              const SizedBox(height: 32),

              // ── Botón compartir ──────────────────────────────
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  onPressed: sharing ? null : onShare,
                  icon: sharing
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.ios_share_rounded),
                  label: Text(sharing ? 'Preparando...' : 'Compartir mi Wrapped',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.3),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tarjeta que se captura al compartir
// ─────────────────────────────────────────────────────────────────────────────

class _ShareCard extends StatelessWidget {
  final _YearSummary summary;
  const _ShareCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A0508), Color(0xFF2D0B0B), Color(0xFF120306)],
        ),
        border: Border.all(color: const Color(0xFFE53935).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFE53935), borderRadius: BorderRadius.circular(10)),
                child: Text('${summary.year}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)),
              ),
              const SizedBox(width: 12),
              const Text('La Vida en Directo', style: TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 24),

          // Big number
          Text('${summary.total}', style: const TextStyle(color: Colors.white, fontSize: 80, fontWeight: FontWeight.w900, height: 1, letterSpacing: -2)),
          const Text('conciertos', style: TextStyle(color: Color(0xFFE53935), fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: 0.5)),

          const SizedBox(height: 24),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.08)),
          const SizedBox(height: 20),

          // Stats rows
          if (summary.topArtist != '—') ...[
            _Row(emoji: '🎤', label: 'Artista favorito', value: summary.topArtist),
            const SizedBox(height: 12),
          ],
          if (summary.topCity != '—') ...[
            _Row(emoji: '🏙️', label: 'Ciudad favorita', value: summary.topCity),
            const SizedBox(height: 12),
          ],
          if (summary.topMonth != '—')
            _Row(emoji: '📅', label: 'Mes más activo', value: summary.topMonth),

          const SizedBox(height: 20),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.08)),
          const SizedBox(height: 16),

          // Bottom stats
          Row(
            children: [
              _MiniBox(value: '${summary.uniqueArtists}', label: 'artistas'),
              const SizedBox(width: 10),
              _MiniBox(value: '${summary.uniqueCities}', label: 'ciudades'),
              const SizedBox(width: 10),
              if (summary.avgRating > 0)
                _MiniBox(value: summary.avgRating.toStringAsFixed(1), label: 'valoración'),
            ],
          ),

          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Text('🎸 La Vida en Directo', style: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 11, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  const _Row({required this.emoji, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w500)),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniBox extends StatelessWidget {
  final String value;
  final String label;
  const _MiniBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 9, height: 1.2), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Pantalla teaser — aparece cuando el Wrapped del año actual aún no está listo
// (antes de diciembre)
// ─────────────────────────────────────────────────────────────────────────────

class _WrapTeaser extends StatelessWidget {
  final int year;
  final VoidCallback onClose;

  const _WrapTeaser({required this.year, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final monthsLeft = 12 - now.month; // meses que faltan hasta diciembre
    const monthLabels = ['E','F','M','A','M','J','J','A','S','O','N','D'];

    return Scaffold(
      backgroundColor: const Color(0xFF07070F),
      body: Stack(
        children: [
          // Watermark año
          Positioned.fill(
            child: Center(
              child: Text(
                '$year',
                style: const TextStyle(
                  fontSize: 148,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -6,
                  color: Color(0x09FFFFFF),
                  height: 1,
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true))
                  .custom(duration: 5.seconds, builder: (_, v, child) =>
                      Opacity(opacity: 0.5 + v * 0.5, child: child)),
            ),
          ),

          // Contenido principal
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 64, 32, 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),

                  // Emoji animado
                  const Text('🎟️', style: TextStyle(fontSize: 52))
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .slideY(begin: 0, end: -0.12, duration: 2.seconds, curve: Curves.easeInOut),

                  const SizedBox(height: 24),

                  // Label
                  Text(
                    'Tu año en conciertos',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 14, fontWeight: FontWeight.w500),
                  ).animate().fadeIn(),

                  const SizedBox(height: 10),

                  // Headline
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 46, fontWeight: FontWeight.w900, height: 0.95, letterSpacing: -2),
                      children: [
                        const TextSpan(text: 'Tu ', style: TextStyle(color: Colors.white)),
                        const TextSpan(text: 'Wrapped\n', style: TextStyle(color: Color(0xFFE53935))),
                        TextSpan(text: 'del $year', style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.3, curve: Curves.easeOutCubic),

                  const SizedBox(height: 8),

                  Text(
                    'llega en diciembre',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white.withValues(alpha: 0.35), letterSpacing: -0.5),
                  ).animate(delay: 200.ms).fadeIn(),

                  const SizedBox(height: 36),

                  // Dots de meses
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PROGRESO DEL AÑO',
                        style: TextStyle(fontSize: 10, letterSpacing: 1.8, color: Colors.white.withValues(alpha: 0.22), fontWeight: FontWeight.w600),
                      ),
                      Text(
                        monthsLeft == 1 ? '1 mes para diciembre' : '$monthsLeft meses para diciembre',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFFFFB300)),
                      ),
                    ],
                  ).animate(delay: 300.ms).fadeIn(),

                  const SizedBox(height: 12),

                  Row(
                    children: List.generate(12, (i) {
                      final month = i + 1;
                      final isDone = month < now.month;
                      final isCurrent = month == now.month;

                      Color bg;
                      Color fg;
                      if (isCurrent) {
                        bg = const Color(0xFFE53935);
                        fg = Colors.white;
                      } else if (isDone) {
                        bg = const Color(0xFFE53935).withValues(alpha: 0.22);
                        fg = const Color(0xFFE53935).withValues(alpha: 0.8);
                      } else {
                        bg = Colors.white.withValues(alpha: 0.07);
                        fg = Colors.white.withValues(alpha: 0.22);
                      }

                      return Expanded(
                        child: AnimatedContainer(
                          duration: 300.ms,
                          margin: const EdgeInsets.symmetric(horizontal: 2.5),
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: bg,
                            shape: BoxShape.circle,
                            boxShadow: isCurrent ? [
                              BoxShadow(color: const Color(0xFFE53935).withValues(alpha: 0.5), blurRadius: 10, spreadRadius: 1),
                            ] : null,
                          ),
                          child: Center(
                            child: Text(
                              monthLabels[i],
                              style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: fg),
                            ),
                          ),
                        ).animate(delay: (320 + i * 40).ms).fadeIn().scale(begin: const Offset(0.5, 0.5)),
                      );
                    }),
                  ),

                  const SizedBox(height: 32),

                  // Teaser card con stats difuminados
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.055),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TU HISTORIA ESTE AÑO',
                          style: TextStyle(fontSize: 9, letterSpacing: 2, color: Colors.white.withValues(alpha: 0.22), fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 16),
                        ImageFiltered(
                          imageFilter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Row(
                            children: [
                              _TeaserStat(num: '—', label: 'conciertos'),
                              Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.08), margin: const EdgeInsets.symmetric(horizontal: 18)),
                              _TeaserStat(num: '—', label: 'artistas'),
                              Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.08), margin: const EdgeInsets.symmetric(horizontal: 18)),
                              _TeaserStat(num: '—', label: 'ciudades'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.2),

                  const Spacer(),
                ],
              ),
            ),
          ),

          // Barra de progreso y botón cerrar (arriba)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: List.generate(9, (_) =>
                        Expanded(child: Container(
                          height: 3,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.22), borderRadius: BorderRadius.circular(2)),
                        )),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: onClose,
                    child: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
                    ),
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

class _TeaserStat extends StatelessWidget {
  final String num;
  final String label;
  const _TeaserStat({required this.num, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(num, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: Colors.white, height: 1, letterSpacing: -1)),
          const SizedBox(height: 5),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.4), fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
