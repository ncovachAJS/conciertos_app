import 'package:flutter/material.dart';

import '../../data/services/setlist_service.dart';

class SetlistTestPage extends StatefulWidget {
  const SetlistTestPage({super.key});

  @override
  State<SetlistTestPage> createState() => _SetlistTestPageState();
}

class _SetlistTestPageState extends State<SetlistTestPage> {
  final service = SetlistService();

  String result = 'Pulsa el botón para buscar un setlist';

  bool loading = false;

  Future<void> search() async {
    setState(() {
      loading = true;
    });

    try {
      final setlist = await service.searchSetlist(
        artist: 'Metallica',
        date: DateTime(2024, 7, 14),
        city: 'Madrid',
      );

      if (setlist == null) {
        result = 'No se encontró ningún setlist.';
      } else {
        result =
            '''
Artista: ${setlist.artist}

Recinto: ${setlist.venue}

Ciudad: ${setlist.city}

Canciones:

${setlist.songs.map((e) => "• ${e.name}").join("\n")}
''';
      }
    } catch (e) {
      result = e.toString();
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prueba Setlist.fm')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: loading ? null : search,
              child: const Text('Buscar Setlist'),
            ),

            const SizedBox(height: 20),

            Expanded(child: SingleChildScrollView(child: Text(result))),
          ],
        ),
      ),
    );
  }
}
