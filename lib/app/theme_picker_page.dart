import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme_provider.dart';

class ThemePickerPage extends ConsumerWidget {
  const ThemePickerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(themeProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              const Text(
                '¿Cómo prefieres\nver la app?',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Puedes cambiarlo después en Ajustes.',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.54),
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 48),

              _ThemeOption(
                icon: Icons.brightness_auto,
                title: 'Por defecto del sistema',
                subtitle: 'Sigue el ajuste de tu móvil',
                selected: current == ThemeMode.system,
                onTap: () =>
                    ref.read(themeProvider.notifier).setTheme(ThemeMode.system),
              ),
              const SizedBox(height: 16),
              _ThemeOption(
                icon: Icons.dark_mode_rounded,
                title: 'Oscuro',
                subtitle: 'Fondo negro, ideal para conciertos',
                selected: current == ThemeMode.dark,
                onTap: () =>
                    ref.read(themeProvider.notifier).setTheme(ThemeMode.dark),
              ),
              const SizedBox(height: 16),
              _ThemeOption(
                icon: Icons.light_mode_rounded,
                title: 'Claro',
                subtitle: 'Fondo blanco, máxima legibilidad',
                selected: current == ThemeMode.light,
                onTap: () =>
                    ref.read(themeProvider.notifier).setTheme(ThemeMode.light),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.go('/splash'),
                  child: const Text('Empezar'),
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    // Por defecto sistema ya está seleccionado
                    context.go('/splash');
                  },
                  child: Text(
                    'Usar el del sistema',
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFE53935).withOpacity(0.1)
              : cs.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? const Color(0xFFE53935)
                : cs.onSurface.withOpacity(0.12),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFE53935).withOpacity(0.15)
                    : cs.onSurface.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: selected
                    ? const Color(0xFFE53935)
                    : cs.onSurface.withOpacity(0.6),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: selected ? const Color(0xFFE53935) : cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: cs.onSurface.withOpacity(0.54),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFFE53935),
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
