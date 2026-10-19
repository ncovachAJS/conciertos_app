import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../data/services/discogs_link_service.dart';
import '../providers/records_provider.dart';

final _discogsLinkServiceProvider = Provider((_) => DiscogsLinkService());

final discogsStatusProvider = FutureProvider.autoDispose<DiscogsStatus>(
  (ref) => ref.read(_discogsLinkServiceProvider).status(),
);

class DiscogsLinkPage extends ConsumerStatefulWidget {
  const DiscogsLinkPage({super.key});

  @override
  ConsumerState<DiscogsLinkPage> createState() => _DiscogsLinkPageState();
}

class _DiscogsLinkPageState extends ConsumerState<DiscogsLinkPage> {
  bool _busy = false;
  bool _importing = false;

  DiscogsLinkService get _service => ref.read(_discogsLinkServiceProvider);

  void _snack(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _connect() async {
    final l = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await _service.connect();
      ref.invalidate(discogsStatusProvider);
    } on DiscogsDeniedException {
      _snack(l.discogsDenied);
    } on PlatformException {
      // El usuario cerró la ventana de autorización
      _snack(l.discogsDenied);
    } catch (_) {
      _snack(l.discogsConnectError);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _import() async {
    final l = AppLocalizations.of(context);
    setState(() => _importing = true);
    try {
      final r = await _service.import();
      ref.invalidate(recordsProvider);
      _snack([
        l.discogsImportDone(r.collection, r.wishlist),
        if (r.skipped > 0) l.discogsImportSkipped(r.skipped),
      ].join(' · '));
    } catch (_) {
      _snack(l.discogsImportError);
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  Future<void> _disconnect() async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.discogsDisconnect),
        content: Text(l.discogsDisconnectConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.discogsDisconnect),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await _service.disconnect();
      ref.invalidate(discogsStatusProvider);
    } catch (_) {
      _snack(l.discogsConnectError);
    }
  }

  Widget _spinner() => const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2),
      );

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final status = ref.watch(discogsStatusProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.discogsTitle)),
      body: status.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l.discogsConnectError),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => ref.invalidate(discogsStatusProvider),
                child: Text(l.retry),
              ),
            ],
          ),
        ),
        data: (s) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Icon(Icons.album, size: 64),
            const SizedBox(height: 16),
            if (!s.connected) ...[
              Text(l.discogsIntro, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _busy ? null : _connect,
                icon: _busy ? _spinner() : const Icon(Icons.login),
                label: Text(l.discogsConnect),
              ),
            ] else ...[
              Text(
                l.discogsConnectedAs(s.username ?? ''),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                l.discogsImportHint,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _importing ? null : _import,
                icon: _importing ? _spinner() : const Icon(Icons.download),
                label: Text(_importing ? l.discogsImporting : l.discogsImport),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _importing ? null : _disconnect,
                child: Text(l.discogsDisconnect),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
