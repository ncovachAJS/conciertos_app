import 'package:flutter/material.dart';

import '../../features/concerts/domain/entities/concert.dart';

class ConcertCardV2 extends StatelessWidget {
  final Concert concert;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ConcertCardV2({
    super.key,
    required this.concert,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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

    Widget _infoRow(IconData icon, String title, String value) {
      return Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white70, size: 20),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
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
          child: Icon(
            Icons.music_note_rounded,
            size: 90,
            color: Colors.white24,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Material(
        color: const Color(0xff181A20),
        elevation: 10,
        borderRadius: BorderRadius.circular(28),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //=========================
              // IMAGEN
              //=========================
              SizedBox(
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

                    // if (concert.liked)
                    //   Positioned(
                    //     top: 18,
                    //     right: 18,
                    //     child: Container(
                    //       width: 50,
                    //       height: 50,
                    //       decoration: BoxDecoration(
                    //         color: Colors.blue,
                    //         borderRadius: BorderRadius.circular(25),
                    //       ),
                    //       child: const Icon(
                    //         Icons.thumb_up,
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //   ),
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
                            final filled = index < concert.rating;

                            return Icon(
                              filled
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              color: Colors.amber,
                              size: 24,
                            );
                          }),
                        ),

                        const Spacer(),

                        if (concert.liked)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(.15),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.thumb_up,
                                  size: 16,
                                  color: Colors.green,
                                ),

                                SizedBox(width: 6),

                                Text(
                                  'Recomendado',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    const Divider(color: Colors.white12),

                    const SizedBox(height: 20),

                    // _infoRow(
                    //   Icons.calendar_today_rounded,
                    //   'Fecha',
                    //   '${concert.date.day}/${concert.date.month}/${concert.date.year}',
                    // ),

                    // const SizedBox(height: 14),

                    // _infoRow(Icons.stadium_rounded, 'Recinto', concert.venue),

                    // const SizedBox(height: 14),

                    // _infoRow(Icons.location_on_rounded, 'Ciudad', concert.city),

                    // const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: onEdit,
                            icon: const Icon(Icons.edit),
                            label: const Text('Editar'),
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(52),
                              backgroundColor: Colors.blueGrey.shade700,
                            ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: FilledButton.icon(
                            onPressed: onDelete,
                            icon: const Icon(Icons.delete),
                            label: const Text('Eliminar'),
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(52),
                              backgroundColor: Colors.red.shade700,
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
      ),
    );
  }
}
