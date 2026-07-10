import 'package:flutter/material.dart';

class SplashTitle extends StatelessWidget {
  const SplashTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(Icons.music_note, color: Colors.white, size: 70),

        SizedBox(height: 30),

        Text(
          'LA VIDA EN DIRECTO',
          style: TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),

        SizedBox(height: 12),

        Text(
          'Cada concierto cuenta una historia.',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ],
    );
  }
}
