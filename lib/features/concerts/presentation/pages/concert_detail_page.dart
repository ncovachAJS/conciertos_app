import 'package:flutter/material.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/app_page.dart';
import '../../domain/entities/concert.dart';

import '../../../setlist/data/services/setlist_service.dart';
import '../../../setlist/domain/entities/setlist.dart';

class ConcertDetailPage extends StatefulWidget {
  final Concert concert;

  const ConcertDetailPage({super.key, required this.concert});

  @override
  State<ConcertDetailPage> createState() => _ConcertDetailPageState();
}

class _ConcertDetailPageState extends State<ConcertDetailPage> {
  final SetlistService _setlistService = SetlistService();

  Setlist? setlist;

  bool loadingSetlist = true;

  bool showFullSetlist = false;

  @override
  void initState() {
    super.initState();
    _loadSetlist();
  }

  Future<void> _loadSetlist() async {
    try {
      setlist = await _setlistService.searchSetlist(
        artist: widget.concert.artist,
        date: widget.concert.date,
        city: widget.concert.city,
        venue: widget.concert.venue,
      );
    } catch (e) {
      debugPrint(e.toString());
    }

    if (mounted) {
      setState(() {
        loadingSetlist = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: '🎸 ${widget.concert.artist}',
      showBackButton: true,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                widget.concert.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(
                    color: const Color(0xFF2B2B2B),
                    child: const Icon(
                      Icons.music_note,
                      color: Colors.white24,
                      size: 80,
                    ),
                  );
                },
              ),
            ),
          ),

          // const SizedBox(height: 24),

          // Text(
          //   widget.concert.artist,
          //   style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          // ),
          // Text(
          //   widget.concert.festival,
          //   style: const TextStyle(color: Colors.white70, fontSize: 18),
          // ),
          const SizedBox(height: 30),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Fecha'),
                  subtitle: Text(DateFormatter.short(widget.concert.date)),
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.stadium),
                  title: const Text('Recinto'),
                  subtitle: Text(widget.concert.venue),
                ),

                if (widget.concert.city.isNotEmpty) ...[
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.location_city),
                    title: const Text('Ciudad'),
                    subtitle: Text(widget.concert.city),
                  ),
                ],

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.music_note),
                  title: const Text('Concierto'),
                  subtitle: Text(widget.concert.name),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.queue_music, color: Colors.redAccent),
                      SizedBox(width: 10),
                      Text(
                        'Setlist',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  if (loadingSetlist)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (setlist == null)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'No se encontró ningún setlist para este concierto.',
                        style: TextStyle(color: Colors.white70, fontSize: 15),
                      ),
                    )
                  else ...[
                    Text(
                      '${setlist!.venue} · ${setlist!.city}',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Builder(
                      builder: (context) {
                        final songsToShow = showFullSetlist
                            ? setlist!.songs
                            : setlist!.songs.take(10).toList();

                        return Column(
                          children: [
                            ...List.generate(songsToShow.length, (index) {
                              final song = songsToShow[index];

                              return ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: const Color(0xFFE53935),
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                title: Text(song.name),
                              );
                            }),

                            if (setlist!.songs.length > 10)
                              TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    showFullSetlist = !showFullSetlist;
                                  });
                                },
                                icon: Icon(
                                  showFullSetlist
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                ),
                                label: Text(
                                  showFullSetlist
                                      ? 'Ver menos'
                                      : 'Ver las ${setlist!.songs.length - 10} canciones restantes',
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
