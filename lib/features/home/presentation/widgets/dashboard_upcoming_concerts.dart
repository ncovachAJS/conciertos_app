import 'package:flutter/material.dart';

import '../../../../../core/responsive/responsive.dart';
import '../../../concerts/domain/entities/concert.dart';
import 'dashboard_next_concert.dart';

class DashboardUpcomingConcerts extends StatefulWidget {
  final List<Concert> concerts;
  final ValueChanged<int>? onConcertChanged;

  const DashboardUpcomingConcerts({
    super.key,
    required this.concerts,
    this.onConcertChanged,
  });

  @override
  State<DashboardUpcomingConcerts> createState() =>
      _DashboardUpcomingConcertsState();
}

class _DashboardUpcomingConcertsState extends State<DashboardUpcomingConcerts> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final concerts = widget.concerts;
    final isTablet = Responsive.isTablet(context);

    if (concerts.isEmpty) {
      return const DashboardNextConcert(concert: null);
    }

    if (_currentIndex >= concerts.length) {
      _currentIndex = concerts.length - 1;
    }

    // ── iPad: dos tarjetas en fila ────────────────────────────────────────────
    if (isTablet) {
      // Página de 2: mostramos concerts[page*2] y concerts[page*2+1]
      final totalPages = (concerts.length / 2).ceil();
      final page = (_currentIndex ~/ 2).clamp(0, totalPages - 1);
      final i1 = page * 2;
      final i2 = i1 + 1 < concerts.length ? i1 + 1 : -1;

      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DashboardNextConcert(concert: concerts[i1]),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: i2 >= 0
                    ? DashboardNextConcert(concert: concerts[i2])
                    : const SizedBox.shrink(),
              ),
            ],
          ),
          if (totalPages > 1) ...[
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: page > 0
                      ? () => setState(() {
                            _currentIndex = (page - 1) * 2;
                            widget.onConcertChanged?.call(_currentIndex);
                          })
                      : null,
                  child: Icon(
                    Icons.chevron_left_rounded,
                    color: page > 0
                        ? Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6)
                        : Colors.transparent,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${page + 1} / $totalPages',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: page < totalPages - 1
                      ? () => setState(() {
                            _currentIndex = (page + 1) * 2;
                            widget.onConcertChanged?.call(_currentIndex);
                          })
                      : null,
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: page < totalPages - 1
                        ? Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6)
                        : Colors.transparent,
                  ),
                ),
              ],
            ),
          ],
        ],
      );
    }

    // ── iPhone / Android: carrusel de 1 en 1 (sin cambios) ───────────────────
    return Column(
      children: [
        GestureDetector(
          onHorizontalDragEnd: (details) {
            setState(() {
              if (details.primaryVelocity == null) return;
              if (details.primaryVelocity! < -150 &&
                  _currentIndex < concerts.length - 1) {
                _currentIndex++;
                widget.onConcertChanged?.call(_currentIndex);
              }
              if (details.primaryVelocity! > 150 && _currentIndex > 0) {
                _currentIndex--;
                widget.onConcertChanged?.call(_currentIndex);
              }
            });
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: DashboardNextConcert(
              key: ValueKey(_currentIndex),
              concert: concerts[_currentIndex],
            ),
          ),
        ),

        if (concerts.length > 1) ...[
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _currentIndex > 0
                    ? () => setState(() {
                          _currentIndex--;
                          widget.onConcertChanged?.call(_currentIndex);
                        })
                    : null,
                child: Icon(
                  Icons.chevron_left_rounded,
                  color: _currentIndex > 0
                      ? Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6)
                      : Colors.transparent,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${_currentIndex + 1} / ${concerts.length}',
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _currentIndex < concerts.length - 1
                    ? () => setState(() {
                          _currentIndex++;
                          widget.onConcertChanged?.call(_currentIndex);
                        })
                    : null,
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: _currentIndex < concerts.length - 1
                      ? Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6)
                      : Colors.transparent,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
