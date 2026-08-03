import 'package:cached_network_image/cached_network_image.dart';
import 'package:conciertos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/recommended_event.dart';

class RecommendationCard extends StatelessWidget {
  final RecommendedEvent event;
  final bool isCompact;
  final bool wantToAttend;
  final VoidCallback onToggleWantToAttend;

  const RecommendationCard({
    super.key,
    required this.event,
    required this.wantToAttend,
    required this.onToggleWantToAttend,
    this.isCompact = false,
  });

  Future<void> _openTicketUrl() async {
    final uri = Uri.parse(event.ticketUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('No se pudo abrir ${event.ticketUrl}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isCompact ? _buildCompact(context) : _buildCard(context);
  }

  Widget _buildCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: event.imageUrl,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
                    color: const Color(0xFF2B2B2B),
                    child: const Icon(Icons.music_note, color: Colors.white24, size: 60),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: _WantToAttendButton(
                  active: wantToAttend,
                  onTap: onToggleWantToAttend,
                  filled: true,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.artist,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 18),
                    const SizedBox(width: 6),
                    Expanded(child: Text('${event.city} · ${event.venue}')),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.calendar_month, size: 18),
                    const SizedBox(width: 6),
                    Text(DateFormat('dd/MM/yyyy').format(event.date)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _openTicketUrl,
                    icon: const Icon(Icons.confirmation_number),
                    label: Text(AppLocalizations.of(context).buyTickets),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompact(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dateStr = DateFormat('d MMM yyyy', 'es').format(event.date);
    final subtitle = [event.city, event.venue].where((s) => s.isNotEmpty).join(' · ');

    return InkWell(
      onTap: event.ticketUrl.isNotEmpty ? _openTicketUrl : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: event.imageUrl,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: cs.onSurface.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.music_note_rounded,
                      color: cs.onSurface.withValues(alpha: 0.3), size: 24),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.artist,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                          fontSize: 12, color: cs.onSurface.withValues(alpha: 0.5)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 2),
                  Text(
                    dateStr,
                    style: TextStyle(
                        fontSize: 11, color: cs.onSurface.withValues(alpha: 0.4)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _WantToAttendButton(active: wantToAttend, onTap: onToggleWantToAttend),
          ],
        ),
      ),
    );
  }
}

class _WantToAttendButton extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;
  final bool filled;

  const _WantToAttendButton({
    required this.active,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? Colors.greenAccent : Colors.white70;

    if (filled) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                active ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
                color: color,
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                active ? 'Apuntado' : 'Quiero ir',
                style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      );
    }

    return IconButton(
      onPressed: onTap,
      icon: Icon(
        active ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
        color: active ? Colors.greenAccent : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
      ),
      tooltip: active ? 'Quitar de mi lista' : 'Quiero asistir',
    );
  }
}
