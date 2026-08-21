import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/responsive/responsive.dart';
import '../features/notifications/presentation/controllers/notifications_controller.dart';
import '../l10n/generated/app_localizations.dart';

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
      case '/':        return 0;
      case '/concerts': return 1;
      case '/feed':    return 2;
      case '/favorites': return 3;
      case '/statistics': return 4;
      default:         return 0;
    }
  }

  void _navigate(BuildContext context, int index) {
    switch (index) {
      case 0: context.go('/');
      case 1: context.go('/concerts');
      case 2: context.go('/feed');
      case 3: context.go('/favorites');
      case 4: context.go('/statistics');
    }
  }

  @override
  Widget build(BuildContext context) {
    final unread  = _notif.unreadCount;
    final l       = AppLocalizations.of(context);
    final idx     = _currentIndex(context);

    // ── iPad: barra superior estilo Apple Music ──────────────────────────────
    if (Responsive.isTablet(context)) {
      final labels = [
        l.navHome,
        l.navConcerts,
        l.navMemories,
        l.navFavorites,
        l.navStats,
      ];

      return Scaffold(
        // AppBar transparente con las pestañas centradas
        appBar: _TopTabAppBar(
          selectedIndex: idx,
          labels: labels,
          unreadCount: unread,
          onTap: (i) => _navigate(context, i),
        ),
        body: widget.child,
      );
    }

    // ── iPhone: barra inferior (sin cambios) ─────────────────────────────────
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (i) => _navigate(context, i),
        destinations: [
          NavigationDestination(
            icon: _BadgeIcon(icon: Icons.home_outlined, count: unread),
            selectedIcon:
                _BadgeIcon(icon: Icons.home, count: unread, selected: true),
            label: l.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.library_music_outlined),
            selectedIcon: const Icon(Icons.library_music),
            label: l.navConcerts,
          ),
          NavigationDestination(
            icon: const Icon(Icons.photo_library_outlined),
            selectedIcon: const Icon(Icons.photo_library),
            label: l.navMemories,
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_border),
            selectedIcon: const Icon(Icons.favorite),
            label: l.navFavorites,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart),
            label: l.navStats,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// AppBar con las pestañas pill centradas — estilo Apple Music / iPadOS
// ---------------------------------------------------------------------------

class _TopTabAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedIndex;
  final List<String> labels;
  final int unreadCount;
  final ValueChanged<int> onTap;

  const _TopTabAppBar({
    required this.selectedIndex,
    required this.labels,
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: cs.surface,
      surfaceTintColor: cs.surfaceTint,
      // Las pestañas en el centro — ocupan el espacio del título
      title: _PillTabBar(
        selectedIndex: selectedIndex,
        labels: labels,
        unreadCount: unreadCount,
        onTap: onTap,
      ),
      centerTitle: true,
    );
  }
}

// ---------------------------------------------------------------------------
// Pill tab bar — igual que la barra de navegación de Apple Music en iPad
// ---------------------------------------------------------------------------

class _PillTabBar extends StatelessWidget {
  final int selectedIndex;
  final List<String> labels;
  final int unreadCount;
  final ValueChanged<int> onTap;

  const _PillTabBar({
    required this.selectedIndex,
    required this.labels,
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(labels.length, (i) {
          final selected = i == selectedIndex;
          final hasUnread = i == 0 && unreadCount > 0;

          return GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
              decoration: BoxDecoration(
                color: selected ? cs.surface : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: cs.shadow.withValues(alpha: 0.12),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    labels[i],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.w400,
                      color: selected
                          ? cs.onSurface
                          : cs.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                  if (hasUnread) ...[
                    const SizedBox(width: 5),
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE53935),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Icono con badge de notificaciones (usado en la barra inferior de iPhone)
// ---------------------------------------------------------------------------

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
