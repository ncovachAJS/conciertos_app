import 'package:conciertos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../../shared/widgets/empty_state.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../data/models/app_notification_model.dart';
import '../controllers/notifications_controller.dart';
import '../../../../shared/widgets/skeletons/generic_page_skeleton.dart';
import '../../../friends/presentation/widgets/friend_avatar.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationsController _ctrl = NotificationsController.instance;

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(_rebuild);
    _ctrl.loadNotifications();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _ctrl.removeListener(_rebuild);
    super.dispose();
  }

  Future<void> _confirmDeleteAll() async {
    final l = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.deleteNotificationsTitle),
        content: Text(l.deleteNotificationsConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.deleteAll),
          ),
        ],
      ),
    );
    if (confirm == true) _ctrl.deleteAll();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.notificationsTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (_ctrl.notifications.isNotEmpty) ...[
            if (_ctrl.unreadCount > 0)
              TextButton(
                onPressed: _ctrl.markAllRead,
                child: Text(l.markRead),
              ),
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: l.deleteAll,
              onPressed: _confirmDeleteAll,
            ),
          ],
        ],
      ),
      body: _ctrl.loading
          ? const GenericPageSkeleton(itemCount: 5)
          : _ctrl.notifications.isEmpty
          ? EmptyState(
              emoji: '🔔',
              title: l.noNotifications,
              subtitle: 'Aquí aparecerán tus avisos y actividad de amigos',
            )
          : ListView.separated(
              itemCount: _ctrl.notifications.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final n = _ctrl.notifications[i];
                return Dismissible(
                  key: ValueKey(n.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red.shade700,
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (_) => _ctrl.deleteOne(n.id),
                  child: _NotificationTile(
                    notification: n,
                    onTap: () => _onTap(n),
                  ),
                );
              },
            ),
    );
  }

  void _onTap(AppNotificationModel n) {
    if (!n.read) _ctrl.markRead(n.id);
    final data = n.data ?? {};
    switch (n.type) {
      case 'CONCERT_TAG':
      case 'FRIEND_CONCERT':
      case 'PHOTO_TAG':
        final concertId = data['concertId']?.toString();
        if (concertId != null) context.push('/concert-detail-by-id/$concertId');
        break;
      case 'CONCERT_COMMENT':
        final concertId = data['concertId']?.toString();
        if (concertId != null) {
          context.push(
            '/concert-detail-by-id/$concertId',
            extra: {'scrollToComments': true},
          );
        }
        break;
      case 'FRIEND_REQUEST':
      case 'FRIEND_ACCEPTED':
        context.push('/friends');
        break;
    }
  }
}

class _NotificationTile extends StatelessWidget {
  final AppNotificationModel notification;
  final VoidCallback onTap;

  const _NotificationTile({required this.notification, required this.onTap});

  IconData _icon() {
    switch (notification.type) {
      case 'CONCERT_TAG':
        return Icons.music_note_rounded;
      case 'PHOTO_TAG':
        return Icons.photo_camera_rounded;
      case 'FRIEND_REQUEST':
        return Icons.person_add_rounded;
      case 'FRIEND_ACCEPTED':
        return Icons.check_circle_rounded;
      case 'FRIEND_CONCERT':
        return Icons.queue_music_rounded;
      case 'CONCERT_COMMENT':
        return Icons.chat_bubble_outline_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const red = Color(0xFFE53935);
    final unread = !notification.read;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: unread ? red.withOpacity(0.06) : null,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            notification.sender != null
                ? FriendAvatar(
                    name: notification.sender!.name,
                    avatarUrl: notification.sender!.avatarUrl,
                    radius: 22,
                  )
                : CircleAvatar(
                    radius: 22,
                    backgroundColor: red.withOpacity(0.12),
                    child: Icon(_icon(), color: red, size: 20),
                  ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: unread ? FontWeight.bold : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notification.body,
                    style: TextStyle(
                      fontSize: 13,
                      color: cs.onSurface.withOpacity(0.6),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeago.format(notification.createdAt, locale: 'es'),
                    style: TextStyle(
                      fontSize: 11,
                      color: cs.onSurface.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),

            if (unread)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 8),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
