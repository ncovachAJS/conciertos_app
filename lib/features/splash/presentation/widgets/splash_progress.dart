import 'package:flutter/material.dart';

class SplashProgress extends StatelessWidget {
  final double progress;

  const SplashProgress({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: LinearProgressIndicator(
          value: progress,
          minHeight: 6,
          backgroundColor: Colors.white24,
          valueColor: const AlwaysStoppedAnimation(Color(0xFFFFB300)),
        ),
      ),
    );
  }
}
