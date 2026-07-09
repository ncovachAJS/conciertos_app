import 'package:flutter/material.dart';

/// Imagen de red con loader de progreso mientras descarga y fade-in al aparecer.
/// Se usa en la galería de recuerdos y en el feed.
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
    return Image.network(
      url,
      fit: fit,
      loadingBuilder: (context, child, progress) {
        final loaded = progress == null;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeOut,
          child: loaded
              ? child
              : Container(
                  key: const ValueKey('loader'),
                  color: const Color(0xFF2B2B2B),
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: loaderSize,
                    height: loaderSize,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: progress.expectedTotalBytes != null
                          ? progress.cumulativeBytesLoaded /
                              progress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                ),
        );
      },
      errorBuilder: (context, error, stackTrace) => Container(
        color: const Color(0xFF2B2B2B),
        alignment: Alignment.center,
        child: Icon(
          Icons.broken_image_outlined,
          color: Colors.white24,
          size: errorIconSize,
        ),
      ),
    );
  }
}
