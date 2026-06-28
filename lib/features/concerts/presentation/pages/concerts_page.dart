import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/app_page.dart';
import '../../data/services/concert_service.dart';

class ConcertsPage extends StatelessWidget {
  const ConcertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final concerts = ConcertService().getConcerts();

    return AppPage(
      title: '🎸 Conciertos',
      child: ListView.separated(
        itemCount: concerts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final concert = concerts[index];

          return Card(
            child: ListTile(
              onTap: () {
                context.go('/concert-detail', extra: concert);
              },
              leading: const Icon(Icons.music_note),
              title: Text(concert.artist),
              subtitle: Text('${concert.festival}\n${concert.city}'),
              trailing: const Icon(Icons.chevron_right),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
