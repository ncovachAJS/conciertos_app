import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../concerts/domain/entities/concert.dart';

/// Muestra la meta anual de conciertos y el progreso actual.
/// Si no hay meta configurada, ofrece establecerla con un toque.
class DashboardAnnualGoal extends StatefulWidget {
  final List<Concert> concerts;

  const DashboardAnnualGoal({super.key, required this.concerts});

  @override
  State<DashboardAnnualGoal> createState() => _DashboardAnnualGoalState();
}

class _DashboardAnnualGoalState extends State<DashboardAnnualGoal> {
  static const _prefKey = 'annual_concert_goal';
  int? _goal;

  @override
  void initState() {
    super.initState();
    _loadGoal();
  }

  Future<void> _loadGoal() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt(_prefKey);
    if (mounted) setState(() => _goal = saved);
  }

  Future<void> _saveGoal(int goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKey, goal);
    if (mounted) setState(() => _goal = goal);
  }

  void _editGoal() {
    final controller = TextEditingController(
      text: _goal != null ? '$_goal' : '',
    );

    showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Meta anual de conciertos'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Número de conciertos',
            hintText: 'Ej: 20',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
            ),
            onPressed: () {
              final v = int.tryParse(controller.text.trim());
              Navigator.pop(ctx, v);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    ).then((v) {
      if (v != null && v > 0) _saveGoal(v);
    });
  }

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;
    final done = widget.concerts
        .where((c) => c.date.year == year)
        .length;
    final cs = Theme.of(context).colorScheme;

    // Sin meta establecida → tarjeta de invitación
    if (_goal == null) {
      return GestureDetector(
        onTap: _editGoal,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: cs.onSurface.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: cs.onSurface.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.flag_rounded,
                  color: Color(0xFFE53935),
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Establece tu meta para $year',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '¿Cuántos conciertos quieres ver este año?',
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: cs.onSurface.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      );
    }

    // Con meta → barra de progreso
    final progress = (_goal! > 0 ? done / _goal! : 0.0).clamp(0.0, 1.0);
    final reached = done >= _goal!;
    final remaining = (_goal! - done).clamp(0, _goal!);
    final color = reached ? const Color(0xFF43A047) : const Color(0xFFE53935);

    return GestureDetector(
      onTap: _editGoal,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
        decoration: BoxDecoration(
          color: cs.onSurface.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: cs.onSurface.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  reached
                      ? Icons.emoji_events_rounded
                      : Icons.flag_rounded,
                  color: color,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  reached
                      ? '¡Meta alcanzada en $year! 🎉'
                      : 'Meta $year: $_goal conciertos',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Text(
                  '$done / $_goal',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: cs.onSurface.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
            if (!reached) ...[
              const SizedBox(height: 8),
              Text(
                'Te quedan $remaining conciertos para conseguirlo',
                style: TextStyle(
                  fontSize: 11,
                  color: cs.onSurface.withValues(alpha: 0.45),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
