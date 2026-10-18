import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:conciertos_app/l10n/generated/app_localizations.dart';

import '../../../../core/config/pro_config.dart';
import '../../../../shared/widgets/pro_paywall_sheet.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../concerts/presentation/providers/concerts_provider.dart';
import '../../../photos/presentation/flows/add_memory_flow.dart';
import '../../domain/quick_action.dart';

/// Aspecto de cada atajo: icono, color y etiqueta (corta, cabe bajo el icono).
class QuickActionSpec {
  final IconData icon;
  final Color color;
  final String Function(AppLocalizations l) label;

  const QuickActionSpec({
    required this.icon,
    required this.color,
    required this.label,
  });
}

final Map<QuickActionId, QuickActionSpec> kQuickActionSpecs = {
  QuickActionId.add: QuickActionSpec(
    icon: Icons.add_rounded,
    color: const Color(0xFFE53935),
    label: (l) => l.actionAdd,
  ),
  QuickActionId.events: QuickActionSpec(
    icon: Icons.explore_outlined,
    color: const Color(0xFF42A5F5),
    label: (l) => l.actionEvents,
  ),
  QuickActionId.stats: QuickActionSpec(
    icon: Icons.bar_chart_rounded,
    color: const Color(0xFFFFB300),
    label: (l) => l.actionStats,
  ),
  QuickActionId.import: QuickActionSpec(
    icon: Icons.download_rounded,
    color: const Color(0xFF66BB6A),
    label: (l) => l.actionImport,
  ),
  QuickActionId.friends: QuickActionSpec(
    icon: Icons.people_alt_rounded,
    color: const Color(0xFFAB47BC),
    label: (l) => l.friendsTitle,
  ),
  QuickActionId.calendar: QuickActionSpec(
    icon: Icons.calendar_month_rounded,
    color: const Color(0xFF5C6BC0),
    label: (l) => l.viewCalendar,
  ),
  QuickActionId.memory: QuickActionSpec(
    icon: Icons.add_a_photo_rounded,
    color: const Color(0xFF26A69A),
    label: (l) => l.quickActionMemory,
  ),
  QuickActionId.records: QuickActionSpec(
    icon: Icons.album_rounded,
    color: const Color(0xFF8E24AA),
    label: (l) => l.quickActionRecords,
  ),
};

/// Atajos que el usuario puede elegir (oculta los Pro si no lo es).
List<QuickActionId> availableQuickActions() {
  final isPro = AuthController.instance.user?.isPro == true;
  return QuickActionId.values
      .where((a) => isPro || !kProOnlyQuickActions.contains(a))
      .toList();
}

/// Ejecuta el destino de un atajo.
Future<void> runQuickAction(
  BuildContext context,
  WidgetRef ref,
  QuickActionId id,
) async {
  switch (id) {
    case QuickActionId.add:
      final count = ref.read(ownConcertsCountProvider);
      final isPro = ProConfig.isUserPro(AuthController.instance.user?.isPro);
      final allowed = await ProPaywallSheet.checkLimit(context, count, isPro);
      if (allowed && context.mounted) context.push('/add');
    case QuickActionId.events:
      context.push('/recommendations');
    case QuickActionId.stats:
      context.push('/statistics');
    case QuickActionId.import:
      context.push('/import');
    case QuickActionId.friends:
      context.push('/friends');
    case QuickActionId.calendar:
      context.go('/concerts?view=calendar');
    case QuickActionId.memory:
      await startAddMemory(context, ref);
    case QuickActionId.records:
      context.push('/records');
  }
}
