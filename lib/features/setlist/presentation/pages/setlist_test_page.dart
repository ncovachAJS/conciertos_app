import 'package:flutter/material.dart';

import '../../data/services/setlist_service.dart';
import '../../domain/entities/setlist.dart';

class SetlistTestPage extends StatefulWidget {
  const SetlistTestPage({super.key});

  @override
  State<SetlistTestPage> createState() => _SetlistTestPageState();
}

class _SetlistTestPageState extends State<SetlistTestPage> {
  final _service = SetlistService();

  Setlist? _setlist;
  String _error = '';
  bool _loading = false;

  Future<void> _search() async {
    setState(() {
      _loading = true;
      _error = '';
      _setlist = null;
    });

    try {
      _setlist = await _service.searchSetlist(
        artist: 'Metallica',
        date: DateTime(2024, 7, 14),
        city: 'Madrid',
      );
    } catch (e) {
      _error = e.toString();
    }

    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prueba Setlist.fm')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _loading ? null : _search,
              child: const Text('Buscar Setlist'),
            ),

            const SizedBox(height: 20),

            if (_loading)
              const CircularProgressIndicator()
            else if (_error.isNotEmpty)
              Text(_error, style: const TextStyle(color: Colors.redAccent))
            else if (_setlist == null)
              const Text('Pulsa el botón para buscar un setlist')
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Artista: ${_setlist!.artist}'),
                      Text('Recinto: ${_setlist!.venue}'),
                      Text('Ciudad: ${_setlist!.city}'),
                      Text('Total canciones: ${_setlist!.totalSongs}'),
                      const SizedBox(height: 16),

                      // Iteramos por sets (principal + encores)
                      for (final set in _setlist!.sets) ...[
                        Text(
                          set.isEncore ? '🎸 ${set.name}' : '🎵 Set principal',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        for (final song in set.songs)
                          Text(
                            '  • ${song.name}'
                            '${song.isTape ? ' 📼' : ''}'
                            '${song.isCover ? ' (versión de ${song.coverOf})' : ''}'
                            '${song.hasGuest ? ' con ${song.withArtist}' : ''}',
                          ),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
