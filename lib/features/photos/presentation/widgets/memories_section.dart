import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../concerts/data/services/upload_service.dart';
import '../../data/models/concert_photo_model.dart';
import '../../data/services/photo_api_service.dart';
import '../pages/photo_viewer_page.dart';

/// Galería de fotos de recuerdo de un concierto: lista, añade (subiendo a
/// Cloudinary) y borra fotos.
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

  Future<void> _addPhoto() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image == null || !mounted) return;

    final caption = await _askCaption(File(image.path));

    // caption == null => el usuario canceló.
    if (caption == null || !mounted) return;

    setState(() => _uploading = true);

    try {
      final imageUrl = await _uploadService.uploadImage(image.path);

      final photo = await _photoService.addPhoto(
        concertId: widget.concertId,
        imageUrl: imageUrl,
        caption: caption,
      );

      if (!mounted) return;

      setState(() {
        _photos = [photo, ..._photos];
        _uploading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() => _uploading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo subir la foto. Inténtalo de nuevo.'),
        ),
      );
    }
  }

  Future<String?> _askCaption(File image) {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo recuerdo'),
        content: Column(
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Publicar'),
          ),
        ],
      ),
    );
  }

  Future<void> _openPhoto(ConcertPhotoModel photo) async {
    final deleted = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PhotoViewerPage(
          photo: photo,
          onDelete: () => _photoService.deletePhoto(photo.id),
        ),
      ),
    );

    if (deleted == true && mounted) {
      setState(() {
        _photos = _photos.where((p) => p.id != photo.id).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.photo_library_rounded, color: Colors.redAccent),
            const SizedBox(width: 10),
            const Text(
              'Recuerdos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: _uploading ? null : _addPhoto,
              icon: _uploading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.add_a_photo_outlined, size: 20),
              label: Text(_uploading ? 'Subiendo...' : 'Añadir'),
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
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              final photo = _photos[index];

              return GestureDetector(
                onTap: () => _openPhoto(photo),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    photo.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFF2B2B2B),
                      child: const Icon(
                        Icons.broken_image_outlined,
                        color: Colors.white24,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
