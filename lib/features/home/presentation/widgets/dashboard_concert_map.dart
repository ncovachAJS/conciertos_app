import 'package:conciertos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardConcertMap extends StatelessWidget {
  const DashboardConcertMap({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => context.push('/concert-map'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFE53935).withOpacity(.10),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFE53935).withOpacity(.18),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFE53935).withOpacity(.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.map_rounded,
                color: Color(0xFFE53935),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.concertMapTitle,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    l.concertMapDashboardSubtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: cs.onSurface.withOpacity(0.55),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: cs.onSurface.withOpacity(0.35),
            ),
          ],
        ),
      ),
    );
  }
}
