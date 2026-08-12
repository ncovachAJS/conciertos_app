import 'package:flutter/material.dart';

import '../shimmer_box.dart';

/// Skeleton de la lista de conciertos.
class ConcertsSkeleton extends StatelessWidget {
  const ConcertsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      itemCount: 7,
      separatorBuilder: (_, _s) => const SizedBox(height: 12),
      itemBuilder: (_, __) => const _ConcertCardSkeleton(),
    );
  }
}

class _ConcertCardSkeleton extends StatelessWidget {
  const _ConcertCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: .45),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Imagen
          const ShimmerBox(width: 68, height: 68, borderRadius: 14),
          const SizedBox(width: 14),
          // Texto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerFill(height: 17, borderRadius: 8),
                const SizedBox(height: 7),
                ShimmerBox(width: 130, height: 13, borderRadius: 6),
                const SizedBox(height: 7),
                ShimmerBox(width: 90, height: 11, borderRadius: 6),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Rating
          Column(
            children: [
              const ShimmerBox(width: 36, height: 36, borderRadius: 18),
              const SizedBox(height: 6),
              ShimmerBox(width: 30, height: 10, borderRadius: 5),
            ],
          ),
        ],
      ),
    );
  }
}
