import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Imagen de red con caché en disco — no recarga al hacer scroll.
/// Usa cached_network_image para persistir entre sesiones.
class NetworkPhoto extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double loaderSize;
  final double errorIconSize;

  /// Ancho máximo en memoria (px). Pasar null para no limitar.
  /// En thumbnails pequeños usar ~300; en viewer a pantalla completa usar null.
  final int? memCacheWidth;

  const NetworkPhoto({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.loaderSize = 22,
    this.errorIconSize = 24,
    this.memCacheWidth = 600,
  });

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return _error();

    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      memCacheWidth: memCacheWidth,
      placeholder: (context, url) => Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      errorWidget: (context, url, error) => _error(),
      // Sin fade para que las imágenes cacheadas aparezcan instantáneamente
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
    );
  }

  Widget _error() {
    return Container(
      color: const Color(0xFF2B2B2B),
      alignment: Alignment.center,
      child: Icon(
        Icons.broken_image_outlined,
        color: Colors.white24,
        size: errorIconSize,
      ),
    );
  }
}
