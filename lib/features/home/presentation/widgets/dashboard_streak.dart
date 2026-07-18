import 'package:flutter/material.dart';

import '../../../concerts/domain/entities/concert.dart';

/// Widget de racha — muestra cuántos conciertos este mes o tiempo sin ir.
class DashboardStreak extends StatelessWidget {
  final List<Concert> concerts;

  const DashboardStreak({super.key, required this.concerts});

  @override
  Widget build(BuildContext context) {
    if (concerts.isEmpty) return const SizedBox.shrink();

    final cs = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final past = concerts.where((c) => c.date.isBefore(now)).toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    if (past.isEmpty) return const SizedBox.shrink();

    // Conciertos este mes
    final thisMonth = past
        .where((c) => c.date.year == now.year && c.date.month == now.month)
        .length;

    // Días desde el último concierto
    final daysSinceLast = now.difference(past.first.date).inDays;

    final String emoji;
    final String title;
    final String subtitle;
    final Color color;

    if (thisMonth >= 5) {
      emoji = '🔥';
      title = '¡Mes épico!';
      subtitle = '$thisMonth conciertos este mes — estás en racha';
      color = const Color(0xFFE53935);
    } else if (thisMonth >= 2) {
      emoji = '🎸';
      title = 'Buen mes';
      subtitle = '$thisMonth conciertos este mes';
      color = const Color(0xFF42A5F5);
    } else if (daysSinceLast <= 7) {
      emoji = '⚡';
      title = 'Acabas de salir';
      subtitle = 'Último concierto hace $daysSinceLast días';
      color = const Color(0xFF66BB6A);
    } else if (daysSinceLast > 90) {
      emoji = '😴';
      title = 'Llevas tiempo sin ir';
      subtitle = '$daysSinceLast días sin conciertos — ¡es hora de volver!';
      color = const Color(0xFFFFC107);
    } else {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.25), width: 1),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: cs.onSurface.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
