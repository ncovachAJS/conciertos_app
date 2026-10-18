import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/app_shell.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/quick_action.dart';
import '../providers/quick_actions_provider.dart';
import '../widgets/quick_action_catalog.dart';

/// Elegir y ordenar los atajos de la fila de accesos rápidos del dashboard.
class QuickActionsEditPage extends ConsumerWidget {
  const QuickActionsEditPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final notifier = ref.read(quickActionsProvider.notifier);
    final selected =
        ref.watch(quickActionsProvider).asData?.value ?? kDefaultQuickActions;
    final available = availableQuickActions()
        .where((a) => !selected.contains(a))
        .toList();
    final full = selected.length >= kMaxQuickActions;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.quickActionsEditTitle),
        actions: [
          TextButton(onPressed: notifier.reset, child: Text(l.resetLabel)),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          12,
          12,
          12,
          16 + floatingNavBarClearance(context),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              l.quickActionsEditHint(kMaxQuickActions),
              style: TextStyle(
                fontSize: 13,
                color: cs.onSurface.withValues(alpha: .55),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _Header(l.quickActionsYours(selected.length, kMaxQuickActions)),
          ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            buildDefaultDragHandles: false,
            onReorder: notifier.reorder,
            children: [
              for (var i = 0; i < selected.length; i++)
                _ActionTile(
                  key: ValueKey(selected[i]),
                  id: selected[i],
                  trailing: [
                    IconButton(
                      tooltip: l.delete,
                      // Siempre debe quedar al menos un atajo
                      onPressed: selected.length > 1
                          ? () => notifier.remove(selected[i])
                          : null,
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    ReorderableDragStartListener(
                      index: i,
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.drag_handle_rounded),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 20),
          _Header(l.quickActionsAvailable),
          if (full)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Text(
                l.quickActionsMaxReached(kMaxQuickActions),
                style: TextStyle(color: cs.onSurface.withValues(alpha: .55)),
              ),
            ),
          for (final id in available)
            _ActionTile(
              id: id,
              trailing: [
                IconButton(
                  tooltip: l.add,
                  onPressed: full ? null : () => notifier.add(id),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String text;

  const _Header(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 4, 6),
        child: Text(text, style: Theme.of(context).textTheme.titleSmall),
      );
}

class _ActionTile extends StatelessWidget {
  final QuickActionId id;
  final List<Widget> trailing;

  const _ActionTile({super.key, required this.id, required this.trailing});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final spec = kQuickActionSpecs[id]!;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: .55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outline.withValues(alpha: .12)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: spec.color.withValues(alpha: .15),
            shape: BoxShape.circle,
          ),
          child: Icon(spec.icon, color: spec.color, size: 22),
        ),
        title: Text(
          spec.label(l),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: trailing),
      ),
    );
  }
}
