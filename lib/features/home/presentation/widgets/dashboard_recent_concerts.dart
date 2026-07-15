import 'package:flutter/material.dart';

import '../../../concerts/domain/entities/concert.dart';

class DashboardRecentConcerts extends StatelessWidget {
  final List<Concert> concerts;

  const DashboardRecentConcerts({super.key, required this.concerts});

  @override
  Widget build(BuildContext context) {
    if (concerts.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'Todavía no hay conciertos.',
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
        ),
      );
    }

    return SizedBox(
      height: 215,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: concerts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (_, index) => _RecentConcertCard(concert: concerts[index]),
      ),
    );
  }
}

class _RecentConcertCard extends StatelessWidget {
  final Concert concert;

  const _RecentConcertCard({required this.concert});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF1C1F26),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  concert.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFF303542),
                    child: const Icon(
                      Icons.music_note,
                      size: 60,
                      color: Colors.white24,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(.85),
                        ],
                      ),
                    ),
                  ),
                ),
                if (concert.liked)
                  const Positioned(
                    top: 10,
                    right: 10,
                    child: CircleAvatar(
                      radius: 17,
                      backgroundColor: Color(0xFFE53935),
                      child: Icon(
                        Icons.thumb_up,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
              ],
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
                  concert.festival,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
