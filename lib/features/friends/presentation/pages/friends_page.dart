import 'package:flutter/material.dart';

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
    showSearch(context: context, delegate: _FriendSearchDelegate(_ctrl));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const red = Color(0xFFE53935);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Amigos'),
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_search_rounded),
            tooltip: 'Buscar personas',
            onPressed: _openSearch,
          ),
        ],
        bottom: TabBar(
          controller: _tabs,
          labelColor: red,
          unselectedLabelColor: cs.onSurface.withOpacity(0.5),
          indicatorColor: red,
          tabs: [
            Tab(text: 'Amigos (${_ctrl.friends.length})'),
            Tab(
              text: _ctrl.pendingRequests.isEmpty
                  ? 'Solicitudes'
                  : 'Solicitudes (${_ctrl.pendingRequests.length})',
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

  _FriendSearchDelegate(this.ctrl);

  @override
  String get searchFieldLabel => 'Buscar por nombre o email...';

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
                  'Escribe al menos 2 caracteres',
                  style: TextStyle(color: cs.onSurface.withOpacity(0.4)),
                ),
              ],
            ),
          );
        }

        if (ctrl.searchResults.isEmpty) {
          return Center(
            child: Text(
              'No se encontraron usuarios',
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

    Widget trailing;
    if (user.isAccepted) {
      trailing = const Text(
        'Amigo ✓',
        style: TextStyle(
          color: Color(0xFFE53935),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      );
    } else if (user.isPending) {
      trailing = user.isSender == true
          ? Text(
              'Enviada',
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
                child: const Text(
                  'Aceptar',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
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
          child: const Text(
            'Añadir',
            style: TextStyle(
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
              'Aún no tienes amigos.\nBúscalos con el icono de arriba.',
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
          trailing: IconButton(
            icon: Icon(
              Icons.person_remove_outlined,
              color: cs.onSurface.withOpacity(0.4),
            ),
            tooltip: 'Eliminar amigo',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Eliminar amigo'),
                  content: Text('¿Seguro que quieres eliminar a ${f.name}?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancelar'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Eliminar'),
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
    final cs = Theme.of(context).colorScheme;

    if (ctrl.pendingRequests.isEmpty) {
      return Center(
        child: Text(
          'No tienes solicitudes pendientes.',
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
          subtitle: const Text('Quiere ser tu amigo'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFFE53935),
                ),
                tooltip: 'Aceptar',
                onPressed: () => ctrl.acceptRequest(r.friendshipId!, r.id),
              ),
              IconButton(
                icon: Icon(
                  Icons.cancel_outlined,
                  color: cs.onSurface.withOpacity(0.4),
                ),
                tooltip: 'Rechazar',
                onPressed: () => ctrl.removeFriend(r.friendshipId!),
              ),
            ],
          ),
        );
      },
    );
  }
}
