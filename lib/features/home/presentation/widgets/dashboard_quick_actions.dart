import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:conciertos_app/l10n/generated/app_localizations.dart';

import '../../../../shared/widgets/pro_paywall_sheet.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../concerts/presentation/providers/concerts_provider.dart';
import '../../../import/presentation/pages/import_page.dart';
import '../../../friends/presentation/controllers/friends_controller.dart';

class DashboardQuickActions extends ConsumerWidget {
  const DashboardQuickActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: _QuickAction(
            icon: Icons.add_rounded,
            title: l.actionAdd,
            color: const Color(0xFFE53935),
            onTap: () async {
              final count = ref.read(ownConcertsCountProvider);
              final isPro = AuthController.instance.user?.isPro ?? false;
              final allowed =
                  await ProPaywallSheet.checkLimit(context, count, isPro);
              if (allowed && context.mounted) context.push('/add');
            },
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _QuickAction(
            icon: Icons.confirmation_number_outlined,
            title: l.actionTickets,
            color: const Color(0xFF42A5F5),
            onTap: () => context.push('/recommendations'),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _QuickAction(
            icon: Icons.bar_chart_rounded,
            title: l.actionStats,
            color: const Color(0xFFFFB300),
            onTap: () => context.push('/statistics'),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _QuickAction(
            icon: Icons.download_rounded,
            title: l.actionImport,
            color: const Color(0xFF66BB6A),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ImportPage()),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: ListenableBuilder(
            listenable: FriendsController.instance,
            builder: (context, _) => _QuickAction(
              icon: Icons.people_alt_rounded,
              title: l.friendsTitle,
              color: const Color(0xFFAB47BC),
              badge: FriendsController.instance.pendingRequests.length,
              onTap: () => context.push('/friends'),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;
  final int badge;

  const _QuickAction({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
    this.badge = 0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
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
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
