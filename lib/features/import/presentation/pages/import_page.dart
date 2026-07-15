import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  int _tab = 0;

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

  final _festivalService = FestivalImportService();
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

  Future<void> _search({bool more = false}) async {
    final q = _searchController.text.trim();
    if (q.isEmpty) return;
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
      final r = await _setlistService.searchArtistConcerts(
        q,
        page: more ? _page + 1 : 1,
      );
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

  @override
  Widget build(BuildContext context) {
    debugPrint('BUILD CALLED tab=$_tab');

    final isArtist = _tab == 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Importar')),
      floatingActionButton: isArtist && _selected.isNotEmpty && !_importing
          ? FloatingActionButton.extended(
              onPressed: _importSelected,
              icon: const Icon(Icons.download_rounded),
              label: Text('Importar ${_selected.length}'),
            )
          : null,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // CustomScrollView — no necesita constraints de altura del padre
          CustomScrollView(
            slivers: [
              // Tab switcher
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton.icon(
                        onPressed: () => setState(() => _tab = 0),
                        icon: Icon(
                          Icons.person_search,
                          color: isArtist
                              ? const Color(0xFFE53935)
                              : Colors.white54,
                        ),
                        label: Text(
                          'Por artista',
                          style: TextStyle(
                            color: isArtist
                                ? const Color(0xFFE53935)
                                : Colors.white54,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => setState(() => _tab = 1),
                        icon: Icon(
                          Icons.festival,
                          color: !isArtist
                              ? const Color(0xFFE53935)
                              : Colors.white54,
                        ),
                        label: Text(
                          'Festivales',
                          style: TextStyle(
                            color: !isArtist
                                ? const Color(0xFFE53935)
                                : Colors.white54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: Divider(height: 1)),

              // Search bar (artist only)
              if (isArtist)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
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
                  ),
                ),

              // Counter (artist only)
              if (isArtist && _total > 0)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        Text(
                          '$_total encontrados',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
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
                  ),
                ),

              // Artist content
              if (isArtist) ...[
                if (_searching && _concerts.isEmpty)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_concerts.isEmpty)
                  const SliverFillRemaining(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text(
                          'Busca un artista para ver sus conciertos.',
                          style: TextStyle(color: Colors.white54, fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                else
                  SliverList.builder(
                    itemCount: _concerts.length + (_hasMore ? 1 : 0),
                    itemBuilder: (_, i) {
                      if (i == _concerts.length) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: OutlinedButton(
                            onPressed: _searching
                                ? null
                                : () => _search(more: true),
                            child: const Text('Cargar más'),
                          ),
                        );
                      }
                      final c = _concerts[i];
                      final sel = _selected.contains(c.id);
                      return CheckboxListTile(
                        value: sel,
                        onChanged: (v) => setState(
                          () => v == true
                              ? _selected.add(c.id)
                              : _selected.remove(c.id),
                        ),
                        title: Text(
                          c.artist,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${c.formattedDate}  ·  ${c.venue}, ${c.city}',
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
                          ),
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
                  ),
              ],

              // Festival content
              if (!isArtist) ...[
                if (_loadingFestivals)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_festivals.isEmpty)
                  const SliverFillRemaining(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text(
                          'No hay festivales en assets/imports/festivals.json',
                          style: TextStyle(color: Colors.white54),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                else
                  SliverList.builder(
                    itemCount: _festivals.length,
                    itemBuilder: (_, i) {
                      final f = _festivals[i];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Card(
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
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
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
                        ),
                      );
                    },
                  ),
              ],

              // Bottom padding for FAB
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),

          // Progress overlay
          if (_importing)
            _buildOverlay(_importedCount, _importTotal, _importingArtist),
          if (_importingFestival)
            _buildOverlay(_festImported, _festTotal, _festArtist),
        ],
      ),
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
