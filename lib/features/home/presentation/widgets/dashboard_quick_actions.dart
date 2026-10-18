import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:conciertos_app/l10n/generated/app_localizations.dart';

import '../../../../core/config/pro_config.dart';
import '../../../../shared/widgets/pro_paywall_sheet.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../friends/presentation/controllers/friends_controller.dart';
import '../../domain/quick_action.dart';
import '../providers/quick_actions_provider.dart';
import 'quick_action_catalog.dart';

/// Fila de accesos rápidos del dashboard. Los atajos son configurables:
/// mantener pulsado uno abre el editor (misma regla Pro que el resto de la
/// personalización del inicio).
class DashboardQuickActions extends ConsumerWidget {
  const DashboardQuickActions({super.key});

  Future<void> _openEditor(BuildContext context) async {
    final isPro = ProConfig.isUserPro(AuthController.instance.user?.isPro);
    if (!isPro) {
      await ProPaywallSheet.showPaywall(context);
      return;
    }
    if (context.mounted) context.push('/quick-actions-edit');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    // Mientras carga mostramos los de siempre para que no parpadee la fila.
    final actions =
        ref.watch(quickActionsProvider).asData?.value ?? kDefaultQuickActions;

    return Row(
      children: [
        for (var i = 0; i < actions.length; i++) ...[
          if (i > 0) const SizedBox(width: 14),
          Expanded(
            child: _badged(
              actions[i],
              (badge) {
                final spec = kQuickActionSpecs[actions[i]]!;
                return _QuickAction(
                  icon: spec.icon,
                  title: spec.label(l),
                  color: spec.color,
                  badge: badge,
                  onTap: () => runQuickAction(context, ref, actions[i]),
                  onLongPress: () => _openEditor(context),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  /// El atajo de amigos muestra el contador de solicitudes pendientes y se
  /// reconstruye al cambiar su controlador.
  Widget _badged(QuickActionId id, Widget Function(int badge) build) {
    switch (id) {
      case QuickActionId.friends:
        return ListenableBuilder(
          listenable: FriendsController.instance,
          builder: (_, _) =>
              build(FriendsController.instance.pendingRequests.length),
        );
      default:
        return build(0);
    }
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final int badge;

  const _QuickAction({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
    required this.onLongPress,
    this.badge = 0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      onLongPress: onLongPress,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              if (badge > 0)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE53935),
                      shape: BoxShape.circle,
                    ),
                    constraints:
                        const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      badge > 99 ? '99+' : '$badge',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          // scaleDown: las etiquetas largas (p. ej. "Calendario") se encogen
          // en vez de desbordar o partirse en dos líneas.
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
