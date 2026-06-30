import 'package:conciertos_app/shared/widgets/hero_concert_card.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/concert_card.dart';
import '../../../concerts/domain/entities/concert.dart';

import '../../../../shared/widgets/hero_concert_card.dart';

import 'section_title.dart';

class UpcomingConcerts extends StatelessWidget {
  const UpcomingConcerts({super.key});

  @override
  Widget build(BuildContext context) {
    final upcoming = [
      Concert(
        id: '1',
        artist: 'Iron Maiden',
        festival: 'Rock Imperium Festival',
        city: 'Madrid',
        date: DateTime(2026, 7, 15),
        venue: 'Estadio Wanda Metropolitano',
      ),
      Concert(
        id: '2',
        artist: 'Ghost',
        festival: 'Resurrection Fest',
        city: 'Viveiro',
        date: DateTime(2026, 7, 2),
        venue: 'Estadio Wanda Metropolitano',
      ),
      Concert(
        id: '3',
        artist: 'Muse',
        festival: 'Mad Cool',
        city: 'Madrid',
        date: DateTime(2026, 7, 11),
        venue: 'Estadio Wanda Metropolitano',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(text: 'Próximo concierto'),

        const SizedBox(height: 16),

        HeroConcertCard(concert: upcoming.first),

        const SizedBox(height: 32),

        const SectionTitle(text: 'A continuación'),

        const SizedBox(height: 16),

        SizedBox(
          height: 380,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: upcoming.length - 1,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 300,
                child: ConcertCard(concert: upcoming[index + 1]),
              );
            },
          ),
        ),
      ],
    );
  }
}
