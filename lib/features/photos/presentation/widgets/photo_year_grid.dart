import 'package:flutter/material.dart';

import '../../data/models/concert_photo_model.dart';
import '../pages/photo_viewer_page.dart';
import 'network_photo.dart';

class PhotoYearGrid extends StatelessWidget {
  final int year;
  final List<ConcertPhotoModel> photos;

  const PhotoYearGrid({super.key, required this.year, required this.photos});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            year == 0 ? 'Sin fecha' : year.toString(),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: photos.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final photo = photos[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PhotoViewerPage(photo: photo),
                    ),
                  );
                },
                child: Hero(
                  tag: photo.id,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black,
                    clipBehavior: Clip.hardEdge,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      clipBehavior: Clip.hardEdge,
                      child: Image.network(photo.imageUrl),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
