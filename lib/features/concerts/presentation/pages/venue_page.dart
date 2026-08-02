import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/concert.dart';
import '../providers/concerts_provider.dart';

class VenuePage extends ConsumerWidget {
  final String venue;
  final String city;

  const VenuePage({super.key, required this.venue, required this.city});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    const red = Color(0xFFE53935);

    final all = ref.watch(concertsProvider).asData?.value ?? [];

    // Todos los conciertos en este recinto, ordenados del más reciente
    final concerts = all
        .where((c) =>
            c.venue.trim().toLowerCase() == venue.trim().toLowerCase())
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    final past = concerts.where((c) => c.isPastConcert).toList();
    final upcoming = concerts.where((c) => !c.isPastConcert).toList();

    // Estadísticas
    final artists = past
        .map((c) => c.artist.trim())
        .where((a) => a.isNotEmpty)
        .toSet();
    final firstVisit = past.isEmpty ? null : past.last;
    final lastVisit = past.isEmpty ? null : past.first;
    final coverImage = concerts
        .where((c) => c.imageUrl.isNotEmpty)
        .firstOrNull
        ?.imageUrl ?? '';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Header ────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (coverImage.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: coverImage,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) =>
                          Container(color: const Color(0xFF1A1A1A)),
                    )
                  else
                    Container(color: const Color(0xFF1A1A1A)),
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
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.stadium,
                                color: Colors.white70, size: 16),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                venue,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        if (city.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            city,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Stats ──────────────────────────────────────────────────────
          if (concerts.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: Row(
                  children: [
                    _StatChip(
                      icon: Icons.confirmation_number_outlined,
                      label: '${past.length}',
                      sublabel: past.length == 1 ? l.artistConcertSingular : l.artistConcertPlural,
                      color: red,
                    ),
                    const SizedBox(width: 12),
                    _StatChip(
                      icon: Icons.people_outline,
                      label: '${artists.length}',
                      sublabel: artists.length == 1 ? 'artista' : 'artistas',
                      color: Colors.blueAccent,
                    ),
                    if (upcoming.isNotEmpty) ...[
                      const SizedBox(width: 12),
                      _StatChip(
                        icon: Icons.event_outlined,
                        label: '${upcoming.length}',
                        sublabel: upcoming.length == 1
                            ? 'próximo'
                            : 'próximos',
                        color: Colors.green,
                      ),
                    ],
                  ],
                ),
              ),
            ),

          // Primera / última visita
          if (firstVisit != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: Row(
                  children: [
                    Icon(Icons.history_rounded,
                        size: 14, color: cs.onSurface.withOpacity(0.4)),
                    const SizedBox(width: 6),
                    Text(
                      'Primera visita: ${DateFormatter.short(firstVisit.date)}',
                      style: TextStyle(
                          color: cs.onSurface.withOpacity(0.5),
                          fontSize: 13),
                    ),
                    if (lastVisit != null && lastVisit.id != firstVisit.id) ...[
                      const SizedBox(width: 16),
                      Icon(Icons.update_rounded,
                          size: 14, color: cs.onSurface.withOpacity(0.4)),
                      const SizedBox(width: 6),
                      Text(
                        'Última: ${DateFormatter.short(lastVisit.date)}',
                        style: TextStyle(
                            color: cs.onSurface.withOpacity(0.5),
                            fontSize: 13),
                      ),
                    ],
                  ],
                ),
              ),
            ),

          // ── Próximos ───────────────────────────────────────────────────
          if (upcoming.isNotEmpty) ...[
            _SectionHeader(
                icon: Icons.event_outlined,
                title: l.artistUpcoming,
                color: Colors.green),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _ConcertRow(concert: upcoming[i]),
                childCount: upcoming.length,
              ),
            ),
          ],

          // ── Historial ──────────────────────────────────────────────────
          if (past.isNotEmpty) ...[
            _SectionHeader(
                icon: Icons.history_rounded,
                title: l.artistHistory,
                color: red),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _ConcertRow(concert: past[i]),
                childCount: past.length,
              ),
            ),
          ],

          // Vacío
          if (concerts.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.stadium,
                        size: 64, color: cs.onSurface.withOpacity(0.15)),
                    const SizedBox(height: 16),
                    Text(
                      'No hay conciertos en este recinto',
                      style: TextStyle(
                          color: cs.onSurface.withOpacity(0.4),
                          fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}

// ── Chip de estadística ───────────────────────────────────────────────────────

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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: cs.onSurface)),
              Text(sublabel,
                  style: TextStyle(
                      fontSize: 11,
                      color: cs.onSurface.withOpacity(0.5))),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Encabezado de sección ─────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _SectionHeader(
      {required this.icon, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Fila de concierto ─────────────────────────────────────────────────────────

class _ConcertRow extends StatelessWidget {
  final Concert concert;

  const _ConcertRow({required this.concert});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => context.push('/concert-detail', extra: concert),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Miniatura
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 52,
                height: 52,
                child: concert.imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: concert.imageUrl,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => _placeholder(cs),
                      )
                    : _placeholder(cs),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    concert.artist.isNotEmpty ? concert.artist : concert.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    DateFormatter.short(concert.date),
                    style: TextStyle(
                        color: cs.onSurface.withOpacity(0.5), fontSize: 13),
                  ),
                ],
              ),
            ),
            if (concert.rating > 0) ...[
              const SizedBox(width: 8),
              Row(
                children: List.generate(
                  concert.rating,
                  (_) => const Icon(Icons.star_rounded,
                      size: 13, color: Colors.amber),
                ),
              ),
            ],
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded,
                color: cs.onSurface.withOpacity(0.3)),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(ColorScheme cs) => Container(
        color: cs.surfaceContainerHighest,
        child: Icon(Icons.music_note,
            color: cs.onSurface.withOpacity(0.2), size: 24),
      );
}
