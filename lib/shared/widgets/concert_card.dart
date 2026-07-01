import 'package:flutter/material.dart';

import '../../features/concerts/domain/entities/concert.dart';

class ConcertCard extends StatelessWidget {
  final Concert concert;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ConcertCard({
    super.key,
    required this.concert,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      elevation: 0,
      color: const Color(0xFF181A20),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //--------------------------------------------------
            // HERO IMAGE
            //--------------------------------------------------
            Stack(
              children: [
                SizedBox(
                  height: 280,
                  width: double.infinity,
                  child: concert.imageUrl.isNotEmpty
                      ? Image.network(
                          concert.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return _placeholder();
                          },
                        )
                      : _placeholder(),
                ),

                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(.10),

                          Colors.transparent,

                          Colors.black.withOpacity(.80),
                        ],
                      ),
                    ),
                  ),
                ),

                //------------------------------------------
                // FECHA
                //------------------------------------------
                Positioned(left: 18, top: 18, child: _buildDateBadge()),

                //------------------------------------------
                // LIKE
                //------------------------------------------
                if (concert.liked)
                  Positioned(
                    right: 18,
                    top: 18,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.45),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Icon(
                        Icons.thumb_up_alt_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),

                //------------------------------------------
                // ARTISTA SOBRE LA FOTO
                //------------------------------------------
                Positioned(
                  left: 22,
                  right: 22,
                  bottom: 22,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        concert.artist,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 30,
                          height: 1,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        concert.festival,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //------------------------------------------
                  // CHIPS
                  //------------------------------------------
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      if (concert.venue.isNotEmpty)
                        _buildChip(
                          icon: Icons.stadium_rounded,
                          text: concert.venue,
                        ),

                      if (concert.city.isNotEmpty)
                        _buildChip(
                          icon: Icons.location_on_rounded,
                          text: concert.city,
                        ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  //------------------------------------------
                  // VALORACIÓN
                  //------------------------------------------
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        final selected = index < concert.rating;

                        return Padding(
                          padding: const EdgeInsets.only(right: 2),
                          child: Icon(
                            selected
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: Colors.amber,
                            size: 22,
                          ),
                        );
                      }),

                      const Spacer(),

                      PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.more_vert_rounded,
                          color: Colors.white70,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        onSelected: (value) {
                          switch (value) {
                            case 'edit':
                              onEdit?.call();
                              break;

                            case 'delete':
                              onDelete?.call();
                              break;
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'edit', child: Text('Editar')),

                          PopupMenuItem(
                            value: 'delete',
                            child: Text('Eliminar'),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  //------------------------------------------
                  // FECHA COMPLETA
                  //------------------------------------------
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        size: 16,
                        color: Colors.white38,
                      ),

                      const SizedBox(width: 8),

                      Text(
                        '${concert.date.day}/${concert.date.month}/${concert.date.year}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
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

  Widget _buildChip({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFF252830),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white70),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
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
      width: 72,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.30),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            concert.date.day.toString(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              height: 1,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            months[concert.date.month],
            style: const TextStyle(
              color: Colors.redAccent,
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

  Widget _placeholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2B2E37), Color(0xFF121317)],
        ),
      ),
      child: const Center(
        child: Icon(Icons.music_note_rounded, color: Colors.white24, size: 90),
      ),
    );
  }
}
