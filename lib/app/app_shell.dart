import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
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
      case '/':          return 0;
      case '/concerts':  return 1;
      case '/feed':      return 2;
      case '/favorites': return 3;
      case '/statistics':return 4;
      default:           return 0;
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
    final unread = _notif.unreadCount;
    final l      = AppLocalizations.of(context);
    final idx    = _currentIndex(context);

    final labels = [
      l.navHome,
      l.navConcerts,
      l.navMemories,
      l.navFavorites,
      l.navStats,
    ];

    // ── iPad: pill tabs en la barra superior (Apple Music style) ─────────────
    if (Responsive.isTablet(context)) {
      return Scaffold(
        appBar: _TopTabAppBar(
          selectedIndex: idx,
          labels: labels,
          unreadCount: unread,
          onTap: (i) => _navigate(context, i),
        ),
        body: widget.child,
      );
    }

    // ── iPhone: Liquid Glass bottom nav (iOS 26 style) ───────────────────────
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return Scaffold(
        extendBody: true,
        body: widget.child,
        bottomNavigationBar: _LiquidGlassNavBar(
          selectedIndex: idx,
          labels: labels,
          unreadCount: unread,
          onTap: (i) => _navigate(context, i),
        ),
      );
    }

    // ── Android: pill tabs en la barra inferior ──────────────────────────────
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: _BottomPillNavBar(
        selectedIndex: idx,
        labels: labels,
        unreadCount: unread,
        onTap: (i) => _navigate(context, i),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// AppBar con pill tabs centradas — iPad (Apple Music / iPadOS)
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
// Pill tab bar (compartido entre iPad top y Android bottom)
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
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
// Android: pill tabs en la barra inferior
// ---------------------------------------------------------------------------

class _BottomPillNavBar extends StatelessWidget {
  final int selectedIndex;
  final List<String> labels;
  final int unreadCount;
  final ValueChanged<int> onTap;

  const _BottomPillNavBar({
    required this.selectedIndex,
    required this.labels,
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: cs.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: _PillTabBar(
              selectedIndex: selectedIndex,
              labels: labels,
              unreadCount: unreadCount,
              onTap: onTap,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// iPhone: Liquid Glass bottom nav — iOS 26 style
// ---------------------------------------------------------------------------

class _LiquidGlassNavBar extends StatelessWidget {
  final int selectedIndex;
  final List<String> labels;
  final int unreadCount;
  final ValueChanged<int> onTap;

  const _LiquidGlassNavBar({
    required this.selectedIndex,
    required this.labels,
    required this.unreadCount,
    required this.onTap,
  });

  static const _icons = <(IconData, IconData)>[
    (Icons.home_outlined,          Icons.home_rounded),
    (Icons.library_music_outlined, Icons.library_music_rounded),
    (Icons.photo_library_outlined, Icons.photo_library_rounded),
    (Icons.favorite_border,        Icons.favorite_rounded),
    (Icons.bar_chart_outlined,     Icons.bar_chart_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final cs         = Theme.of(context).colorScheme;
    final isDark     = Theme.of(context).brightness == Brightness.dark;

    // Fondo semitransparente según tema
    final overlayColor = isDark
        ? cs.surface.withValues(alpha: 0.72)
        : Colors.white.withValues(alpha: 0.80);

    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 32, sigmaY: 32),
        child: Container(
          decoration: BoxDecoration(
            color: overlayColor,
            border: Border(
              top: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.06),
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 58,
              child: Row(
                children: List.generate(_icons.length, (i) {
                  final selected   = i == selectedIndex;
                  final hasUnread  = i == 0 && unreadCount > 0;
                  final iconData   = selected ? _icons[i].$2 : _icons[i].$1;
                  final iconColor  = selected
                      ? cs.onSurface
                      : cs.onSurface.withValues(alpha: 0.42);
                  final labelColor = iconColor;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onTap(i),
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Pill highlight en el icono seleccionado
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOutCubic,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 5),
                            decoration: selected
                                ? BoxDecoration(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.13)
                                        : Colors.black.withValues(alpha: 0.07),
                                    borderRadius: BorderRadius.circular(20),
                                    // Borde interior tipo vidrio
                                    border: Border.all(
                                      color: isDark
                                          ? Colors.white.withValues(alpha: 0.18)
                                          : Colors.black.withValues(alpha: 0.10),
                                      width: 0.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.08),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  )
                                : null,
                            child: Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
                              children: [
                                Icon(iconData, color: iconColor, size: 23),
                                // Punto rojo de notificación
                                if (hasUnread)
                                  Positioned(
                                    top: -3,
                                    right: -3,
                                    child: Container(
                                      width: 7,
                                      height: 7,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE53935),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: overlayColor,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 3),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 220),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: labelColor,
                              letterSpacing: -0.1,
                            ),
                            child: Text(labels[i]),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

