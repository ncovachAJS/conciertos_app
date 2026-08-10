import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/concert.dart';

class ConcertCalendarView extends StatefulWidget {
  final List<Concert> concerts;

  /// Callback que se invoca cuando el usuario quiere añadir un concierto
  /// en una fecha concreta. Si es null, la funcionalidad de añadir queda oculta.
  final void Function(DateTime date)? onAddConcert;

  const ConcertCalendarView({
    super.key,
    required this.concerts,
    this.onAddConcert,
  });

  @override
  State<ConcertCalendarView> createState() => _ConcertCalendarViewState();
}

class _ConcertCalendarViewState extends State<ConcertCalendarView> {
  late DateTime _focus;

  static const _weekdays = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
  static const _months = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
  ];

  @override
  void initState() {
    super.initState();
    _focus = DateTime(DateTime.now().year, DateTime.now().month);
  }

  Map<int, List<Concert>> _byDay() {
    final map = <int, List<Concert>>{};
    for (final c in widget.concerts) {
      if (c.date.year == _focus.year && c.date.month == _focus.month) {
        (map[c.date.day] ??= []).add(c);
      }
    }
    return map;
  }

  bool get _isCurrentMonth {
    final now = DateTime.now();
    return _focus.year == now.year && _focus.month == now.month;
  }

  void _prevMonth() =>
      setState(() => _focus = DateTime(_focus.year, _focus.month - 1));
  void _nextMonth() =>
      setState(() => _focus = DateTime(_focus.year, _focus.month + 1));
  void _goToToday() =>
      setState(() => _focus = DateTime(DateTime.now().year, DateTime.now().month));

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final byDay = _byDay();

    final firstOfMonth = DateTime(_focus.year, _focus.month, 1);
    final startOffset = (firstOfMonth.weekday - 1) % 7;
    final daysInMonth = DateUtils.getDaysInMonth(_focus.year, _focus.month);
    final totalCells = startOffset + daysInMonth;
    final rows = (totalCells / 7).ceil();

    final today = DateTime.now();

    return Column(
      children: [
        // ── Cabecera: mes + navegación ────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Row(
            children: [
              IconButton(
                onPressed: _prevMonth,
                icon: const Icon(Icons.chevron_left_rounded, size: 22),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
              Expanded(
                child: Text(
                  '${_months[_focus.month - 1]} ${_focus.year}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              // Botón "Hoy" — solo visible cuando no es el mes actual
              AnimatedOpacity(
                duration: const Duration(milliseconds: 180),
                opacity: _isCurrentMonth ? 0 : 1,
                child: GestureDetector(
                  onTap: _isCurrentMonth ? null : _goToToday,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Hoy',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE53935),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: _nextMonth,
                icon: const Icon(Icons.chevron_right_rounded, size: 22),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
            ],
          ),
        ),

        // ── Cabecera días de semana ───────────────────────────────────
        Row(
          children: List.generate(7, (i) {
            final isWeekend = i >= 5;
            return Expanded(
              child: Center(
                child: Text(
                  _weekdays[i],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                    color: isWeekend
                        ? cs.onSurface.withValues(alpha: 0.3)
                        : cs.onSurface.withValues(alpha: 0.45),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),

        // ── Grid de días (scrollable, celdas de altura fija) ─────────
        Expanded(
          child: SingleChildScrollView(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 0.78, // celdas ligeramente más altas que anchas
              ),
              itemCount: rows * 7,
              itemBuilder: (_, index) {
                final dayNum = index - startOffset + 1;
                if (dayNum < 1 || dayNum > daysInMonth) {
                  return const SizedBox.shrink();
                }
                final concerts = byDay[dayNum] ?? [];
                final isToday = _focus.year == today.year &&
                    _focus.month == today.month &&
                    today.day == dayNum;

                final date = DateTime(_focus.year, _focus.month, dayNum);
                return _DayCell(
                  day: dayNum,
                  concerts: concerts,
                  isToday: isToday,
                  canAdd: widget.onAddConcert != null,
                  onTap: concerts.isNotEmpty
                      ? () => _showDaySheet(context, dayNum, concerts, date)
                      : widget.onAddConcert != null
                          ? () => widget.onAddConcert!(date)
                          : null,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showDaySheet(
    BuildContext context,
    int day,
    List<Concert> concerts,
    DateTime date,
  ) {
    final cs = Theme.of(context).colorScheme;
    final label = '$day de ${_months[_focus.month - 1]}';
    final addConcert = widget.onAddConcert;

    showModalBottomSheet(
      context: context,
      backgroundColor: cs.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.45,
        maxChildSize: 0.9,
        builder: (_, controller) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: cs.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Row(
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${concerts.length} concierto${concerts.length > 1 ? 's' : ''}',
                      style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600,
                        color: Color(0xFFE53935),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: cs.onSurface.withValues(alpha: 0.08)),
            Expanded(
              child: ListView.separated(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                itemCount: concerts.length,
                separatorBuilder: (_, i) => const SizedBox(height: 10),
                itemBuilder: (ctx, i) => _SheetRow(concert: concerts[i]),
              ),
            ),
            // ── Botón añadir en esta fecha ──────────────────────────
            if (addConcert != null) ...[
              Divider(height: 1, color: cs.onSurface.withValues(alpha: 0.08)),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      addConcert(date);
                    },
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Añadir concierto en esta fecha'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFE53935),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Celda de día — diseño con imagen de fondo + número encima
// ─────────────────────────────────────────────────────────────────────────────

class _DayCell extends StatelessWidget {
  final int day;
  final List<Concert> concerts;
  final bool isToday;
  final bool canAdd;
  final VoidCallback? onTap;

  const _DayCell({
    required this.day,
    required this.concerts,
    required this.isToday,
    this.canAdd = false,
    this.onTap,
  });

  // Color de iniciales determinista por artista
  static Color _artistColor(String artist) {
    const palette = [
      Color(0xFFB71C1C), Color(0xFF6A1B9A), Color(0xFF0D47A1),
      Color(0xFF1B5E20), Color(0xFFE65100), Color(0xFF006064),
    ];
    if (artist.isEmpty) return palette[0];
    return palette[artist.codeUnitAt(0) % palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasConcerts = concerts.isNotEmpty;
    final primary = hasConcerts ? concerts.first : null;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Fondo: imagen del primer concierto o color sólido ──────
            if (primary != null)
              primary.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: primary.imageUrl,
                      fit: BoxFit.cover,
                      errorWidget: (ctx, url, err) =>
                          _ColorBg(color: _artistColor(primary.artist)),
                      placeholder: (ctx, url) =>
                          _ColorBg(color: _artistColor(primary.artist)),
                    )
                  : _ColorBg(color: _artistColor(primary.artist))
            else
              Container(
                color: isToday
                    ? const Color(0xFFE53935).withValues(alpha: 0.08)
                    : cs.onSurface.withValues(alpha: 0.04),
              ),

            // ── Gradiente oscuro (cuando hay imagen) para leer el número ──
            if (primary != null)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.55),
                      Colors.black.withValues(alpha: 0.15),
                    ],
                  ),
                ),
              ),

            // ── Número del día ────────────────────────────────────────
            Positioned(
              top: 5,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: isToday
                      ? BoxDecoration(
                          color: const Color(0xFFE53935),
                          shape: BoxShape.circle,
                        )
                      : null,
                  child: Center(
                    child: Text(
                      '$day',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isToday
                            ? Colors.white
                            : primary != null
                                ? Colors.white
                                : cs.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Badge "+N" si hay más de un concierto ────────────────
            if (concerts.length > 1)
              Positioned(
                bottom: 5,
                right: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '+${concerts.length - 1}',
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            // ── Borde de hoy (sin imagen) ─────────────────────────────
            if (isToday && primary == null)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFE53935),
                      width: 1.5,
                    ),
                  ),
                ),
              ),

            // ── Icono "+" en días vacíos tapeables ───────────────────
            if (primary == null && canAdd)
              Positioned(
                bottom: 5,
                right: 5,
                child: Icon(
                  Icons.add_rounded,
                  size: 12,
                  color: cs.onSurface.withValues(alpha: 0.25),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ColorBg extends StatelessWidget {
  final Color color;
  const _ColorBg({required this.color});

  @override
  Widget build(BuildContext context) => ColoredBox(color: color);
}

// ─────────────────────────────────────────────────────────────────────────────
// Fila en el bottom-sheet
// ─────────────────────────────────────────────────────────────────────────────

class _SheetRow extends StatelessWidget {
  final Concert concert;
  const _SheetRow({required this.concert});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        context.push('/concert-detail', extra: concert);
      },
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(14),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            // Thumbnail
            SizedBox(
              width: 64, height: 64,
              child: concert.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: concert.imageUrl,
                      fit: BoxFit.cover,
                      errorWidget: (ctx, url, err) =>
                          _FallbackThumb(concert: concert),
                    )
                  : _FallbackThumb(concert: concert),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      concert.artist,
                      style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (concert.name.isNotEmpty &&
                        concert.name != concert.artist) ...[
                      const SizedBox(height: 2),
                      Text(
                        concert.name,
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurface.withValues(alpha: 0.55),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (concert.venue.isNotEmpty || concert.city.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        [concert.venue, concert.city]
                            .where((s) => s.isNotEmpty)
                            .join(' · '),
                        style: TextStyle(
                          fontSize: 11,
                          color: cs.onSurface.withValues(alpha: 0.4),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: cs.onSurface.withValues(alpha: 0.25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FallbackThumb extends StatelessWidget {
  final Concert concert;
  const _FallbackThumb({required this.concert});

  static Color _color(String artist) {
    const palette = [
      Color(0xFFE53935), Color(0xFF8E24AA), Color(0xFF1E88E5),
      Color(0xFF00897B), Color(0xFFFF8F00), Color(0xFF43A047),
    ];
    if (artist.isEmpty) return palette[0];
    return palette[artist.codeUnitAt(0) % palette.length];
  }

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: _color(concert.artist),
        child: Center(
          child: Text(
            concert.artist.isNotEmpty ? concert.artist[0].toUpperCase() : '?',
            style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white,
            ),
          ),
        ),
      );
}
