import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/app_page.dart';
import '../../data/models/concert_photo_model.dart';
import '../../data/services/photo_api_service.dart';
import '../widgets/network_photo.dart';
import 'photo_viewer_page.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final PhotoApiService _service = PhotoApiService();
  List<ConcertPhotoModel> _photos = [];
  bool _loading = true;

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

      setState(() {
        _loading = false;
      });
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
    return AppPage(
      title: 'Recuerdos',
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: _photos.isEmpty ? _buildEmpty() : _buildGrid(),
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

  Widget _buildGrid() {
    final grouped = groupBy<ConcertPhotoModel, int>(
      _photos,
      (p) => p.concert?.date.year ?? 0,
    );
    final years = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: years.length,
      itemBuilder: (_, i) {
        final year = years[i];
        final yearPhotos = grouped[year]!;

        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                year == 0 ? 'Sin fecha' : '$year',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: yearPhotos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                  childAspectRatio: 1,
                ),
                itemBuilder: (_, j) {
                  final photo = yearPhotos[j];

                  return GestureDetector(
                    onTap: () => _openPhoto(yearPhotos, j),
                    child: Hero(
                      tag: photo.id,
                      child: NetworkPhoto(
                        url: photo.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
