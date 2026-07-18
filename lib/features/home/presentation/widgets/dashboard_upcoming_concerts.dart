import 'package:flutter/material.dart';

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

    if (concerts.isEmpty) {
      return const DashboardNextConcert(concert: null);
    }

    if (_currentIndex >= concerts.length) {
      _currentIndex = concerts.length - 1;
    }

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

        // ✅ Contador en vez de puntos — más limpio con muchos conciertos
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
                      ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
                      : Colors.transparent,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${_currentIndex + 1} / ${concerts.length}',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.5),
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
                      ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
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
