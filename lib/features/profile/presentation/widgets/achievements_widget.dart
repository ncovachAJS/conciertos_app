import 'package:flutter/material.dart';

import '../../domain/achievement.dart';

class AchievementsWidget extends StatelessWidget {
  final List<Achievement> achievements;

  const AchievementsWidget({super.key, required this.achievements});

  @override
  Widget build(BuildContext context) {
    final unlocked = achievements.where((a) => a.unlocked).length;
    final total = achievements.length;
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('🏆', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(
              'LOGROS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFFC107),
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
          ],
        ),
        const SizedBox(height: 4),
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
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.82,
          ),
          itemCount: achievements.length,
          itemBuilder: (context, i) => _TrophyTile(achievement: achievements[i]),
        ),
      ],
    );
  }
}

class _TrophyTile extends StatelessWidget {
  final Achievement achievement;
  const _TrophyTile({required this.achievement});

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
                  Text(achievement.emoji, style: const TextStyle(fontSize: 26)),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      achievement.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
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
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
                      color: locked ? Colors.white38 : const Color(0xFFFFC107),
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
