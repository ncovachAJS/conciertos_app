import 'package:conciertos_app/features/spotify/domain/entities/data/services/spotify_api_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/app_page.dart';
import '../../../photos/presentation/widgets/memories_section.dart';
import '../../../setlist/data/services/setlist_service.dart';
import '../../../setlist/domain/entities/setlist.dart';
import '../../../setlist/presentation/widgets/setlist_section.dart';
import '../../../spotify/domain/entities/spotify_artist.dart';
import '../../domain/entities/concert.dart';

class ConcertDetailPage extends StatefulWidget {
  final Concert concert;

  const ConcertDetailPage({super.key, required this.concert});

  @override
  State<ConcertDetailPage> createState() => _ConcertDetailPageState();
}

class _ConcertDetailPageState extends State<ConcertDetailPage> {
  final SetlistService _setlistService = SetlistService();
  final SpotifyApiService _spotifyService = SpotifyApiService();

  Setlist? _setlist;
  SpotifyArtist? _spotifyArtist;

  bool _loadingSetlist = true;
  bool _loadingSpotify = true;

  @override
  void initState() {
    super.initState();
    _loadSetlist();
    _loadSpotify();
  }

  Future<void> _loadSetlist() async {
    if (!widget.concert.isPastConcert) {
      setState(() => _loadingSetlist = false);
      return;
    }
    try {
      _setlist = await _setlistService.searchSetlist(
        artist: widget.concert.artist,
        date: widget.concert.date,
        city: widget.concert.city,
        venue: widget.concert.venue,
      );
    } catch (e) {
      debugPrint('Setlist error: $e');
    } finally {
      if (mounted) setState(() => _loadingSetlist = false);
    }
  }

  Future<void> _loadSpotify() async {
    try {
      _spotifyArtist = await _spotifyService.searchArtist(
        widget.concert.artist,
      );
    } catch (e) {
      debugPrint('Spotify error: $e');
    } finally {
      if (mounted) setState(() => _loadingSpotify = false);
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
          // Imagen del concierto
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                widget.concert.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFF2B2B2B),
                  child: const Icon(
                    Icons.music_note,
                    color: Colors.white24,
                    size: 80,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Info del concierto
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

          // Card de Spotify con imagen + géneros + botón
          if (!_loadingSpotify && _spotifyArtist != null) ...[
            const SizedBox(height: 20),
            _SpotifyCard(artist: _spotifyArtist!),
          ],

          const SizedBox(height: 24),

          // Fotos / recuerdos
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: MemoriesSection(concertId: widget.concert.id),
            ),
          ),

          const SizedBox(height: 24),

          // Setlist
          if (widget.concert.isPastConcert)
            SetlistSection(loading: _loadingSetlist, setlist: _setlist)
          else
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: const [
                    Icon(Icons.queue_music, color: Colors.white38),
                    SizedBox(width: 10),
                    Text(
                      'El setlist estará disponible\ntras el concierto.',
                      style: TextStyle(color: Colors.white54, fontSize: 15),
                    ),
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

// ---------------------------------------------------------------------------
// Card de Spotify
// ---------------------------------------------------------------------------

class _SpotifyCard extends StatelessWidget {
  final SpotifyArtist artist;

  const _SpotifyCard({required this.artist});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Imagen del artista
            if (artist.image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  artist.image!,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const _SpotifyPlaceholder(),
                ),
              )
            else
              const _SpotifyPlaceholder(),

            const SizedBox(width: 16),

            // Nombre + géneros
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artist.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (artist.genres.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      artist.genres.take(2).join(' · '),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                  if (artist.followers > 0) ...[
                    const SizedBox(height: 2),
                    Text(
                      '${_formatFollowers(artist.followers)} seguidores',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Botón Spotify
            IconButton(
              onPressed: () async {
                await launchUrl(
                  Uri.parse(artist.url),
                  mode: LaunchMode.externalApplication,
                );
              },
              icon: const Icon(Icons.open_in_new),
              tooltip: 'Abrir en Spotify',
            ),
          ],
        ),
      ),
    );
  }

  String _formatFollowers(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(0)}K';
    return '$n';
  }
}

class _SpotifyPlaceholder extends StatelessWidget {
  const _SpotifyPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFF1DB954).withOpacity(.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.music_note, color: Color(0xFF1DB954), size: 32),
    );
  }
}
