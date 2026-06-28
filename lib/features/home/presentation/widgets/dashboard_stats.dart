import 'package:flutter/material.dart';

import 'dashboard_stat_card.dart';

class DashboardStats extends StatelessWidget {
  const DashboardStats({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        DashboardStatCard(
          icon: Icons.music_note,
          value: '286',
          title: 'Conciertos',
        ),
        SizedBox(width: 16),
        DashboardStatCard(
          icon: Icons.festival,
          value: '55',
          title: 'Festivales',
        ),
      ],
    );
  }
}
