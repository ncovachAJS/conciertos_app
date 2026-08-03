import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../concerts/domain/entities/concert.dart';
import '../../../concerts/presentation/providers/concerts_provider.dart';
import '../../../profile/domain/achievement.dart';
import '../../../profile/presentation/widgets/achievements_widget.dart';
import '../../data/services/friends_api_service.dart';
import '../../domain/entities/friend.dart';
import '../widgets/friend_avatar.dart';

// ---------------------------------------------------------------------------
// Modelo de estadísticas
// ---------------------------------------------------------------------------

class _Stats {
  final List<Concert> concerts;
  _Stats(this.concerts);

  int get total => concerts.length;

  int get uniqueArtists => concerts
      .map((c) => c.artist.trim())
      .where((a) => a.isNotEmpty)
      .toSet()
      .length;

  int get uniqueFestivals => concerts
      .map((c) => c.festival.trim())
      .where((f) => f.isNotEmpty)
      .toSet()
      .length;

  double get avgRating {
    final rated = concerts.where((c) => c.rating > 0).toList();
    if (rated.isEmpty) return 0;
    return rated.fold<int>(0, (s, c) => s + c.rating) / rated.length;
  }

  List<MapEntry<String, int>> get topArtists =>
      _top(concerts.map((c) => c.artist.trim()).where((a) => a.isNotEmpty));

  List<MapEntry<String, int>> _top(Iterable<String> values, {int take = 5}) {
    final map = <String, int>{};
    for (final v in values) {
      map[v] = (map[v] ?? 0) + 1;
    }
    final sorted = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(take).toList();
  }
}

// ---------------------------------------------------------------------------
// Página
// ---------------------------------------------------------------------------

class FriendProfilePage extends ConsumerStatefulWidget {
  final Friend friend;
  const FriendProfilePage({super.key, required this.friend});

  @override
  ConsumerState<FriendProfilePage> createState() => _FriendProfilePageState();
}

class _FriendProfilePageState extends ConsumerState<FriendProfilePage> {
  final _friendsApi = FriendsApiService();
  List<Concert> _friendUpcoming = [];
  bool _loadingFriendConcerts = false;
  List<Achievement>? _friendAchievements;

  @override
  void initState() {
    super.initState();
    _loadFriendData();
  }

  Future<void> _loadFriendData() async {
    setState(() => _loadingFriendConcerts = true);
    try {
      final results = await Future.wait([
        _friendsApi.getFriendUpcomingConcerts(widget.friend.id),
        _friendsApi.getFriendStats(widget.friend.id),
      ]);
      if (mounted) {
        setState(() {
          _friendUpcoming = results[0] as List<Concert>;
          _friendAchievements = AchievementsEngine.compute(results[1] as UserStats);
        });
      }
    } catch (e) {
      debugPrint('Error cargando datos del amigo: $e');
    } finally {
      if (mounted) setState(() => _loadingFriendConcerts = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final concertsAsync = ref.watch(concertsProvider);
    final cs = Theme.of(context).colorScheme;
    const red = Color(0xFFE53935);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.friend.name,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: concertsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(l.error)),
        data: (allConcerts) {
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);

          final shared = allConcerts
              .where((c) => c.participantIds.contains(widget.friend.id))
              .toList()
            ..sort((a, b) => b.date.compareTo(a.date));

          final upcoming = shared
              .where((c) =>
                  !DateTime(c.date.year, c.date.month, c.date.day)
                      .isBefore(today))
              .toList()
            ..sort((a, b) => a.date.compareTo(b.date));

          final past = shared
              .where((c) =>
                  DateTime(c.date.year, c.date.month, c.date.day)
                      .isBefore(today))
              .toList();

          final stats = _Stats(past);

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
            children: [
              // ── Cabecera de perfil ─────────────────────────────────────
              _ProfileHeader(friend: widget.friend, cs: cs),
              const SizedBox(height: 24),

              // ── Logros del amigo ───────────────────────────────────────
              if (_friendAchievements != null) ...[
                AchievementsWidget(achievements: _friendAchievements!),
                const SizedBox(height: 28),
              ],

              // ── Próximos conciertos propios del amigo ─────────────────
              _SectionTitle(
                icon: Icons.calendar_month_rounded,
                title: 'PRÓXIMOS CONCIERTOS DE ${widget.friend.name.toUpperCase().split(' ').first}',
                color: Colors.deepPurpleAccent,
              ),
              const SizedBox(height: 12),
              if (_loadingFriendConcerts)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_friendUpcoming.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'No tiene conciertos próximos',
                    style: TextStyle(
                      color: cs.onSurface.withOpacity(0.4),
                      fontSize: 14,
                    ),
                  ),
                )
              else
                _ConcertList(
                  concerts: _friendUpcoming,
                  cs: cs,
                  accent: Colors.deepPurpleAccent,
                ),
              const SizedBox(height: 28),

              // ── Sección conciertos juntos ──────────────────────────────
              if (shared.isEmpty) ...[
                _EmptyShared(cs: cs),
              ] else ...[
                // ── Próximos ─────────────────────────────────────────────
                if (upcoming.isNotEmpty) ...[
                  _SectionTitle(
                    icon: Icons.people_rounded,
                    title: 'PRÓXIMOS CONCIERTOS JUNTOS',
                    color: Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _ConcertList(concerts: upcoming, cs: cs, accent: Colors.green),
                  const SizedBox(height: 28),
                ],

                // ── Stats (basadas en pasados) ────────────────────────────
                if (past.isNotEmpty) ...[
                  _SectionTitle(
                    icon: Icons.history_rounded,
                    title: 'NÚMEROS JUNTOS',
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  _StatsGrid(stats: stats, l: l, red: red),
                  const SizedBox(height: 28),

                  if (stats.topArtists.isNotEmpty) ...[
                    _SectionTitle(
                      icon: Icons.person,
                      title: l.topArtists,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(height: 12),
                    _HorizontalBars(entries: stats.topArtists, color: red),
                    const SizedBox(height: 28),
                  ],

                  _SectionTitle(
                    icon: Icons.queue_music_rounded,
                    title: 'HISTORIAL',
                    color: Colors.tealAccent,
                  ),
                  const SizedBox(height: 12),
                  _ConcertList(concerts: past, cs: cs),
                ],
              ],
            ],
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Cabecera de perfil
// ---------------------------------------------------------------------------

class _ProfileHeader extends StatelessWidget {
  final Friend friend;
  final ColorScheme cs;

  const _ProfileHeader({required this.friend, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          FriendAvatar(
            name: friend.name,
            avatarUrl: friend.avatarUrl,
            radius: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friend.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  friend.email,
                  style: TextStyle(
                    fontSize: 13,
                    color: cs.onSurface.withOpacity(0.5),
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

// ---------------------------------------------------------------------------
// Estado vacío
// ---------------------------------------------------------------------------

class _EmptyShared extends StatelessWidget {
  final ColorScheme cs;
  const _EmptyShared({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(
            Icons.music_off_rounded,
            size: 64,
            color: cs.onSurface.withOpacity(0.18),
          ),
          const SizedBox(height: 16),
          Text(
            'Aún no habéis ido a ningún\nconcierto juntos.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: cs.onSurface.withOpacity(0.45),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '¡Etiquetad vuestros próximos directos!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: cs.onSurface.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Grid de estadísticas
// ---------------------------------------------------------------------------

class _StatsGrid extends StatelessWidget {
  final _Stats stats;
  final AppLocalizations l;
  final Color red;

  const _StatsGrid({required this.stats, required this.l, required this.red});

  @override
  Widget build(BuildContext context) {
    final items = [
      _CardData(
        '${stats.total}',
        l.totalConcertsLabel,
        Icons.music_note_rounded,
        const Color(0xFFE53935),
      ),
      _CardData(
        '${stats.uniqueArtists}',
        l.uniqueArtistsLabel,
        Icons.person_rounded,
        const Color(0xFF42A5F5),
      ),
      _CardData(
        '${stats.uniqueFestivals}',
        l.uniqueFestivalsLabel,
        Icons.festival_rounded,
        const Color(0xFF66BB6A),
      ),
      _CardData(
        stats.avgRating > 0
            ? stats.avgRating.toStringAsFixed(1)
            : l.noDataDash,
        l.avgRatingLabel,
        Icons.star_rounded,
        const Color(0xFFFFC107),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 14) / 2;
        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: items
              .map(
                (d) => SizedBox(
                  width: cardWidth,
                  height: cardWidth * 0.72,
                  child: _StatCard(data: d),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _CardData {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _CardData(this.value, this.label, this.icon, this.color);
}

class _StatCard extends StatelessWidget {
  final _CardData data;
  const _StatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: data.color.withOpacity(.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(data.icon, color: data.color, size: 20),
          ),
          const Spacer(),
          Text(
            data.value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            data.label,
            style: TextStyle(
              color:
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Título de sección
// ---------------------------------------------------------------------------

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? color;
  const _SectionTitle({required this.icon, required this.title, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.onSurface.withOpacity(0.54);
    return Row(
      children: [
        Icon(icon, color: c, size: 18),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: c,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Barras horizontales
// ---------------------------------------------------------------------------

class _HorizontalBars extends StatelessWidget {
  final List<MapEntry<String, int>> entries;
  final Color color;
  const _HorizontalBars({required this.entries, required this.color});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();
    final maxVal = entries.first.value;
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          for (int i = 0; i < entries.length; i++) ...[
            if (i > 0) const SizedBox(height: 14),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    entries[i].key,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: cs.onSurface),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final ratio =
                          maxVal > 0 ? entries[i].value / maxVal : 0.0;
                      return Stack(
                        children: [
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: cs.onSurface.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Container(
                            height: 8,
                            width: constraints.maxWidth *
                                ratio.clamp(0.03, 1.0),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 24,
                  child: Text(
                    '${entries[i].value}',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Lista de conciertos compartidos
// ---------------------------------------------------------------------------

class _ConcertList extends StatelessWidget {
  final List<Concert> concerts;
  final ColorScheme cs;
  final Color? accent;
  const _ConcertList({required this.concerts, required this.cs, this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          for (int i = 0; i < concerts.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: cs.onSurface.withOpacity(0.08),
              ),
            _ConcertRow(concert: concerts[i], cs: cs, accent: accent),
          ],
        ],
      ),
    );
  }
}

class _ConcertRow extends StatelessWidget {
  final Concert concert;
  final ColorScheme cs;
  final Color? accent;
  const _ConcertRow({required this.concert, required this.cs, this.accent});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('d MMM yyyy', 'es').format(concert.date);
    final subtitle =
        [concert.venue, concert.city].where((s) => s.isNotEmpty).join(' · ');

    return InkWell(
      onTap: () => context.push('/concert-detail', extra: concert),
      borderRadius: BorderRadius.circular(22),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            if (concert.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: concert.imageUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => _PlaceholderIcon(cs: cs),
                ),
              )
            else
              _PlaceholderIcon(cs: cs),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    concert.artist.isNotEmpty ? concert.artist : concert.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurface.withOpacity(0.5),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  dateStr,
                  style: TextStyle(
                    fontSize: 11,
                    color: cs.onSurface.withOpacity(0.45),
                  ),
                ),
                if (concert.rating > 0) ...[
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 12,
                        color: Color(0xFFFFC107),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${concert.rating}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFC107),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            const SizedBox(width: 4),
            if (accent != null)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                ),
              ),
            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: cs.onSurface.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderIcon extends StatelessWidget {
  final ColorScheme cs;
  const _PlaceholderIcon({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: cs.onSurface.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.music_note_rounded,
        color: cs.onSurface.withOpacity(0.3),
        size: 24,
      ),
    );
  }
}
