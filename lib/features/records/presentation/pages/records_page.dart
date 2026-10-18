import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_shell.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/album_record.dart';
import '../providers/records_provider.dart';

String recordFormatLabel(AppLocalizations l, RecordFormat f) => switch (f) {
      RecordFormat.vinyl => l.recordsFormatVinyl,
      RecordFormat.cd => l.recordsFormatCd,
      RecordFormat.other => l.recordsFormatOther,
    };

class RecordsPage extends ConsumerStatefulWidget {
  const RecordsPage({super.key});

  @override
  ConsumerState<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends ConsumerState<RecordsPage> {
  RecordFormat? _filter; // null = todos
  bool _wishlist = false; // false = colección, true = lista de deseos

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final records = ref.watch(recordsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.recordsTitle)),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: floatingNavBarClearance(context)),
        child: FloatingActionButton(
          onPressed: () => context.push(
            _wishlist ? '/records/search?wishlist=1' : '/records/search',
          ),
          child: const Icon(Icons.add),
        ),
      ),
      body: records.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l.recordsLoadError),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => ref.invalidate(recordsProvider),
                child: Text(l.retry),
              ),
            ],
          ),
        ),
        data: (_) {
          final all = _wishlist
              ? ref.watch(wishlistRecordsProvider)
              : ref.watch(ownedRecordsProvider);
          final list = _filter == null
              ? all
              : all.where((r) => r.format == _filter).toList();
          final spent = list.fold<double>(0, (sum, r) => sum + (r.price ?? 0));
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<bool>(
                    segments: [
                      ButtonSegment(
                        value: false,
                        icon: const Icon(Icons.album_outlined),
                        label: Text(l.recordsTabCollection),
                      ),
                      ButtonSegment(
                        value: true,
                        icon: const Icon(Icons.bookmark_border),
                        label: Text(l.recordsTabWishlist),
                      ),
                    ],
                    selected: {_wishlist},
                    onSelectionChanged: (s) =>
                        setState(() => _wishlist = s.first),
                  ),
                ),
              ),
              _FilterBar(
                selected: _filter,
                onChanged: (f) => setState(() => _filter = f),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    [
                      l.recordsCount(list.length),
                      if (spent > 0) l.recordsSpent(spent.toStringAsFixed(2)),
                    ].join(' · '),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
              Expanded(
                child: all.isEmpty
                    ? _EmptyState(
                        title: _wishlist
                            ? l.recordsWishlistEmpty
                            : l.recordsEmpty,
                        hint: _wishlist
                            ? l.recordsWishlistEmptyHint
                            : l.recordsEmptyHint,
                      )
                    : GridView.builder(
                        padding: EdgeInsets.fromLTRB(
                          16,
                          12,
                          16,
                          floatingNavBarClearance(context) + 72,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 180,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: list.length,
                        itemBuilder: (_, i) => _RecordTile(record: list[i]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final RecordFormat? selected;
  final ValueChanged<RecordFormat?> onChanged;

  const _FilterBar({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Wrap(
        spacing: 8,
        children: [
          ChoiceChip(
            label: Text(l.recordsFormatAll),
            selected: selected == null,
            onSelected: (_) => onChanged(null),
          ),
          for (final f in [RecordFormat.vinyl, RecordFormat.cd])
            ChoiceChip(
              label: Text(recordFormatLabel(l, f)),
              selected: selected == f,
              onSelected: (_) => onChanged(f),
            ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String hint;

  const _EmptyState({required this.title, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.album_outlined, size: 64, color: Theme.of(context).hintColor),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(hint, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class RecordCover extends StatelessWidget {
  final String? url;
  final double? size;

  const RecordCover({super.key, required this.url, this.size});

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: size,
      height: size,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Icon(Icons.album_outlined),
    );
    if (url == null || url!.isEmpty) return placeholder;
    return CachedNetworkImage(
      imageUrl: url!,
      width: size,
      height: size,
      fit: BoxFit.cover,
      placeholder: (_, _) => placeholder,
      errorWidget: (_, _, _) => placeholder,
    );
  }
}

class _RecordTile extends ConsumerWidget {
  final AlbumRecord record;

  const _RecordTile({required this.record});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => context.push('/record/${record.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: RecordCover(url: record.coverUrl),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            record.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(
            [
              record.artist,
              recordFormatLabel(l, record.format),
              if (record.year != null) '${record.year}',
            ].join(' · '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

/// Pide confirmación y borra el disco. Devuelve true si se borró.
Future<bool> confirmDeleteRecord(
  BuildContext context,
  WidgetRef ref,
  AlbumRecord record,
) async {
  final l = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l.recordsDeleteTitle),
      content: Text(l.recordsDeleteConfirm(record.title)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l.delete),
        ),
      ],
    ),
  );
  if (ok != true) return false;
  try {
    await ref.read(recordsProvider.notifier).remove(record.id);
    return true;
  } catch (_) {
    messenger.showSnackBar(SnackBar(content: Text(l.error)));
    return false;
  }
}
