import 'package:flutter/material.dart';
import '../shimmer_box.dart';

/// Skeleton genérico para páginas con lista de items.
class GenericPageSkeleton extends StatelessWidget {
  final int itemCount;
  final bool withHeader;

  const GenericPageSkeleton({
    super.key,
    this.itemCount = 6,
    this.withHeader = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      children: [
        if (withHeader) ...[
          const ShimmerFill(height: 44, borderRadius: 22),
          const SizedBox(height: 20),
        ],
        ...List.generate(
          itemCount,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              children: [
                ShimmerBox(
                  width: 58,
                  height: 58,
                  borderRadius: 14,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerFill(height: 16, borderRadius: 8),
                      const SizedBox(height: 7),
                      ShimmerBox(
                        width: 120 + (i % 3) * 30.0,
                        height: 12,
                        borderRadius: 6,
                      ),
                      const SizedBox(height: 5),
                      ShimmerBox(
                        width: 80,
                        height: 11,
                        borderRadius: 6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Skeleton de cards en grid 2×N.
class GenericGridSkeleton extends StatelessWidget {
  final int itemCount;

  const GenericGridSkeleton({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: 0.75,
      children: List.generate(
        itemCount,
        (_) => const ShimmerFill(height: double.infinity, borderRadius: 20),
      ),
    );
  }
}

/// Skeleton de tarjetas horizontales (feed).
class FeedSkeleton extends StatelessWidget {
  const FeedSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (_, sep) => const SizedBox(height: 16),
      itemBuilder: (_, __) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const ShimmerBox(width: 36, height: 36, borderRadius: 18),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerBox(width: 120, height: 13, borderRadius: 6),
                  const SizedBox(height: 5),
                  const ShimmerBox(width: 80, height: 11, borderRadius: 6),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const ShimmerFill(height: 200, borderRadius: 18),
          const SizedBox(height: 10),
          const ShimmerBox(width: 160, height: 14, borderRadius: 7),
          const SizedBox(height: 5),
          const ShimmerBox(width: 100, height: 11, borderRadius: 6),
        ],
      ),
    );
  }
}

/// Skeleton inline para secciones (setlist, fotos, recomendaciones).
class InlineSectionSkeleton extends StatelessWidget {
  final int lines;
  const InlineSectionSkeleton({super.key, this.lines = 3});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        lines,
        (i) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ShimmerFill(
            height: 52,
            borderRadius: 14,
          ),
        ),
      ),
    );
  }
}
