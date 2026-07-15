import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/app_page.dart';
import '../../../concerts/data/models/concert_model.dart';
import '../../../concerts/presentation/providers/concerts_provider.dart';
import '../../data/festival_import_service.dart';
import '../../data/models/festival_model.dart';
import '../../data/models/setlist_concert_model.dart';
import '../../data/services/artist_image_service.dart';
import '../../data/services/setlist_import_service.dart';

class ImportPage extends ConsumerStatefulWidget {
  const ImportPage({super.key});

  @override
  ConsumerState<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends ConsumerState<ImportPage> {
  // ── Tab ──────────────────────────────────────────────────────────────────
  int _tab = 0;

  // ── Artist search ────────────────────────────────────────────────────────
  final _searchController = TextEditingController();
  final _setlistService = SetlistImportService();
  final _imageService = ArtistImageService();

  List<SetlistConcertModel> _concerts = [];
  final Set<String> _selected = {};
  bool _searching = false;
  bool _importing = false;
  bool _hasMore = false;
  int _page = 1;
  int _total = 0;
  int _importedCount = 0;
  int _importTotal = 0;
  String _importingArtist = '';

  // ── Festivals ────────────────────────────────────────────────────────────
  final FestivalImportService _festivalService = FestivalImportService();
  List<FestivalModel> _festivals = [];
  bool _loadingFestivals = true;
  bool _importingFestival = false;
  int _festImported = 0;
  int _festTotal = 0;
  String _festArtist = '';

  @override
  void initState() {
    super.initState();
    _loadFestivals();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Artist methods ────────────────────────────────────────────────────────

  Future<void> _search({bool more = false}) async {
    final q = _searchController.text.trim();
    if (q.isEmpty) return;

    final nextPage = more ? _page + 1 : 1;

    setState(() {
      _searching = true;
      if (!more) {
        _concerts = [];
        _selected.clear();
        _page = 1;
        _total = 0;
      }
    });

    try {
      final r = await _setlistService.searchArtistConcerts(q, page: nextPage);
      if (!mounted) return;
      setState(() {
        _concerts = more ? [..._concerts, ...r.concerts] : r.concerts;
        _total = r.total;
        _page = r.page;
        _hasMore = _concerts.length < _total && r.concerts.isNotEmpty;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  Future<void> _importSelected() async {
    if (_selected.isEmpty) return;
    final toImport = _concerts.where((c) => _selected.contains(c.id)).toList();

    setState(() {
      _importing = true;
      _importTotal = toImport.length;
      _importedCount = 0;
    });

    try {
      final img = await _imageService.getImage(toImport.first.artist) ?? '';
      for (final c in toImport) {
        if (!mounted) return;
        setState(() {
          _importingArtist = '${c.venue} · ${c.city}';
          _importedCount++;
        });
        await ref
            .read(concertsProvider.notifier)
            .add(
              ConcertModel(
                id: '',
                name: c.artist,
                artist: c.artist,
                festival: '',
                date: c.date,
                venue: c.venue,
                city: c.city,
                imageUrl: img,
                rating: 0,
                liked: false,
                favorite: false,
              ),
            );
      }
      if (!mounted) return;
      setState(() => _selected.clear());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${toImport.length} concierto${toImport.length > 1 ? "s" : ""} importado${toImport.length > 1 ? "s" : ""} 🎸',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  // ── Festival methods ──────────────────────────────────────────────────────

  Future<void> _loadFestivals() async {
    try {
      _festivals = await _festivalService.getFestivals();
    } catch (_) {}
    if (mounted) setState(() => _loadingFestivals = false);
  }

  Future<void> _importFestival(FestivalModel f) async {
    final concerts = await _festivalService.loadFestivalModel(f);
    if (!mounted) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${f.title} ${f.year}'),
        content: SizedBox(
          width: 400,
          height: 280,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${concerts.length} conciertos',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: concerts.length,
                  itemBuilder: (_, i) => ListTile(
                    dense: true,
                    leading: const Icon(Icons.music_note),
                    title: Text(concerts[i].artist),
                    subtitle: Text(
                      '${concerts[i].date.day}/${concerts[i].date.month}/${concerts[i].date.year}',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Importar'),
          ),
        ],
      ),
    );

    if (ok != true || !mounted) return;

    setState(() {
      _importingFestival = true;
      _festTotal = concerts.length;
      _festImported = 0;
    });

    try {
      for (final c in concerts) {
        if (!mounted) return;
        setState(() {
          _festArtist = c.artist;
          _festImported++;
        });
        await _festivalService.loadFestivalModel(
          FestivalModel(
            id: f.id,
            title: f.title,
            year: f.year,
            city: f.city,
            venue: f.venue,
            concerts: [
              {
                'artist': c.artist,
                'festival': c.festival,
                'name': c.name,
                'city': c.city,
                'venue': c.venue,
                'date': c.date.toIso8601String(),
                'imageUrl': c.imageUrl,
                'rating': c.rating,
                'liked': c.liked,
              },
            ],
          ),
        );
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${concerts.length} conciertos importados')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _importingFestival = false);
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Importar',
      child: Column(
        children: [
          // Tab switcher
          Row(
            children: [
              _TabBtn(
                label: 'Por artista',
                icon: Icons.person_search,
                selected: _tab == 0,
                onTap: () => setState(() => _tab = 0),
              ),
              _TabBtn(
                label: 'Festivales',
                icon: Icons.festival,
                selected: _tab == 1,
                onTap: () => setState(() => _tab = 1),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Controles del tab artista
          if (_tab == 0) ...[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Nombre del artista...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (_) => _search(),
                    textInputAction: TextInputAction.search,
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: _searching ? null : () => _search(),
                  child: const Text('Buscar'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_total > 0)
              Row(
                children: [
                  Text(
                    '$_total encontrados',
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                  const Spacer(),
                  if (_selected.isNotEmpty)
                    Text(
                      '${_selected.length} seleccionados',
                      style: const TextStyle(
                        color: Color(0xFFE53935),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                ],
              ),
            const SizedBox(height: 8),
          ],

          // Contenido principal (Expanded)
          Expanded(
            child: Stack(
              children: [
                if (_tab == 0) _buildArtistContent(),
                if (_tab == 1) _buildFestivalContent(),

                // Botón importar artista
                if (_tab == 0 && _selected.isNotEmpty && !_importing)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 8,
                    child: FilledButton.icon(
                      onPressed: _importSelected,
                      icon: const Icon(Icons.download_rounded),
                      label: Text(
                        'Importar ${_selected.length} concierto${_selected.length > 1 ? "s" : ""}',
                      ),
                    ),
                  ),

                // Overlay artista
                if (_importing)
                  _buildOverlay(_importedCount, _importTotal, _importingArtist),

                // Overlay festival
                if (_importingFestival)
                  _buildOverlay(_festImported, _festTotal, _festArtist),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArtistContent() {
    if (_searching && _concerts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_concerts.isEmpty) {
      return const Center(
        child: Text(
          'Busca un artista para ver sus conciertos.',
          style: TextStyle(color: Colors.white54, fontSize: 15),
          textAlign: TextAlign.center,
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: _concerts.length + (_hasMore ? 1 : 0),
      itemBuilder: (_, i) {
        if (i == _concerts.length) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: OutlinedButton(
              onPressed: _searching ? null : () => _search(more: true),
              child: const Text('Cargar más'),
            ),
          );
        }
        final c = _concerts[i];
        final sel = _selected.contains(c.id);
        return CheckboxListTile(
          value: sel,
          onChanged: (v) => setState(
            () => v == true ? _selected.add(c.id) : _selected.remove(c.id),
          ),
          title: Text(
            c.artist,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '${c.formattedDate}  ·  ${c.venue}, ${c.city}',
            style: const TextStyle(color: Colors.white60, fontSize: 13),
          ),
          secondary: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: c.isPast
                  ? const Color(0xFFE53935).withOpacity(.15)
                  : const Color(0xFF42A5F5).withOpacity(.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              c.isPast ? Icons.music_note : Icons.event,
              color: c.isPast
                  ? const Color(0xFFE53935)
                  : const Color(0xFF42A5F5),
              size: 18,
            ),
          ),
          activeColor: const Color(0xFFE53935),
        );
      },
    );
  }

  Widget _buildFestivalContent() {
    if (_loadingFestivals)
      return const Center(child: CircularProgressIndicator());
    if (_festivals.isEmpty) {
      return const Center(
        child: Text(
          'No hay festivales en assets/imports/festivals.json',
          style: TextStyle(color: Colors.white54),
          textAlign: TextAlign.center,
        ),
      );
    }
    return ListView.builder(
      itemCount: _festivals.length,
      itemBuilder: (_, i) {
        final f = _festivals[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  f.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${f.year}',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => _importFestival(f),
                    icon: const Icon(Icons.download),
                    label: const Text('Importar'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOverlay(int done, int total, String current) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            const Text(
              'Importando...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 260,
              child: LinearProgressIndicator(
                value: total == 0 ? 0 : done / total,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$done / $total',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              current,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tab button
// ---------------------------------------------------------------------------

class _TabBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TabBtn({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFFE53935) : Colors.white54;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: 2,
              color: selected ? const Color(0xFFE53935) : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
