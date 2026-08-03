import 'package:flutter/material.dart';

import '../../domain/achievement.dart';

/// Muestra los logros recién desbloqueados uno a uno como un toast animado.
Future<void> showAchievementToasts(
    BuildContext context, List<Achievement> achievements) async {
  for (final a in achievements) {
    if (!context.mounted) return;
    await _showOne(context, a);
    await Future.delayed(const Duration(milliseconds: 300));
  }
}

Future<void> _showOne(BuildContext context, Achievement achievement) async {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (_) => _AchievementToast(
      achievement: achievement,
      onDone: () => entry.remove(),
    ),
  );

  overlay.insert(entry);
  await Future.delayed(const Duration(milliseconds: 3500));
}

class _AchievementToast extends StatefulWidget {
  final Achievement achievement;
  final VoidCallback onDone;

  const _AchievementToast({required this.achievement, required this.onDone});

  @override
  State<_AchievementToast> createState() => _AchievementToastState();
}

class _AchievementToastState extends State<_AchievementToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);

    _ctrl.forward();

    Future.delayed(const Duration(milliseconds: 2800), () async {
      if (!mounted) return;
      await _ctrl.reverse();
      widget.onDone();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _fade,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFFFC107).withValues(alpha: 0.6),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFC107).withValues(alpha: 0.15),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC107).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        widget.achievement.emoji,
                        style: const TextStyle(fontSize: 26),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '🏆 Logro desbloqueado',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFFFFC107),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.achievement.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          widget.achievement.description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white60,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
