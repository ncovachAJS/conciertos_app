import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Buenos días';
    }

    if (hour < 20) {
      return 'Buenas tardes';
    }

    return 'Buenas noches';
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthController.instance.user;

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
                            fontSize: 31,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        TextSpan(
                          text: 'EN DIRECTO',
                          style: GoogleFonts.teko(
                            fontSize: 31,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFFFC107),
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 2),

                  const Text(
                    'Cada concierto cuenta una historia.',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                ],
              ),
            ),

            // Container(
            //   width: 48,
            //   height: 48,
            //   decoration: BoxDecoration(
            //     color: const Color(0xFF242731),
            //     borderRadius: BorderRadius.circular(16),
            //   ),
            //   child: const Icon(
            //     Icons.notifications_none_rounded,
            //     color: Colors.white,
            //   ),
            // ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => context.push('/profile'),
              child: Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: Color(0xFFE53935),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x55E53935),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 26),

        Text(
          '${_greeting()}, ${user?.name ?? "Rockero"} 🤘',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 6),

        const Text(
          'Todo listo para volver al directo.',
          style: TextStyle(color: Colors.white60, fontSize: 15),
        ),
      ],
    );
  }
}
