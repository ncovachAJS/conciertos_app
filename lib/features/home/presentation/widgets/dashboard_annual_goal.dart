import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/notifiers/annual_goal_notifier.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../concerts/domain/entities/concert.dart';

/// Muestra la meta anual y el progreso.
/// Tocar abre los conciertos ya vistos este año.
/// La meta se configura desde Ajustes.
class DashboardAnnualGoal extends StatefulWidget {
  final List<Concert> concerts;

  const DashboardAnnualGoal({super.key, required this.concerts});

  @override
  State<DashboardAnnualGoal> createState() => _DashboardAnnualGoalState();
}

class _DashboardAnnualGoalState extends State<DashboardAnnualGoal> {
  int? _goal;

  String get _prefKey {
    final userId = AuthController.instance.user?.id ?? 'guest';
    return 'annual_concert_goal_$userId';
  }

  @override
  void initState() {
    super.initState();
    _loadGoal();
    // Escucha cambios en tiempo real desde ajustes
    AnnualGoalNotifier.instance.addListener(_onGoalChanged);
  }

  @override
  void dispose() {
    AnnualGoalNotifier.instance.removeListener(_onGoalChanged);
    super.dispose();
  }

  void _onGoalChanged() {
    if (mounted) setState(() => _goal = AnnualGoalNotifier.instance.value);
  }

  Future<void> _loadGoal() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final value = prefs.getInt(_prefKey);
    // Sincroniza con el notifier singleton al cargar
    AnnualGoalNotifier.instance.value = value;
    setState(() => _goal = value);
  }

  /// Llamado también desde settings_page para recargar tras editar.
  Future<void> reload() => _loadGoal();

  void _showConcertsSheet(
      BuildContext context, List<Concert> yearConcerts, int year) {
    final cs = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: cs.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.55,
        maxChildSize: 0.92,
        builder: (_, controller) => Column(
          children: [
            // Handle
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Cabecera
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Row(
                children: [
                  const Icon(Icons.flag_rounded,
                      color: Color(0xFFE53935), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Mis conciertos de $year',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${yearConcerts.length}${_goal != null ? ' / $_goal' : ''}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFE53935),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: cs.onSurface.withValues(alpha: 0.08)),
            // Lista
            Expanded(
              child: yearConcerts.isEmpty
                  ? Center(
                      child: Text(
                        'Aún no has ido a ningún concierto en $year',
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.45),
                        ),
                      ),
                    )
                  : ListView.separated(
                      controller: controller,
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                      itemCount: yearConcerts.length,
                      separatorBuilder: (_, idx) =>
                          const SizedBox(height: 10),
                      itemBuilder: (bCtx, i) =>
                          _ConcertRow(concert: yearConcerts[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;
    final userId = AuthController.instance.user?.id ?? '';

    // 1. Conciertos pasados de este año
    final pastThisYear = widget.concerts
        .where((c) => c.date.year == year && c.isPastConcert)
        .toList();

    // 2. Fechas que ya tiene el usuario propio (para deduplicar compartidos)
    final myDates = pastThisYear
        .where((c) => c.userId == userId || c.userId.isEmpty)
        .map((c) => DateTime(c.date.year, c.date.month, c.date.day))
        .toSet();

    // 3. Incluir propio siempre; incluir compartido sólo si no hay propio ese día
    final yearConcerts = pastThisYear
        .where(
          (c) =>
              c.userId == userId ||
              c.userId.isEmpty ||
              !myDates.contains(
                  DateTime(c.date.year, c.date.month, c.date.day)),
        )
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    final done = yearConcerts.length;
    final cs = Theme.of(context).colorScheme;

    // Sin meta → tarjeta de invitación (apunta a ajustes)
    if (_goal == null) {
      return GestureDetector(
        onTap: () => _showConcertsSheet(context, yearConcerts, year),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: cs.onSurface.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: cs.onSurface.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.flag_rounded,
                  color: Color(0xFFE53935),
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$done concierto${done != 1 ? 's' : ''} en $year',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Configura tu meta en Ajustes',
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: cs.onSurface.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      );
    }

    // Con meta → barra de progreso
    final progress = (_goal! > 0 ? done / _goal! : 0.0).clamp(0.0, 1.0);
    final reached = done >= _goal!;
    final remaining = (_goal! - done).clamp(0, _goal!);
    final color =
        reached ? const Color(0xFF43A047) : const Color(0xFFE53935);

    return GestureDetector(
      onTap: () => _showConcertsSheet(context, yearConcerts, year),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
        decoration: BoxDecoration(
          color: cs.onSurface.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: cs.onSurface.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  reached ? Icons.emoji_events_rounded : Icons.flag_rounded,
                  color: color,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    reached
                        ? '¡Meta alcanzada en $year! 🎉'
                        : 'Meta $year: $_goal conciertos',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  '$done / $_goal',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: cs.onSurface.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
            if (!reached) ...[
              const SizedBox(height: 8),
              Text(
                'Te quedan $remaining concierto${remaining != 1 ? 's' : ''} para conseguirlo',
                style: TextStyle(
                  fontSize: 11,
                  color: cs.onSurface.withValues(alpha: 0.45),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Fila de concierto dentro del sheet
// ─────────────────────────────────────────────────────────────────────────────

class _ConcertRow extends StatelessWidget {
  final Concert concert;
  const _ConcertRow({required this.concert});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final date = concert.date;
    final dateStr =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        context.push('/concert-detail', extra: concert);
      },
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(14),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            // Thumbnail
            SizedBox(
              width: 64,
              height: 64,
              child: concert.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: concert.imageUrl,
                      fit: BoxFit.cover,
                      errorWidget: (ctx, url, err) =>
                          _Fallback(artist: concert.artist),
                    )
                  : _Fallback(artist: concert.artist),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      concert.artist.isNotEmpty ? concert.artist : concert.name,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (concert.venue.isNotEmpty || concert.city.isNotEmpty)
                      Text(
                        [concert.venue, concert.city]
                            .where((s) => s.isNotEmpty)
                            .join(' · '),
                        style: TextStyle(
                          fontSize: 11,
                          color: cs.onSurface.withValues(alpha: 0.5),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 2),
                    Text(
                      dateStr,
                      style: TextStyle(
                        fontSize: 11,
                        color: cs.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (concert.rating > 0)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded,
                        color: Color(0xFFFFC107), size: 13),
                    const SizedBox(width: 2),
                    Text(
                      '${concert.rating}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFFC107),
                      ),
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(Icons.chevron_right_rounded,
                    size: 18,
                    color: cs.onSurface.withValues(alpha: 0.25)),
              ),
          ],
        ),
      ),
    );
  }
}

class _Fallback extends StatelessWidget {
  final String artist;
  const _Fallback({required this.artist});

  static Color _color(String a) {
    const p = [
      Color(0xFFB71C1C), Color(0xFF6A1B9A), Color(0xFF0D47A1),
      Color(0xFF1B5E20), Color(0xFFE65100), Color(0xFF006064),
    ];
    if (a.isEmpty) return p[0];
    return p[a.codeUnitAt(0) % p.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _color(artist),
      alignment: Alignment.center,
      child: Text(
        artist.isNotEmpty ? artist[0].toUpperCase() : '♪',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
