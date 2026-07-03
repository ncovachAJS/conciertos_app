import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_page.dart';
import '../../../concerts/data/services/concert_api_service.dart';
import '../../../concerts/domain/entities/concert.dart';
import '../../data/models/festival_model.dart';
import '../../data/festival_import_service.dart';

class ImportPage extends StatefulWidget {
  const ImportPage({super.key});

  @override
  State<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  final FestivalImportService _service = FestivalImportService();

  List<FestivalModel> festivals = [];

  bool loading = true;
  bool importing = false;

  int imported = 0;
  int totalConcerts = 0;
  String currentArtist = '';

  @override
  void initState() {
    super.initState();
    _loadFestivals();
  }

  Future<void> _loadFestivals() async {
    festivals = await _service.getFestivals();

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _importFestival(FestivalModel festival) async {
    try {
      final concerts = await _service.loadFestivalModel(festival);

      if (!mounted) return;

      final confirmar = await _showConcertPreview(
        title: '${festival.title} ${festival.year}',
        concerts: concerts,
      );

      if (confirmar != true) {
        return;
      }

      setState(() {
        importing = true;
      });

      await _saveConcerts(concerts);
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error importando: $e')));
    }
  }

  Future<bool?> _showConcertPreview({
    required String title,
    required List<Concert> concerts,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: 400,
            height: 350,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${concerts.length} conciertos encontrados',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: ListView.builder(
                    itemCount: concerts.length,
                    itemBuilder: (_, index) {
                      final concert = concerts[index];

                      return ListTile(
                        dense: true,
                        leading: const Icon(Icons.music_note),
                        title: Text(concert.artist),
                        subtitle: Text(
                          '${concert.date.day}/${concert.date.month}/${concert.date.year} '
                          '${concert.date.hour.toString().padLeft(2, '0')}:'
                          '${concert.date.minute.toString().padLeft(2, '0')}',
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Importar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveConcerts(List<Concert> concerts) async {
    try {
      totalConcerts = concerts.length;
      imported = 0;

      for (final concert in concerts) {
        if (mounted) {
          setState(() {
            currentArtist = concert.artist;
            imported++;
          });
        }

        await ConcertApiService().addConcert(concert);
      }

      if (!mounted) return;

      setState(() {
        importing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${concerts.length} conciertos importados correctamente',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        importing = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error importando: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Importar festivales',
      child: Stack(
        children: [
          loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: festivals.length,
                  itemBuilder: (context, index) {
                    return _festivalCard(festivals[index]);
                  },
                ),

          if (importing)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),

                    const SizedBox(height: 24),

                    const Text(
                      'Importando festival...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: 260,
                      child: LinearProgressIndicator(
                        value: totalConcerts == 0
                            ? 0
                            : imported / totalConcerts,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      '$imported / $totalConcerts conciertos',
                      style: const TextStyle(color: Colors.white70),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Procesando:',
                      style: TextStyle(color: Colors.white54),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      currentArtist,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _festivalCard(FestivalModel festival) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              festival.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              festival.year.toString(),
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () async {
                  await _importFestival(festival);
                },
                icon: const Icon(Icons.download),
                label: const Text('Importar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
