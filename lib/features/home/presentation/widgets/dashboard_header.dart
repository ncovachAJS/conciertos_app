import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../concerts/presentation/providers/concerts_provider.dart';
import '../../notificaciones/pages/notifications_page.dart';

class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos días';
    if (hour < 20) return 'Buenas tardes';
    return 'Buenas noches';
  }

  int _badgeCount(List concerts) {
    final now = DateTime.now();
    final upcoming = concerts.where((c) {
      final days = c.date.difference(now).inDays;
      return days >= 0 && days <= 7;
    }).length;
    final memories = concerts
        .where(
          (c) =>
              c.date.day == now.day &&
              c.date.month == now.month &&
              c.date.year < now.year,
        )
        .length;
    return upcoming + memories;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: AuthController.instance,
      builder: (context, _) {
        final user = AuthController.instance.user;
        final avatarUrl = user?.avatarUrl;
        final concerts = ref.watch(concertsProvider).asData?.value ?? [];
        final badge = _badgeCount(concerts);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        overflow: TextOverflow.visible,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'LA VIDA ',
                              style: GoogleFonts.teko(
                                fontSize: 33,
                                fontWeight: FontWeight.w700,
                                color: cs.onSurface,
                                letterSpacing: 1.2,
                              ),
                            ),
                            TextSpan(
                              text: 'EN DIRECTO',
                              style: GoogleFonts.teko(
                                fontSize: 33,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFFFC107),
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Cada concierto cuenta una historia.',
                        // ✅ Adaptado al tema
                        style: TextStyle(
                          color: cs.onSurface.withOpacity(0.54),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Campanita con badge
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const NotificationsPage(),
                    ),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 43,
                        height: 43,
                        decoration: BoxDecoration(
                          color: cs.onSurface.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.notifications_outlined,
                          color: cs.onSurface.withOpacity(0.7),
                          size: 24,
                        ),
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
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Text(
                              badge > 9 ? '9+' : '$badge',
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
                ),

                const SizedBox(width: 10),

                // Avatar de perfil
                GestureDetector(
                  onTap: () => context.push('/profile'),
                  child: Container(
                    width: 43,
                    height: 43,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 2,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: avatarUrl != null && avatarUrl.isNotEmpty
                        ? Image.network(
                            avatarUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.person_outline,
                              color: Colors.white,
                              size: 24,
                            ),
                          )
                        : const Icon(
                            Icons.person_outline,
                            color: Colors.white,
                            size: 24,
                          ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 26),

            Text(
              '${_greeting()}, ${user?.name ?? "Rockero"} 🤘',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Todo listo para volver al directo.',
              style: TextStyle(
                color: cs.onSurface.withOpacity(0.6),
                fontSize: 15,
              ),
            ),
          ],
        );
      },
    );
  }
}
