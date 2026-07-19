import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
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

  final _shareKey = GlobalKey();

  Future<void> _share(Concert concert) async {
    // Renderizamos la tarjeta offscreen y la capturamos como PNG
    try {
      // Mostramos la tarjeta en un overlay invisible para poder capturarla
      final completer = OverlayEntry(
        builder: (_) => Positioned(
          left: -9999, // fuera de pantalla
          top: 0,
          child: RepaintBoundary(
            key: _shareKey,
            child: _ShareCard(concert: concert),
          ),
        ),
      );
      Overlay.of(context).insert(completer);

      // Esperamos un frame para que Flutter lo pinte
      await Future.delayed(const Duration(milliseconds: 100));

      final boundary =
          _shareKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      final image = await boundary?.toImage(pixelRatio: 3.0);
      completer.remove();

      if (image == null || !mounted) return;

      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/concierto_${concert.id}.png');
      await file.writeAsBytes(bytes);

      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'La Vida en Directo 🎶');
    } catch (e) {
      // Fallback a texto plano si algo falla
      final lines = [
        '🎸 ${concert.artist}',
        '📅 ${DateFormatter.short(concert.date)}',
        if (concert.venue.isNotEmpty) '📍 ${concert.venue}',
        if (concert.city.isNotEmpty) '🏙 ${concert.city}',
        if (concert.rating > 0) '${'⭐' * concert.rating}',
        '',
        'La Vida en Directo 🎶',
      ];
      Share.share(lines.join('\n'));
    }
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
// Tarjeta visual para compartir
// ---------------------------------------------------------------------------

class _ShareCard extends StatelessWidget {
  final Concert concert;

  const _ShareCard({required this.concert});

  @override
  Widget build(BuildContext context) {
    final hasRating = concert.rating > 0;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 380,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A1A), Color(0xFF2C1A1A), Color(0xFF1A1A1A)],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Color(0xFFE53935).withOpacity(0.4),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen de cabecera
            if (concert.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: Image.network(
                  concert.imageUrl,
                  width: 380,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: const Color(0xFF2B2B2B),
                    child: const Center(
                      child: Icon(
                        Icons.music_note,
                        color: Color(0xFFE53935),
                        size: 64,
                      ),
                    ),
                  ),
                ),
              ),

            // Franja roja con el artista
            Container(
              width: double.infinity,
              color: const Color(0xFFE53935),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                concert.artist,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Datos del concierto
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (concert.name.isNotEmpty && concert.name != concert.artist)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        concert.name,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),

                  _InfoRow(
                    Icons.calendar_today_rounded,
                    DateFormatter.short(concert.date),
                  ),
                  if (concert.venue.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _InfoRow(Icons.stadium_rounded, concert.venue),
                  ],
                  if (concert.city.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _InfoRow(Icons.location_city_rounded, concert.city),
                  ],
                  if (concert.festival.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _InfoRow(Icons.festival_rounded, concert.festival),
                  ],

                  if (hasRating) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < concert.rating
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: i < concert.rating
                              ? const Color(0xFFFFC107)
                              : Colors.white24,
                          size: 22,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Pie de marca
                  Row(
                    children: [
                      const Icon(
                        Icons.music_note,
                        color: Color(0xFFE53935),
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'La Vida en Directo',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.35),
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFE53935), size: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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
