import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive.dart';
import '../../domain/achievement.dart';

/// Número de logros visibles cuando el panel está colapsado.
/// - Teléfono: 2 filas × 4 cols = 8
/// - Tablet:   2 filas × 8 cols = 16
const _kCollapsedPhone = 8;
const _kCollapsedTablet = 16;

class AchievementsWidget extends StatefulWidget {
  final List<Achievement> achievements;

  const AchievementsWidget({super.key, required this.achievements});

  @override
  State<AchievementsWidget> createState() => _AchievementsWidgetState();
}

class _AchievementsWidgetState extends State<AchievementsWidget>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  late final AnimationController _ctrl;
  late final Animation<double> _rotate;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _rotate = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final achievements = widget.achievements;
    final unlocked = achievements.where((a) => a.unlocked).length;
    final total = achievements.length;
    final cs = Theme.of(context).colorScheme;
    final isTablet = Responsive.isTablet(context);

    final collapsedCount =
        isTablet ? _kCollapsedTablet : _kCollapsedPhone;
    final columns = isTablet ? 8 : 4;

    final visibleItems =
        _expanded ? achievements : achievements.take(collapsedCount).toList();
    final hasMore = achievements.length > collapsedCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Cabecera ──────────────────────────────────────────────────
        GestureDetector(
          onTap: hasMore ? _toggle : null,
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: [
              const Text('🏆', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              const Text(
                'LOGROS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFC107),
                  letterSpacing: 1.1,
                ),
              ),
              const Spacer(),
              Text(
                '$unlocked / $total',
                style: TextStyle(
                  fontSize: 12,
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
              ),
              if (hasMore) ...[
                const SizedBox(width: 6),
                RotationTransition(
                  turns: _rotate,
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: cs.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 4),

        // ── Barra de progreso ─────────────────────────────────────────
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: total > 0 ? unlocked / total : 0,
            minHeight: 4,
            backgroundColor: cs.onSurface.withValues(alpha: 0.1),
            valueColor: const AlwaysStoppedAnimation(Color(0xFFFFC107)),
          ),
        ),

        const SizedBox(height: 16),

        // ── Grid animada ──────────────────────────────────────────────
        AnimatedSize(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: isTablet ? 8 : 12,
              crossAxisSpacing: isTablet ? 8 : 12,
              childAspectRatio: isTablet ? 0.9 : 0.82,
            ),
            itemCount: visibleItems.length,
            itemBuilder: (context, i) => _TrophyTile(
              achievement: visibleItems[i],
              compact: isTablet,
            ),
          ),
        ),

        // ── Botón Ver más / Ver menos ─────────────────────────────────
        if (hasMore) ...[
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _toggle,
            child: Center(
              child: AnimatedBuilder(
                animation: _ctrl,
                builder: (_, __) => Text(
                  _expanded
                      ? 'Ver menos'
                      : 'Ver todos los logros (${achievements.length - collapsedCount} más)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFFC107).withValues(alpha: 0.8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _TrophyTile extends StatelessWidget {
  final Achievement achievement;
  final bool compact;
  const _TrophyTile({required this.achievement, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final locked = !achievement.unlocked;

    return GestureDetector(
      onTap: () => _showDetail(context),
      child: Container(
        decoration: BoxDecoration(
          color: locked
              ? cs.onSurface.withValues(alpha: 0.05)
              : const Color(0xFFFFC107).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: locked
              ? null
              : Border.all(
                  color: const Color(0xFFFFC107).withValues(alpha: 0.35),
                  width: 1,
                ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    achievement.emoji,
                    style: TextStyle(fontSize: compact ? 18 : 26),
                  ),
                  SizedBox(height: compact ? 4 : 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      achievement.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: compact ? 8 : 10,
                        fontWeight: FontWeight.w600,
                        color: locked
                            ? cs.onSurface.withValues(alpha: 0.3)
                            : cs.onSurface.withValues(alpha: 0.85),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (locked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: cs.surface.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Icon(Icons.lock_rounded, size: 18, color: Colors.white24),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    final locked = !achievement.unlocked;
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(achievement.emoji, style: const TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            Text(
              achievement.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              achievement.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: locked
                    ? Colors.white10
                    : const Color(0xFFFFC107).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    locked ? Icons.lock_rounded : Icons.check_circle_rounded,
                    size: 16,
                    color: locked ? Colors.white38 : const Color(0xFFFFC107),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    locked ? 'Bloqueado' : '¡Desbloqueado!',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color:
                          locked ? Colors.white38 : const Color(0xFFFFC107),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
