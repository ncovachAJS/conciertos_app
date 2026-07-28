import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/auth_controller.dart';
import '../../../notifications/presentation/controllers/notifications_controller.dart';

class SessionGatePage extends StatefulWidget {
  const SessionGatePage({super.key});

  @override
  State<SessionGatePage> createState() => _SessionGatePageState();
}

class _SessionGatePageState extends State<SessionGatePage> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final auth = AuthController.instance;
    final prefs = await SharedPreferences.getInstance();

    await auth.loadSession();

    if (!mounted) return;

    if (auth.user == null) {
      context.go('/login');
      return;
    }

    // Inicializar notificaciones push
    NotificationsController.instance.init().ignore();
    NotificationsController.instance.refreshUnreadCount().ignore();

    final hasSeenSplash = prefs.getBool('hasSeenSplash') ?? false;
    if (!hasSeenSplash) {
      context.go('/splash');
    } else {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
