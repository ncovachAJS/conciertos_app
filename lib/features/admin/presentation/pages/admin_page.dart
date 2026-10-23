import 'package:conciertos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../widgets/admin_broadcast_tab.dart';
import '../widgets/admin_stats_tab.dart';
import '../widgets/admin_users_tab.dart';

/// Panel de administración: estadísticas de uso, avisos a todos los usuarios y
/// gestión de usuarios. El acceso real lo valida el backend (AdminGuard); aquí
/// solo se oculta la pantalla a quien no es admin.
class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    if (AuthController.instance.user?.isAdmin != true) {
      return Scaffold(
        appBar: AppBar(title: Text(l.adminPanelTitle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 48, color: Colors.grey),
                const SizedBox(height: 12),
                Text(l.adminNoAccess, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => context.pop(),
                  child: Text(l.adminBack),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.adminPanelTitle),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: l.adminTabStats),
              Tab(text: l.adminTabBroadcast),
              Tab(text: l.adminTabUsers),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AdminStatsTab(),
            AdminBroadcastTab(),
            AdminUsersTab(),
          ],
        ),
      ),
    );
  }
}
