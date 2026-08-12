import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/skeletons/generic_page_skeleton.dart';
import '../../domain/dashboard_section.dart';
import '../providers/dashboard_layout_provider.dart';

/// Pantalla para reordenar y ocultar/mostrar secciones del dashboard.
class DashboardEditPage extends ConsumerWidget {
  const DashboardEditPage({super.key});

  static IconData _icon(DashboardSectionId id) => switch (id) {
        DashboardSectionId.streak => Icons.local_fire_department_rounded,
        DashboardSectionId.annualGoal => Icons.flag_rounded,
        DashboardSectionId.ratePending => Icons.star_half_rounded,
        DashboardSectionId.onThisDay => Icons.cake_rounded,
        DashboardSectionId.upcoming => Icons.calendar_month_rounded,
        DashboardSectionId.stats => Icons.bar_chart_rounded,
        DashboardSectionId.recommended => Icons.local_fire_department_outlined,
        DashboardSectionId.favorites => Icons.favorite_rounded,
        DashboardSectionId.recent => Icons.history_rounded,
      };

  static String _label(DashboardSectionId id) => switch (id) {
        DashboardSectionId.streak => 'Racha de conciertos',
        DashboardSectionId.annualGoal => 'Meta anual',
        DashboardSectionId.ratePending => 'Por valorar',
        DashboardSectionId.onThisDay => 'En tal día como hoy',
        DashboardSectionId.upcoming => 'Próximos conciertos',
        DashboardSectionId.stats => 'Estadísticas rápidas',
        DashboardSectionId.recommended => 'Recomendaciones',
        DashboardSectionId.favorites => 'Favoritos',
        DashboardSectionId.recent => 'Últimos añadidos',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionsAsync = ref.watch(dashboardLayoutProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalizar dashboard'),
        actions: [
          TextButton(
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Restablecer orden'),
                  content: const Text(
                    '¿Restaurar la disposición por defecto del dashboard?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Restablecer'),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                await ref.read(dashboardLayoutProvider.notifier).reset();
              }
            },
            child: const Text('Restablecer'),
          ),
        ],
      ),
      body: sectionsAsync.when(
        loading: () => const GenericPageSkeleton(itemCount: 8, withHeader: true),
        error: (e, _) =>
            const Center(child: Text('Error cargando la configuración')),
        data: (sections) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                'Arrastra   para reordenar · activa o desactiva cada sección',
                style: TextStyle(
                  fontSize: 13,
                  color: cs.onSurface.withValues(alpha: .55),
                ),
              ),
            ),
            Expanded(
              child: ReorderableListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                itemCount: sections.length,
                onReorder: (oldIndex, newIndex) => ref
                    .read(dashboardLayoutProvider.notifier)
                    .reorder(oldIndex, newIndex),
                proxyDecorator: (child, index, animation) => Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(14),
                  shadowColor: cs.shadow,
                  child: child,
                ),
                itemBuilder: (context, index) {
                  final section = sections[index];
                  return _SectionTile(
                    key: ValueKey(section.id),
                    index: index,
                    section: section,
                    icon: _icon(section.id),
                    label: _label(section.id),
                    onToggle: () => ref
                        .read(dashboardLayoutProvider.notifier)
                        .toggleVisibility(section.id),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTile extends StatelessWidget {
  final int index;
  final DashboardSection section;
  final IconData icon;
  final String label;
  final VoidCallback onToggle;

  const _SectionTile({
    super.key,
    required this.index,
    required this.section,
    required this.icon,
    required this.label,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final visible = section.visible;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: visible ? 1.0 : 0.45,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withValues(alpha: .55),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outline.withValues(alpha: .12)),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: cs.primary, size: 20),
          ),
          title: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          subtitle: visible
              ? null
              : Text(
                  'Oculta',
                  style: TextStyle(
                    fontSize: 12,
                    color: cs.onSurface.withValues(alpha: .4),
                  ),
                ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Switch.adaptive(
                value: visible,
                onChanged: (_) => onToggle(),
                activeThumbColor: cs.primary,
                activeTrackColor: cs.primary.withValues(alpha: .5),
              ),
              const SizedBox(width: 4),
              ReorderableDragStartListener(
                index: index,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.drag_handle_rounded,
                    color: cs.onSurface.withValues(alpha: .35),
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
