import 'dart:async';

import 'package:conciertos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/app_shell.dart';
import '../../../friends/presentation/widgets/friend_avatar.dart';
import '../../data/services/admin_api_service.dart';

class AdminUsersTab extends StatefulWidget {
  const AdminUsersTab({super.key});

  @override
  State<AdminUsersTab> createState() => _AdminUsersTabState();
}

class _AdminUsersTabState extends State<AdminUsersTab>
    with AutomaticKeepAliveClientMixin {
  final _api = AdminApiService();
  final _search = TextEditingController();
  Timer? _debounce;

  final List<AdminUser> _users = [];
  int _total = 0;
  bool _loading = true;
  bool _loadingMore = false;
  bool _error = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final query = _search.text;
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final page = await _api.listUsers(q: query);
      if (!mounted || query != _search.text) return;
      setState(() {
        _users
          ..clear()
          ..addAll(page.items);
        _total = page.total;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore || _users.length >= _total) return;
    final query = _search.text;
    setState(() => _loadingMore = true);
    try {
      final page = await _api.listUsers(q: query, skip: _users.length);
      if (!mounted || query != _search.text) return;
      setState(() => _users.addAll(page.items));
    } catch (_) {
      // el usuario puede reintentar pulsando de nuevo
    } finally {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  void _onSearchChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _load);
  }

  Future<void> _togglePro(AdminUser user) async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final next = !user.isPro;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(next ? l.adminMakePro : l.adminRemovePro),
        content: Text(
          next
              ? l.adminMakeProConfirm(user.name)
              : l.adminRemoveProConfirm(user.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.adminConfirm),
          ),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await _api.setPro(user.id, next);
      if (!mounted) return;
      setState(() {
        final i = _users.indexWhere((u) => u.id == user.id);
        if (i >= 0) _users[i] = _users[i].copyWith(isPro: next);
      });
      messenger.showSnackBar(SnackBar(content: Text(l.adminProChanged)));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l.adminActionError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).languageCode;
    final dateFmt = DateFormat.yMMMd(locale);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: TextField(
            controller: _search,
            onChanged: _onSearchChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: l.adminSearchHint,
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l.adminUsersCount(_total),
              style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
            ),
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(l.adminLoadError),
                          const SizedBox(height: 12),
                          OutlinedButton(
                            onPressed: _load,
                            child: Text(l.adminRetry),
                          ),
                        ],
                      ),
                    )
                  : _users.isEmpty
                      ? Center(child: Text(l.adminNoUsers))
                      : ListView.separated(
                          padding: EdgeInsets.only(
                            bottom: 16 + floatingNavBarClearance(context),
                          ),
                          itemCount: _users.length + 1,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, i) {
                            if (i == _users.length) {
                              if (_users.length >= _total) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.all(12),
                                child: Center(
                                  child: _loadingMore
                                      ? const CircularProgressIndicator()
                                      : OutlinedButton(
                                          onPressed: _loadMore,
                                          child: Text(l.adminLoadMore),
                                        ),
                                ),
                              );
                            }
                            final u = _users[i];
                            return ListTile(
                              leading: FriendAvatar(
                                name: u.name,
                                avatarUrl: u.avatarUrl,
                                radius: 20,
                              ),
                              title: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      u.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (u.isPro) ...[
                                    const SizedBox(width: 6),
                                    const _Badge('PRO', Color(0xFFE53935)),
                                  ],
                                  if (u.isAdmin) ...[
                                    const SizedBox(width: 6),
                                    const _Badge('ADMIN', Colors.blueGrey),
                                  ],
                                ],
                              ),
                              subtitle: Text(
                                '${u.email}\n${l.adminUserMeta(u.concertCount, dateFmt.format(u.createdAt.toLocal()))}',
                              ),
                              isThreeLine: true,
                              trailing: IconButton(
                                tooltip: u.isPro
                                    ? l.adminRemovePro
                                    : l.adminMakePro,
                                icon: Icon(
                                  u.isPro
                                      ? Icons.star_rounded
                                      : Icons.star_outline_rounded,
                                  color: u.isPro
                                      ? const Color(0xFFE53935)
                                      : null,
                                ),
                                onPressed: () => _togglePro(u),
                              ),
                            );
                          },
                        ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  const _Badge(this.text, this.color);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .15),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      );
}
