import 'package:flutter/material.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/app_page.dart';
import '../../data/models/concert_photo_model.dart';
import '../../data/services/photo_api_service.dart';
import '../widgets/network_photo.dart';
import 'photo_viewer_page.dart';

/// Feed global tipo Instagram con todas las fotos de recuerdo de los conciertos.
class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final PhotoApiService _service = PhotoApiService();

  List<ConcertPhotoModel> _photos = [];
  bool _loading = true;
  bool _gridView = true;

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

  void _openPhoto(ConcertPhotoModel photo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PhotoViewerPage(photo: photo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Recuerdos',
      actions: [
        if (!_loading && _photos.isNotEmpty)
          IconButton(
            tooltip: _gridView ? 'Ver en lista' : 'Ver en cuadrícula',
            icon: Icon(_gridView ? Icons.view_agenda_outlined : Icons.grid_view),
            onPressed: () => setState(() => _gridView = !_gridView),
          ),
      ],
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: _photos.isEmpty ? _buildEmpty() : _buildContent(),
            ),
    );
  }

  Widget _buildEmpty() {
    return ListView(
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
    );
  }

  Widget _buildContent() {
    if (_gridView) {
      return GridView.builder(
        itemCount: _photos.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
        ),
        itemBuilder: (context, index) {
          final photo = _photos[index];

          return GestureDetector(
            onTap: () => _openPhoto(photo),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: NetworkPhoto(url: photo.imageUrl),
            ),
          );
        },
      );
    }

    return ListView.separated(
      itemCount: _photos.length,
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        return _FeedPost(photo: _photos[index]);
      },
    );
  }
}

class _FeedPost extends StatelessWidget {
  final ConcertPhotoModel photo;

  const _FeedPost({required this.photo});

  @override
  Widget build(BuildContext context) {
    final concert = photo.concert;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (concert != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFF262A33),
                  child: Icon(Icons.music_note, color: Colors.white70),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        concert.artist,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        [
                          if (concert.festival.isNotEmpty) concert.festival,
                          if (concert.city.isNotEmpty) concert.city,
                          DateFormatter.short(concert.date),
                        ].join(' · '),
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PhotoViewerPage(photo: photo),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AspectRatio(
              aspectRatio: 1,
              child: NetworkPhoto(url: photo.imageUrl, errorIconSize: 60),
            ),
          ),
        ),

        if (photo.caption.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              photo.caption,
              style: const TextStyle(fontSize: 15),
            ),
          ),
      ],
    );
  }
}
