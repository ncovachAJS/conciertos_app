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
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_greeting()} 👋',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Bienvenido a My Concerts',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        const CircleAvatar(radius: 24, child: Icon(Icons.person)),
      ],
    );
  }
}
