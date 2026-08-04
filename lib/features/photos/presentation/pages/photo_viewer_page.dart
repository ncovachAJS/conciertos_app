import 'package:conciertos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../friends/data/services/friends_api_service.dart';
import '../../../friends/presentation/widgets/friend_avatar.dart';
import '../../../friends/presentation/widgets/tag_friends_selector.dart';
import '../../data/models/concert_photo_model.dart';
import '../../domain/entities/concert_photo.dart';
import '../widgets/network_photo.dart';

class PhotoViewerPage extends StatefulWidget {
  final List<ConcertPhotoModel> photos;
  final int initialIndex;
  final Future<void> Function(ConcertPhoto)? onDelete;
  final Future<ConcertPhotoModel?> Function(ConcertPhoto, String friendId)?
  onTagFriend;
  final Future<ConcertPhotoModel?> Function(ConcertPhoto, String friendId)?
  onUntagFriend;

  const PhotoViewerPage({
    super.key,
    required this.photos,
    this.initialIndex = 0,
    this.onDelete,
    this.onTagFriend,
    this.onUntagFriend,
  });

  @override
  State<PhotoViewerPage> createState() => _PhotoViewerPageState();
}

class _PhotoViewerPageState extends State<PhotoViewerPage> {
  late final PageController _pageController;
  late int _currentIndex;
  late List<ConcertPhotoModel> _photos;

  @override
  void initState() {
    super.initState();
    _photos = List.from(widget.photos);
    // Acotamos por si nos llega un índice fuera de rango: un initialPage
    // inválido deja el PageView en blanco sin error visible.
    _currentIndex = _photos.isEmpty
        ? 0
        : widget.initialIndex.clamp(0, _photos.length - 1);
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  ConcertPhotoModel get _current => _photos[_currentIndex];

  Future<void> _confirmDelete() async {
    final l = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.deletePhotoTitle),
        content: Text(l.deletePhotoConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.delete),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await widget.onDelete?.call(_current);
    if (mounted) Navigator.pop(context, _current.id);
  }

  Future<void> _showTagSheet() async {
    final photo = _current;
    final taggedIds = photo.participants.map((p) => p.id).toList();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).tagPeople,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TagFriendsSelector(
              initialSelectedIds: taggedIds,
              isPast: true,
              onChanged: (newIds) async {
                for (final id in newIds) {
                  if (!taggedIds.contains(id)) {
                    final updated = await widget.onTagFriend?.call(photo, id);
                    taggedIds.add(id);
                    if (updated != null && mounted) {
                      setState(() {
                        final idx = _photos.indexWhere(
                          (x) => x.id == updated.id,
                        );
                        if (idx != -1) _photos[idx] = updated;
                      });
                    }
                  }
                }
                for (final id in List.from(taggedIds)) {
                  if (!newIds.contains(id)) {
                    final updated = await widget.onUntagFriend?.call(photo, id);
                    taggedIds.remove(id);
                    if (updated != null && mounted) {
                      setState(() {
                        final idx = _photos.indexWhere(
                          (x) => x.id == updated.id,
                        );
                        if (idx != -1) _photos[idx] = updated;
                      });
                    }
                  }
                }
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(AppLocalizations.of(context).done),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final total = _photos.length;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: total > 1
            ? Text(
                '${_currentIndex + 1} / $total',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              )
            : null,
        centerTitle: true,
        actions: [
          if (widget.onTagFriend != null)
            IconButton(
              icon: const Icon(Icons.person_add_outlined, color: Colors.white),
              tooltip: l.tag,
              onPressed: _showTagSheet,
            ),
          if (widget.onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white),
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: total,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemBuilder: (_, i) {
                final photo = _photos[i];
                return InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 5,
                  child: Center(
                    child: Hero(
                      tag: photo.id,
                      child: NetworkPhoto(
                        url: photo.imageUrl,
                        fit: BoxFit.contain,
                        loaderSize: 32,
                        errorIconSize: 80,
                        memCacheWidth: null, // resolución completa en el viewer
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Participantes etiquetados
          if (_current.participants.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              color: Colors.black,
              child: Row(
                children: [
                  const Icon(Icons.person_pin, color: Colors.white54, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      children: _current.participants
                          .map(
                            (p) => Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FriendAvatar(
                                  name: p.name,
                                  avatarUrl: p.avatarUrl,
                                  radius: 10,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  p.name.split(' ').first,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),

          // Caption
          if (_current.caption.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              color: Colors.black,
              child: Text(
                _current.caption,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),

          // Indicadores
          if (total > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 24, top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(total, (i) {
                  final active = i == _currentIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: active ? 10 : 6,
                    height: active ? 10 : 6,
                    decoration: BoxDecoration(
                      color: active ? Colors.white : Colors.white38,
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
