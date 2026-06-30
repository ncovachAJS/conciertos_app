import 'package:flutter/material.dart';

class DashboardStats extends StatelessWidget {
  const DashboardStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Text(
              'TU HISTORIA',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                letterSpacing: 2,
                color: Colors.white54,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              '286',
              style: TextStyle(fontSize: 58, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(
              'conciertos vividos',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _StatItem(value: '55', title: 'Festivales'),

                _StatItem(value: '18', title: 'Años'),

                _StatItem(value: '42', title: 'Ciudades'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String title;

  const _StatItem({required this.value, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 6),

        Text(title, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}
