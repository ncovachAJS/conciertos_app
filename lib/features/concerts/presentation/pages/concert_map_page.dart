import 'dart:convert';
import 'dart:ui' as ui;

import 'package:conciertos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/concert.dart';
import '../providers/concerts_provider.dart';

// ---------------------------------------------------------------------------
// Modelo interno — un recinto único con todos sus conciertos
// ---------------------------------------------------------------------------

class _VenueGroup {
  final String venue;
  final String city;
  final List<Concert> concerts;
  LatLng? location;

  _VenueGroup({
    required this.venue,
    required this.city,
    required this.concerts,
  });

  String get key => '${venue.toLowerCase()}|${city.toLowerCase()}';

  String get displayName {
    if (venue.isNotEmpty && city.isNotEmpty) return '$venue · $city';
    return venue.isNotEmpty ? venue : city;
  }

  String get geocodeQuery {
    return [venue, city].where((s) => s.isNotEmpty).join(', ');
  }
}

// ---------------------------------------------------------------------------
// Página principal
// ---------------------------------------------------------------------------

class ConcertMapPage extends ConsumerStatefulWidget {
  const ConcertMapPage({super.key});

  @override
  ConsumerState<ConcertMapPage> createState() => _ConcertMapPageState();
}

class _ConcertMapPageState extends ConsumerState<ConcertMapPage> {
  final MapController _mapController = MapController();

  List<_VenueGroup> _groups = [];
  int _geocoded = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _buildGroups());
  }

  void _buildGroups() {
    final concerts = ref.read(concertsProvider).asData?.value ?? [];

    // Solo pasados con venue o city
    final past = concerts.where(
      (c) => c.isPastConcert && (c.venue.isNotEmpty || c.city.isNotEmpty),
    );

    // Agrupar por recinto único (venue|city)
    final map = <String, _VenueGroup>{};
    for (final c in past) {
      final key = '${c.venue.toLowerCase()}|${c.city.toLowerCase()}';
      if (map.containsKey(key)) {
        map[key]!.concerts.add(c);
      } else {
        map[key] = _VenueGroup(
          venue: c.venue,
          city: c.city,
          concerts: [c],
        );
      }
    }

    _groups = map.values.toList();
    if (_groups.isEmpty) {
      setState(() => _loading = false);
      return;
    }

    _geocodeAll();
  }

  Future<void> _geocodeAll() async {
    for (final group in _groups) {
      await _geocodeGroup(group);
      // Esperar 400ms entre peticiones para respetar el rate-limit de Nominatim
      await Future.delayed(const Duration(milliseconds: 400));
    }
    if (mounted) {
      setState(() => _loading = false);
      _fitBounds();
    }
  }

  Future<void> _geocodeGroup(_VenueGroup group) async {
    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/search'
        '?q=${Uri.encodeComponent(group.geocodeQuery)}&format=json&limit=1',
      );
      final response = await http.get(uri, headers: {
        'User-Agent': 'ConciertosApp/1.0',
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        if (data.isNotEmpty) {
          final lat = double.tryParse(data[0]['lat'] as String);
          final lng = double.tryParse(data[0]['lon'] as String);
          if (lat != null && lng != null) {
            group.location = LatLng(lat, lng);
          }
        }
      }
    } catch (_) {}

    if (mounted) {
      setState(() => _geocoded++);
    }
  }

  void _fitBounds() {
    final located = _groups.where((g) => g.location != null).toList();
    if (located.isEmpty) return;

    if (located.length == 1) {
      _mapController.move(located.first.location!, 13);
      return;
    }

    final lats = located.map((g) => g.location!.latitude);
    final lngs = located.map((g) => g.location!.longitude);
    final bounds = LatLngBounds(
      LatLng(lats.reduce((a, b) => a < b ? a : b),
          lngs.reduce((a, b) => a < b ? a : b)),
      LatLng(lats.reduce((a, b) => a > b ? a : b),
          lngs.reduce((a, b) => a > b ? a : b)),
    );
    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(60)),
    );
  }

  void _showVenueSheet(BuildContext context, _VenueGroup group) {
    final l = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.45,
        maxChildSize: 0.85,
        builder: (_, scrollController) => _VenueSheet(
          group: group,
          scrollController: scrollController,
          l: l,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final located = _groups.where((g) => g.location != null).toList();
    final total = _groups.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.concertMapTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          // ── Mapa ──────────────────────────────────────────────────────────
          if (located.isEmpty && !_loading)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.map_outlined,
                      size: 64,
                      color: cs.onSurface.withOpacity(0.15),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l.concertMapNoData,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: cs.onSurface.withOpacity(0.4),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            FlutterMap(
              mapController: _mapController,
              options: const MapOptions(
                initialCenter: LatLng(40.4, -3.7), // Madrid como centro inicial
                initialZoom: 5,
                interactionOptions: InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.conciertos.app',
                ),
                MarkerLayer(
                  markers: [
                    for (final group in located)
                      Marker(
                        point: group.location!,
                        width: 48,
                        height: 58,
                        child: GestureDetector(
                          onTap: () => _showVenueSheet(context, group),
                          child: _VenueMarker(count: group.concerts.length),
                        ),
                      ),
                  ],
                ),
              ],
            ),

          // ── Barra de progreso mientras geocodifica ─────────────────────
          if (_loading && total > 0)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: cs.surface.withOpacity(0.92),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${l.concertMapLoading} ${l.concertMapProgress(_geocoded, total)}',
                          style: TextStyle(
                            fontSize: 13,
                            color: cs.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: total == 0 ? 0 : _geocoded / total,
                      backgroundColor: cs.onSurface.withOpacity(0.1),
                      color: const Color(0xFFE53935),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),
            ),

          // ── Botón para re-centrar ────────────────────────────────────────
          if (located.isNotEmpty)
            Positioned(
              bottom: 24,
              right: 16,
              child: FloatingActionButton.small(
                tooltip: 'Centrar',
                backgroundColor: cs.surface,
                foregroundColor: cs.onSurface,
                onPressed: _fitBounds,
                child: const Icon(Icons.center_focus_strong_rounded),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Marcador personalizado: círculo rojo + nota musical + badge de cantidad
// ---------------------------------------------------------------------------

class _VenueMarker extends StatelessWidget {
  final int count;
  const _VenueMarker({required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFE53935),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xAAE53935),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.music_note_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            if (count > 1)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE53935),
                    ),
                  ),
                ),
              ),
          ],
        ),
        CustomPaint(
          size: const Size(12, 8),
          painter: _PinTailPainter(),
        ),
      ],
    );
  }
}

class _PinTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE53935)
      ..style = PaintingStyle.fill;
    final path = ui.Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_PinTailPainter old) => false;
}

// ---------------------------------------------------------------------------
// Bottom sheet — lista de conciertos en ese recinto
// ---------------------------------------------------------------------------

class _VenueSheet extends StatelessWidget {
  final _VenueGroup group;
  final ScrollController scrollController;
  final AppLocalizations l;

  const _VenueSheet({
    required this.group,
    required this.scrollController,
    required this.l,
  });

  Future<void> _openMaps() async {
    final query = [group.venue, group.city]
        .where((s) => s.isNotEmpty)
        .join(', ');
    await launchUrl(
      Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}',
      ),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: cs.onSurface.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Nombre del recinto
          Row(
            children: [
              const Icon(
                Icons.location_on_rounded,
                color: Color(0xFFE53935),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  group.displayName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: _openMaps,
                icon: const Icon(Icons.open_in_new, size: 15),
                label: Text(
                  l.concertMapOpenInMaps,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l.concertMapConcertsHere,
            style: TextStyle(
              color: cs.onSurface.withOpacity(0.5),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),

          // Lista de conciertos
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: group.concerts.length,
              itemBuilder: (ctx, i) {
                final c = group.concerts[i];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 4),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: c.imageUrl.isNotEmpty
                        ? Image.network(
                            c.imageUrl,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const _PlaceholderThumb(),
                          )
                        : const _PlaceholderThumb(),
                  ),
                  title: Text(
                    c.artist,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '${c.name}  ·  ${c.date.year}',
                    style: TextStyle(
                      color: cs.onSurface.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push('/concert-detail', extra: c);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderThumb extends StatelessWidget {
  const _PlaceholderThumb();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      color: const Color(0xFF2B2B2B),
      child: const Icon(Icons.music_note, color: Colors.white24, size: 24),
    );
  }
}
