import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../concerts/presentation/providers/concerts_provider.dart';
import '../../../ticketmaster/data/services/ticketmaster_service.dart';
import '../../../ticketmaster/domain/entities/ticketmaster_event.dart';

class RecommendedConcerts extends ConsumerStatefulWidget {
  final List<String> favoriteArtists;

  const RecommendedConcerts({super.key, required this.favoriteArtists});

  @override
  ConsumerState<RecommendedConcerts> createState() =>
      _RecommendedConcertsState();
}

class _RecommendedConcertsState extends ConsumerState<RecommendedConcerts> {
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
      return const SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (events.isEmpty) {
      return _buildLocalFallback(context);
    }

    final cs = Theme.of(context).colorScheme;

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
              color: cs.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: cs.shadow.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
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
                        style: TextStyle(color: cs.onSurface.withOpacity(0.7)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event.city,
                        style: TextStyle(color: cs.onSurface.withOpacity(0.54)),
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

  /// Fallback local: top artistas más vistos de tu colección
  Widget _buildLocalFallback(BuildContext context) {
    final concerts = ref.read(concertsProvider).asData?.value ?? [];
    final cs = Theme.of(context).colorScheme;

    if (concerts.isEmpty) {
      return Text(
        'Añade conciertos para ver recomendaciones.',
        style: TextStyle(color: cs.onSurface.withOpacity(0.54), fontSize: 14),
      );
    }

    // Top 5 artistas más vistos
    final countMap = <String, int>{};
    for (final c in concerts) {
      if (c.artist.trim().isNotEmpty) {
        countMap[c.artist.trim()] = (countMap[c.artist.trim()] ?? 0) + 1;
      }
    }
    final topArtists =
        (countMap.entries.toList()..sort((a, b) => b.value.compareTo(a.value)))
            .take(5)
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'No encontramos eventos próximos. Tus artistas más vistos:',
          style: TextStyle(color: cs.onSurface.withOpacity(0.54), fontSize: 13),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: topArtists.map((entry) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: const Color(0xFFE53935).withOpacity(0.3),
                ),
                boxShadow: [
                  BoxShadow(color: cs.shadow.withOpacity(0.06), blurRadius: 6),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.music_note,
                    color: Color(0xFFE53935),
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    entry.key,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '×${entry.value}',
                    style: TextStyle(
                      color: cs.onSurface.withOpacity(0.4),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
