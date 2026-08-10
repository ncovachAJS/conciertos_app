import 'package:flutter/material.dart';
import 'package:conciertos_app/l10n/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/tutorial/tutorial_content.dart';
import '../../../../core/tutorial/tutorial_overlay.dart';
import '../../../../core/tutorial/tutorial_service.dart';
import '../../data/models/friend_model.dart';
import '../controllers/friends_controller.dart';
import '../widgets/friend_avatar.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage>
    with SingleTickerProviderStateMixin {
  final FriendsController _ctrl = FriendsController.instance;
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _ctrl.addListener(_rebuild);
    _ctrl.loadFriends();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _showTutorialIfNeeded(),
    );
  }

  Future<void> _showTutorialIfNeeded() async {
    final should = await TutorialService.shouldShow(TutorialService.friends);
    if (!should || !mounted) return;
    await TutorialService.markShown(TutorialService.friends);
    if (!mounted) return;
    await TutorialOverlay.show(
      context,
      steps: TutorialContent.friends(AppLocalizations.of(context)),
    );
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _tabs.dispose();
    _ctrl.removeListener(_rebuild);
    super.dispose();
  }

  void _openSearch() {
    final l = AppLocalizations.of(context);
    showSearch(
      context: context,
      delegate: _FriendSearchDelegate(_ctrl, searchHint: l.searchFriendHint),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const red = Color(0xFFE53935);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).friendsTitle),
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.dynamic_feed_rounded),
            tooltip: 'Actividad de amigos',
            onPressed: () => context.push('/friends-activity'),
          ),
          IconButton(
            icon: const Icon(Icons.person_search_rounded),
            tooltip: AppLocalizations.of(context).friendsSearchPeople,
            onPressed: _openSearch,
          ),
        ],
        bottom: TabBar(
          controller: _tabs,
          labelColor: red,
          unselectedLabelColor: cs.onSurface.withOpacity(0.5),
          indicatorColor: red,
          tabs: [
            Tab(text: AppLocalizations.of(context).friendsTabFriends(_ctrl.friends.length)),
            Tab(
              text: _ctrl.pendingRequests.isEmpty
                  ? AppLocalizations.of(context).friendsTabRequests
                  : AppLocalizations.of(context).friendsTabRequestsCount(_ctrl.pendingRequests.length),
            ),
          ],
        ),
      ),
      body: _ctrl.loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabs,
              children: [
                _FriendsList(ctrl: _ctrl),
                _PendingList(ctrl: _ctrl),
              ],
            ),
    );
  }
}

// ── SearchDelegate — maneja foco, teclado y resultados correctamente ────────

class _FriendSearchDelegate extends SearchDelegate<void> {
  final FriendsController ctrl;
  final String searchHint;

  _FriendSearchDelegate(this.ctrl, {required this.searchHint});

  @override
  String get searchFieldLabel => searchHint;

  @override
  List<Widget> buildActions(BuildContext context) => [
    if (query.isNotEmpty)
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          query = '';
          ctrl.clearSearch();
          showSuggestions(context);
        },
      ),
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back_ios_new_rounded),
    onPressed: () {
      ctrl.clearSearch();
      close(context, null);
    },
  );

  @override
  Widget buildResults(BuildContext context) => _buildList(context);

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.trim().length >= 2) {
      // Diferir para no llamar a notifyListeners durante el build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ctrl.search(query.trim());
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ctrl.clearSearch();
      });
    }
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: ctrl,
      builder: (_, __) {
        if (ctrl.searching) {
          return const Center(child: CircularProgressIndicator());
        }

        if (query.trim().length < 2) {
          final l = AppLocalizations.of(context);
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.person_search_rounded,
                  size: 64,
                  color: cs.onSurface.withOpacity(0.15),
                ),
                const SizedBox(height: 16),
                Text(
                  l.friendsTypeToSearch,
                  style: TextStyle(color: cs.onSurface.withOpacity(0.4)),
                ),
              ],
            ),
          );
        }

        if (ctrl.searchResults.isEmpty) {
          return Center(
            child: Text(
              AppLocalizations.of(context).friendsNoUsersFound,
              style: TextStyle(color: cs.onSurface.withOpacity(0.4)),
            ),
          );
        }

        return ListView.builder(
          itemCount: ctrl.searchResults.length,
          itemBuilder: (_, i) =>
              _SearchResultTile(user: ctrl.searchResults[i], ctrl: ctrl),
        );
      },
    );
  }
}

// ── Resultado de búsqueda ──────────────────────────────────────────────────

class _SearchResultTile extends StatelessWidget {
  final FriendModel user;
  final FriendsController ctrl;
  const _SearchResultTile({required this.user, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const red = Color(0xFFE53935);

    final l = AppLocalizations.of(context);
    Widget trailing;
    if (user.isAccepted) {
      trailing = Text(
        l.friendAlreadyFriend,
        style: const TextStyle(
          color: Color(0xFFE53935),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      );
    } else if (user.isPending) {
      trailing = user.isSender == true
          ? Text(
              l.friendRequestSent,
              style: TextStyle(
                color: cs.onSurface.withOpacity(0.5),
                fontSize: 12,
              ),
            )
          : GestureDetector(
              onTap: () => ctrl.acceptRequest(user.friendshipId!, user.id),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  l.friendAccept,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
    } else {
      trailing = GestureDetector(
        onTap: () => ctrl.sendRequest(user.id),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE53935),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            l.friendAdd,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return ListTile(
      leading: FriendAvatar(
        name: user.name,
        avatarUrl: user.avatarUrl,
        radius: 22,
      ),
      title: Text(
        user.name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        user.email,
        style: TextStyle(color: cs.onSurface.withOpacity(0.5), fontSize: 12),
      ),
      trailing: trailing,
    );
  }
}

// ── Lista de amigos ────────────────────────────────────────────────────────

class _FriendsList extends StatelessWidget {
  final FriendsController ctrl;
  const _FriendsList({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;

    if (ctrl.friends.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.group_outlined,
              size: 64,
              color: cs.onSurface.withOpacity(0.15),
            ),
            const SizedBox(height: 16),
            Text(
              l.friendsNoFriendsHere,
              textAlign: TextAlign.center,
              style: TextStyle(color: cs.onSurface.withOpacity(0.4)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: ctrl.friends.length,
      itemBuilder: (_, i) {
        final f = ctrl.friends[i];
        return ListTile(
          leading: FriendAvatar(
            name: f.name,
            avatarUrl: f.avatarUrl,
            radius: 22,
          ),
          title: Text(
            f.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          onTap: () => context.push('/friend-profile', extra: f),
          trailing: IconButton(
            icon: Icon(
              Icons.person_remove_outlined,
              color: cs.onSurface.withOpacity(0.4),
            ),
            tooltip: l.deleteFriendTitle,
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(l.deleteFriendTitle),
                  content: Text(l.friendDeleteConfirm(f.name)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(l.cancel),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(l.delete),
                    ),
                  ],
                ),
              );
              if (confirm == true) ctrl.removeFriend(f.friendshipId!);
            },
          ),
        );
      },
    );
  }
}

// ── Solicitudes pendientes ─────────────────────────────────────────────────

class _PendingList extends StatelessWidget {
  final FriendsController ctrl;
  const _PendingList({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;

    if (ctrl.pendingRequests.isEmpty) {
      return Center(
        child: Text(
          l.friendsNoPendingRequests,
          style: TextStyle(color: cs.onSurface.withOpacity(0.4)),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: ctrl.pendingRequests.length,
      itemBuilder: (_, i) {
        final r = ctrl.pendingRequests[i];
        return ListTile(
          leading: FriendAvatar(
            name: r.name,
            avatarUrl: r.avatarUrl,
            radius: 22,
          ),
          title: Text(
            r.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(l.friendRequestReceived),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFFE53935),
                ),
                tooltip: l.friendAccept,
                onPressed: () => ctrl.acceptRequest(r.friendshipId!, r.id),
              ),
              IconButton(
                icon: Icon(
                  Icons.cancel_outlined,
                  color: cs.onSurface.withOpacity(0.4),
                ),
                tooltip: l.friendReject,
                onPressed: () => ctrl.removeFriend(r.friendshipId!),
              ),
            ],
          ),
        );
      },
    );
  }
}
