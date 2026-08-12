import 'package:flutter/material.dart';

import '../shimmer_box.dart';

/// Skeleton de la página de estadísticas.
class StatsSkeleton extends StatelessWidget {
  const StatsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
      shrinkWrap: true,
      children: [
        // ── Resumen: tarjetas en Wrap ─────────────────────────────────
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(
            4,
            (_) => const ShimmerBox(width: 150, height: 90, borderRadius: 18),
          ),
        ),
        const SizedBox(height: 32),

        // ── Bar chart ─────────────────────────────────────────────────
        const ShimmerBox(width: 180, height: 20, borderRadius: 10),
        const SizedBox(height: 16),
        const ShimmerFill(height: 200, borderRadius: 22),
        const SizedBox(height: 32),

        // ── Bar chart 2 ───────────────────────────────────────────────
        const ShimmerBox(width: 160, height: 20, borderRadius: 10),
        const SizedBox(height: 16),
        const ShimmerFill(height: 160, borderRadius: 22),
        const SizedBox(height: 32),

        // ── Top list ──────────────────────────────────────────────────
        const ShimmerBox(width: 120, height: 20, borderRadius: 10),
        const SizedBox(height: 16),
        ...List.generate(
          5,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                ShimmerBox(
                  width: 32,
                  height: 32,
                  borderRadius: 8,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ShimmerFill(
                    height: 14,
                    borderRadius: 7,
                  ),
                ),
                const SizedBox(width: 12),
                ShimmerBox(width: 40, height: 14, borderRadius: 7),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
