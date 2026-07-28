import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/notifications/presentation/controllers/notifications_controller.dart';

class AppShell extends StatefulWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final NotificationsController _notif = NotificationsController.instance;

  @override
  void initState() {
    super.initState();
    _notif.addListener(_rebuild);
    _notif.refreshUnreadCount();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _notif.removeListener(_rebuild);
    super.dispose();
  }

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    switch (location) {
      case '/':
        return 0;
      case '/concerts':
        return 1;
      case '/feed':
        return 2;
      case '/favorites':
        return 3;
      case '/statistics':
        return 4;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final unread = _notif.unreadCount;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex(context),
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/');
            case 1:
              context.go('/concerts');
            case 2:
              context.go('/feed');
            case 3:
              context.go('/favorites');
            case 4:
              context.go('/statistics');
          }
        },
        destinations: [
          NavigationDestination(
            icon: _BadgeIcon(icon: Icons.home_outlined, count: unread),
            selectedIcon: _BadgeIcon(
              icon: Icons.home,
              count: unread,
              selected: true,
            ),
            label: 'Inicio',
          ),
          const NavigationDestination(
            icon: Icon(Icons.library_music_outlined),
            selectedIcon: Icon(Icons.library_music),
            label: 'Conciertos',
          ),
          const NavigationDestination(
            icon: Icon(Icons.photo_library_outlined),
            selectedIcon: Icon(Icons.photo_library),
            label: 'Recuerdos',
          ),
          const NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          const NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
        ],
      ),
    );
  }
}

class _BadgeIcon extends StatelessWidget {
  final IconData icon;
  final int count;
  final bool selected;

  const _BadgeIcon({
    required this.icon,
    required this.count,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    if (count == 0) return Icon(icon);

    return Badge(
      label: Text(count > 99 ? '99+' : '$count'),
      backgroundColor: const Color(0xFFE53935),
      textColor: Colors.white,
      child: Icon(icon),
    );
  }
}
