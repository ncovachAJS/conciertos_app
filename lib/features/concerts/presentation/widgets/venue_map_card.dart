import 'dart:convert';
import 'dart:ui' as ui;

import 'package:conciertos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class VenueMapCard extends StatefulWidget {
  final String venue;
  final String city;

  const VenueMapCard({super.key, required this.venue, required this.city});

  @override
  State<VenueMapCard> createState() => _VenueMapCardState();
}

class _VenueMapCardState extends State<VenueMapCard> {
  LatLng? _location;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _geocode();
  }

  Future<void> _geocode() async {
    final parts = [widget.venue, widget.city].where((s) => s.isNotEmpty);
    if (parts.isEmpty) {
      if (mounted) setState(() => _loading = false);
      return;
    }

    final query = parts.join(', ');

    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/search'
        '?q=${Uri.encodeComponent(query)}&format=json&limit=1',
      );
      final response = await http.get(uri, headers: {
        'User-Agent': 'ConciertosApp/1.0',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        if (data.isNotEmpty) {
          final lat = double.tryParse(data[0]['lat'] as String);
          final lng = double.tryParse(data[0]['lon'] as String);
          if (lat != null && lng != null && mounted) {
            setState(() => _location = LatLng(lat, lng));
          }
        }
      }
    } catch (_) {}

    if (mounted) setState(() => _loading = false);
  }

  Future<void> _openInMaps() async {
    final query = [widget.venue, widget.city]
        .where((s) => s.isNotEmpty)
        .join(', ');
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}',
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.map_rounded,
                  color: Color(0xFFE53935),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  l.mapVenueLocation,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (_location != null)
                  TextButton.icon(
                    onPressed: _openInMaps,
                    icon: const Icon(Icons.open_in_new, size: 15),
                    label: Text(
                      l.mapOpenIn,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: _loading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: cs.onSurface.withOpacity(0.4),
                          strokeWidth: 2,
                        ),
                      )
                    : _location == null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_off_rounded,
                              size: 36,
                              color: cs.onSurface.withOpacity(0.25),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l.mapNotAvailable,
                              style: TextStyle(
                                color: cs.onSurface.withOpacity(0.4),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      )
                    : FlutterMap(
                        options: MapOptions(
                          initialCenter: _location!,
                          initialZoom: 15,
                          interactionOptions: const InteractionOptions(
                            flags: InteractiveFlag.none,
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
                              Marker(
                                point: _location!,
                                width: 44,
                                height: 52,
                                child: const _VenuePin(),
                              ),
                            ],
                          ),
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

// Pin personalizado: círculo rojo con nota musical + triángulo inferior
class _VenuePin extends StatelessWidget {
  const _VenuePin();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            color: Color(0xFFE53935),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x88E53935),
                blurRadius: 8,
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

    // ui.Path to avoid conflict with flutter_map's Path type
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
