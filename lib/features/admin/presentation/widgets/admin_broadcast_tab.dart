import 'package:conciertos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../app/app_shell.dart';
import '../../data/services/admin_api_service.dart';

class AdminBroadcastTab extends StatefulWidget {
  const AdminBroadcastTab({super.key});

  @override
  State<AdminBroadcastTab> createState() => _AdminBroadcastTabState();
}

class _AdminBroadcastTabState extends State<AdminBroadcastTab>
    with AutomaticKeepAliveClientMixin {
  final _api = AdminApiService();
  final _title = TextEditingController();
  final _body = TextEditingController();
  String _audience = 'all';
  bool _inApp = true;
  bool _sending = false;
  String? _target; // destino al tocar el aviso; null = solo abrir la app

  // Filtro por versión instalada
  bool _onlyOutdated = false;
  List<AppVersionCount> _builds = []; // solo los que tienen build conocido
  int? _maxBuild;

  // Vista previa de alcance (no envía nada)
  BroadcastResult? _preview;
  bool _previewLoading = false;
  int _previewSeq = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadVersions();
    _refreshPreview();
  }

  Future<void> _loadVersions() async {
    try {
      final all = await _api.getVersions();
      if (!mounted) return;
      final known = all.where((v) => v.build != null).toList();
      setState(() {
        _builds = known;
        _maxBuild ??= known.isEmpty ? null : known.first.build;
      });
    } catch (_) {
      // sin versiones el filtro simplemente no está disponible
    }
  }

  int? get _effectiveMaxBuild => _onlyOutdated ? _maxBuild : null;

  Future<void> _refreshPreview() async {
    final seq = ++_previewSeq;
    setState(() => _previewLoading = true);
    try {
      final p = await _api.previewBroadcast(
        audience: _audience,
        maxBuild: _effectiveMaxBuild,
      );
      if (!mounted || seq != _previewSeq) return;
      setState(() {
        _preview = p;
        _previewLoading = false;
      });
    } catch (_) {
      if (!mounted || seq != _previewSeq) return;
      setState(() {
        _preview = null;
        _previewLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  bool get _valid =>
      _title.text.trim().isNotEmpty && _body.text.trim().isNotEmpty;

  void _useUpdateTemplate(AppLocalizations l) {
    setState(() {
      _title.text = l.adminTemplateUpdateTitle;
      _body.text = l.adminTemplateUpdateBody;
    });
  }

  String _audienceName(AppLocalizations l) => switch (_audience) {
        'pro' => l.adminAudiencePro,
        'free' => l.adminAudienceFree,
        _ => l.adminAudienceAll,
      };

  Future<void> _send() async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.adminConfirmTitle),
        content: Text(l.adminConfirmBody(
          _audienceName(l),
          _preview?.recipients ?? 0,
          _preview?.devices ?? 0,
        )),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.adminSend),
          ),
        ],
      ),
    );
    if (ok != true) return;

    setState(() => _sending = true);
    try {
      final r = await _api.broadcast(
        title: _title.text.trim(),
        body: _body.text.trim(),
        audience: _audience,
        inApp: _inApp,
        maxBuild: _effectiveMaxBuild,
        target: _target,
      );
      if (!mounted) return;
      _title.clear();
      _body.clear();
      messenger.showSnackBar(
        SnackBar(content: Text(l.adminSentOk(r.recipients, r.devices))),
      );
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l.adminSendError)));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;

    return ListView(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 + floatingNavBarClearance(context),
      ),
      children: [
        Text(
          l.adminBroadcastIntro,
          style: TextStyle(color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: ActionChip(
            avatar: const Icon(Icons.system_update_alt_rounded, size: 18),
            label: Text(l.adminTemplateUpdate),
            onPressed: _sending ? null : () => _useUpdateTemplate(l),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _title,
          maxLength: 80,
          enabled: !_sending,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: l.adminFieldTitle,
            border: const OutlineInputBorder(),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _body,
          maxLength: 300,
          maxLines: 4,
          enabled: !_sending,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: l.adminFieldBody,
            border: const OutlineInputBorder(),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        Text(
          l.adminAudienceLabel,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        SegmentedButton<String>(
          segments: [
            ButtonSegment(value: 'all', label: Text(l.adminAudienceAll)),
            ButtonSegment(value: 'pro', label: Text(l.adminAudiencePro)),
            ButtonSegment(value: 'free', label: Text(l.adminAudienceFree)),
          ],
          selected: {_audience},
          onSelectionChanged: _sending
              ? null
              : (v) {
                  setState(() => _audience = v.first);
                  _refreshPreview();
                },
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _onlyOutdated,
          onChanged: (_sending || _builds.isEmpty)
              ? null
              : (v) {
                  setState(() => _onlyOutdated = v);
                  _refreshPreview();
                },
          title: Text(l.adminOnlyOutdatedSwitch),
          subtitle: Text(
            _builds.isEmpty ? l.adminNoVersionsYet : l.adminOnlyOutdatedHint,
          ),
        ),
        if (_onlyOutdated && _builds.isNotEmpty)
          DropdownButtonFormField<int>(
            initialValue: _maxBuild,
            decoration: InputDecoration(
              labelText: l.adminOutdatedBeforeLabel,
              border: const OutlineInputBorder(),
            ),
            items: _builds
                .map(
                  (v) => DropdownMenuItem(
                    value: v.build,
                    child: Text(l.adminVersionOption(v.version ?? '?', v.build!)),
                  ),
                )
                .toList(),
            onChanged: _sending
                ? null
                : (v) {
                    setState(() => _maxBuild = v);
                    _refreshPreview();
                  },
          ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String?>(
          initialValue: _target,
          decoration: InputDecoration(
            labelText: l.adminTargetLabel,
            border: const OutlineInputBorder(),
          ),
          items: [
            DropdownMenuItem(value: null, child: Text(l.adminTargetNone)),
            DropdownMenuItem(value: 'store', child: Text(l.adminTargetStore)),
            DropdownMenuItem(
              value: 'notifications',
              child: Text(l.adminTargetNotifications),
            ),
            DropdownMenuItem(value: 'friends', child: Text(l.adminTargetFriends)),
            DropdownMenuItem(
              value: 'statistics',
              child: Text(l.adminTargetStatistics),
            ),
            DropdownMenuItem(value: 'records', child: Text(l.adminTargetRecords)),
          ],
          onChanged: _sending ? null : (v) => setState(() => _target = v),
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _inApp,
          onChanged: _sending ? null : (v) => setState(() => _inApp = v),
          title: Text(l.adminInAppSwitch),
          subtitle: Text(l.adminInAppHint),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withValues(alpha: .5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.groups_rounded, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _previewLoading
                      ? l.adminPreviewLoading
                      : _preview == null
                          ? l.adminLoadError
                          : l.adminPreviewReach(
                              _preview!.recipients,
                              _preview!.devices,
                            ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: (_valid && !_sending && (_preview?.recipients ?? 0) > 0)
              ? _send
              : null,
          icon: _sending
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.campaign_rounded),
          label: Text(l.adminSend),
        ),
      ],
    );
  }
}
