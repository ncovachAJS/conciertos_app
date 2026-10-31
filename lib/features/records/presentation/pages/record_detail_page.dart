import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/app_shell.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/album_record.dart';
import '../providers/records_provider.dart';
import 'records_page.dart' show RecordCover, confirmDeleteRecord, recordFormatLabel;

class RecordDetailPage extends ConsumerStatefulWidget {
  final String recordId;

  const RecordDetailPage({super.key, required this.recordId});

  @override
  ConsumerState<RecordDetailPage> createState() => _RecordDetailPageState();
}

class _RecordDetailPageState extends ConsumerState<RecordDetailPage> {
  final _notes = TextEditingController();
  final _price = TextEditingController();
  bool _notesInitialised = false;
  bool _savingNotes = false;

  @override
  void dispose() {
    _notes.dispose();
    _price.dispose();
    super.dispose();
  }

  /// Guarda un cambio suelto (estrellas, estado, lista de deseos → colección).
  Future<void> _patch(AlbumRecord record, Map<String, dynamic> fields) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(recordsProvider.notifier).patch(record.id, fields);
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l.error)));
    }
  }

  Future<void> _saveNotes(AlbumRecord record) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    FocusScope.of(context).unfocus();
    final rawPrice = _price.text.trim().replaceAll(',', '.');
    final price = rawPrice.isEmpty ? null : double.tryParse(rawPrice);
    if (rawPrice.isNotEmpty && price == null) {
      messenger.showSnackBar(SnackBar(content: Text(l.recordsPriceInvalid)));
      return;
    }
    setState(() => _savingNotes = true);
    try {
      await ref.read(recordsProvider.notifier).patch(record.id, {
        'notes': _notes.text.trim(),
        'price': price, // null borra el precio
      });
      messenger.showSnackBar(SnackBar(content: Text(l.recordsNotesSaved)));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l.error)));
    } finally {
      if (mounted) setState(() => _savingNotes = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final record = ref
        .watch(recordsProvider)
        .value
        ?.where((r) => r.id == widget.recordId)
        .firstOrNull;

    // Borrado o lista aún sin cargar
    if (record == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (!_notesInitialised) {
      _notes.text = record.notes ?? '';
      _price.text = record.price == null
          ? ''
          : record.price!.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '');
      _notesInitialised = true;
    }

    final detail = record.discogsId == null
        ? null
        : ref.watch(recordDetailProvider(record.discogsId!));

    return Scaffold(
      appBar: AppBar(
        title: Text(record.title, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: l.delete,
            onPressed: () async {
              final deleted = await confirmDeleteRecord(context, ref, record);
              if (deleted && context.mounted) context.pop();
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          16,
          8,
          16,
          floatingNavBarClearance(context) + 24,
        ),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: RecordCover(url: record.coverUrl),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            record.title,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            record.artist,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Chip(label: Text(recordFormatLabel(l, record.format))),
              if (record.year != null) Chip(label: Text('${record.year}')),
              if (record.country != null && record.country!.isNotEmpty)
                Chip(label: Text(record.country!)),
              if (record.label != null && record.label!.isNotEmpty)
                Chip(label: Text(record.label!)),
              ...?detail?.value?.genres.map((g) => Chip(label: Text(g))),
              ...?detail?.value?.styles.map((s) => Chip(label: Text(s))),
            ],
          ),
          if (record.status == RecordStatus.wishlist) ...[
            const SizedBox(height: 16),
            FilledButton.icon(
              icon: const Icon(Icons.check_circle_outline),
              label: Text(l.recordsMarkOwned),
              onPressed: () => _patch(record, {'status': 'OWNED'}),
            ),
          ],
          const SizedBox(height: 24),
          _SectionTitle(l.recordsRating),
          Row(
            children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    i <= record.rating ? Icons.star_rounded : Icons.star_border_rounded,
                    color: Colors.amber,
                    size: 32,
                  ),
                  // Tocar la estrella ya marcada quita la valoración
                  onPressed: () => _patch(
                    record,
                    {'rating': record.rating == i ? 0 : i},
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          _SectionTitle(l.recordsCondition),
          Wrap(
            spacing: 8,
            children: [
              for (final c in kRecordConditions)
                ChoiceChip(
                  label: Text(c),
                  selected: record.condition == c,
                  onSelected: (sel) => _patch(record, {'condition': sel ? c : null}),
                ),
            ],
          ),
          const SizedBox(height: 16),
          _SectionTitle(l.recordsPrice),
          TextField(
            controller: _price,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(suffixText: '€'),
          ),
          const SizedBox(height: 16),
          _SectionTitle(l.recordsNotes),
          TextField(
            controller: _notes,
            minLines: 2,
            maxLines: 6,
            maxLength: 2000,
            decoration: InputDecoration(hintText: l.recordsNotesHint),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: _savingNotes ? null : () => _saveNotes(record),
              child: Text(l.save),
            ),
          ),
          if (detail != null) ...[
            const SizedBox(height: 16),
            _SectionTitle(l.recordsTracklist),
            detail.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, _) => Text(l.recordsDetailError),
              data: (d) => Column(
                children: [
                  if (d.tracklist.isEmpty) Text(l.recordsNoTracklist),
                  for (final t in d.tracklist)
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: SizedBox(
                        width: 36,
                        child: Text(
                          t.position,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      title: Text(t.title),
                      trailing: Text(t.duration),
                    ),
                  if (d.discogsUrl != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        icon: const Icon(Icons.open_in_new, size: 18),
                        label: Text(l.recordsOpenDiscogs),
                        onPressed: () => launchUrl(
                          Uri.parse(d.discogsUrl!),
                          mode: LaunchMode.externalApplication,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: Theme.of(context).textTheme.titleMedium),
      );
}
