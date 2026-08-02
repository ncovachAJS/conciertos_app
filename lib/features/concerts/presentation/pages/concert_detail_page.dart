import 'dart:io';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:conciertos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:conciertos_app/features/friends/presentation/widgets/friend_avatar.dart';
import 'package:flutter/material.dart';
import '../../../../core/tutorial/tutorial_service.dart';
import '../../../../core/tutorial/tutorial_overlay.dart';
import '../../../../core/tutorial/tutorial_content.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/app_page.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../concerts/presentation/providers/concerts_provider.dart';
import '../../../concerts/data/models/concert_model.dart';
import '../../../photos/presentation/widgets/memories_section.dart';
import '../widgets/venue_map_card.dart';
import '../../../setlist/data/services/setlist_service.dart';
import '../../../setlist/domain/entities/setlist.dart';
import '../../../setlist/presentation/widgets/setlist_section.dart';
import '../../../spotify/domain/entities/data/services/spotify_api_service.dart';
import '../../../spotify/domain/entities/spotify_artist.dart';
import '../../domain/entities/concert.dart';

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
    await TutorialOverlay.show(context, steps: TutorialContent.concertDetail(AppLocalizations.of(context)));
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
          SnackBar(content: Text(AppLocalizations.of(context).artistNotFound('$e'))),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingSpotify = false);
    }
  }

  Future<void> _showSpotifySearch() async {
    final l = AppLocalizations.of(context);
    final controller = TextEditingController(text: widget.concert.artist);
    final query = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.searchArtistSpotify),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l.artistNameHint,
            prefixIcon: const Icon(Icons.search),
          ),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: Text(l.search),
          ),
        ],
      ),
    );
    if (query != null && mounted) await _searchSpotify(query);
  }

  void _openImage(BuildContext context, String url) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (_, __, ___) => _FullscreenImageViewer(url: url),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  Future<void> _shareCard(Concert concert) async {
    final cardKey = GlobalKey();
    if (!mounted) return;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ShareBottomSheet(concert: concert, cardKey: cardKey),
    );
  }

  Future<void> _edit(Concert concert) async {
    final result = await context.push('/add', extra: concert);
    if (result == true && mounted) {
      await ref.read(concertsProvider.notifier).reload();
    }
  }

  Future<void> _delete(Concert concert) async {
    final l = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.deleteConcert),
        content: Text(l.deleteConcertConfirm(concert.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.delete),
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
      ).showSnackBar(SnackBar(content: Text(l.concertDeleteError('$e'))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    // Obtenemos el concert desde el provider para que se actualice automáticamente
    final concerts = ref.watch(concertsProvider).asData?.value ?? [];
    final concert = concerts.firstWhere(
      (c) => c.id == widget.concert.id,
      orElse: () => ConcertModel.fromEntity(widget.concert),
    );

    if (_deleting) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(l.deletingConcert),
            ],
          ),
        ),
      );
    }

    final currentUserId = AuthController.instance.user?.id ?? '';
    final isOwner = concert.userId == currentUserId;

    return AppPage(
      title: '🎸 ${concert.artist}',
      showBackButton: true,
      actions: [
        IconButton(
          tooltip: 'Compartir',
          onPressed: () => _shareCard(concert),
          icon: const Icon(Icons.ios_share_rounded),
        ),
        if (isOwner) ...[
          IconButton(
            tooltip: l.edit,
            onPressed: () => _edit(concert),
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: l.delete,
            onPressed: () => _delete(concert),
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          ),
        ],
      ],
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Imagen del concierto
          GestureDetector(
            onTap: concert.imageUrl.isNotEmpty
                ? () => _openImage(context, concert.imageUrl)
                : null,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: concert.imageUrl,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
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
          ),

          const SizedBox(height: 30),

          // Info del concierto
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(l.dateLabel),
                  subtitle: Text(DateFormatter.short(concert.date)),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.stadium),
                  title: Text(l.venueLabel),
                  subtitle: Text(concert.venue),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.push('/venue', extra: {
                    'venue': concert.venue,
                    'city': concert.city,
                  }),
                ),
                if (concert.price > 0) ...[
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.euro_rounded),
                    title: Text(concert.festival.isNotEmpty ? 'Precio del festival' : 'Precio de la entrada'),
                    subtitle: Text(
                      '${concert.price.toStringAsFixed(2)} €',
                    ),
                  ),
                ],
                if (concert.city.isNotEmpty) ...[
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.location_city),
                    title: Text(l.cityLabel),
                    subtitle: Text(concert.city),
                  ),
                ],
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.music_note),
                  title: Text(l.concertLabel),
                  subtitle: Text(concert.name),
                ),
              ],
            ),
          ),

          // Mapa de ubicación
          if (concert.venue.isNotEmpty || concert.city.isNotEmpty) ...[
            const SizedBox(height: 20),
            VenueMapCard(venue: concert.venue, city: concert.city),
          ],

          // Participantes
          if (concert.participants.isNotEmpty) ...[
            const SizedBox(height: 20),
            _ParticipantsCard(concert: concert),
          ],

          // Card de Spotify
          if (!_loadingSpotify && _spotifyArtist != null) ...[
            const SizedBox(height: 20),
            _SpotifyCard(
              artist: _spotifyArtist!,
              onSearchTap: _showSpotifySearch,
            ),
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
                  children: [
                    const Icon(Icons.queue_music, color: Colors.white38),
                    const SizedBox(width: 10),
                    Text(
                      l.setlistComingSoon,
                      style: const TextStyle(color: Colors.white54, fontSize: 15),
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
  final VoidCallback? onSearchTap;

  const _SpotifyCard({required this.artist, this.onSearchTap});

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
                child: CachedNetworkImage(
                  imageUrl: artist.image!,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => const _SpotifyPlaceholder(),
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
                      AppLocalizations.of(context).spotifyFollowers(_formatFollowers(artist.followers)),
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
              onPressed: onSearchTap,
              icon: const Icon(Icons.edit_outlined),
              tooltip: AppLocalizations.of(context).searchArtistSpotify,
            ),
            IconButton(
              onPressed: () async {
                await launchUrl(
                  Uri.parse(artist.url),
                  mode: LaunchMode.externalApplication,
                );
              },
              icon: const Icon(Icons.open_in_new),
              tooltip: AppLocalizations.of(context).openInSpotify,
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

// ---------------------------------------------------------------------------
// Visor de imagen a pantalla completa
// ---------------------------------------------------------------------------

class _FullscreenImageViewer extends StatelessWidget {
  final String url;
  const _FullscreenImageViewer({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 5.0,
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.contain,
            errorWidget: (_, __, ___) => const Icon(
              Icons.broken_image_outlined,
              color: Colors.white38,
              size: 64,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom sheet de compartir
// ---------------------------------------------------------------------------

class _ShareBottomSheet extends StatefulWidget {
  final Concert concert;
  final GlobalKey cardKey;

  const _ShareBottomSheet({required this.concert, required this.cardKey});

  @override
  State<_ShareBottomSheet> createState() => _ShareBottomSheetState();
}

class _ShareBottomSheetState extends State<_ShareBottomSheet> {
  bool _sharing = false;

  Future<void> _capture() async {
    setState(() => _sharing = true);
    try {
      await Future.delayed(const Duration(milliseconds: 80));
      final boundary = widget.cardKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;
      final bytes = byteData.buffer.asUint8List();
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/concierto_${widget.concert.id}.png');
      await file.writeAsBytes(bytes);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text:
              '${widget.concert.artist} · ${DateFormat('d MMM yyyy', 'es').format(widget.concert.date)}',
        ),
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: cs.onSurface.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            // Previsualización de la tarjeta
            RepaintBoundary(
              key: widget.cardKey,
              child: _ConcertShareCard(concert: widget.concert),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FilledButton.icon(
                onPressed: _sharing ? null : _capture,
                icon: _sharing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.ios_share_rounded),
                label: Text(_sharing ? 'Preparando...' : 'Compartir'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  backgroundColor: const Color(0xFFE53935),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tarjeta visual del concierto
// ---------------------------------------------------------------------------

class _ConcertShareCard extends StatelessWidget {
  final Concert concert;
  const _ConcertShareCard({required this.concert});

  @override
  Widget build(BuildContext context) {
    final hasImage = concert.imageUrl.isNotEmpty;
    final dateStr =
        DateFormat('d MMM yyyy', 'es').format(concert.date).toUpperCase();
    final location = [concert.venue, concert.city]
        .where((s) => s.isNotEmpty)
        .join(' · ');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF121212),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Imagen del concierto
          AspectRatio(
            aspectRatio: 1.0,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (hasImage)
                  CachedNetworkImage(
                    imageUrl: concert.imageUrl,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) =>
                        const _ShareCardPlaceholder(),
                  )
                else
                  const _ShareCardPlaceholder(),
                // Degradado inferior sobre la imagen
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          const Color(0xFF121212).withOpacity(0.5),
                          const Color(0xFF121212),
                        ],
                        stops: const [0.5, 0.8, 1.0],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Info
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Artista
                Text(
                  concert.artist.isNotEmpty ? concert.artist : concert.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (concert.artist.isNotEmpty &&
                    concert.name.isNotEmpty &&
                    concert.name != concert.artist) ...[
                  const SizedBox(height: 4),
                  Text(
                    concert.name,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 14),
                // Fecha
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 13,
                      color: Color(0xFFE53935),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      dateStr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                if (location.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: 13,
                        color: Color(0xFFE53935),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                if (concert.rating > 0) ...[
                  const SizedBox(height: 10),
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
                        size: 18,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                // Watermark
                Row(
                  children: const [
                    Icon(
                      Icons.music_note_rounded,
                      size: 14,
                      color: Color(0xFFE53935),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'LA VIDA EN DIRECTO',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareCardPlaceholder extends StatelessWidget {
  const _ShareCardPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF2B2B2B),
      child: const Center(
        child: Icon(Icons.music_note_rounded, color: Colors.white12, size: 80),
      ),
    );
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

// ---------------------------------------------------------------------------
// Sección de participantes
// ---------------------------------------------------------------------------

class _ParticipantsCard extends StatelessWidget {
  final Concert concert;
  const _ParticipantsCard({required this.concert});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final label = concert.isPastConcert ? l.participantsAlsoWere : l.participantsAlsoGoing;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.group_rounded,
                  color: Color(0xFFE53935),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: concert.participants.map((p) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FriendAvatar(
                      name: p.name,
                      avatarUrl: p.avatarUrl,
                      radius: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      p.name.split(' ').first, // solo el primer nombre
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
