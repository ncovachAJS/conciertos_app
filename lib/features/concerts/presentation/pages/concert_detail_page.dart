import 'package:share_plus/share_plus.dart';
import 'package:conciertos_app/features/spotify/domain/entities/data/services/spotify_api_service.dart';
import 'package:flutter/material.dart';
import '../../../../core/tutorial/tutorial_service.dart';
import '../../../../core/tutorial/tutorial_overlay.dart';
import '../../../../core/tutorial/tutorial_content.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/app_page.dart';
import '../../../concerts/presentation/providers/concerts_provider.dart';
import '../../../photos/presentation/widgets/memories_section.dart';
import '../../../setlist/data/services/setlist_service.dart';
import '../../../setlist/domain/entities/setlist.dart';
import '../../../setlist/presentation/widgets/setlist_section.dart';
import '../../../spotify/domain/entities/spotify_artist.dart';
import '../../domain/entities/concert.dart';
import '../../../concerts/data/models/concert_model.dart';

class ConcertDetailPage extends ConsumerStatefulWidget {
  final Concert concert;

  const ConcertDetailPage({super.key, required this.concert});

  @override
  ConsumerState<ConcertDetailPage> createState() => _ConcertDetailPageState();
}

class _ConcertDetailPageState extends ConsumerState<ConcertDetailPage> {
  final SetlistService _setlistService = SetlistService();
  final SpotifyApiService _spotifyService = SpotifyApiService();

  Setlist? _setlist;
  SpotifyArtist? _spotifyArtist;

  bool _loadingSetlist = true;
  bool _loadingSpotify = true;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    _loadSetlist();
    _loadSpotify();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) _showTutorialIfNeeded();
    });
  }

  Future<void> _showTutorialIfNeeded() async {
    final should = await TutorialService.shouldShow(TutorialService.detail);
    if (!should || !mounted) return;
    await TutorialService.markShown(TutorialService.detail);
    if (!mounted) return;
    await TutorialOverlay.show(context, steps: TutorialContent.concertDetail);
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

  Future<void> _searchSpotify(String query) async {
    if (query.trim().isEmpty) return;
    setState(() => _loadingSpotify = true);
    try {
      final artist = await _spotifyService.searchArtist(query.trim());
      if (mounted) setState(() => _spotifyArtist = artist);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se encontró el artista: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingSpotify = false);
    }
  }

  Future<void> _showSpotifySearch() async {
    final controller = TextEditingController(text: widget.concert.artist);
    final query = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Buscar artista en Spotify'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Nombre del artista...',
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('Buscar'),
          ),
        ],
      ),
    );
    if (query != null && mounted) await _searchSpotify(query);
  }

  void _share(Concert concert) {
    final lines = <String>[
      '🎸 ${concert.artist}',
      if (concert.name.isNotEmpty && concert.name != concert.artist)
        concert.name,
      '📅 ${DateFormatter.short(concert.date)}',
      if (concert.venue.isNotEmpty) '📍 ${concert.venue}',
      if (concert.city.isNotEmpty) '🏙 ${concert.city}',
      if (concert.festival.isNotEmpty) '🎪 ${concert.festival}',
      if (concert.rating > 0) '${'⭐' * concert.rating}',
      '',
      'Compartido desde La Vida en Directo 🎶',
    ];
    Share.share(lines.join('\n'));
  }

  Future<void> _edit(Concert concert) async {
    final result = await context.push('/add', extra: concert);
    if (result == true && mounted) {
      await ref.read(concertsProvider.notifier).reload();
    }
  }

  Future<void> _delete(Concert concert) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar concierto'),
        content: Text(
          '¿Seguro que quieres eliminar "${concert.name}"?\nEsta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    setState(() => _deleting = true);

    try {
      await ref.read(concertsProvider.notifier).delete(widget.concert.id);
      if (!mounted) return;
      context.pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _deleting = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No se pudo eliminar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos el concert desde el provider para que se actualice automáticamente
    final concerts = ref.watch(concertsProvider).asData?.value ?? [];
    final concert = concerts.firstWhere(
      (c) => c.id == widget.concert.id,
      orElse: () => widget.concert as ConcertModel,
    );

    if (_deleting) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Eliminando...'),
            ],
          ),
        ),
      );
    }

    return AppPage(
      title: concert.artist,
      showBackButton: true,
      actions: [
        IconButton(
          tooltip: 'Compartir',
          onPressed: () => _share(concert),
          icon: const Icon(Icons.share_outlined),
        ),
        IconButton(
          tooltip: 'Editar',
          onPressed: () => _edit(concert),
          icon: const Icon(Icons.edit_outlined),
        ),
        IconButton(
          tooltip: 'Eliminar',
          onPressed: () => _delete(concert),
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
        ),
      ],
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Imagen del concierto
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                concert.imageUrl,
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
                  subtitle: Text(DateFormatter.short(concert.date)),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.stadium),
                  title: const Text('Recinto'),
                  subtitle: Text(concert.venue),
                ),
                if (concert.city.isNotEmpty) ...[
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.location_city),
                    title: const Text('Ciudad'),
                    subtitle: Text(concert.city),
                  ),
                ],
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.music_note),
                  title: const Text('Concierto'),
                  subtitle: Text(concert.name),
                ),
              ],
            ),
          ),

          // Card de Spotify
          if (!_loadingSpotify && _spotifyArtist != null) ...[
            const SizedBox(height: 20),
            _SpotifyCard(artist: _spotifyArtist!),
          ],

          const SizedBox(height: 24),

          // Fotos / recuerdos
          MemoriesSection(concertId: widget.concert.id),

          const SizedBox(height: 24),

          // Setlist
          if (concert.isPastConcert)
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
