import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:conciertos_app/l10n/generated/app_localizations.dart';

import '../../../records/domain/entities/album_record.dart';
import '../../../records/presentation/pages/records_page.dart' show RecordCover;
import '../../../records/presentation/providers/records_provider.dart';

/// Sección "Mi colección" del dashboard: recuento, tira con las últimas
/// carátulas y acceso a la colección completa.
class DashboardRecords extends ConsumerWidget {
  const DashboardRecords({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final async = ref.watch(recordsProvider);

    // Mientras carga o si falla no mostramos nada: es una sección secundaria
    // y no debe ensuciar el inicio con errores.
    if (!async.hasValue) return const SizedBox(height: 120);

    final owned = ref.watch(ownedRecordsProvider);
    final wishlist = ref.watch(wishlistRecordsProvider);

    if (owned.isEmpty && wishlist.isEmpty) {
      return _EmptyCard(onTap: () => context.push('/records'));
    }

    final vinyl = owned.where((r) => r.format == RecordFormat.vinyl).length;
    final cds = owned.where((r) => r.format == RecordFormat.cd).length;
    final latest = owned.take(12).toList(); // la lista ya viene de más nueva a más antigua

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            _StatChip(l.recordsCount(owned.length), strong: true),
            if (vinyl > 0) _StatChip(l.recordsVinylCount(vinyl)),
            if (cds > 0) _StatChip(l.recordsCdCount(cds)),
            if (wishlist.isNotEmpty)
              _StatChip(l.recordsWishlistCount(wishlist.length)),
          ],
        ),
        if (latest.isNotEmpty) ...[
          const SizedBox(height: 14),
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: latest.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, i) => GestureDetector(
                onTap: () => context.push('/record/${latest[i].id}'),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: cs.shadow.withValues(alpha: .15),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: RecordCover(url: latest[i].coverUrl, size: 120),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String text;
  final bool strong;

  const _StatChip(this.text, {this.strong = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: strong
            ? const Color(0xFF8E24AA).withValues(alpha: .18)
            : cs.surfaceContainerHighest.withValues(alpha: .6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: strong ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final VoidCallback onTap;

  const _EmptyCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF8E24AA).withValues(alpha: .10),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF8E24AA).withValues(alpha: .35),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.album_rounded, size: 40, color: Color(0xFF8E24AA)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.dashRecordsEmptyTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l.dashRecordsEmptyHint,
                    style: TextStyle(color: cs.onSurface.withValues(alpha: .65)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}
