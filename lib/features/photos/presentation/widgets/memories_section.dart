import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:conciertos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/widgets/shimmer_box.dart';
import '../../../concerts/data/services/upload_service.dart';
import '../../../friends/presentation/widgets/friend_avatar.dart';
import '../../../friends/presentation/widgets/tag_friends_selector.dart';
import '../../data/models/concert_photo_model.dart';
import '../../data/services/photo_api_service.dart';
import '../pages/photo_viewer_page.dart';
import '../../../../core/utils/cloudinary_utils.dart';

class MemoriesSection extends StatefulWidget {
  final String concertId;
  final bool isPast;

  const MemoriesSection({
    super.key,
    required this.concertId,
    this.isPast = true,
  });

  @override
  State<MemoriesSection> createState() => _MemoriesSectionState();
}

class _MemoriesSectionState extends State<MemoriesSection> {
  final PhotoApiService _photoService = PhotoApiService();
  final UploadService _uploadService = UploadService();
  final ImagePicker _picker = ImagePicker();

  List<ConcertPhotoModel> _photos = [];
  bool _loading = true;
  bool _uploading = false;
  int _uploadCurrent = 0;
  int _uploadTotal = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final photos = await _photoService.getConcertPhotos(widget.concertId);
      if (!mounted) return;
      setState(() {
        _photos = photos;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _addPhotos() async {
    final images = await _picker.pickMultiImage(imageQuality: 95);
    if (images.isEmpty || !mounted) return;

    // Para una sola foto mostramos el diálogo con caption y etiquetas
    if (images.length == 1) {
      final result = await _askCaptionAndTags(File(images.first.path));
      if (result == null || !mounted) return;

      setState(() {
        _uploading = true;
        _uploadCurrent = 0;
        _uploadTotal = 1;
      });

      try {
        setState(() => _uploadCurrent = 1);
        final imageUrl = await _uploadService.uploadImage(images.first.path);
        final photo = await _photoService.addPhoto(
          concertId: widget.concertId,
          imageUrl: imageUrl,
          caption: result.$1,
          taggedFriendIds: result.$2,
        );
        if (!mounted) return;
        setState(() => _photos = [photo, ..._photos]);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).photoUploadError(e.toString()))));
      } finally {
        if (mounted)
          setState(() {
            _uploading = false;
            _uploadCurrent = 0;
            _uploadTotal = 0;
          });
      }
      return;
    }

    // Varias fotos — subimos en paralelo
    setState(() {
      _uploading = true;
      _uploadCurrent = 0;
      _uploadTotal = images.length;
    });

    final results = await Future.wait(
      images.map((image) async {
        try {
          final imageUrl = await _uploadService.uploadImage(image.path);
          final photo = await _photoService.addPhoto(
            concertId: widget.concertId,
            imageUrl: imageUrl,
          );
          if (mounted) setState(() => _uploadCurrent++);
          return photo;
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context).photoUploadError(e.toString()))),
            );
          }
          return null;
        }
      }),
    );

    if (!mounted) return;
    final newPhotos = results.whereType<ConcertPhotoModel>().toList();
    setState(() {
      _photos = [...newPhotos, ..._photos];
      _uploading = false;
      _uploadCurrent = 0;
      _uploadTotal = 0;
    });
  }

  // Devuelve (caption, taggedFriendIds) o null si se cancela
  Future<(String, List<String>)?> _askCaptionAndTags(File image) {
    final controller = TextEditingController();
    List<String> taggedIds = [];

    return showDialog<(String, List<String>)>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          title: Text(AppLocalizations.of(ctx).newMemory),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      image,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(ctx).captionHint,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TagFriendsSelector(
                    isPast: widget.isPast,
                    onChanged: (ids) => taggedIds = ids,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(AppLocalizations.of(ctx).cancel),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.pop(ctx, (controller.text.trim(), taggedIds)),
              child: Text(AppLocalizations.of(ctx).publish),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openPhoto(ConcertPhotoModel photo) async {
    final index = _photos.indexOf(photo);
    final deletedId = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => PhotoViewerPage(
          photos: _photos,
          initialIndex: index,
          onDelete: (p) async {
            await _photoService.deletePhoto(p.id);
          },
          onTagFriend: (p, friendId) async {
            debugPrint('🏷️ onTagFriend foto: ${p.id} friend: $friendId');
            return await _photoService.tagFriend(p.id, friendId);
          },
          onUntagFriend: (p, friendId) async {
            return await _photoService.untagFriend(p.id, friendId);
          },
        ),
      ),
    );

    if (deletedId != null && mounted) {
      setState(
        () => _photos = _photos.where((p) => p.id != deletedId).toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.photo_library_rounded,
                  color: Colors.redAccent,
                ),
                const SizedBox(width: 10),
                Text(
                  l.memoriesTitle,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _uploading ? null : _addPhotos,
                  icon: _uploading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add_a_photo_outlined, size: 20),
                  label: Text(
                    _uploading
                        ? l.uploadingPhotos(_uploadCurrent, _uploadTotal)
                        : l.add,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (_loading)
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 1,
                children: List.generate(
                  6,
                  (_) => const ShimmerFill(height: double.infinity, borderRadius: 0),
                ),
              )
            else if (_photos.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  l.noMemoriesShort,
                  style: TextStyle(
                    color: cs.onSurface.withOpacity(0.5),
                    fontSize: 15,
                  ),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _photos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  childAspectRatio: 1,
                ),
                itemBuilder: (_, index) {
                  final photo = _photos[index];
                  return GestureDetector(
                    onTap: () => _openPhoto(photo),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Hero(
                          tag: photo.id,
                          child: ClipRect(
                            child: SizedBox.expand(
                              child: CachedNetworkImage(
                                imageUrl: cloudinaryThumbnail(photo.imageUrl),
                                fit: BoxFit.cover,
                                memCacheWidth: 300,
                                fadeInDuration: Duration.zero,
                                fadeOutDuration: Duration.zero,
                                placeholder: (_, __) => Container(
                                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                ),
                                errorWidget: (_, __, ___) => Container(
                                  color: const Color(0xFF2B2B2B),
                                  child: const Icon(Icons.broken_image_outlined, color: Colors.white24),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Badge de etiquetas
                        if (photo.participants.isNotEmpty)
                          Positioned(
                            bottom: 4,
                            left: 4,
                            child: Row(
                              children: photo.participants
                                  .take(3)
                                  .map(
                                    (p) => Padding(
                                      padding: const EdgeInsets.only(right: 2),
                                      child: FriendAvatar(
                                        name: p.name,
                                        avatarUrl: p.avatarUrl,
                                        radius: 8,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
