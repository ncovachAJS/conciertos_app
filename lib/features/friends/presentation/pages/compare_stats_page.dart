import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../concerts/domain/entities/concert.dart';
import '../../../concerts/presentation/providers/concerts_provider.dart';
import '../../domain/entities/friend.dart';
import '../widgets/friend_avatar.dart';

class CompareStatsPage extends ConsumerWidget {
  final Friend friend;
  final List<Concert> friendConcerts;

  const CompareStatsPage({
    super.key,
    required this.friend,
    required this.friendConcerts,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final allMyConcerts = ref.watch(concertsProvider).asData?.value ?? [];

    // Deduplicación de mis conciertos (mismo que concertStatsProvider)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final currentUserId = AuthController.instance.user?.id ?? '';
    final currentUserName = AuthController.instance.user?.name ?? 'Tú';

    // Incluir propios + compartidos, deduplicar por artista+fecha
    final _pastAll = allMyConcerts.where((c) => c.date.isBefore(today)).toList()
      ..sort((a, b) {
        // Propios primero para que la versión propia gane en deduplicación
        final aOwn = (a.userId == currentUserId || a.userId.isEmpty) ? 0 : 1;
        final bOwn = (b.userId == currentUserId || b.userId.isEmpty) ? 0 : 1;
        return aOwn.compareTo(bOwn);
      });

    final _seenKeys = <String>{};
    final myConcerts = <Concert>[];
    for (final c in _pastAll) {
      final key =
          '${c.artist.trim().toLowerCase()}_${DateTime(c.date.year, c.date.month, c.date.day)}';
      if (_seenKeys.add(key)) myConcerts.add(c);
    }

    // Deduplicar conciertos del amigo por artista+fecha (propios ganan sobre compartidos)
    final _friendSorted = friendConcerts.where((c) => c.date.isBefore(today)).toList()
      ..sort((a, b) {
        final aOwn = a.userId == friend.id ? 0 : 1;
        final bOwn = b.userId == friend.id ? 0 : 1;
        return aOwn.compareTo(bOwn);
      });

    final _friendSeenKeys = <String>{};
    final friendPast = <Concert>[];
    for (final c in _friendSorted) {
      final key =
          '${c.artist.trim().toLowerCase()}_${DateTime(c.date.year, c.date.month, c.date.day)}';
      if (_friendSeenKeys.add(key)) friendPast.add(c);
    }

    final myStats = _ConcertStats(myConcerts);
    final friendStats = _ConcertStats(friendPast);

    // Artistas en común
    final myArtists = myConcerts
        .map((c) => c.artist.trim())
        .where((a) => a.isNotEmpty)
        .toSet();
    final friendArtists = friendPast
        .map((c) => c.artist.trim())
        .where((a) => a.isNotEmpty)
        .toSet();

    final commonArtists = myArtists.intersection(friendArtists).toList()
      ..sort((a, b) {
        final countA = myConcerts.where((c) => c.artist.trim() == a).length +
            friendPast.where((c) => c.artist.trim() == a).length;
        final countB = myConcerts.where((c) => c.artist.trim() == b).length +
            friendPast.where((c) => c.artist.trim() == b).length;
        return countB.compareTo(countA);
      });

    final onlyMyArtists = myArtists
        .difference(friendArtists)
        .toList()
      ..sort((a, b) {
        final countA = myConcerts.where((c) => c.artist.trim() == a).length;
        final countB = myConcerts.where((c) => c.artist.trim() == b).length;
        return countB.compareTo(countA);
      });

    final onlyFriendArtists = friendArtists
        .difference(myArtists)
        .toList()
      ..sort((a, b) {
        final countA = friendPast.where((c) => c.artist.trim() == a).length;
        final countB = friendPast.where((c) => c.artist.trim() == b).length;
        return countB.compareTo(countA);
      });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Tú vs ${friend.name.split(' ').first}',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
        children: [
          // ── Cabecera con avatares ────────────────────────────────────────
          _CompareHeader(
            myName: currentUserName,
            myAvatarUrl: AuthController.instance.user?.avatarUrl,
            friend: friend,
            cs: cs,
          ),
          const SizedBox(height: 24),

          // ── Tabla de estadísticas ────────────────────────────────────────
          _SectionTitle(title: 'ESTADÍSTICAS', icon: Icons.bar_chart_rounded),
          const SizedBox(height: 12),
          _StatsTable(
            myStats: myStats,
            friendStats: friendStats,
            friendName: friend.name.split(' ').first,
            cs: cs,
          ),
          const SizedBox(height: 28),

          // ── Artistas en común ────────────────────────────────────────────
          if (commonArtists.isNotEmpty) ...[
            _SectionTitle(
              title: 'ARTISTAS EN COMÚN',
              icon: Icons.favorite_rounded,
              color: Colors.pinkAccent,
            ),
            const SizedBox(height: 12),
            _ArtistChipsList(
              artists: commonArtists,
              color: Colors.pinkAccent,
              cs: cs,
            ),
            const SizedBox(height: 28),
          ],

          // ── Solo yo ──────────────────────────────────────────────────────
          if (onlyMyArtists.isNotEmpty) ...[
            _SectionTitle(
              title: 'SOLO TÚ HAS VISTO',
              icon: Icons.person_rounded,
              color: const Color(0xFF42A5F5),
            ),
            const SizedBox(height: 12),
            _ArtistChipsList(
              artists: onlyMyArtists.take(5).toList(),
              color: const Color(0xFF42A5F5),
              cs: cs,
            ),
            const SizedBox(height: 28),
          ],

          // ── Solo el amigo ────────────────────────────────────────────────
          if (onlyFriendArtists.isNotEmpty) ...[
            _SectionTitle(
              title: 'SOLO ${friend.name.split(' ').first.toUpperCase()} HA VISTO',
              icon: Icons.person_rounded,
              color: Colors.deepPurpleAccent,
            ),
            const SizedBox(height: 12),
            _ArtistChipsList(
              artists: onlyFriendArtists.take(5).toList(),
              color: Colors.deepPurpleAccent,
              cs: cs,
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Estadísticas locales
// ---------------------------------------------------------------------------

class _ConcertStats {
  final List<Concert> concerts;

  _ConcertStats(this.concerts);

  int get total => concerts.length;

  int get uniqueArtists => concerts
      .map((c) => c.artist.trim())
      .where((a) => a.isNotEmpty)
      .toSet()
      .length;

  double get avgRating {
    final rated = concerts.where((c) => c.hasDetailedRating).toList();
    if (rated.isEmpty) return 0;
    return rated.fold<double>(0, (s, c) => s + c.detailedAvg) / rated.length;
  }

  int get thisYear {
    final year = DateTime.now().year;
    return concerts.where((c) => c.date.year == year).length;
  }

  String get topArtist {
    final map = <String, int>{};
    for (final c in concerts) {
      final a = c.artist.trim();
      if (a.isEmpty) continue;
      map[a] = (map[a] ?? 0) + 1;
    }
    if (map.isEmpty) return '—';
    final sorted = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.key;
  }
}

// ---------------------------------------------------------------------------
// Cabecera de comparación
// ---------------------------------------------------------------------------

class _CompareHeader extends StatelessWidget {
  final String myName;
  final String? myAvatarUrl;
  final Friend friend;
  final ColorScheme cs;

  const _CompareHeader({
    required this.myName,
    required this.myAvatarUrl,
    required this.friend,
    required this.cs,
  });

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
          // Tú
          Expanded(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFFE53935).withOpacity(0.2),
                  backgroundImage: (myAvatarUrl != null && myAvatarUrl!.isNotEmpty)
                      ? NetworkImage(myAvatarUrl!)
                      : null,
                  child: (myAvatarUrl == null || myAvatarUrl!.isEmpty)
                      ? Text(
                          myName.isNotEmpty ? myName[0].toUpperCase() : 'T',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE53935),
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 8),
                Text(
                  myName.split(' ').first,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // VS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'VS',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: cs.onSurface.withOpacity(0.4),
                letterSpacing: 2,
              ),
            ),
          ),
          // Amigo
          Expanded(
            child: Column(
              children: [
                FriendAvatar(
                  name: friend.name,
                  avatarUrl: friend.avatarUrl,
                  radius: 30,
                ),
                const SizedBox(height: 8),
                Text(
                  friend.name.split(' ').first,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
// Tabla de estadísticas
// ---------------------------------------------------------------------------

class _StatsTable extends StatelessWidget {
  final _ConcertStats myStats;
  final _ConcertStats friendStats;
  final String friendName;
  final ColorScheme cs;

  const _StatsTable({
    required this.myStats,
    required this.friendStats,
    required this.friendName,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    final rows = [
      _StatRow(
        label: 'Total conciertos',
        myValue: '${myStats.total}',
        friendValue: '${friendStats.total}',
        myWins: myStats.total > friendStats.total,
        friendWins: friendStats.total > myStats.total,
      ),
      _StatRow(
        label: 'Artistas únicos',
        myValue: '${myStats.uniqueArtists}',
        friendValue: '${friendStats.uniqueArtists}',
        myWins: myStats.uniqueArtists > friendStats.uniqueArtists,
        friendWins: friendStats.uniqueArtists > myStats.uniqueArtists,
      ),
      _StatRow(
        label: 'Media rating',
        myValue: myStats.avgRating > 0
            ? '${myStats.avgRating.toStringAsFixed(1)} ⭐'
            : '—',
        friendValue: friendStats.avgRating > 0
            ? '${friendStats.avgRating.toStringAsFixed(1)} ⭐'
            : '—',
        myWins: myStats.avgRating > friendStats.avgRating,
        friendWins: friendStats.avgRating > myStats.avgRating,
      ),
      _StatRow(
        label: 'Este año',
        myValue: '${myStats.thisYear}',
        friendValue: '${friendStats.thisYear}',
        myWins: myStats.thisYear > friendStats.thisYear,
        friendWins: friendStats.thisYear > myStats.thisYear,
      ),
      _StatRow(
        label: 'Artista top',
        myValue: myStats.topArtist,
        friendValue: friendStats.topArtist,
        myWins: false,
        friendWins: false,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: cs.onSurface.withOpacity(0.08),
              ),
            _StatsTableRow(row: rows[i], cs: cs),
          ],
        ],
      ),
    );
  }
}

class _StatRow {
  final String label;
  final String myValue;
  final String friendValue;
  final bool myWins;
  final bool friendWins;

  const _StatRow({
    required this.label,
    required this.myValue,
    required this.friendValue,
    required this.myWins,
    required this.friendWins,
  });
}

class _StatsTableRow extends StatelessWidget {
  final _StatRow row;
  final ColorScheme cs;

  const _StatsTableRow({required this.row, required this.cs});

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFE53935);
    final myColor = row.myWins ? accentColor : cs.onSurface;
    final friendColor = row.friendWins ? Colors.deepPurpleAccent : cs.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Mi valor
          Expanded(
            child: Text(
              row.myValue,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 15,
                fontWeight: row.myWins ? FontWeight.w800 : FontWeight.w500,
                color: myColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Label centrada
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              row.label,
              style: TextStyle(
                fontSize: 11,
                color: cs.onSurface.withOpacity(0.5),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Valor del amigo
          Expanded(
            child: Text(
              row.friendValue,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 15,
                fontWeight: row.friendWins ? FontWeight.w800 : FontWeight.w500,
                color: friendColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Lista de chips de artistas
// ---------------------------------------------------------------------------

class _ArtistChipsList extends StatelessWidget {
  final List<String> artists;
  final Color color;
  final ColorScheme cs;

  const _ArtistChipsList({
    required this.artists,
    required this.color,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: artists.map((artist) {
        return Chip(
          label: Text(
            artist,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: color.withOpacity(0.1),
          side: BorderSide(color: color.withOpacity(0.3)),
          padding: const EdgeInsets.symmetric(horizontal: 4),
        );
      }).toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Título de sección
// ---------------------------------------------------------------------------

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? color;

  const _SectionTitle({
    required this.title,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.onSurface.withOpacity(0.54);
    return Row(
      children: [
        Icon(icon, color: c, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: c,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ],
    );
  }
}
