import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/app_page.dart';
import '../../data/services/concert_service.dart';
import '../../domain/entities/concert.dart';

class ConcertsPage extends StatefulWidget {
  const ConcertsPage({super.key});

  @override
  State<ConcertsPage> createState() => _ConcertsPageState();
}

class _ConcertsPageState extends State<ConcertsPage> {
  late List<Concert> concerts;

  @override
  void initState() {
    super.initState();
    concerts = ConcertService.instance.getConcerts();
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: '🎸 Conciertos',
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          tooltip: 'Añadir concierto',
          onPressed: () async {
            final result = await context.push('/add');

            if (result == true) {
              setState(() {
                concerts = ConcertService.instance.getConcerts();
              });
            }
          },
        ),
      ],
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
