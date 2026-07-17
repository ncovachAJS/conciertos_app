import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../concerts/data/services/upload_service.dart';
import '../../data/models/concert_photo_model.dart';
import '../../data/services/photo_api_service.dart';
import '../pages/photo_viewer_page.dart';
import 'network_photo.dart';

class MemoriesSection extends StatefulWidget {
  final String concertId;

  const MemoriesSection({super.key, required this.concertId});

  @override
  State<MemoriesSection> createState() => _MemoriesSectionState();
}

class _MemoriesSectionState extends State<MemoriesSection> {
  final PhotoApiService _photoService = PhotoApiService();
  final UploadService _uploadService = UploadService();
  final ImagePicker _picker = ImagePicker();

  List<ConcertPhotoModel> _photos = [];
  bool _loading = true;
  bool _uploading = false;
  int _uploadCurrent = 0;
  int _uploadTotal = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final photos = await _photoService.getConcertPhotos(widget.concertId);
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

  Future<void> _addPhotos() async {
    // Selección múltiple
    final images = await _picker.pickMultiImage(imageQuality: 85);
    if (images.isEmpty || !mounted) return;

    // Si es una sola foto pedimos caption; si son varias, subimos directamente
    String? caption;
    if (images.length == 1) {
      caption = await _askCaption(File(images.first.path));
      if (caption == null || !mounted) return; // cancelado
    }

    setState(() {
      _uploading = true;
      _uploadCurrent = 0;
      _uploadTotal = images.length;
    });

    final newPhotos = <ConcertPhotoModel>[];

    for (final image in images) {
      if (!mounted) break;
      setState(() => _uploadCurrent++);

      try {
        final imageUrl = await _uploadService.uploadImage(image.path);
        final photo = await _photoService.addPhoto(
          concertId: widget.concertId,
          imageUrl: imageUrl,
          caption: caption ?? '',
        );
        newPhotos.add(photo);
      } catch (e) {
        if (!mounted) break;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al subir foto: $e')));
      }
    }

    if (!mounted) return;
    setState(() {
      _photos = [...newPhotos, ..._photos];
      _uploading = false;
      _uploadCurrent = 0;
      _uploadTotal = 0;
    });
  }

  Future<String?> _askCaption(File image) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nuevo recuerdo'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  image,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Pie de foto (opcional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Publicar'),
          ),
        ],
      ),
    );
  }

  Future<void> _openPhoto(ConcertPhotoModel photo) async {
    final index = _photos.indexOf(photo);
    final deleted = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PhotoViewerPage(
          photos: _photos,
          initialIndex: index,
          onDelete: (p) => _photoService.deletePhoto(p.id),
        ),
      ),
    );
    if (deleted == true && mounted) {
      setState(() => _photos = _photos.where((p) => p.id != photo.id).toList());
    }
  }

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
                const Icon(
                  Icons.photo_library_rounded,
                  color: Colors.redAccent,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Recuerdos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _uploading ? null : _addPhotos,
                  icon: _uploading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add_a_photo_outlined, size: 20),
                  label: Text(
                    _uploading
                        ? 'Subiendo $_uploadCurrent/$_uploadTotal...'
                        : 'Añadir',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_photos.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Todavía no hay recuerdos. ¡Añade tus fotos del concierto!',
                  style: TextStyle(color: Colors.white60, fontSize: 15),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _photos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  childAspectRatio: 1,
                ),
                itemBuilder: (_, index) {
                  final photo = _photos[index];
                  return GestureDetector(
                    onTap: () => _openPhoto(photo),
                    child: Hero(
                      tag: photo.id,
                      child: ClipRect(
                        child: SizedBox.expand(
                          child: Image.network(
                            photo.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
