import 'package:flutter/material.dart';

import '../../domain/entities/concert_photo.dart';
import '../widgets/network_photo.dart';

/// Visor a pantalla completa de una foto de recuerdo, con zoom, pie de foto
/// y opción de borrado. Devuelve `true` al hacer `pop` si la foto se eliminó.
class PhotoViewerPage extends StatelessWidget {
  final ConcertPhoto photo;
  final Future<void> Function()? onDelete;

  const PhotoViewerPage({
    super.key,
    required this.photo,
    this.onDelete,
  });

  Future<void> _confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar foto'),
        content: const Text('¿Seguro que quieres eliminar este recuerdo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await onDelete?.call();

    if (context.mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _confirmDelete(context),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              minScale: 0.8,
              maxScale: 4,
              child: Center(
                child: NetworkPhoto(
                  url: photo.imageUrl,
                  fit: BoxFit.contain,
                  loaderSize: 32,
                  errorIconSize: 80,
                ),
              ),
            ),
          ),
          if (photo.caption.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: Colors.black,
              child: Text(
                photo.caption,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }
}
