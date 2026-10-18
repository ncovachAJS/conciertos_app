import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:conciertos_app/l10n/generated/app_localizations.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../concerts/data/services/upload_service.dart';
import '../../../concerts/domain/entities/concert.dart';
import '../../../concerts/presentation/providers/concerts_provider.dart';
import '../../../friends/presentation/widgets/tag_friends_selector.dart';
import '../../data/services/photo_api_service.dart';
import '../memories_events.dart';

/// Flujo completo "añadir recuerdo": elegir concierto (si no se indica),
/// elegir fotos, texto y etiquetas (si es una sola foto) y subirlas.
///
/// Solo se pueden vincular conciertos propios: los de amigos en los que
/// estás etiquetado no se pueden editar.
Future<void> startAddMemory(
  BuildContext context,
  WidgetRef ref, {
  Concert? concert,
}) async {
  final l = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final router = GoRouter.of(context);

  // 1. Concierto
  var target = concert;
  if (target == null) {
    final userId = AuthController.instance.user?.id ?? '';
    final own = (ref.read(concertsProvider).asData?.value ?? const <Concert>[])
        .where((c) => c.userId == userId || c.userId.isEmpty)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    if (own.isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text(l.memoryNoConcerts)));
      return;
    }
    target = await pickConcertForMemory(context, own);
    if (target == null || !context.mounted) return;
  }

  // 2. Fotos
  final images = await ImagePicker().pickMultiImage(imageQuality: 95);
  if (images.isEmpty || !context.mounted) return;

  // 3. Texto y etiquetas (solo con una foto, como en la ficha del concierto)
  var caption = '';
  var tagged = <String>[];
  if (images.length == 1) {
    final result = await askMemoryCaptionAndTags(
      context,
      File(images.first.path),
      isPast: target.date.isBefore(DateTime.now()),
    );
    if (result == null || !context.mounted) return;
    caption = result.$1;
    tagged = result.$2;
  }

  // 4. Subida con progreso
  final progress = ValueNotifier<int>(0);
  // Se captura ahora: si la pantalla de origen se cierra durante la subida,
  // el diálogo de progreso se debe poder cerrar igualmente.
  final rootNavigator = Navigator.of(context, rootNavigator: true);
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => PopScope(
      canPop: false,
      child: AlertDialog(
        content: ValueListenableBuilder<int>(
          valueListenable: progress,
          builder: (_, done, _) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(value: done / images.length),
              const SizedBox(height: 16),
              Text(l.memoryUploading(done, images.length)),
            ],
          ),
        ),
      ),
    ),
  );

  final upload = UploadService();
  final api = PhotoApiService();
  final concertId = target.id;
  String? firstError;

  final results = await Future.wait(
    images.map((image) async {
      try {
        final url = await upload.uploadImage(image.path);
        final photo = await api.addPhoto(
          concertId: concertId,
          imageUrl: url,
          caption: caption,
          taggedFriendIds: tagged,
        );
        progress.value++;
        return photo;
      } catch (e) {
        firstError ??= e.toString();
        progress.value++;
        return null;
      }
    }),
  );

  rootNavigator.pop();
  progress.dispose();

  final added = results.whereType<Object>().length;
  if (added > 0) memoriesChanged.value++;

  if (added == 0) {
    messenger.showSnackBar(
      SnackBar(content: Text(l.photoUploadError(firstError ?? ''))),
    );
    return;
  }

  final failed = images.length - added;
  final concertToOpen = target;
  messenger.showSnackBar(
    SnackBar(
      content: Text(
        failed > 0
            ? l.memoryAddedPartial(added, failed)
            : l.memoryAddedTo(added, concertToOpen.artist),
      ),
      action: SnackBarAction(
        label: l.memoryView,
        onPressed: () => router.push('/concert-detail', extra: concertToOpen),
      ),
    ),
  );
}

/// Hoja inferior con buscador para elegir uno de los conciertos propios.
Future<Concert?> pickConcertForMemory(
  BuildContext context,
  List<Concert> concerts,
) {
  return showModalBottomSheet<Concert>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) => _ConcertPickerSheet(concerts: concerts),
  );
}

class _ConcertPickerSheet extends StatefulWidget {
  final List<Concert> concerts;

  const _ConcertPickerSheet({required this.concerts});

  @override
  State<_ConcertPickerSheet> createState() => _ConcertPickerSheetState();
}

class _ConcertPickerSheetState extends State<_ConcertPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final dateFormat = DateFormat.yMMMd(locale);
    final q = _query.trim().toLowerCase();

    final list = q.isEmpty
        ? widget.concerts
        : widget.concerts.where((c) {
            return [c.artist, c.name, c.festival, c.venue, c.city]
                .any((s) => s.toLowerCase().contains(q));
          }).toList();

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * .8,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l.memoryPickConcert,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: l.search,
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: list.isEmpty
                  ? Center(child: Text(l.memoryNoResults))
                  : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (_, i) {
                        final c = list[i];
                        final subtitle = [
                          if (c.festival.isNotEmpty) c.festival else c.name,
                          if (c.venue.isNotEmpty) c.venue,
                          dateFormat.format(c.date),
                        ].where((s) => s.isNotEmpty).join(' · ');
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 48,
                              height: 48,
                              child: c.imageUrl.isEmpty
                                  ? const ColoredBox(
                                      color: Color(0xFF303542),
                                      child: Icon(Icons.music_note),
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: c.imageUrl,
                                      fit: BoxFit.cover,
                                      errorWidget: (_, _, _) => const ColoredBox(
                                        color: Color(0xFF303542),
                                        child: Icon(Icons.music_note),
                                      ),
                                    ),
                            ),
                          ),
                          title: Text(
                            c.artist,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () => Navigator.pop(context, c),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Diálogo "Nuevo recuerdo": vista previa, texto y amigos etiquetados.
/// Devuelve (texto, ids de amigos) o null si se cancela.
Future<(String, List<String>)?> askMemoryCaptionAndTags(
  BuildContext context,
  File image, {
  required bool isPast,
}) {
  final controller = TextEditingController();
  var taggedIds = <String>[];

  return showDialog<(String, List<String>)>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(AppLocalizations.of(ctx).newMemory),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  image,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(ctx).captionHint,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TagFriendsSelector(
                isPast: isPast,
                onChanged: (ids) => taggedIds = ids,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(AppLocalizations.of(ctx).cancel),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.pop(ctx, (controller.text.trim(), taggedIds)),
          child: Text(AppLocalizations.of(ctx).publish),
        ),
      ],
    ),
  );
}
