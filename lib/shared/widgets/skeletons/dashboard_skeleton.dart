import 'package:flutter/material.dart';

import '../shimmer_box.dart';

/// Skeleton del dashboard — imita la estructura del DashboardView.
class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────
          Row(
            children: [
              const ShimmerBox(width: 52, height: 52, borderRadius: 26),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ShimmerBox(width: 120, height: 14, borderRadius: 7),
                    const SizedBox(height: 6),
                    ShimmerFill(height: 20, borderRadius: 8),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              const ShimmerBox(width: 40, height: 40, borderRadius: 20),
            ],
          ),
          const SizedBox(height: 24),

          // ── Quick actions ────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(4, (_) => const _ActionSkeleton()),
          ),
          const SizedBox(height: 28),

          // ── Streak card ──────────────────────────────────────────────
          const ShimmerFill(height: 90, borderRadius: 22),
          const SizedBox(height: 20),

          // ── Stats 2×2 ────────────────────────────────────────────────
          const _StatsGridSkeleton(),
          const SizedBox(height: 32),

          // ── Section title ────────────────────────────────────────────
          const ShimmerBox(width: 160, height: 18, borderRadius: 9),
          const SizedBox(height: 18),

          // ── Horizontal cards (próximos) ──────────────────────────────
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (_, _s) => const SizedBox(width: 14),
              itemBuilder: (_, __) => const ShimmerBox(
                width: 160,
                height: 180,
                borderRadius: 22,
              ),
            ),
          ),
          const SizedBox(height: 36),

          // ── Section title ────────────────────────────────────────────
          const ShimmerBox(width: 140, height: 18, borderRadius: 9),
          const SizedBox(height: 18),

          // ── Recent concerts list ─────────────────────────────────────
          ...List.generate(3, (_) => const _ConcertTileSkeleton()),
        ],
      ),
    );
  }
}

class _ActionSkeleton extends StatelessWidget {
  const _ActionSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ShimmerBox(width: 56, height: 56, borderRadius: 18),
        const SizedBox(height: 8),
        ShimmerBox(width: 44, height: 11, borderRadius: 6),
      ],
    );
  }
}

class _StatsGridSkeleton extends StatelessWidget {
  const _StatsGridSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: ShimmerFill(height: 110, borderRadius: 22)),
            const SizedBox(width: 14),
            Expanded(child: ShimmerFill(height: 110, borderRadius: 22)),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: ShimmerFill(height: 110, borderRadius: 22)),
            const SizedBox(width: 14),
            Expanded(child: ShimmerFill(height: 110, borderRadius: 22)),
          ],
        ),
      ],
    );
  }
}

class _ConcertTileSkeleton extends StatelessWidget {
  const _ConcertTileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          const ShimmerBox(width: 56, height: 56, borderRadius: 14),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerFill(height: 16, borderRadius: 8),
                const SizedBox(height: 6),
                ShimmerBox(width: 100, height: 12, borderRadius: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
