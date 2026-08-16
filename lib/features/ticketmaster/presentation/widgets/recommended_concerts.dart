import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../shared/widgets/shimmer_box.dart';

import '../../../../l10n/generated/app_localizations.dart';

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
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  @override
  void didUpdateWidget(RecommendedConcerts oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.favoriteArtists != widget.favoriteArtists) {
      _loadEvents();
    }
  }

  Future<void> _loadEvents() async {
    setState(() {
      loading = true;
      hasError = false;
    });
    try {
      events = await _service.getRecommendedEvents(widget.favoriteArtists);
    } catch (e) {
      debugPrint('RecommendedConcerts error: $e');
      if (mounted) setState(() => hasError = true);
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
    final l = AppLocalizations.of(context);
    if (loading) {
      return SizedBox(
        height: 300,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          separatorBuilder: (_, __) => const SizedBox(width: 16),
          itemBuilder: (_, __) => const ShimmerBox(
            width: 220,
            height: 300,
            borderRadius: 24,
          ),
        ),
      );
    }

    if (hasError) {
      return _buildError(context, l);
    }

    if (events.isEmpty) {
      return _buildLocalFallback(context, l);
    }

    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
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
                          l.becauseYouLike(event.recommendedBecause),
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
                        child: Text(l.viewOnTicketmaster),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
          ),
        ),
        // Atribución requerida por las ToS de Ticketmaster
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Powered by Ticketmaster',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.withOpacity(0.55),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context, AppLocalizations l) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(Icons.wifi_off_rounded,
            size: 18, color: cs.onSurface.withOpacity(0.4)),
        const SizedBox(width: 8),
        Text(
          l.error,
          style:
              TextStyle(color: cs.onSurface.withOpacity(0.54), fontSize: 14),
        ),
        const SizedBox(width: 12),
        TextButton(
          onPressed: _loadEvents,
          child: Text(l.retry),
        ),
      ],
    );
  }

  Widget _buildLocalFallback(BuildContext context, AppLocalizations l) {
    final cs = Theme.of(context).colorScheme;

    if (widget.favoriteArtists.isEmpty) {
      return Text(
        l.noConcertsAddForRec,
        style: TextStyle(color: cs.onSurface.withOpacity(0.54), fontSize: 14),
      );
    }

    // Cuenta de conciertos por artista para mostrar el ×N
    final concerts = ref.read(concertsProvider).asData?.value ?? [];
    final countMap = <String, int>{};
    for (final c in concerts) {
      final a = c.artist.trim();
      if (a.isNotEmpty) countMap[a] = (countMap[a] ?? 0) + 1;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.noUpcomingEvents,
          style: TextStyle(color: cs.onSurface.withOpacity(0.54), fontSize: 13),
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: widget.favoriteArtists.map((artist) {
              final count = countMap[artist];
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
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
                      const Icon(Icons.music_note, color: Color(0xFFE53935), size: 14),
                      const SizedBox(width: 6),
                      Text(
                        artist,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      if (count != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          '×$count',
                          style: TextStyle(
                            color: cs.onSurface.withOpacity(0.4),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
