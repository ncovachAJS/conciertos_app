import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/app_page.dart';
import '../../data/services/concert_service.dart';
import '../../domain/entities/concert.dart';
import '../../../../shared/widgets/concert_card.dart';

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

          return ConcertCard(
            concert: concert,
            onTap: () {
              context.go('/concert-detail', extra: concert);
            },
            onDelete: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Eliminar concierto'),
                    content: Text('¿Quieres eliminar "${concert.artist}"?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Eliminar'),
                      ),
                    ],
                  );
                },
              );

              if (confirm == true) {
                ConcertService.instance.deleteConcert(concert.id);

                setState(() {
                  concerts = ConcertService.instance.getConcerts();
                });

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${concert.artist} eliminado')),
                );
              }
            },
          );
        },
      ),
    );
  }
}
