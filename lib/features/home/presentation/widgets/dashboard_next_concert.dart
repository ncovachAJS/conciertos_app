import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../controllers/dashboard_controller.dart';

class DashboardNextConcert extends StatelessWidget {
  final DashboardController controller;

  const DashboardNextConcert({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final concert = controller.nextConcert;

    if (concert == null) {
      return Container(
        height: 220,
        decoration: BoxDecoration(
          color: const Color(0xFF1C1F26),
          borderRadius: BorderRadius.circular(28),
        ),
        child: const Center(
          child: Text(
            'No hay conciertos próximos 🎸',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    const months = [
      '',
      'ENE',
      'FEB',
      'MAR',
      'ABR',
      'MAY',
      'JUN',
      'JUL',
      'AGO',
      'SEP',
      'OCT',
      'NOV',
      'DIC',
    ];

    return GestureDetector(
      onTap: () {
        context.push('/concert-detail', extra: concert);
      },
      child: Container(
        height: 260,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(28)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              concert.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  color: const Color(0xFF303542),
                  child: const Center(
                    child: Icon(
                      Icons.music_note,
                      size: 80,
                      color: Colors.white24,
                    ),
                  ),
                );
              },
            ),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(.90)],
                ),
              ),
            ),

            Positioned(
              top: 18,
              left: 18,
              child: Container(
                width: 72,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      concert.date.day.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      months[concert.date.month],
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      concert.date.year.toString(),
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (concert.liked)
              Positioned(
                top: 18,
                right: 18,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE53935),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.thumb_up, color: Colors.white),
                ),
              ),

            Positioned(
              left: 22,
              right: 22,
              bottom: 22,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    concert.artist,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 30,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    concert.festival,
                    style: const TextStyle(color: Colors.white70, fontSize: 18),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Icon(
                        Icons.stadium_rounded,
                        color: Colors.white70,
                        size: 18,
                      ),

                      const SizedBox(width: 6),

                      Expanded(
                        child: Text(
                          concert.venue,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: Colors.white70,
                        size: 18,
                      ),

                      const SizedBox(width: 6),

                      Expanded(
                        child: Text(
                          concert.city,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
