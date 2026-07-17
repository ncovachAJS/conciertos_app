import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Imagen de red con caché en disco — no recarga al hacer scroll.
/// Usa cached_network_image para persistir entre sesiones.
class NetworkPhoto extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double loaderSize;
  final double errorIconSize;

  const NetworkPhoto({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.loaderSize = 22,
    this.errorIconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return _error();

    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      // Muestra placeholder mientras carga
      placeholder: (context, url) => Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        alignment: Alignment.center,
        child: SizedBox(
          width: loaderSize,
          height: loaderSize,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: const AlwaysStoppedAnimation(Color(0xFFE53935)),
          ),
        ),
      ),
      // Error
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
