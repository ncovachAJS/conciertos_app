import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Container(
        //   width: 52,
        //   height: 52,
        //   decoration: BoxDecoration(
        //     color: const Color(0xFF242731),
        //     borderRadius: BorderRadius.circular(16),
        //   ),
        //   child: const Icon(Icons.menu_rounded, color: Colors.white),
        // ),

        // const SizedBox(width: 18),
        const Expanded(
          child: Text(
            'Mis conciertos',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              height: 1.50,
            ),
          ),
        ),

        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF242731),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
              ),
            ),

            const SizedBox(width: 10),

            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
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
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            ),
          ],
        ),
      ],
    );
  }
}
