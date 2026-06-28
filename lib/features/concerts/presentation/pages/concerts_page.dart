import 'package:flutter/material.dart';

class ConcertsPage extends StatelessWidget {
  const ConcertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('🎸 Conciertos', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
