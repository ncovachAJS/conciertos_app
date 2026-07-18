import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../concerts/domain/entities/concert.dart';
import '../../../concerts/presentation/providers/concerts_provider.dart';

/// Muestra el último concierto pasado sin valorar con CTA para puntuarlo.
class DashboardRatePending extends ConsumerWidget {
  const DashboardRatePending({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final concerts = ref.watch(concertsProvider).asData?.value ?? [];
    final now = DateTime.now();

    final pending =
        concerts.where((c) => c.date.isBefore(now) && c.rating == 0).toList()
          ..sort((a, b) => b.date.compareTo(a.date));

    if (pending.isEmpty) return const SizedBox.shrink();

    final concert = pending.first;
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => context.push('/concert-detail', extra: concert),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFC107).withOpacity(0.1),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFFFC107).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const Text('⭐', style: TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¿Qué tal estuvo ${concert.artist}?',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Aún no has valorado este concierto',
                    style: TextStyle(
                      color: cs.onSurface.withOpacity(0.54),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: cs.onSurface.withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }
}
