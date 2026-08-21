import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../core/responsive/responsive.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../concerts/domain/entities/concert.dart';
import '../../../concerts/presentation/providers/concerts_provider.dart';

/// Un concierto por vez, deslizable, de todos los pendientes de sub-valoración.
class DashboardRatePending extends ConsumerStatefulWidget {
  const DashboardRatePending({super.key});

  @override
  ConsumerState<DashboardRatePending> createState() =>
      _DashboardRatePendingState();
}

class _DashboardRatePendingState extends ConsumerState<DashboardRatePending> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final concerts = ref.watch(concertsProvider).asData?.value ?? [];
    final now = DateTime.now();
    final currentUserId = AuthController.instance.user?.id ?? '';

    final pending = concerts.where((c) {
      final isOwn = c.userId.isEmpty || c.userId == currentUserId;
      return isOwn && c.date.isBefore(now) && !c.hasDetailedRating;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    if (pending.isEmpty) {
      // En iPad mostramos un estado "todo valorado" para no dejar el hueco vacío
      if (!Responsive.isTablet(context)) return const SizedBox.shrink();
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF4CAF50).withOpacity(0.08),
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.25)),
        ),
        child: Row(
          children: [
            const Text('✅', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Todo valorado',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'No tienes conciertos pendientes de valorar',
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Si el índice actual quedó fuera de rango (ej. valoraron uno), lo ajustamos.
    final page = _currentPage.clamp(0, pending.length - 1);

    const amber = Color(0xFFFFC107);
    const radius = BorderRadius.all(Radius.circular(18));

    return Container(
      decoration: BoxDecoration(
        color: amber.withOpacity(0.07),
        borderRadius: radius,
        border: Border.all(color: amber.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                const Text('⭐', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Por valorar',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                // Navegación  ◀ N/total ▶
                _NavButton(
                  icon: Icons.chevron_left_rounded,
                  enabled: page > 0,
                  onTap: () {
                    setState(() => _currentPage = page - 1);
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
                const SizedBox(width: 2),
                Text(
                  '${page + 1}/${pending.length}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: amber.withOpacity(0.9),
                  ),
                ),
                const SizedBox(width: 2),
                _NavButton(
                  icon: Icons.chevron_right_rounded,
                  enabled: page < pending.length - 1,
                  onTap: () {
                    setState(() => _currentPage = page + 1);
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ],
            ),
          ),

          const Divider(height: 1, indent: 16, endIndent: 16),

          // ── Tarjeta deslizable ───────────────────────────────
          SizedBox(
            height: 72,
            child: PageView.builder(
              controller: _pageController,
              itemCount: pending.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (context, i) =>
                  _PendingConcertRow(concert: pending[i]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Botón de navegación ─────────────────────────────────────────────────────

class _NavButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Icon(
        icon,
        size: 22,
        color: enabled
            ? const Color(0xFFFFC107)
            : const Color(0xFFFFC107).withOpacity(0.25),
      ),
    );
  }
}

// ── Fila de concierto pendiente ─────────────────────────────────────────────

class _PendingConcertRow extends StatelessWidget {
  final Concert concert;
  const _PendingConcertRow({required this.concert});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dateStr = DateFormat('d MMM yyyy', 'es').format(concert.date);

    return InkWell(
      onTap: () => context.push('/add', extra: concert),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Imagen o placeholder
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: concert.imageUrl.isNotEmpty
                  ? Image.network(
                      concert.imageUrl,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    concert.artist,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateStr,
                    style: TextStyle(
                      color: cs.onSurface.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.star_outline_rounded,
                color: Color(0xFFFFC107), size: 18),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded,
                color: cs.onSurface.withOpacity(0.3), size: 18),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFFFC107).withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.music_note_rounded,
            color: Color(0xFFFFC107), size: 20),
      );
}
