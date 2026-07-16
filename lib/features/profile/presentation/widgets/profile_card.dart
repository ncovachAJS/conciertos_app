import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.totalConcerts,
    required this.totalFavorites,
    required this.totalPhotos,
    required this.level,
    required this.memberNumber,
    this.avatarUrl,
    this.onAvatarTap,
  });

  final String name;
  final String subtitle;
  final int totalConcerts;
  final int totalFavorites;
  final int totalPhotos;
  final String level;
  final int memberNumber;
  final String? avatarUrl;
  final VoidCallback? onAvatarTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE53935), Color(0xFF8E1B1B)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x55E53935),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),

          // Avatar — tappable para cambiar foto
          GestureDetector(
            onTap: onAvatarTap,
            child: Stack(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white38, width: 2),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: avatarUrl != null && avatarUrl!.isNotEmpty
                      ? Image.network(
                          avatarUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.person_outline,
                            color: Colors.white,
                            size: 48,
                          ),
                        )
                      : const Icon(
                          Icons.person_outline,
                          color: Colors.white,
                          size: 48,
                        ),
                ),

                // Icono de cámara
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFE53935),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 14,
                      color: Color(0xFFE53935),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontStyle: FontStyle.italic,
            ),
          ),

          const SizedBox(height: 24),

          const Divider(color: Colors.white24),

          const SizedBox(height: 8),

          Text(
            "MIEMBRO #${memberNumber.toString().padLeft(6, '0')}",
            style: TextStyle(
              color: Colors.white.withOpacity(.7),
              letterSpacing: 2,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _Stat(
                  icon: Icons.music_note,
                  value: totalConcerts.toString(),
                  label: 'Conciertos',
                ),
              ),
              Expanded(
                child: _Stat(
                  icon: Icons.star,
                  value: totalFavorites.toString(),
                  label: 'Favoritos',
                ),
              ),
              Expanded(
                child: _Stat(
                  icon: Icons.photo_camera,
                  value: totalPhotos.toString(),
                  label: 'Recuerdos',
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          Container(
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Text(
                "▌▌▌▌ ▌▌ ▌▌▌▌▌▌ ▌▌ ▌▌▌▌",
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.white70,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.value, required this.label});

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}
