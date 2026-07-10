import 'dart:typed_data';

import 'package:flutter/material.dart';

class PhotoThumbnail extends StatelessWidget {
  const PhotoThumbnail({
    super.key,
    required this.image,
    this.onTap,
    this.borderRadius = 12,
  });

  final ImageProvider image;
  final VoidCallback? onTap;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Image(image: image, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
