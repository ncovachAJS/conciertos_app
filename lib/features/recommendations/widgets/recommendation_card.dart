import 'package:conciertos_app/features/recommendations/presentation/pages/domain/entities/recommended_event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecommendationCard extends StatelessWidget {
  final RecommendedEvent event;

  const RecommendationCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              event.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image_not_supported),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.artist,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(Icons.location_on, size: 18),
                    const SizedBox(width: 6),
                    Expanded(child: Text('${event.city} · ${event.venue}')),
                  ],
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(Icons.calendar_month, size: 18),
                    const SizedBox(width: 6),
                    Text(DateFormat('dd/MM/yyyy').format(event.date)),
                  ],
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      // siguiente paso
                    },
                    icon: const Icon(Icons.confirmation_number),
                    label: const Text('Comprar entradas'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
