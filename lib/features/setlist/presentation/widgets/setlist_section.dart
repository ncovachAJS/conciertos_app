import 'package:flutter/material.dart';

import '../../domain/entities/setlist.dart';
import '../../domain/entities/setlist_set.dart';
import '../../domain/entities/song.dart';

class SetlistSection extends StatefulWidget {
  final bool loading;
  final Setlist? setlist;

  const SetlistSection({
    super.key,
    required this.loading,
    required this.setlist,
  });

  @override
  State<SetlistSection> createState() => _SetlistSectionState();
}

class _SetlistSectionState extends State<SetlistSection> {
  bool _showAll = false;
  static const int _previewCount = 10;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.queue_music, color: Colors.redAccent),
                const SizedBox(width: 10),
                const Text(
                  'Setlist',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                if (widget.setlist != null) ...[
                  const Spacer(),
                  Text(
                    '${widget.setlist!.totalSongs} canciones',
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 20),

            if (widget.loading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (widget.setlist == null || widget.setlist!.sets.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'No se encontró ningún setlist para este concierto.',
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
              )
            else
              _SetlistContent(
                setlist: widget.setlist!,
                showAll: _showAll,
                previewCount: _previewCount,
                onToggle: () => setState(() => _showAll = !_showAll),
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _SetlistContent extends StatelessWidget {
  final Setlist setlist;
  final bool showAll;
  final int previewCount;
  final VoidCallback onToggle;

  const _SetlistContent({
    required this.setlist,
    required this.showAll,
    required this.previewCount,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final allSongs = setlist.allSongs;
    final hasMore = allSongs.length > previewCount;

    // Calculamos qué canciones mostrar por set.
    int remaining = showAll ? allSongs.length : previewCount;
    final setsToShow = <SetlistSet>[];

    for (final set in setlist.sets) {
      if (remaining <= 0) break;
      if (set.songs.isEmpty) continue;
      final songsToShow = set.songs.take(remaining).toList();
      setsToShow.add(SetlistSet(name: set.name, songs: songsToShow));
      remaining -= songsToShow.length;
    }

    // Construimos la lista de widgets imperativamente para poder
    // incrementar songNumber sin conflictos de tipo en los spreads.
    final widgets = <Widget>[
      Text(
        '${setlist.venue} · ${setlist.city}',
        style: const TextStyle(color: Colors.white60, fontSize: 14),
      ),
      const SizedBox(height: 18),
    ];

    int songNumber = 0;

    for (int i = 0; i < setsToShow.length; i++) {
      final set = setsToShow[i];

      if (set.isEncore) {
        widgets.add(_SetHeader(name: set.name!));
      }

      for (final song in set.songs) {
        songNumber++;
        widgets.add(_SongTile(number: songNumber, song: song));
      }

      if (i < setsToShow.length - 1) {
        widgets.add(const SizedBox(height: 8));
      }
    }

    if (hasMore) {
      widgets.add(
        TextButton.icon(
          onPressed: onToggle,
          icon: Icon(showAll ? Icons.expand_less : Icons.expand_more),
          label: Text(
            showAll
                ? 'Ver menos'
                : 'Ver las ${allSongs.length - previewCount} canciones restantes',
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}

// ---------------------------------------------------------------------------

class _SetHeader extends StatelessWidget {
  final String name;

  const _SetHeader({required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFE53935).withOpacity(.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE53935).withOpacity(.4)),
        ),
        child: Text(
          name.toUpperCase(),
          style: const TextStyle(
            color: Color(0xFFE53935),
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _SongTile extends StatelessWidget {
  final int number;
  final Song song;

  const _SongTile({required this.number, required this.song});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: song.isTape
                ? const Icon(
                    Icons.album_outlined,
                    size: 20,
                    color: Colors.white38,
                  )
                : Text(
                    '$number',
                    style: const TextStyle(
                      color: Color(0xFFE53935),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.name,
                  style: TextStyle(
                    fontSize: 15,
                    color: song.isTape ? Colors.white54 : Colors.white,
                    fontStyle: song.isTape
                        ? FontStyle.italic
                        : FontStyle.normal,
                  ),
                ),
                if (song.isCover)
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      'Versión de ${song.coverOf}',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ),
                if (song.hasGuest)
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          size: 13,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'con ${song.withArtist}',
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (song.info != null && song.info!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      song.info!,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
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
