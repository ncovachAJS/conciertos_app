import 'package:flutter/material.dart';

import '../../../concerts/presentation/providers/concerts_provider.dart';

class DashboardStats extends StatelessWidget {
  final ConcertStats stats;

  const DashboardStats({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: 1,
      children: [
        _StatCard(
          value: stats.total.toString(),
          label: 'Conciertos',
          icon: Icons.music_note_rounded,
          color: const Color(0xFFE53935),
        ),
        _StatCard(
          value: stats.festivals.toString(),
          label: 'Festivales',
          icon: Icons.festival_rounded,
          color: const Color(0xFF42A5F5),
        ),
        _StatCard(
          value: stats.avgRating.toStringAsFixed(1),
          label: 'Valoración',
          icon: Icons.star_rounded,
          color: const Color(0xFFFFC107),
        ),
        _StatCard(
          value: stats.liked.toString(),
          label: 'Te gustan',
          icon: Icons.thumb_up_alt_rounded,
          color: const Color(0xFF4CAF50),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1F26),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
