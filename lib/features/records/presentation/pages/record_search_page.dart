import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../data/services/records_api_service.dart';
import '../../domain/entities/album_record.dart';
import '../providers/records_provider.dart';
import 'records_page.dart' show RecordCover, recordFormatLabel;

class RecordSearchPage extends ConsumerStatefulWidget {
  /// true → los discos se añaden a la lista de deseos en vez de a la colección.
  final bool wishlist;

  const RecordSearchPage({super.key, this.wishlist = false});

  @override
  ConsumerState<RecordSearchPage> createState() => _RecordSearchPageState();
}

class _RecordSearchPageState extends ConsumerState<RecordSearchPage> {
  final _controller = TextEditingController();
  RecordFormat? _format;
  List<AlbumRecord>? _results;
  bool _loading = false;
  bool _failed = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final q = _controller.text.trim();
    if (q.isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      final res = await ref
          .read(recordsSearchServiceProvider)
          .search(q, format: _format);
      if (mounted) setState(() => _results = res);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _add(AlbumRecord record) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(recordsProvider.notifier)
          .add(record.withStatus(
            widget.wishlist ? RecordStatus.wishlist : RecordStatus.owned,
          ));
      messenger.showSnackBar(SnackBar(content: Text(l.recordsAdded)));
    } on RecordAlreadyExistsException {
      messenger.showSnackBar(SnackBar(content: Text(l.recordsAlreadyAdded)));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l.recordsAddError)));
    }
  }

  Future<void> _addManual() async {
    final l = AppLocalizations.of(context);
    final title = TextEditingController();
    final artist = TextEditingController();
    var format = RecordFormat.vinyl;

    final record = await showDialog<AlbumRecord>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text(l.recordsAddManual),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: title,
                decoration: InputDecoration(labelText: l.recordsTitleLabel),
              ),
              TextField(
                controller: artist,
                decoration: InputDecoration(labelText: l.recordsArtistLabel),
              ),
              const SizedBox(height: 12),
              SegmentedButton<RecordFormat>(
                segments: [
                  for (final f in RecordFormat.values)
                    ButtonSegment(value: f, label: Text(recordFormatLabel(l, f))),
                ],
                selected: {format},
                onSelectionChanged: (s) => setLocal(() => format = s.first),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l.cancel),
            ),
            TextButton(
              onPressed: () {
                if (title.text.trim().isEmpty || artist.text.trim().isEmpty) {
                  return;
                }
                Navigator.pop(
                  ctx,
                  AlbumRecord(
                    id: '',
                    title: title.text.trim(),
                    artist: artist.text.trim(),
                    format: format,
                  ),
                );
              },
              child: Text(l.save),
            ),
          ],
        ),
      ),
    );
    title.dispose();
    artist.dispose();
    if (record != null) await _add(record);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final owned = ref
            .watch(recordsProvider)
            .value
            ?.map((r) => r.discogsId)
            .whereType<int>()
            .toSet() ??
        const <int>{};

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.wishlist ? l.recordsSearchWishlistTitle : l.recordsSearchTitle,
        ),
        actions: [
          TextButton(onPressed: _addManual, child: Text(l.recordsAddManual)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _search(),
              decoration: InputDecoration(
                hintText: l.recordsSearchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: _search,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: Text(l.recordsFormatAll),
                    selected: _format == null,
                    onSelected: (_) => setState(() => _format = null),
                  ),
                  for (final f in [RecordFormat.vinyl, RecordFormat.cd])
                    ChoiceChip(
                      label: Text(recordFormatLabel(l, f)),
                      selected: _format == f,
                      onSelected: (_) => setState(() => _format = f),
                    ),
                ],
              ),
            ),
          ),
          Expanded(child: _body(l, owned)),
        ],
      ),
    );
  }

  Widget _body(AppLocalizations l, Set<int> owned) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_failed) return Center(child: Text(l.recordsSearchError));
    final results = _results;
    if (results == null) {
      return Center(child: Text(l.recordsSearchPrompt));
    }
    if (results.isEmpty) return Center(child: Text(l.recordsSearchEmpty));

    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (_, _) => const Divider(height: 1, indent: 88),
      itemBuilder: (_, i) {
        final r = results[i];
        final isOwned = r.discogsId != null && owned.contains(r.discogsId);
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: RecordCover(url: r.coverUrl, size: 56),
          ),
          title: Text(r.title, maxLines: 2, overflow: TextOverflow.ellipsis),
          subtitle: Text(
            [
              r.artist,
              recordFormatLabel(l, r.format),
              if (r.year != null) '${r.year}',
              if (r.country != null) r.country!,
            ].where((s) => s.isNotEmpty).join(' · '),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: isOwned
              ? const Icon(Icons.check_circle, color: Colors.green)
              : IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: l.add,
                  onPressed: () => _add(r),
                ),
        );
      },
    );
  }
}
