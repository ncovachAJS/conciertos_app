import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../controllers/auth_controller.dart';

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

    final hasSession = await auth.hasSession();

    if (!mounted) return;

    if (hasSession) {
      context.go('/splash');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
