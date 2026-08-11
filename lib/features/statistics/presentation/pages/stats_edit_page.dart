import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/stats_section.dart';
import '../providers/stats_layout_provider.dart';

class StatsEditPage extends ConsumerWidget {
  const StatsEditPage({super.key});

  static IconData _icon(StatsSectionId id) => switch (id) {
        StatsSectionId.summary => Icons.grid_view_rounded,
        StatsSectionId.byYear => Icons.bar_chart_rounded,
        StatsSectionId.byMonth => Icons.calendar_view_month_rounded,
        StatsSectionId.byDayOfWeek => Icons.view_week_outlined,
        StatsSectionId.topArtists => Icons.person_rounded,
        StatsSectionId.topGenres => Icons.library_music_outlined,
        StatsSectionId.topFestivals => Icons.festival_rounded,
        StatsSectionId.topCities => Icons.location_city_rounded,
        StatsSectionId.topVenues => Icons.stadium_rounded,
        StatsSectionId.festivalSplit => Icons.compare_arrows_rounded,
        StatsSectionId.ratingDist => Icons.star_rounded,
        StatsSectionId.avgRatingByYear => Icons.trending_up_rounded,
        StatsSectionId.topRatedArtists => Icons.emoji_events_rounded,
        StatsSectionId.priceStats => Icons.euro_rounded,
      };

  static String _label(StatsSectionId id) => switch (id) {
        StatsSectionId.summary => 'Resumen (tarjetas)',
        StatsSectionId.byYear => 'Conciertos por año',
        StatsSectionId.byMonth => 'Conciertos por mes',
        StatsSectionId.byDayOfWeek => 'Día de la semana favorito',
        StatsSectionId.topArtists => 'Top artistas',
        StatsSectionId.topGenres => 'Géneros musicales',
        StatsSectionId.topFestivals => 'Top festivales',
        StatsSectionId.topCities => 'Ciudades favoritas',
        StatsSectionId.topVenues => 'Recintos más visitados',
        StatsSectionId.festivalSplit => 'Festival vs. individual',
        StatsSectionId.ratingDist => 'Distribución de valoraciones',
        StatsSectionId.avgRatingByYear => 'Valoración media por año',
        StatsSectionId.topRatedArtists => 'Artistas mejor valorados',
        StatsSectionId.priceStats => 'Precio de las entradas',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionsAsync = ref.watch(statsLayoutProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalizar estadísticas'),
        actions: [
          TextButton(
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Restablecer orden'),
                  content: const Text(
                    '¿Restaurar la disposición por defecto?',
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
                await ref.read(statsLayoutProvider.notifier).reset();
              }
            },
            child: const Text('Restablecer'),
          ),
        ],
      ),
      body: sectionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
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
                    .read(statsLayoutProvider.notifier)
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
                        .read(statsLayoutProvider.notifier)
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
  final StatsSection section;
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
