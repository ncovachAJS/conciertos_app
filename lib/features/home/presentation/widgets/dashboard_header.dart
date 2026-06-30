import 'package:flutter/material.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Spacer(),

            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person),
            ),
          ],
        ),

        const SizedBox(height: 28),

        Text(
          '${_greeting()} 👋',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
        ),

        const SizedBox(height: 10),

        Text(
          'My Concerts',
          style: Theme.of(
            context,
          ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        Text(
          'Tu historia en directo',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: Colors.white54),
        ),
      ],
    );
  }
}
