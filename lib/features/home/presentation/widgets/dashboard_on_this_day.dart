import 'package:flutter/material.dart';

import '../../../concerts/domain/entities/concert.dart';

/// "En tal día como hoy" — muestra conciertos del mismo día/mes en años anteriores.
class DashboardOnThisDay extends StatelessWidget {
  final List<Concert> concerts;

  const DashboardOnThisDay({super.key, required this.concerts});

  @override
  Widget build(BuildContext context) {
    if (concerts.isEmpty) return const SizedBox.shrink();

    final cs = Theme.of(context).colorScheme;
    final now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: concerts.map((concert) {
        final yearsAgo = now.year - concert.date.year;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFE53935).withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '🎂',
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hace $yearsAgo año${yearsAgo > 1 ? "s" : ""}',
                      style: TextStyle(
                        color: const Color(0xFFE53935),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      concert.artist,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${concert.venue}, ${concert.city}',
                      style: TextStyle(
                        color: cs.onSurface.withOpacity(0.54),
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (concert.rating > 0) ...[
                const SizedBox(width: 8),
                Row(
                  children: List.generate(
                    concert.rating,
                    (_) => const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFFFC107),
                      size: 14,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}
