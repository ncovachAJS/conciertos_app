import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:conciertos_app/l10n/generated/app_localizations.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../concerts/presentation/providers/concerts_provider.dart';
import '../../../notifications/presentation/controllers/notifications_controller.dart';
import '../../../../shared/widgets/pro_paywall_sheet.dart';

class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({super.key});

  String _greeting(AppLocalizations l) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l.greetingMorning;
    if (hour < 20) return l.greetingAfternoon;
    return l.greetingEvening;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: Listenable.merge([
        AuthController.instance,
        NotificationsController.instance,
      ]),
      builder: (context, _) {
        final user = AuthController.instance.user;
        final avatarUrl = user?.avatarUrl;
        final badge = NotificationsController.instance.unreadCount;

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
                              text: '${l.appTitleLine1} ',
                              style: GoogleFonts.teko(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: cs.onSurface,
                                letterSpacing: 1.2,
                              ),
                            ),
                            TextSpan(
                              text: l.appTitleLine2,
                              style: GoogleFonts.teko(
                                fontSize: 30,
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
                        l.tagline,
                        style: TextStyle(
                          color: cs.onSurface.withOpacity(0.54),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Campanita con badge de notificaciones reales
                GestureDetector(
                  onTap: () => context.push('/notifications'),
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
                          badge > 0
                              ? Icons.notifications_rounded
                              : Icons.notifications_outlined,
                          color: badge > 0
                              ? const Color(0xFFE53935)
                              : cs.onSurface.withOpacity(0.7),
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
                        ? CachedNetworkImage(
                            imageUrl: avatarUrl,
                            fit: BoxFit.cover,
                            memCacheWidth: 120,
                            fadeInDuration: Duration.zero,
                            errorWidget: (_, __, ___) => const Icon(
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

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    '${_greeting(l)}, ${user?.name ?? l.defaultNickname} 🤘',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final isPro =
                        AuthController.instance.user?.isPro ?? false;
                    if (!isPro) {
                      await ProPaywallSheet.showPaywall(context);
                      return;
                    }
                    if (context.mounted) context.push('/dashboard-edit');
                  },
                  child: Icon(
                    Icons.tune_rounded,
                    size: 20,
                    color: cs.onSurface.withOpacity(0.35),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Text(
              l.readyForNext,
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
