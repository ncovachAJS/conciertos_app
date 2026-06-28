import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_page.dart';
import '../widgets/concert_card.dart';
import '../widgets/dashboard_stat_card.dart';
import '../widgets/section_title.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: '🎸 My Concerts',
      child: ListView(
        children: [
          Text(
            'Buenos días 👋',
            style: Theme.of(context).textTheme.headlineLarge,
          ),

          const SizedBox(height: 24),

          const Row(
            children: [
              DashboardStatCard(
                title: 'Conciertos',
                value: '286',
                icon: Icons.music_note,
              ),
              SizedBox(width: 16),
              DashboardStatCard(
                title: 'Festivales',
                value: '55',
                icon: Icons.festival,
              ),
            ],
          ),

          const SizedBox(height: 32),

          const SectionTitle(text: 'Próximos conciertos'),

          ConcertCard(
            artist: 'Iron Maiden',
            festival: 'Madrid',
            date: '15 Jul 2026',
          ),

          ConcertCard(
            artist: 'Ghost',
            festival: 'Resurrection Fest',
            date: '2 Jul 2026',
          ),
        ],
      ),
    );
  }
}
