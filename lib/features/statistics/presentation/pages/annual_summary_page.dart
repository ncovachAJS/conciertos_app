import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

import '../../../concerts/domain/entities/concert.dart';
import '../../../concerts/presentation/providers/concerts_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Modelo de datos del resumen anual
// ─────────────────────────────────────────────────────────────────────────────

class _YearSummary {
  final int year;
  final int total;
  final String topArtist;
  final String topCity;
  final String topVenue;
  final String topMonth;
  final double avgRating;
  final int festivals;
  final int liked;

  const _YearSummary({
    required this.year,
    required this.total,
    required this.topArtist,
    required this.topCity,
    required this.topVenue,
    required this.topMonth,
    required this.avgRating,
    required this.festivals,
    required this.liked,
  });

  static _YearSummary from(List<Concert> concerts, int year) {
    final c = concerts.where((c) => c.date.year == year).toList();

    String _top(Iterable<String> values) {
      final map = <String, int>{};
      for (final v in values) {
        map[v] = (map[v] ?? 0) + 1;
      }
      if (map.isEmpty) return '—';
      return map.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
    }

    final monthNames = [
      '', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
    ];

    final monthCounts = <int, int>{};
    for (final concert in c) {
      monthCounts[concert.date.month] =
          (monthCounts[concert.date.month] ?? 0) + 1;
    }
    final topMonthIdx = monthCounts.isEmpty
        ? 0
        : monthCounts.entries
            .reduce((a, b) => a.value >= b.value ? a : b)
            .key;

    final rated = c.where((x) => x.rating > 0).toList();
    final avg = rated.isEmpty
        ? 0.0
        : rated.fold<int>(0, (s, x) => s + x.rating) / rated.length;

    final festivalSet = <String>{};
    for (final x in c) {
      if (x.festival.trim().isNotEmpty) festivalSet.add(x.festival.trim());
    }

    return _YearSummary(
      year: year,
      total: c.length,
      topArtist: _top(
        c.map((x) => x.artist.trim()).where((a) => a.isNotEmpty),
      ),
      topCity: _top(
        c.map((x) => x.city.trim()).where((a) => a.isNotEmpty),
      ),
      topVenue: _top(
        c.map((x) => x.venue.trim()).where((a) => a.isNotEmpty),
      ),
      topMonth: topMonthIdx == 0 ? '—' : monthNames[topMonthIdx],
      avgRating: avg,
      festivals: festivalSet.length,
      liked: c.where((x) => x.liked).length,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Página principal
// ─────────────────────────────────────────────────────────────────────────────

class AnnualSummaryPage extends ConsumerStatefulWidget {
  const AnnualSummaryPage({super.key});

  @override
  ConsumerState<AnnualSummaryPage> createState() => _AnnualSummaryPageState();
}

class _AnnualSummaryPageState extends ConsumerState<AnnualSummaryPage> {
  final _cardKey = GlobalKey();
  bool _sharing = false;
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = DateTime.now().year;
  }

  List<int> _availableYears(List<Concert> concerts) {
    final years = concerts.map((c) => c.date.year).toSet().toList()
      ..sort((a, b) => b.compareTo(a));
    if (!years.contains(DateTime.now().year)) {
      years.insert(0, DateTime.now().year);
    }
    return years;
  }

  Future<void> _share() async {
    setState(() => _sharing = true);
    try {
      await Future.delayed(const Duration(milliseconds: 80));
      final boundary =
          _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final bytes = byteData.buffer.asUint8List();
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/resumen_$_selectedYear.png');
      await file.writeAsBytes(bytes);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: '🎸 Mi año $_selectedYear en conciertos',
        ),
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final concertsAsync = ref.watch(concertsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text(
          'Resumen anual',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          if (!_sharing)
            IconButton(
              icon: const Icon(Icons.ios_share_rounded, color: Colors.white),
              tooltip: 'Compartir',
              onPressed: _share,
            ),
          if (_sharing)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
      body: concertsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFFE53935)),
        ),
        error: (_, __) => const Center(
          child: Text('Error cargando conciertos',
              style: TextStyle(color: Colors.white54)),
        ),
        data: (concerts) {
          final years = _availableYears(concerts);
          final summary = _YearSummary.from(concerts, _selectedYear);

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
            child: Column(
              children: [
                // ── Selector de año ────────────────────────────────────
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: years.map((y) {
                      final selected = y == _selectedYear;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedYear = y),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFFE53935)
                                  : const Color(0xFF1E1E1E),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Text(
                              '$y',
                              style: TextStyle(
                                color: selected ? Colors.white : Colors.white54,
                                fontWeight: selected
                                    ? FontWeight.w800
                                    : FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // ── Tarjeta compartible ────────────────────────────────
                RepaintBoundary(
                  key: _cardKey,
                  child: _SummaryCard(summary: summary),
                ),

                const SizedBox(height: 24),

                // ── Stats secundarias ──────────────────────────────────
                _SecondaryStats(summary: summary),

                const SizedBox(height: 32),

                // ── Botón de compartir ─────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFE53935),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _sharing ? null : _share,
                    icon: const Icon(Icons.ios_share_rounded),
                    label: const Text(
                      'Compartir resumen',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tarjeta principal (la que se captura como imagen)
// ─────────────────────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final _YearSummary summary;

  const _SummaryCard({required this.summary});

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
          colors: [Color(0xFF1A0A0A), Color(0xFF2D0B0B), Color(0xFF1A0A0A)],
        ),
        border: Border.all(color: const Color(0xFFE53935).withValues(alpha: .3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Año + subtítulo
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${summary.year}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Tu año en conciertos',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Número grande de conciertos
          Text(
            '${summary.total}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 72,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const Text(
            'conciertos',
            style: TextStyle(
              color: Color(0xFFE53935),
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 28),
          const _Divider(),
          const SizedBox(height: 20),

          // Artista top
          _CardRow(
            emoji: '🎤',
            label: 'Artista favorito',
            value: summary.topArtist,
          ),
          const SizedBox(height: 14),

          // Ciudad top
          _CardRow(
            emoji: '🏙️',
            label: 'Ciudad favorita',
            value: summary.topCity,
          ),
          const SizedBox(height: 14),

          // Mes top
          _CardRow(
            emoji: '📅',
            label: 'Mes más activo',
            value: summary.topMonth,
          ),

          const SizedBox(height: 20),
          const _Divider(),
          const SizedBox(height: 20),

          // Rating + festivales
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  value: summary.avgRating > 0
                      ? summary.avgRating.toStringAsFixed(1)
                      : '—',
                  label: 'Valoración\nmedia',
                  icon: '⭐',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MiniStat(
                  value: '${summary.festivals}',
                  label: 'Festivales\ndistintos',
                  icon: '🎪',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MiniStat(
                  value: '${summary.liked}',
                  label: 'Te\ngustaron',
                  icon: '👍',
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Marca de agua
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'La Vida en Directo',
              style: TextStyle(
                color: Colors.white.withValues(alpha: .2),
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: Colors.white.withValues(alpha: .08),
    );
  }
}

class _CardRow extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;

  const _CardRow({
    required this.emoji,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;
  final String icon;

  const _MiniStat({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 9,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stats secundarias (debajo de la tarjeta, no se comparten)
// ─────────────────────────────────────────────────────────────────────────────

class _SecondaryStats extends StatelessWidget {
  final _YearSummary summary;

  const _SecondaryStats({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Más detalles',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              _DetailRow(
                icon: Icons.stadium_rounded,
                label: 'Recinto más visitado',
                value: summary.topVenue,
              ),
              if (summary.topVenue != '—') ...[
                const Divider(color: Colors.white10, height: 24),
              ],
              _DetailRow(
                icon: Icons.star_rounded,
                label: 'Valoración media',
                value: summary.avgRating > 0
                    ? '${summary.avgRating.toStringAsFixed(1)} / 5'
                    : 'Sin valoraciones',
                color: const Color(0xFFFFC107),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color ?? Colors.white38, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white38, fontSize: 11),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
