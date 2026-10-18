import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../pages/records_page.dart' show RecordCover;
import '../providers/records_provider.dart';

/// "Tus discos de este artista", para la ficha de un concierto.
/// No ocupa espacio si el usuario no es Pro o no tiene discos del artista.
class ArtistRecordsCard extends ConsumerWidget {
  final String artist;

  const ArtistRecordsCard({super.key, required this.artist});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fase de pruebas: solo isPro real (no ProConfig.isUserPro, que está abierto).
    // Se comprueba antes de leer los providers para no hacer llamadas a /records
    // (403) de usuarios que no son Pro.
    if (AuthController.instance.user?.isPro != true) {
      return const SizedBox.shrink();
    }

    final records = ref.watch(artistRecordsProvider(artist));
    if (records.isEmpty) return const SizedBox.shrink();

    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.album_rounded, color: Color(0xFF8E24AA)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${l.recordsArtistRecords} · ${records.length}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 84,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: records.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (_, i) => GestureDetector(
                    onTap: () => context.push('/record/${records[i].id}'),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: RecordCover(url: records[i].coverUrl, size: 84),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
