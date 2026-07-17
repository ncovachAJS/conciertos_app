import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../concerts/domain/entities/concert.dart';
import '../../../concerts/presentation/providers/concerts_provider.dart';
import '../../../ticketmaster/data/services/ticketmaster_service.dart';
import '../../../ticketmaster/domain/entities/ticketmaster_event.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  final _ticketmaster = TicketmasterService();

  List<TicketmasterEvent> _recommendations = [];
  bool _loadingRecs = true;

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    try {
      final concerts = ref.read(concertsProvider).asData?.value ?? [];
      final artists = concerts
          .where((c) => c.favorite || c.liked)
          .map((c) => c.artist.trim())
          .where((a) => a.isNotEmpty)
          .toSet()
          .take(8)
          .toList();
      _recommendations = await _ticketmaster.getRecommendedEvents(artists);
    } catch (_) {}
    if (mounted) setState(() => _loadingRecs = false);
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  List<Concert> _upcoming(List<Concert> concerts) {
    final now = DateTime.now();
    return concerts.where((c) => c.date.isAfter(now)).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<Concert> _onThisDay(List<Concert> concerts) {
    final now = DateTime.now();
    return concerts
        .where(
          (c) =>
              c.date.day == now.day &&
              c.date.month == now.month &&
              c.date.year < now.year,
        )
        .toList()
      ..sort((a, b) => b.date.year.compareTo(a.date.year));
  }

  int _daysUntil(DateTime date) => date.difference(DateTime.now()).inDays + 1;

  int _yearsAgo(DateTime date) => DateTime.now().year - date.year;

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final concerts = ref.watch(concertsProvider).asData?.value ?? [];
    final upcoming = _upcoming(concerts);
    final memories = _onThisDay(concerts);

    final hasAnything =
        upcoming.isNotEmpty ||
        memories.isNotEmpty ||
        _recommendations.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        actions: [
          if (hasAnything)
            TextButton(
              onPressed: () {},
              child: const Text('Marcar todo como leído'),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadRecommendations,
        child: !hasAnything && !_loadingRecs
            ? _buildEmpty()
            : ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  // ── Recuerdos (On this day) ───────────────────────────────
                  if (memories.isNotEmpty) ...[
                    _SectionHeader(
                      icon: Icons.history,
                      title: 'Recuerdos de hoy',
                      color: const Color(0xFFFFC107),
                    ),
                    ...memories.map(
                      (c) => _NotificationTile(
                        icon: Icons.celebration,
                        color: const Color(0xFFFFC107),
                        title:
                            'Hace ${_yearsAgo(c.date)} año${_yearsAgo(c.date) > 1 ? "s" : ""}: ${c.artist}',
                        subtitle:
                            '${c.venue}, ${c.city} · ${c.date.day}/${c.date.month}/${c.date.year}',
                        tag: '🎂',
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],

                  // ── Próximos ──────────────────────────────────────────────
                  if (upcoming.isNotEmpty) ...[
                    _SectionHeader(
                      icon: Icons.event_available,
                      title: 'Conciertos próximos',
                      color: const Color(0xFF42A5F5),
                    ),
                    ...upcoming.take(10).map((c) {
                      final days = _daysUntil(c.date);
                      return _NotificationTile(
                        icon: Icons.music_note,
                        color: const Color(0xFF42A5F5),
                        title: c.artist,
                        subtitle: days == 0
                            ? '¡Es hoy! · ${c.venue}, ${c.city}'
                            : days == 1
                            ? '¡Mañana! · ${c.venue}, ${c.city}'
                            : 'Faltan $days días · ${c.venue}, ${c.city}',
                        tag: days <= 3 ? '🔥' : '📅',
                        highlight: days <= 3,
                      );
                    }),
                    const SizedBox(height: 8),
                  ],

                  // ── Recomendaciones ───────────────────────────────────────
                  _SectionHeader(
                    icon: Icons.local_fire_department,
                    title: 'Recomendaciones',
                    color: const Color(0xFFE53935),
                  ),
                  if (_loadingRecs)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_recommendations.isEmpty)
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Text(
                        'Añade conciertos favoritos para recibir recomendaciones.',
                        style: TextStyle(color: Colors.white54),
                      ),
                    )
                  else
                    ..._recommendations.take(10).map((e) {
                      final days = _daysUntil(e.date);
                      return _NotificationTile(
                        icon: Icons.confirmation_number_outlined,
                        color: const Color(0xFFE53935),
                        title: '${e.name} — ${e.recommendedBecause}',
                        subtitle:
                            '${e.venue}, ${e.city} · ${e.date.day}/${e.date.month}/${e.date.year}',
                        tag: days <= 30 ? '🎟️' : '📣',
                      );
                    }),

                  const SizedBox(height: 32),
                ],
              ),
      ),
    );
  }

  Widget _buildEmpty() {
    return ListView(
      children: const [
        SizedBox(height: 100),
        Icon(Icons.notifications_none, size: 80, color: Colors.white24),
        SizedBox(height: 16),
        Center(
          child: Text(
            'Sin notificaciones por ahora.\nAñade conciertos para empezar.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 15),
          ),
        ),
      ],
    );
  }
}

// ── Widgets auxiliares ────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String tag;
  final bool highlight;

  const _NotificationTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.tag,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: highlight
            ? color.withOpacity(0.08)
            : Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: highlight
            ? Border.all(color: color.withOpacity(0.3), width: 1)
            : null,
      ),
      child: ListTile(
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(tag, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
