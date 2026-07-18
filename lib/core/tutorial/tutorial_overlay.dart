import 'package:flutter/material.dart';

/// Paso individual del tutorial
class TutorialStep {
  final IconData icon;
  final String title;
  final String description;

  const TutorialStep({
    required this.icon,
    required this.title,
    required this.description,
  });
}

/// Muestra un tutorial modal paso a paso.
/// Se usa con [TutorialOverlay.show].
class TutorialOverlay extends StatefulWidget {
  final List<TutorialStep> steps;
  final VoidCallback? onFinish;

  const TutorialOverlay({super.key, required this.steps, this.onFinish});

  /// Muestra el tutorial como bottom sheet modal.
  static Future<void> show(
    BuildContext context, {
    required List<TutorialStep> steps,
    VoidCallback? onFinish,
  }) {
    return showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => TutorialOverlay(steps: steps, onFinish: onFinish),
    );
  }

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay>
    with SingleTickerProviderStateMixin {
  int _step = 0;
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_step < widget.steps.length - 1) {
      _controller.reverse().then((_) {
        setState(() => _step++);
        _controller.forward();
      });
    } else {
      Navigator.of(context).pop();
      widget.onFinish?.call();
    }
  }

  void _skip() {
    Navigator.of(context).pop();
    widget.onFinish?.call();
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.steps[_step];
    final total = widget.steps.length;
    final cs = Theme.of(context).colorScheme;
    final isLast = _step == total - 1;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: FadeTransition(
          opacity: _fade,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Indicadores de paso
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(total, (i) {
                  final active = i == _step;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: active ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active
                          ? const Color(0xFFE53935)
                          : cs.onSurface.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 28),

              // Icono
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  step.icon,
                  color: const Color(0xFFE53935),
                  size: 36,
                ),
              ),

              const SizedBox(height: 20),

              // Título
              Text(
                step.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              // Descripción
              Text(
                step.description,
                style: TextStyle(
                  fontSize: 15,
                  color: cs.onSurface.withOpacity(0.6),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 28),

              // Botones
              Row(
                children: [
                  if (!isLast)
                    TextButton(
                      onPressed: _skip,
                      child: Text(
                        'Saltar',
                        style: TextStyle(color: cs.onSurface.withOpacity(0.4)),
                      ),
                    ),
                  const Spacer(),
                  FilledButton(
                    onPressed: _next,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFE53935),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(120, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      isLast ? '¡Empezar! 🎸' : 'Siguiente',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
