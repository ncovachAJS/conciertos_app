import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../concerts/data/models/concert_model.dart';
import '../../../concerts/data/services/concert_api_service.dart';
import '../../../concerts/domain/entities/concert.dart';
import '../../../concerts/presentation/providers/concerts_provider.dart';
import '../../data/models/setlist_concert_model.dart';
import '../../data/services/artist_image_service.dart';
import '../../data/services/setlist_import_service.dart';

class ImportPage extends ConsumerStatefulWidget {
  const ImportPage({super.key});

  @override
  ConsumerState<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends ConsumerState<ImportPage> {
  final _searchController = TextEditingController();
  final _setlistService = SetlistImportService();
  final _imageService = ArtistImageService();

  List<SetlistConcertModel> _concerts = [];
  final Set<String> _selected = {};

  bool _searching = false;
  int _searchId = 0; // incrementa en cada búsqueda para cancelar la anterior
  bool _importing = false;
  bool _hasMore = false;
  int _page = 1;
  int _total = 0;
  int _artistYear = 0;
  int _importedCount = 0;
  int _importTotal = 0;
  String _importingCurrent = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
  }

  void _onSearchTextChanged() {
    if (_searchController.text.isEmpty && _searching) {
      // El usuario borró el campo — cancelamos la búsqueda en curso
      _searchId++;
      setState(() {
        _searching = false;
        _concerts = [];
        _selected.clear();
        _total = 0;
      });
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search({bool more = false}) async {
    final q = _searchController.text.trim();
    if (q.isEmpty) return;

    // Guardamos el ID de esta búsqueda para detectar cancelaciones
    _searchId++;
    final currentId = _searchId;

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
      if (_artistYear == 0) {
        final r = await _setlistService.searchArtistConcerts(
          q,
          page: more ? _page + 1 : 1,
        );
        if (!mounted || _searchId != currentId) return; // cancelada
        setState(() {
          _concerts = more ? [..._concerts, ...r.concerts] : r.concerts;
          _total = r.total;
          _page = r.page;
          _hasMore = _concerts.length < _total && r.concerts.isNotEmpty;
        });
      } else {
        int page = more ? _page + 1 : 1;
        final found = <SetlistConcertModel>[];
        bool hasMore = true;
        int safetyLimit = 15;

        while (hasMore && safetyLimit > 0) {
          final r = await _setlistService.searchArtistConcerts(q, page: page);
          if (r.concerts.isEmpty) break;
          for (final c in r.concerts) {
            if (c.date.year == _artistYear) found.add(c);
          }
          final hasOlder = r.concerts.any((c) => c.date.year < _artistYear);
          hasMore = !hasOlder && r.page * r.itemsPerPage < r.total;
          await Future.delayed(const Duration(milliseconds: 500));
          page++;
          safetyLimit--;
          if (hasOlder || _searchId != currentId) break; // cancelada
        }

        if (!mounted || _searchId != currentId) return; // cancelada
        setState(() {
          _concerts = more ? [..._concerts, ...found] : found;
          _total = found.length;
          _page = page - 1;
          _hasMore = hasMore;
        });
      }
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

    Concert? lastCreated;

    try {
      final img = await _imageService.getImage(toImport.first.artist) ?? '';
      for (final c in toImport) {
        if (!mounted) return;
        setState(() {
          _importingCurrent = '${c.venue} · ${c.city}';
          _importedCount++;
        });
        lastCreated = await ConcertApiService().addConcert(
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

      ref.read(concertsProvider.notifier).reload().ignore();
      if (!mounted) return;
      setState(() => _selected.clear());

      if (toImport.length == 1 && lastCreated != null) {
        if (context.mounted) {
          context.push('/concert-detail', extra: lastCreated);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${toImport.length} concierto${toImport.length > 1 ? "s" : ""} importado${toImport.length > 1 ? "s" : ""} 🎸',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final years = [
      0,
      ...List.generate(
        DateTime.now().year - 1989,
        (i) => DateTime.now().year - i,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Importar conciertos'),
        centerTitle: false,
      ),
      floatingActionButton: _selected.isNotEmpty && !_importing
          ? FloatingActionButton.extended(
              onPressed: _importSelected,
              icon: const Icon(Icons.download_rounded),
              label: Text(
                'Importar ${_selected.length} concierto${_selected.length > 1 ? "s" : ""}',
              ),
              backgroundColor: const Color(0xFFE53935),
              foregroundColor: Colors.white,
            )
          : null,
      body: Stack(
        fit: StackFit.expand,
        children: [
          CustomScrollView(
            slivers: [
              // ── Cabecera informativa ────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Busca un artista',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Importa conciertos desde Setlist.fm',
                        style: TextStyle(
                          color: cs.onSurface.withOpacity(0.54),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Buscador + año ──────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: LayoutBuilder(
                    builder: (ctx, bc) {
                      const yw = 110.0, bw = 88.0, sp = 10.0;
                      final aw = bc.maxWidth - yw - bw - sp * 2;
                      return Row(
                        children: [
                          SizedBox(
                            width: aw,
                            child: TextField(
                              controller: _searchController,
                              onSubmitted: (_) => _search(),
                              textInputAction: TextInputAction.search,
                              style: TextStyle(color: cs.onSurface),
                              decoration: InputDecoration(
                                hintText: 'Artista...',
                                hintStyle: TextStyle(
                                  color: cs.onSurface.withOpacity(0.4),
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: cs.onSurface.withOpacity(0.6),
                                ),
                                filled: true,
                                fillColor: cs.surfaceContainerHighest,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: sp),
                          SizedBox(
                            width: yw,
                            child: DropdownButtonFormField<int>(
                              value: _artistYear,
                              style: TextStyle(
                                color: cs.onSurface,
                                fontSize: 14,
                              ),
                              dropdownColor: cs.surface,
                              decoration: InputDecoration(
                                labelText: 'Año',
                                labelStyle: TextStyle(
                                  color: cs.onSurface.withOpacity(0.6),
                                ),
                                filled: true,
                                fillColor: cs.surfaceContainerHighest,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                              ),
                              items: years
                                  .map(
                                    (y) => DropdownMenuItem(
                                      value: y,
                                      child: Text(
                                        y == 0 ? 'Todos' : '$y',
                                        style: TextStyle(color: cs.onSurface),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (y) {
                                // Cancelamos búsqueda en curso al cambiar año
                                _searchId++;
                                setState(() {
                                  _artistYear = y ?? 0;
                                  if (_searching) {
                                    _searching = false;
                                    _concerts = [];
                                    _selected.clear();
                                    _total = 0;
                                  }
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: sp),
                          SizedBox(
                            width: bw,
                            child: FilledButton(
                              onPressed: _searching ? null : () => _search(),
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFFE53935),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: _searching
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
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

              // ── Contador ────────────────────────────────────────────────
              if (_total > 0)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                    child: Row(
                      children: [
                        Text(
                          '$_total encontrados',
                          style: TextStyle(
                            color: cs.onSurface.withOpacity(0.54),
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

              // ── Lista ───────────────────────────────────────────────────
              if (_searching && _concerts.isEmpty)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_concerts.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.queue_music,
                          size: 72,
                          color: cs.onSurface.withOpacity(0.2),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Busca un artista para\nver sus conciertos',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: cs.onSurface.withOpacity(0.54),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverList.builder(
                  itemCount: _concerts.length + (_hasMore ? 1 : 0),
                  itemBuilder: (_, i) {
                    if (i == _concerts.length) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
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

                    return InkWell(
                      onTap: () => setState(
                        () =>
                            sel ? _selected.remove(c.id) : _selected.add(c.id),
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: sel
                              ? const Color(0xFFE53935).withOpacity(0.08)
                              : cs.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: sel
                                ? const Color(0xFFE53935).withOpacity(0.4)
                                : cs.onSurface.withOpacity(0.08),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: c.isPast
                                    ? const Color(0xFFE53935).withOpacity(.12)
                                    : const Color(0xFF42A5F5).withOpacity(.12),
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
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c.artist,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: cs.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${c.formattedDate}  ·  ${c.venue}, ${c.city}',
                                    style: TextStyle(
                                      color: cs.onSurface.withOpacity(0.54),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: sel
                                    ? const Color(0xFFE53935)
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: sel
                                      ? const Color(0xFFE53935)
                                      : cs.onSurface.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: sel
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 14,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),

          // Overlay importando
          if (_importing)
            Container(
              color: Colors.black87,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: Color(0xFFE53935)),
                    const SizedBox(height: 24),
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
                        value: _importTotal == 0
                            ? 0
                            : _importedCount / _importTotal,
                        color: const Color(0xFFE53935),
                        backgroundColor: Colors.white24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$_importedCount / $_importTotal',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _importingCurrent,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
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
}
