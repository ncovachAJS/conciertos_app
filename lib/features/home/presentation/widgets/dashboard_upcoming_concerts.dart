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
        if (concerts.length > 1) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(concerts.length, (index) {
              final active = index == _currentIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: active ? 10 : 8,
                height: active ? 10 : 8,
                decoration: BoxDecoration(
                  color: active ? const Color(0xFFE53935) : Colors.white24,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}
