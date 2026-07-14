import 'package:flutter/material.dart';

import '../controllers/dashboard_controller.dart';

class DashboardCountdownCard extends StatelessWidget {
  final DashboardController controller;

  const DashboardCountdownCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final concert = controller.nextConcert;

    if (concert == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: const Color(0xFF202028),
        ),
        child: const Column(
          children: [
            Icon(Icons.music_off, color: Colors.white38, size: 42),
            SizedBox(height: 14),
            Text(
              'No tienes próximos conciertos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              'Es hora de buscar tu próximo directo.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white60),
            ),
          ],
        ),
      );
    }

    final today = DateTime.now();

    final days = concert.date
        .difference(DateTime(today.year, today.month, today.day))
        .inDays;

    String title;
    String number;
    String subtitle;

    if (days <= 0) {
      title = '🎉 HOY HAY CONCIERTO';
      number = '🔥';
      subtitle = concert.artist;
    } else if (days == 1) {
      title = '🎸 PRÓXIMO DIRECTO';
      number = '1';
      subtitle = 'Mañana vuelves al directo';
    } else {
      title = '🎸 PRÓXIMO DIRECTO';
      number = '$days';
      subtitle = 'días para volver al directo';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE53935), Color(0xFF8E1B1B)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x44E53935),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            number,
            style: const TextStyle(
              fontSize: 46,
              fontWeight: FontWeight.w900,
              height: .9,
            ),
          ),

          if (days > 1)
            const Text(
              'DÍAS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),

          const SizedBox(height: 8),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
