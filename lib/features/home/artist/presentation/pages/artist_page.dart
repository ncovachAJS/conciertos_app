import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/date_formatter.dart';
import '../../../../concerts/domain/entities/concert.dart';

/// Página de detalle de artista — todos los conciertos de un artista
/// ordenados cronológicamente con estadísticas rápidas.
class ArtistPage extends StatelessWidget {
  final String artist;
  final List<Concert> concerts;

  const ArtistPage({super.key, required this.artist, required this.concerts});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const red = Color(0xFFE53935);

    // Ordenados del más antiguo al más reciente
    final sorted = [...concerts]..sort((a, b) => a.date.compareTo(b.date));
    final past = sorted.where((c) => c.isPastConcert).toList();
    final upcoming = sorted.where((c) => !c.isPastConcert).toList();

    // Estadísticas
    final totalPast = past.length;
    final rated = past.where((c) => c.rating > 0).toList();
    final avgRating = rated.isEmpty
        ? 0.0
        : rated.fold<int>(0, (s, c) => s + c.rating) / rated.length;
    final cities = past
        .map((c) => c.city.trim())
        .where((c) => c.isNotEmpty)
        .toSet();
    final firstConcert = past.isEmpty ? null : past.first;
    final bestConcert = rated.isEmpty
        ? null
        : rated.reduce((a, b) => a.rating >= b.rating ? a : b);

    // Imagen representativa — la del concierto con mejor rating, o el primero
    final coverImage = bestConcert?.imageUrl.isNotEmpty == true
        ? bestConcert!.imageUrl
        : (sorted
              .firstWhere(
                (c) => c.imageUrl.isNotEmpty,
                orElse: () => sorted.first,
              )
              .imageUrl);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Header con imagen ──────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (coverImage.isNotEmpty)
                    Image.network(
                      coverImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: const Color(0xFF1A1A1A)),
                    )
                  else
                    Container(color: const Color(0xFF1A1A1A)),
                  // Degradado para que el texto sea legible
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Text(
                      artist,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Stats rápidas ────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Row(
                    children: [
                      _StatChip(
                        icon: Icons.music_note_rounded,
                        label: '$totalPast',
                        sublabel: totalPast == 1 ? 'concierto' : 'conciertos',
                        color: red,
                      ),
                      const SizedBox(width: 10),
                      if (avgRating > 0)
                        _StatChip(
                          icon: Icons.star_rounded,
                          label: avgRating.toStringAsFixed(1),
                          sublabel: 'valoración media',
                          color: const Color(0xFFFFC107),
                        ),
                      if (avgRating > 0) const SizedBox(width: 10),
                      if (cities.isNotEmpty)
                        _StatChip(
                          icon: Icons.location_city_rounded,
                          label: '${cities.length}',
                          sublabel: cities.length == 1 ? 'ciudad' : 'ciudades',
                          color: const Color(0xFF42A5F5),
                        ),
                    ],
                  ),
                ),

                // ── Datos destacados ─────────────────────────────────────
                if (firstConcert != null) ...[
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        if (firstConcert != null)
                          Expanded(
                            child: _HighlightCard(
                              icon: Icons.history_rounded,
                              label: 'Primer concierto',
                              value: DateFormatter.short(firstConcert.date),
                              sub: firstConcert.venue.isNotEmpty
                                  ? firstConcert.venue
                                  : null,
                              color: red,
                            ),
                          ),
                        if (bestConcert != null &&
                            bestConcert.id != firstConcert?.id) ...[
                          const SizedBox(width: 10),
                          Expanded(
                            child: _HighlightCard(
                              icon: Icons.emoji_events_rounded,
                              label: 'El mejor',
                              value: DateFormatter.short(bestConcert.date),
                              sub: bestConcert.venue.isNotEmpty
                                  ? bestConcert.venue
                                  : null,
                              color: const Color(0xFFFFC107),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],

                // ── Próximos ─────────────────────────────────────────────
                if (upcoming.isNotEmpty) ...[
                  const SizedBox(height: 28),
                  _SectionHeader(
                    icon: Icons.calendar_month_rounded,
                    title: 'PRÓXIMOS',
                  ),
                  const SizedBox(height: 12),
                  ...upcoming.map((c) => _ConcertRow(concert: c, cs: cs)),
                ],

                // ── Historial ────────────────────────────────────────────
                if (past.isNotEmpty) ...[
                  const SizedBox(height: 28),
                  _SectionHeader(
                    icon: Icons.history_rounded,
                    title: 'HISTORIAL',
                  ),
                  const SizedBox(height: 12),
                  // Más reciente primero en historial
                  ...past.reversed.map((c) => _ConcertRow(concert: c, cs: cs)),
                ],

                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widgets auxiliares ─────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: cs.onSurface,
                    ),
                  ),
                  Text(
                    sublabel,
                    style: TextStyle(
                      fontSize: 10,
                      color: cs.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HighlightCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? sub;
  final Color color;

  const _HighlightCard({
    required this.icon,
    required this.label,
    required this.value,
    this.sub,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: cs.onSurface,
            ),
          ),
          if (sub != null)
            Text(
              sub!,
              style: TextStyle(
                fontSize: 12,
                color: cs.onSurface.withOpacity(0.5),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(icon, size: 16, color: cs.onSurface.withOpacity(0.5)),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: cs.onSurface.withOpacity(0.5),
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConcertRow extends StatelessWidget {
  final Concert concert;
  final ColorScheme cs;

  const _ConcertRow({required this.concert, required this.cs});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/concert-detail', extra: concert),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Imagen miniatura
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: concert.imageUrl.isNotEmpty
                  ? Image.network(
                      concert.imageUrl,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    concert.name.isNotEmpty ? concert.name : concert.artist,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: cs.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    [
                      DateFormatter.short(concert.date),
                      if (concert.venue.isNotEmpty) concert.venue,
                      if (concert.city.isNotEmpty) concert.city,
                    ].join(' · '),
                    style: TextStyle(
                      fontSize: 12,
                      color: cs.onSurface.withOpacity(0.5),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (concert.rating > 0) ...[
              const SizedBox(width: 8),
              Row(
                children: List.generate(
                  concert.rating,
                  (_) => const Icon(
                    Icons.star_rounded,
                    color: Color(0xFFFFC107),
                    size: 12,
                  ),
                ),
              ),
            ],
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right,
              color: cs.onSurface.withOpacity(0.3),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFE53935).withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.music_note, color: Color(0xFFE53935), size: 24),
    );
  }
}
