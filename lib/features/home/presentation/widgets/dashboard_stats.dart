import 'package:flutter/material.dart';

import 'package:conciertos_app/l10n/generated/app_localizations.dart';
import '../../../../../core/responsive/responsive.dart';
import '../../../concerts/presentation/providers/concerts_provider.dart';

class DashboardStats extends StatelessWidget {
  final ConcertStats stats;

  const DashboardStats({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isTablet = Responsive.isTablet(context);

    // En iPad: 4 columnas compactas. En iPhone: 2 columnas cuadradas.
    final columns = isTablet ? 4 : 2;
    final aspectRatio = isTablet ? 1.15 : 1.0;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: columns,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: aspectRatio,
      children: [
        _StatCard(
          value: stats.total.toString(),
          label: l.totalConcertsLabel,
          icon: Icons.music_note_rounded,
          color: const Color(0xFFE53935),
        ),
        _StatCard(
          value: stats.festivals.toString(),
          label: l.uniqueFestivalsLabel,
          icon: Icons.festival_rounded,
          color: const Color(0xFF42A5F5),
        ),
        _StatCard(
          value: stats.avgRating.toStringAsFixed(1),
          label: l.avgRatingLabel,
          icon: Icons.star_rounded,
          color: const Color(0xFFFFC107),
        ),
        _StatCard(
          value: stats.liked.toString(),
          label: l.likedLabel,
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
        color: Theme.of(context).colorScheme.surface,
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
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
