import 'package:flutter/material.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/app_page.dart';
import '../../data/models/concert_photo_model.dart';
import '../../data/services/photo_api_service.dart';
import '../widgets/network_photo.dart';
import 'photo_viewer_page.dart';

import 'package:collection/collection.dart';

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
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => PhotoViewerPage(photo: photo)));
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Recuerdos',
      actions: [
        if (!_loading && _photos.isNotEmpty)
          IconButton(
            tooltip: _gridView ? 'Ver en lista' : 'Ver en cuadrícula',
            icon: Icon(
              _gridView ? Icons.view_agenda_outlined : Icons.grid_view,
            ),
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
        Icon(Icons.photo_library_outlined, size: 80, color: Colors.white24),
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
    final grouped = groupBy<ConcertPhotoModel, int>(
      _photos,
      (photo) => photo.concert?.date.year ?? 0,
    );

    final years = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: years.length,
      itemBuilder: (context, index) {
        final year = years[index];
        final photos = grouped[year]!;

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                year == 0 ? 'Sin fecha' : year.toString(),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              if (_gridView)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: photos.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, i) {
                    final photo = photos[i];

                    return GestureDetector(
                      onTap: () => _openPhoto(photo),
                      child: Hero(
                        tag: photo.id,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: NetworkPhoto(
                            url: photo.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                )
              else
                Column(
                  children: photos
                      .map(
                        (photo) => Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: _FeedPost(photo: photo),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        );
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
              MaterialPageRoute(builder: (_) => PhotoViewerPage(photo: photo)),
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
            child: Text(photo.caption, style: const TextStyle(fontSize: 15)),
          ),
      ],
    );
  }
}
