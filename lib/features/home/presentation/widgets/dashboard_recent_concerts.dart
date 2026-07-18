import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../concerts/domain/entities/concert.dart';

class DashboardRecentConcerts extends StatelessWidget {
  final List<Concert> concerts;

  const DashboardRecentConcerts({super.key, required this.concerts});

  @override
  Widget build(BuildContext context) {
    if (concerts.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'Todavía no hay conciertos.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.54),
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: concerts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (_, index) => _RecentCard(concert: concerts[index]),
      ),
    );
  }
}

class _RecentCard extends StatelessWidget {
  final Concert concert;

  const _RecentCard({required this.concert});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: 165,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: AspectRatio(
              aspectRatio: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: concert.imageUrl,
                    fit: BoxFit.cover,
                    fadeInDuration: Duration.zero,
                    errorWidget: (_, __, ___) => Container(
                      color: cs.surfaceContainerHighest,
                      child: Icon(
                        Icons.music_note,
                        size: 48,
                        color: cs.onSurface.withOpacity(0.2),
                      ),
                    ),
                  ),
                  if (concert.liked)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Color(0xFFE53935),
                          size: 13,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  concert.artist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  concert.festival.isNotEmpty
                      ? concert.festival
                      : concert.venue,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: cs.onSurface.withOpacity(0.5),
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
