import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/cloudinary_utils.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/app_page.dart';
import '../../../concerts/domain/entities/concert.dart';
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
        loading: () => const Center(child: CircularProgressIndicator()),
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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dateStr = DateFormat('d MMM yyyy', 'es').format(concert.date);

    return InkWell(
      onTap: () => context.push('/concert-detail', extra: concert),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                          backgroundImage: NetworkImage(concert.userAvatarUrl),
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
                          concert.userName.isNotEmpty ? concert.userName : 'Amigo',
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
