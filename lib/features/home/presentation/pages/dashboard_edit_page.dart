import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_shell.dart';
import '../../../../l10n/generated/app_localizations.dart';
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
        DashboardSectionId.spotifyEmbed => Icons.headphones_rounded,
        DashboardSectionId.records => Icons.album_rounded,
      };

  static String _label(AppLocalizations l, DashboardSectionId id) =>
      switch (id) {
        DashboardSectionId.streak => l.dashSectionStreak,
        DashboardSectionId.annualGoal => l.dashSectionAnnualGoal,
        DashboardSectionId.ratePending => l.dashRatePendingTitle,
        DashboardSectionId.onThisDay => l.dashSectionOnThisDay,
        DashboardSectionId.upcoming => l.dashSectionUpcoming,
        DashboardSectionId.stats => l.dashSectionStats,
        DashboardSectionId.recommended => l.dashSectionRecommended,
        DashboardSectionId.favorites => l.dashSectionFavorites,
        DashboardSectionId.recent => l.dashSectionRecent,
        DashboardSectionId.spotifyEmbed => l.dashSectionSpotify,
        DashboardSectionId.records => l.recordsTitle,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final sectionsAsync = ref.watch(dashboardLayoutProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.dashEditTitle),
        actions: [
          TextButton(
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(l.layoutResetTitle),
                  content: Text(l.dashEditResetConfirm),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(l.cancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(l.resetLabel),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                await ref.read(dashboardLayoutProvider.notifier).reset();
              }
            },
            child: Text(l.resetLabel),
          ),
        ],
      ),
      body: sectionsAsync.when(
        loading: () => const GenericPageSkeleton(itemCount: 8, withHeader: true),
        error: (e, _) => Center(child: Text(l.layoutLoadError)),
        data: (sections) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: cs.primary.withValues(alpha: .25)),
                ),
                child: ListTile(
                  leading: Icon(Icons.dashboard_customize_rounded,
                      color: cs.primary),
                  title: Text(
                    l.quickActionsEditTitle,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(l.quickActionsEditTileSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/quick-actions-edit'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                l.layoutEditHint,
                style: TextStyle(
                  fontSize: 13,
                  color: cs.onSurface.withValues(alpha: .55),
                ),
              ),
            ),
            Expanded(
              child: ReorderableListView.builder(
                padding: EdgeInsets.fromLTRB(
                  12,
                  4,
                  12,
                  16 + floatingNavBarClearance(context),
                ),
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
                    label: _label(l, section.id),
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
                  AppLocalizations.of(context).hiddenLabel,
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
