import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Caja de placeholder con efecto shimmer para skeleton screens.
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;
    final highlight = Theme.of(context).colorScheme.surface;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(
          duration: 1200.ms,
          color: highlight.withValues(alpha: 0.7),
          angle: 0.3,
        );
  }
}

/// Shimmer de ancho libre (se expande todo lo que puede).
class ShimmerFill extends StatelessWidget {
  final double height;
  final double borderRadius;

  const ShimmerFill({
    super.key,
    required this.height,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerBox(
      width: double.infinity,
      height: height,
      borderRadius: borderRadius,
    );
  }
}
