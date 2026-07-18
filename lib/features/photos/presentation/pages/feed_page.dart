import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_page.dart';
import '../../data/models/concert_photo_model.dart';
import '../../data/services/photo_api_service.dart';
import 'photo_viewer_page.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage>
    with AutomaticKeepAliveClientMixin {
  final PhotoApiService _service = PhotoApiService();
  List<ConcertPhotoModel> _photos = [];
  bool _loading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final photos = await _service.getFeed();
      if (!mounted) return;
      setState(() {
        _photos = photos;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  void _openPhoto(List<ConcertPhotoModel> groupPhotos, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            PhotoViewerPage(photos: groupPhotos, initialIndex: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_loading) {
      return const AppPage(
        title: 'Recuerdos',
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_photos.isEmpty) {
      return AppPage(
        title: 'Recuerdos',
        child: RefreshIndicator(
          onRefresh: _load,
          child: ListView(
            children: const [
              SizedBox(height: 120),
              Icon(
                Icons.photo_library_outlined,
                size: 80,
                color: Colors.white24,
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  'Aún no hay recuerdos.\nAñade fotos desde el detalle de un concierto.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white60, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Agrupamos por año
    final grouped = groupBy<ConcertPhotoModel, int>(
      _photos,
      (p) => p.concert?.date.year ?? 0,
    );
    final years = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    // Construimos lista plana de slivers — virtualización correcta en iOS
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _load,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // AppBar
            SliverAppBar(
              title: const Text('Recuerdos'),
              floating: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
            ),

            for (final year in years) ...[
              // Cabecera de año
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                  child: Text(
                    year == 0 ? 'Sin fecha' : '$year',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Grid del año — VIRTUALIZDO correctamente
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((_, j) {
                    final yearPhotos = grouped[year]!;
                    final photo = yearPhotos[j];
                    return GestureDetector(
                      onTap: () => _openPhoto(yearPhotos, j),
                      child: Hero(
                        tag: photo.id,
                        // CachedNetworkImageProvider usa el ImageCache de Flutter
                        // — sirve imágenes ya decodificadas sin parpadeo al volver
                        child: Image(
                          image: CachedNetworkImageProvider(
                            photo.imageUrl,
                            maxWidth: 400,
                          ),
                          fit: BoxFit.cover,
                          gaplessPlayback: true, // sin parpadeo al reconstruir
                          frameBuilder: (_, child, frame, wasSyncLoaded) {
                            // Si la imagen ya estaba en caché, la mostramos sin fade
                            if (wasSyncLoaded || frame != null) return child;
                            return Container(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                            );
                          },
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFF2B2B2B),
                            child: const Icon(
                              Icons.broken_image_outlined,
                              color: Colors.white24,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    );
                  }, childCount: grouped[year]!.length),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    childAspectRatio: 1,
                  ),
                ),
              ),
            ],

            // Padding final
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}
