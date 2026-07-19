import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../concerts/domain/entities/concert.dart';
import '../../../concerts/presentation/providers/concerts_provider.dart';
import '../../artist/presentation/pages/artist_page.dart';

/// "En tal día como hoy" — aniversarios exactos y conciertos de esta semana.
class DashboardOnThisDay extends ConsumerWidget {
  final List<Concert> concerts;

  const DashboardOnThisDay({super.key, required this.concerts});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (concerts.isEmpty) return const SizedBox.shrink();

    final cs = Theme.of(context).colorScheme;
    final now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: concerts.map((concert) {
        final yearsAgo = now.year - concert.date.year;
        final isExactDay =
            concert.date.day == now.day && concert.date.month == now.month;
        final thisYearDate = DateTime(
          now.year,
          concert.date.month,
          concert.date.day,
        );
        final diffDays = thisYearDate
            .difference(DateTime(now.year, now.month, now.day))
            .inDays;

        String timeLabel;
        if (isExactDay) {
          timeLabel = 'Hace $yearsAgo año${yearsAgo > 1 ? 's' : ''}';
        } else if (diffDays > 0) {
          timeLabel =
              'En $diffDays día${diffDays > 1 ? 's' : ''}, hace $yearsAgo año${yearsAgo > 1 ? 's' : ''}';
        } else {
          timeLabel =
              'Hace ${diffDays.abs()} día${diffDays.abs() > 1 ? 's' : ''}, hace $yearsAgo año${yearsAgo > 1 ? 's' : ''}';
        }

        return GestureDetector(
          onTap: () {
            // Navegar al detalle del artista
            final allConcerts = ref.read(concertsProvider).asData?.value ?? [];
            final artistConcerts = allConcerts
                .where((c) => c.artist.trim() == concert.artist.trim())
                .toList();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ArtistPage(
                  artist: concert.artist,
                  concerts: artistConcerts,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(
                  0xFFE53935,
                ).withOpacity(isExactDay ? 0.5 : 0.2),
                width: isExactDay ? 1.5 : 1,
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
                // Imagen o emoji
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: concert.imageUrl.isNotEmpty
                      ? Image.network(
                          concert.imageUrl,
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _emojiPlaceholder(isExactDay),
                        )
                      : _emojiPlaceholder(isExactDay),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        timeLabel,
                        style: TextStyle(
                          color: const Color(
                            0xFFE53935,
                          ).withOpacity(isExactDay ? 1 : 0.7),
                          fontSize: 11,
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
                        [
                          if (concert.venue.isNotEmpty) concert.venue,
                          if (concert.city.isNotEmpty) concert.city,
                        ].join(', '),
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
                  Column(
                    children: [
                      Row(
                        children: List.generate(
                          concert.rating,
                          (_) => const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFFFC107),
                            size: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  color: cs.onSurface.withOpacity(0.3),
                  size: 18,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _emojiPlaceholder(bool isExact) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFE53935).withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          isExact ? '🎂' : '📅',
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
