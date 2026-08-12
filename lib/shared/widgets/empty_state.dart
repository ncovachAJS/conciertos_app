import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Estado vacío con ilustración emoji, título, subtítulo y CTA opcional.
///
/// Uso:
/// ```dart
/// EmptyState(
///   emoji: '🎸',
///   title: 'Aún no tienes conciertos',
///   subtitle: 'Añade tu primer concierto y empieza tu historial',
///   action: ElevatedButton(...),
/// )
/// ```
class EmptyState extends StatelessWidget {
  final String emoji;
  final String title;
  final String? subtitle;
  final Widget? action;
  final Color? accentColor;

  const EmptyState({
    super.key,
    required this.emoji,
    required this.title,
    this.subtitle,
    this.action,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = accentColor ?? cs.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Ilustración ───────────────────────────────────────────
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    color.withValues(alpha: .18),
                    color.withValues(alpha: .04),
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 52),
                ),
              ),
            )
                .animate()
                .scale(
                  begin: const Offset(0.7, 0.7),
                  end: const Offset(1, 1),
                  duration: 420.ms,
                  curve: Curves.elasticOut,
                )
                .fadeIn(duration: 300.ms),

            const SizedBox(height: 24),

            // ── Título ────────────────────────────────────────────────
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ).animate().fadeIn(delay: 80.ms, duration: 300.ms).slideY(
                  begin: 0.2,
                  end: 0,
                  delay: 80.ms,
                  duration: 300.ms,
                ),

            if (subtitle != null) ...[
              const SizedBox(height: 10),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: cs.onSurface.withValues(alpha: .5),
                  height: 1.5,
                ),
              ).animate().fadeIn(delay: 140.ms, duration: 300.ms),
            ],

            if (action != null) ...[
              const SizedBox(height: 28),
              action!.animate().fadeIn(delay: 200.ms, duration: 300.ms),
            ],
          ],
        ),
      ),
    );
  }
}
