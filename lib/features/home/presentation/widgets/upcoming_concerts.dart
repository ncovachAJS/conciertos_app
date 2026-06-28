import 'package:flutter/material.dart';

import 'concert_card.dart';
import 'section_title.dart';

class UpcomingConcerts extends StatelessWidget {
  const UpcomingConcerts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SectionTitle(text: 'Próximos conciertos'),

        ConcertCard(
          artist: 'Iron Maiden',
          festival: 'Madrid',
          date: '15 Jul 2026',
        ),

        SizedBox(height: 12),

        ConcertCard(
          artist: 'Ghost',
          festival: 'Resurrection Fest',
          date: '2 Jul 2026',
        ),
      ],
    );
  }
}
