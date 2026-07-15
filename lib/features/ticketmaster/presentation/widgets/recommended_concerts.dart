import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../ticketmaster/data/services/ticketmaster_service.dart';
import '../../../ticketmaster/domain/entities/ticketmaster_event.dart';

class RecommendedConcerts extends StatefulWidget {
  final List<String> favoriteArtists;

  const RecommendedConcerts({super.key, required this.favoriteArtists});

  @override
  State<RecommendedConcerts> createState() => _RecommendedConcertsState();
}

class _RecommendedConcertsState extends State<RecommendedConcerts> {
  final TicketmasterService _service = TicketmasterService();

  List<TicketmasterEvent> events = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      events = await _service.getRecommendedEvents(widget.favoriteArtists);
    } catch (e) {
      debugPrint(e.toString());
    }

    if (mounted) setState(() => loading = false);
  }

  Future<void> _openTicketmaster(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (events.isEmpty) {
      return const Text('No hay conciertos recomendados.');
    }

    return SizedBox(
      height: 320,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (_, index) {
          final event = events[index];

          return Container(
            width: 250,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: const Color(0xFF1C1F26),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image.network(
                    event.image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.black26,
                      child: const Center(
                        child: Icon(
                          Icons.music_note,
                          size: 60,
                          color: Colors.white24,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(.15),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'Porque te gusta ${event.recommendedBecause}',
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        event.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.venue,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event.city,
                        style: const TextStyle(color: Colors.white54),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => _openTicketmaster(event.url),
                        child: const Text('Ver en Ticketmaster'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
