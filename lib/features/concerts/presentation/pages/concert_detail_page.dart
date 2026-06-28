import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_page.dart';
import '../../domain/entities/concert.dart';
import '../../../../core/utils/date_formatter.dart';

class ConcertDetailPage extends StatelessWidget {
  final Concert concert;

  const ConcertDetailPage({super.key, required this.concert});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: '🎸 ${concert.artist}',
      child: ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    concert.artist,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  ListTile(
                    leading: const Icon(Icons.festival),
                    title: const Text('Festival'),
                    subtitle: Text(concert.festival),
                  ),

                  ListTile(
                    leading: const Icon(Icons.location_city),
                    title: const Text('Ciudad'),
                    subtitle: Text(concert.city),
                  ),

                  ListTile(
                    leading: const Icon(Icons.calendar_month),
                    title: const Text('Fecha'),
                    subtitle: Text(DateFormatter.short(concert.date)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
