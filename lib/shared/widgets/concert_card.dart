import 'package:flutter/material.dart';

import '../../features/concerts/domain/entities/concert.dart';

class ConcertCard extends StatelessWidget {
  final Concert concert;

  final VoidCallback? onImageTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onFavorite;
  final VoidCallback? onLike;
  final ValueChanged<int>? onRatingChanged;

  const ConcertCard({
    super.key,
    required this.concert,
    this.onImageTap,
    this.onEdit,
    this.onDelete,
    this.onFavorite,
    this.onLike,
    this.onRatingChanged,
  });

  Widget _chip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF262A33),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF303542), Color(0xFF171A22)],
        ),
      ),
      child: const Center(
        child: Icon(Icons.music_note_rounded, size: 90, color: Colors.white24),
      ),
    );
  }

  Widget _buildDateBadge() {
    const months = [
      '',
      'ENE',
      'FEB',
      'MAR',
      'ABR',
      'MAY',
      'JUN',
      'JUL',
      'AGO',
      'SEP',
      'OCT',
      'NOV',
      'DIC',
    ];

    return Container(
      width: 76,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Text(
            concert.date.day.toString(),
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            months[concert.date.month],
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            concert.date.year.toString(),
            style: const TextStyle(color: Colors.black54, fontSize: 11),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Material(
        color: const Color(0xff181A20),
        elevation: 10,
        borderRadius: BorderRadius.circular(28),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: onImageTap,
              child: SizedBox(
                height: 320,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    concert.imageUrl.isNotEmpty
                        ? Image.network(concert.imageUrl, fit: BoxFit.cover)
                        : _placeholder(),

                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromARGB(40, 0, 0, 0),
                            Colors.transparent,
                            Color.fromARGB(180, 0, 0, 0),
                          ],
                        ),
                      ),
                    ),

                    Positioned(top: 18, left: 18, child: _buildDateBadge()),

                    Positioned(
                      left: 22,
                      right: 22,
                      bottom: 22,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            concert.artist,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 34,
                              shadows: [
                                Shadow(blurRadius: 12, color: Colors.black),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            concert.festival,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      if (concert.venue.isNotEmpty)
                        _chip(Icons.stadium_rounded, concert.venue),

                      if (concert.city.isNotEmpty)
                        _chip(Icons.location_on_rounded, concert.city),
                    ],
                  ),

                  const SizedBox(height: 22),

                  const Divider(color: Colors.white12, height: 1),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          return GestureDetector(
                            onTap: () => onRatingChanged?.call(index + 1),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Icon(
                                index < concert.rating
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                color: concert.isPastConcert
                                    ? Colors.amber
                                    : Colors.grey,
                                size: 24,
                              ),
                            ),
                          );
                        }),
                      ),

                      const Spacer(),

                      IconButton(
                        onPressed: onLike,
                        icon: Icon(
                          concert.liked
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: concert.liked ? Colors.red : Colors.white70,
                        ),
                      ),

                      IconButton(
                        onPressed: onFavorite,
                        icon: Icon(
                          concert.favorite ? Icons.star : Icons.star_border,
                          color: concert.favorite
                              ? Colors.amber
                              : Colors.white70,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Divider(color: Colors.white12),

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: onEdit,
                          icon: const Icon(Icons.edit_rounded),
                          label: const Text('Editar'),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(54),
                            backgroundColor: Colors.blueGrey.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: FilledButton.icon(
                          onPressed: onDelete,
                          icon: const Icon(Icons.delete_rounded),
                          label: const Text('Eliminar'),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(54),
                            backgroundColor: Colors.red.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
