import 'package:flutter/material.dart';

class SplashLoading extends StatelessWidget {
  final String message;

  const SplashLoading({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Text(
        message,
        key: ValueKey(message),
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
