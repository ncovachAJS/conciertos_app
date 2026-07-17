import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  int _tab = 0; // 0 = artista, 1 = festival, 2 = json

  // ── Tab Artista ───────────────────────────────────────────────────────────
  final _artistController = TextEditingController();
  final _setlistService = SetlistImportService();
  final _imageService = ArtistImageService();
  List<SetlistConcertModel> _artistConcerts = [];
  final Set<String> _artistSelected = {};
  int _artistYear = 0; // 0 = todos los años
  bool _artistSearching = false;
  bool _artistImporting = false;
  bool _artistHasMore = false;
  int _artistPage = 1;
  int _artistTotal = 0;
  int _artistImportedCount = 0;
  int _artistImportTotal = 0;
  String _artistImportingCurrent = '';

  // ── Tab Festival ──────────────────────────────────────────────────────────
  final _festNameController = TextEditingController();
  final _festArtistController = TextEditingController();
  int _festYear = DateTime.now().year;
  List<SetlistConcertModel> _festConcerts = [];
  final Set<String> _festSelected = {};
  bool _festSearching = false;
  bool _festImporting = false;
  bool _festHasMore = false;
  int _festPage = 1;
  int _festImportedCount = 0;
  int _festImportTotal = 0;
  String _festImportingCurrent = '';

  // ── Tab JSON ──────────────────────────────────────────────────────────────
  final _festivalService = FestivalImportService();
  List<FestivalModel> _festivals = [];
  bool _loadingFestivals = true;
  bool _jsonImporting = false;
  int _jsonImported = 0;
  int _jsonTotal = 0;
  String _jsonCurrentArtist = '';

  @override
  void initState() {
    super.initState();
    _loadFestivals();
  }

  @override
  void dispose() {
    _artistController.dispose();
    _festNameController.dispose();
    _festArtistController.dispose();
    super.dispose();
  }

  // ── Artista methods ───────────────────────────────────────────────────────

  Future<void> _searchArtist({bool more = false}) async {
    final q = _artistController.text.trim();
    if (q.isEmpty) return;

    // Limpiamos siempre al empezar una búsqueda nueva
    setState(() {
      _artistSearching = true;
      if (!more) {
        _artistConcerts = [];
        _artistSelected.clear();
        _artistPage = 1;
        _artistTotal = 0;
      }
    });

    try {
      if (_artistYear == 0) {
        // Sin año: una sola página, resultados directos
        final r = await _setlistService.searchArtistConcerts(
          q,
          page: more ? _artistPage + 1 : 1,
        );
        if (!mounted) return;
        setState(() {
          _artistConcerts = more
              ? [..._artistConcerts, ...r.concerts]
              : r.concerts;
          _artistTotal = r.total;
          _artistPage = r.page;
          _artistHasMore =
              _artistConcerts.length < _artistTotal && r.concerts.isNotEmpty;
        });
      } else {
        // Con año: paginamos hasta recoger TODOS los del año buscado.
        // ❌ Antes: el loop salía al encontrar el PRIMER concierto del año.
        // ✅ Ahora: el loop sigue hasta encontrar conciertos MÁS ANTIGUOS que el año.
        int page = more ? _artistPage + 1 : 1;
        final found = <SetlistConcertModel>[];
        bool hasMore = true;
        int safetyLimit = 15;

        while (hasMore && safetyLimit > 0) {
          final r = await _setlistService.searchArtistConcerts(q, page: page);
          if (r.concerts.isEmpty) break;

          for (final c in r.concerts) {
            if (c.date.year == _artistYear) found.add(c);
          }

          // Paramos cuando encontramos conciertos más antiguos que el año buscado
          final hasOlder = r.concerts.any((c) => c.date.year < _artistYear);
          hasMore = !hasOlder && r.page * r.itemsPerPage < r.total;

          await Future.delayed(const Duration(milliseconds: 500));
          page++;
          safetyLimit--;
          if (hasOlder) break;
        }

        if (!mounted) return;
        setState(() {
          _artistConcerts = more ? [..._artistConcerts, ...found] : found;
          // ✅ Mostramos cuántos hay del año, no el total de todos los conciertos
          _artistTotal = found.length;
          _artistPage = page - 1;
          _artistHasMore = hasMore && found.isNotEmpty;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _artistSearching = false);
    }
  }

  Future<void> _importArtistSelected() async {
    if (_artistSelected.isEmpty) return;
    final toImport = _artistConcerts
        .where((c) => _artistSelected.contains(c.id))
        .toList();
    setState(() {
      _artistImporting = true;
      _artistImportTotal = toImport.length;
      _artistImportedCount = 0;
    });

    try {
      // Guardamos los IDs existentes ANTES de importar
      final beforeIds = (ref.read(concertsProvider).asData?.value ?? [])
          .map((c) => c.id)
          .toSet();

      final img = await _imageService.getImage(toImport.first.artist) ?? '';
      for (final c in toImport) {
        if (!mounted) return;
        setState(() {
          _artistImportingCurrent = '${c.venue} · ${c.city}';
          _artistImportedCount++;
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
      setState(() => _artistSelected.clear());

      if (toImport.length == 1) {
        // Buscamos el concierto recién creado — el que NO estaba antes
        final concerts = ref.read(concertsProvider).asData?.value ?? [];
        final created = concerts
            .where((c) => !beforeIds.contains(c.id))
            .firstOrNull;
        if (created != null && mounted) {
          context.push('/concert-detail', extra: created);
          return;
        }
      }

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
      if (mounted) setState(() => _artistImporting = false);
    }
  }

  // ── Festival methods ──────────────────────────────────────────────────────

  Future<void> _searchFestival({bool more = false}) async {
    final artist = _festArtistController.text.trim();
    if (artist.isEmpty) return;

    setState(() {
      _festSearching = true;
      if (!more) {
        _festPage = 1;
        _festConcerts = [];
      }
    });

    try {
      // Los conciertos vienen ordenados por fecha DESC.
      // Avanzamos páginas automáticamente hasta encontrar el año buscado
      // o hasta que los conciertos sean más antiguos que ese año.
      int page = more ? _festPage + 1 : 1;
      final found = <SetlistConcertModel>[];
      bool hasMore = true;
      int safetyLimit = 15; // máximo 15 páginas de búsqueda

      while (found.isEmpty && hasMore && safetyLimit > 0) {
        final r = await _setlistService.searchArtistConcerts(
          artist,
          page: page,
        );

        if (r.concerts.isEmpty) break;

        for (final c in r.concerts) {
          if (c.date.year == _festYear) found.add(c);
        }

        // Si hay conciertos más antiguos que el año buscado, ya no hay más
        final hasOlder = r.concerts.any((c) => c.date.year < _festYear);
        hasMore = !hasOlder && r.page * r.itemsPerPage < r.total;

        page++;
        safetyLimit--;

        if (hasOlder) break;
      }

      if (!mounted) return;
      setState(() {
        _festConcerts = more ? [..._festConcerts, ...found] : found;
        _festPage = page - 1;
        _festHasMore = hasMore;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _festSearching = false);
    }
  }

  Future<void> _importFestSelected() async {
    if (_festSelected.isEmpty) return;
    final toImport = _festConcerts
        .where((c) => _festSelected.contains(c.id))
        .toList();
    final festName = _festNameController.text.trim();
    setState(() {
      _festImporting = true;
      _festImportTotal = toImport.length;
      _festImportedCount = 0;
    });
    try {
      for (final c in toImport) {
        if (!mounted) return;
        setState(() {
          _festImportingCurrent = '${c.artist} · ${c.city}';
          _festImportedCount++;
        });
        final img = await _imageService.getImage(c.artist) ?? '';
        await ref
            .read(concertsProvider.notifier)
            .add(
              ConcertModel(
                id: '',
                name: c.artist,
                artist: c.artist,
                festival: festName,
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
      setState(() => _festSelected.clear());
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
      if (mounted) setState(() => _festImporting = false);
    }
  }

  // ── JSON methods ──────────────────────────────────────────────────────────

  Future<void> _loadFestivals() async {
    try {
      _festivals = await _festivalService.getFestivals();
    } catch (_) {}
    if (mounted) setState(() => _loadingFestivals = false);
  }

  Future<void> _importJsonFestival(FestivalModel f) async {
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
      _jsonImporting = true;
      _jsonTotal = concerts.length;
      _jsonImported = 0;
    });
    try {
      for (final c in concerts) {
        if (!mounted) return;
        setState(() {
          _jsonCurrentArtist = c.artist;
          _jsonImported++;
        });
        // ✅ Guardamos cada concierto en el backend
        await ref
            .read(concertsProvider.notifier)
            .add(
              ConcertModel(
                id: '',
                name: c.name.isNotEmpty ? c.name : c.artist,
                artist: c.artist,
                festival: c.festival,
                date: c.date,
                venue: c.venue,
                city: c.city ?? '',
                imageUrl: c.imageUrl,
                rating: c.rating,
                liked: c.liked,
                favorite: false,
              ),
            );
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${concerts.length} conciertos importados 🎸')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _jsonImporting = false);
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

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

  Widget _buildConcertTile(
    SetlistConcertModel c,
    bool selected,
    ValueChanged<bool?> onChanged,
  ) {
    return CheckboxListTile(
      value: selected,
      onChanged: onChanged,
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
          color: c.isPast ? const Color(0xFFE53935) : const Color(0xFF42A5F5),
          size: 18,
        ),
      ),
      activeColor: const Color(0xFFE53935),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Importar')),
      floatingActionButton:
          (_tab == 0 && _artistSelected.isNotEmpty && !_artistImporting) ||
              (_tab == 1 && _festSelected.isNotEmpty && !_festImporting)
          ? FloatingActionButton.extended(
              onPressed: _tab == 0
                  ? _importArtistSelected
                  : _importFestSelected,
              icon: const Icon(Icons.download_rounded),
              label: Text(
                'Importar ${_tab == 0 ? _artistSelected.length : _festSelected.length}',
              ),
            )
          : null,
      body: Stack(
        fit: StackFit.expand,
        children: [
          CustomScrollView(
            slivers: [
              // ── Tab switcher ──────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _TabBtn(
                        label: 'Artista',
                        icon: Icons.person_search,
                        selected: _tab == 0,
                        onTap: () => setState(() => _tab = 0),
                      ),
                      _TabBtn(
                        label: 'Festival',
                        icon: Icons.festival,
                        selected: _tab == 1,
                        onTap: () => setState(() => _tab = 1),
                      ),
                      _TabBtn(
                        label: 'JSON',
                        icon: Icons.upload_file,
                        selected: _tab == 2,
                        onTap: () => setState(() => _tab = 2),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: Divider(height: 1)),

              // ── TAB 0: Artista ────────────────────────────────────────────
              if (_tab == 0) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: LayoutBuilder(
                      builder: (ctx, bc) {
                        const bw = 88.0, yw = 104.0, sp = 8.0;
                        final aw = bc.maxWidth - bw - yw - sp * 2;
                        final years = [
                          0,
                          ...List.generate(
                            DateTime.now().year - 1989,
                            (i) => DateTime.now().year - i,
                          ),
                        ];
                        return Row(
                          children: [
                            SizedBox(
                              width: aw,
                              child: TextField(
                                controller: _artistController,
                                decoration: const InputDecoration(
                                  hintText: 'Artista...',
                                  prefixIcon: Icon(Icons.search),
                                ),
                                onSubmitted: (_) => _searchArtist(),
                                textInputAction: TextInputAction.search,
                              ),
                            ),
                            const SizedBox(width: sp),
                            SizedBox(
                              width: yw,
                              child: DropdownButtonFormField<int>(
                                value: _artistYear,
                                decoration: const InputDecoration(
                                  labelText: 'Año',
                                ),
                                items: years
                                    .map(
                                      (y) => DropdownMenuItem(
                                        value: y,
                                        child: Text(y == 0 ? 'Todos' : '$y'),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (y) =>
                                    setState(() => _artistYear = y ?? 0),
                              ),
                            ),
                            const SizedBox(width: sp),
                            SizedBox(
                              width: bw,
                              child: FilledButton(
                                onPressed: _artistSearching
                                    ? null
                                    : () => _searchArtist(),
                                child: const Text(
                                  'Buscar',
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                if (_artistTotal > 0)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Row(
                        children: [
                          Text(
                            '$_artistTotal encontrados',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                          const Spacer(),
                          if (_artistSelected.isNotEmpty)
                            Text(
                              '${_artistSelected.length} seleccionados',
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
                if (_artistSearching && _artistConcerts.isEmpty)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_artistConcerts.isEmpty)
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
                    itemCount:
                        _artistConcerts.length + (_artistHasMore ? 1 : 0),
                    itemBuilder: (_, i) {
                      if (i == _artistConcerts.length) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: OutlinedButton(
                            onPressed: _artistSearching
                                ? null
                                : () => _searchArtist(more: true),
                            child: const Text('Cargar más'),
                          ),
                        );
                      }
                      final c = _artistConcerts[i];
                      return _buildConcertTile(
                        c,
                        _artistSelected.contains(c.id),
                        (v) => setState(
                          () => v == true
                              ? _artistSelected.add(c.id)
                              : _artistSelected.remove(c.id),
                        ),
                      );
                    },
                  ),
              ],

              // ── TAB 1: Festival ───────────────────────────────────────────
              if (_tab == 1) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: TextField(
                      controller: _festNameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del festival (etiqueta)',
                        hintText: 'ej. Download Festival 2024',
                        prefixIcon: Icon(Icons.festival),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: LayoutBuilder(
                      builder: (ctx, bc) {
                        const bw = 88.0, yw = 96.0, sp = 8.0;
                        final aw = bc.maxWidth - bw - yw - sp * 2;
                        final years = List.generate(
                          DateTime.now().year - 1989,
                          (i) => DateTime.now().year - i,
                        );
                        return Row(
                          children: [
                            SizedBox(
                              width: aw,
                              child: TextField(
                                controller: _festArtistController,
                                decoration: const InputDecoration(
                                  labelText: 'Artista',
                                  hintText: 'Metallica...',
                                  prefixIcon: Icon(Icons.person_search),
                                ),
                                onSubmitted: (_) => _searchFestival(),
                                textInputAction: TextInputAction.search,
                              ),
                            ),
                            const SizedBox(width: sp),
                            SizedBox(
                              width: yw,
                              child: DropdownButtonFormField<int>(
                                value: _festYear,
                                decoration: const InputDecoration(
                                  labelText: 'Año',
                                ),
                                items: years
                                    .map(
                                      (y) => DropdownMenuItem(
                                        value: y,
                                        child: Text('$y'),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (y) =>
                                    setState(() => _festYear = y ?? _festYear),
                              ),
                            ),
                            const SizedBox(width: sp),
                            SizedBox(
                              width: bw,
                              child: FilledButton(
                                onPressed: _festSearching
                                    ? null
                                    : () => _searchFestival(),
                                child: const Text(
                                  'Buscar',
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                if (_festSelected.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Text(
                        '${_festSelected.length} seleccionados en total',
                        style: const TextStyle(
                          color: Color(0xFFE53935),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                if (_festSearching && _festConcerts.isEmpty)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_festConcerts.isEmpty)
                  const SliverFillRemaining(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text(
                          'Escribe un artista y año para buscar sus conciertos de ese año.',
                          style: TextStyle(color: Colors.white54, fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                else
                  SliverList.builder(
                    itemCount: _festConcerts.length + (_festHasMore ? 1 : 0),
                    itemBuilder: (_, i) {
                      if (i == _festConcerts.length) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: OutlinedButton(
                            onPressed: _festSearching
                                ? null
                                : () => _searchFestival(more: true),
                            child: const Text('Cargar más'),
                          ),
                        );
                      }
                      final c = _festConcerts[i];
                      return _buildConcertTile(
                        c,
                        _festSelected.contains(c.id),
                        (v) => setState(
                          () => v == true
                              ? _festSelected.add(c.id)
                              : _festSelected.remove(c.id),
                        ),
                      );
                    },
                  ),
              ],

              // ── TAB 2: JSON ───────────────────────────────────────────────
              if (_tab == 2) ...[
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
                                    onPressed: () => _importJsonFestival(f),
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

              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),

          // Overlays
          if (_artistImporting)
            _buildOverlay(
              _artistImportedCount,
              _artistImportTotal,
              _artistImportingCurrent,
            ),
          if (_festImporting)
            _buildOverlay(
              _festImportedCount,
              _festImportTotal,
              _festImportingCurrent,
            ),
          if (_jsonImporting)
            _buildOverlay(_jsonImported, _jsonTotal, _jsonCurrentArtist),
        ],
      ),
    );
  }
}

// ── Tab button ────────────────────────────────────────────────────────────────

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
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 60,
            color: selected ? const Color(0xFFE53935) : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
