import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/cloudinary_utils.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/app_page.dart';
import '../../../../shared/widgets/skeletons/generic_page_skeleton.dart';
import '../../../concerts/domain/entities/concert.dart';
import '../../data/concert_comments_service.dart';
import '../../domain/concert_comment.dart';
import '../providers/friends_activity_provider.dart';

class FriendsActivityPage extends ConsumerStatefulWidget {
  const FriendsActivityPage({super.key});

  @override
  ConsumerState<FriendsActivityPage> createState() => _FriendsActivityPageState();
}

class _FriendsActivityPageState extends ConsumerState<FriendsActivityPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      ref.read(friendsActivityProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final activityAsync = ref.watch(friendsActivityProvider);
    final cs = Theme.of(context).colorScheme;

    return AppPage(
      title: 'Actividad de amigos',
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          tooltip: 'Actualizar',
          onPressed: () => ref.read(friendsActivityProvider.notifier).reload(),
        ),
      ],
      child: activityAsync.when(
        loading: () => const GenericPageSkeleton(itemCount: 7),
        error: (e, _) => AppErrorWidget(
          error: e,
          onRetry: () => ref.invalidate(friendsActivityProvider),
        ),
        data: (concerts) {
          if (concerts.isEmpty) {
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
                    'Tus amigos no han agregado\nconciertos todavía',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: cs.onSurface.withOpacity(0.4),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            );
          }

          final notifier = ref.read(friendsActivityProvider.notifier);
          return ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 32),
            itemCount: concerts.length + (notifier.loadingMore ? 1 : 0),
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              if (i == concerts.length) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return _ActivityCard(concert: concerts[i]);
            },
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _ActivityCard extends StatelessWidget {
  final Concert concert;
  const _ActivityCard({required this.concert});

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CommentsSheet(concertId: concert.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dateStr = DateFormat('d MMM yyyy', 'es').format(concert.date);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => context.push('/concert-detail', extra: concert),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Foto del concierto
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: concert.imageUrl.isNotEmpty
                      ? Image.network(
                          cloudinaryThumbnail(concert.imageUrl, width: 80),
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholder(cs),
                        )
                      : _placeholder(cs),
                ),
                const SizedBox(width: 14),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar + nombre del amigo
                      Row(
                        children: [
                          if (concert.userAvatarUrl.isNotEmpty)
                            CircleAvatar(
                              radius: 10,
                              backgroundImage:
                                  NetworkImage(concert.userAvatarUrl),
                            )
                          else
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: cs.primaryContainer,
                              child: Text(
                                concert.userName.isNotEmpty
                                    ? concert.userName[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: cs.onPrimaryContainer,
                                ),
                              ),
                            ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              concert.userName.isNotEmpty
                                  ? concert.userName
                                  : 'Amigo',
                              style: TextStyle(
                                fontSize: 12,
                                color: cs.onSurface.withOpacity(0.55),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        concert.artist,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (concert.name.isNotEmpty)
                        Text(
                          concert.name,
                          style: TextStyle(
                            fontSize: 13,
                            color: cs.onSurface.withOpacity(0.65),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 12,
                            color: cs.onSurface.withOpacity(0.4),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            dateStr,
                            style: TextStyle(
                              fontSize: 12,
                              color: cs.onSurface.withOpacity(0.4),
                            ),
                          ),
                          if (concert.city.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Icon(
                              Icons.location_on_outlined,
                              size: 12,
                              color: cs.onSurface.withOpacity(0.4),
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                concert.city,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: cs.onSurface.withOpacity(0.4),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (concert.rating > 0) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: List.generate(
                            5,
                            (i) => Icon(
                              i < concert.rating
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              size: 14,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, size: 18),
              ],
            ),
          ),
        ),

        // ── Fila de acciones (comentarios) ───────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => _showComments(context),
                icon: Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 16,
                  color: cs.onSurface.withOpacity(0.5),
                ),
                label: Text(
                  'Comentar',
                  style: TextStyle(
                    fontSize: 12,
                    color: cs.onSurface.withOpacity(0.5),
                  ),
                ),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _placeholder(ColorScheme cs) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.music_note_rounded,
        color: cs.onSurface.withOpacity(0.2),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom sheet de comentarios
// ---------------------------------------------------------------------------

class _CommentsSheet extends StatefulWidget {
  final String concertId;
  const _CommentsSheet({required this.concertId});

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final _service = ConcertCommentsService();
  final _textController = TextEditingController();
  late Future<List<ConcertComment>> _commentsFuture;
  List<ConcertComment> _optimisticComments = [];
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _commentsFuture = _service.getComments(widget.concertId);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _send(List<ConcertComment> existing) async {
    final text = _textController.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    _textController.clear();
    try {
      final comment = await _service.addComment(widget.concertId, text);
      if (!mounted) return;
      if (comment != null) {
        setState(() => _optimisticComments = [...existing, ..._optimisticComments, comment]);
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.35,
      maxChildSize: 0.95,
      expand: false,
      builder: (ctx, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              const SizedBox(height: 12),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              // Título
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline_rounded),
                    const SizedBox(width: 10),
                    const Text(
                      'Comentarios',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),

              // Lista de comentarios
              Expanded(
                child: FutureBuilder<List<ConcertComment>>(
                  future: _commentsFuture,
                  builder: (ctx, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final fetched = snap.data ?? [];
                    final all = [...fetched, ..._optimisticComments];

                    if (all.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 48,
                              color: cs.onSurface.withOpacity(0.15),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Sé el primero en comentar',
                              style: TextStyle(
                                color: cs.onSurface.withOpacity(0.4),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      itemCount: all.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 12),
                      itemBuilder: (_, i) =>
                          _CommentTile(comment: all[i], cs: cs),
                    );
                  },
                ),
              ),

              // Campo de texto
              const Divider(height: 1),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  12 + MediaQuery.of(context).viewInsets.bottom,
                ),
                child: FutureBuilder<List<ConcertComment>>(
                  future: _commentsFuture,
                  builder: (ctx, snap) {
                    final fetched = snap.data ?? [];
                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            decoration: InputDecoration(
                              hintText: 'Escribe un comentario…',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              isDense: true,
                            ),
                            minLines: 1,
                            maxLines: 4,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _send(fetched),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _sending
                            ? const SizedBox(
                                width: 38,
                                height: 38,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2),
                              )
                            : IconButton.filled(
                                onPressed: () => _send(fetched),
                                icon: const Icon(Icons.send_rounded),
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xFFE53935),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.all(8),
                                ),
                              ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CommentTile extends StatelessWidget {
  final ConcertComment comment;
  final ColorScheme cs;

  const _CommentTile({required this.comment, required this.cs});

  @override
  Widget build(BuildContext context) {
    final timeStr = _formatTime(comment.createdAt);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        comment.userAvatarUrl.isNotEmpty
            ? CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(comment.userAvatarUrl),
              )
            : CircleAvatar(
                radius: 16,
                backgroundColor: cs.primaryContainer,
                child: Text(
                  comment.userName.isNotEmpty
                      ? comment.userName[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    fontSize: 12,
                    color: cs.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    comment.userName.isNotEmpty ? comment.userName : 'Usuario',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    timeStr,
                    style: TextStyle(
                      fontSize: 11,
                      color: cs.onSurface.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                comment.text,
                style: const TextStyle(fontSize: 14, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'ahora';
    if (diff.inMinutes < 60) return 'hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'hace ${diff.inHours} h';
    if (diff.inDays < 7) return 'hace ${diff.inDays} d';
    return DateFormat('d MMM', 'es').format(dt);
  }
}
