import 'dart:io';

import 'package:conciertos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../../core/tutorial/tutorial_service.dart';
import '../../../../core/tutorial/tutorial_overlay.dart';
import '../../../../core/tutorial/tutorial_content.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/widgets/app_page.dart';
import '../../../concerts/data/models/concert_model.dart';
import '../../../concerts/data/services/concert_api_service.dart';
import '../../../concerts/data/services/upload_service.dart';
import '../../../concerts/domain/entities/concert.dart';
import '../../../concerts/presentation/providers/concerts_provider.dart';
import '../../../friends/presentation/widgets/tag_friends_selector.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../spotify/domain/entities/data/services/spotify_api_service.dart';

class AddConcertPage extends ConsumerStatefulWidget {
  final Concert? concert;

  /// Fecha inicial pre-seleccionada (solo en modo crear, ignorada al editar).
  final DateTime? initialDate;

  const AddConcertPage({super.key, this.concert, this.initialDate});

  @override
  ConsumerState<AddConcertPage> createState() => _AddConcertPageState();
}

class _AddConcertPageState extends ConsumerState<AddConcertPage> {
  final _formKey = GlobalKey<FormState>();

  final _artistController = TextEditingController();
  final _festivalController = TextEditingController();
  final _dateController = TextEditingController();
  final _venueController = TextEditingController();
  final _cityController = TextEditingController();
  final _nameController = TextEditingController();
  bool _hasFestival = false;
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();
  final _genreController = TextEditingController();

  final _spotifyService = SpotifyApiService();
  bool _fetchingGenre = false;

  final ImagePicker _picker = ImagePicker();
  final UploadService _uploadService = UploadService();

  DateTime? _selectedDate;
  File? _selectedImage;
  String? _imageUrl;

  bool _saving = false;
  int _rating = 0;
  bool _liked = false;
  bool _favorite = false;
  List<String> _taggedFriendIds = [];

  bool get _isPastConcert {
    if (_selectedDate == null) return false;
    final today = DateTime.now();
    final todayMidnight = DateTime(today.year, today.month, today.day);
    final concertDate = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
    );
    return concertDate.isBefore(todayMidnight);
  }

  @override
  void initState() {
    super.initState();
    _festivalController.addListener(() {
      final hasFest = _festivalController.text.trim().isNotEmpty;
      if (hasFest != _hasFestival) setState(() => _hasFestival = hasFest);
    });
    if (widget.concert == null) {
      // Solo en modo crear, no al editar
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _showTutorialIfNeeded(),
      );
    }
    if (widget.concert != null) {
      _rating = widget.concert!.rating;
      _liked = widget.concert!.liked;
      _favorite = widget.concert!.favorite;
      _artistController.text = widget.concert!.artist;
      _festivalController.text = widget.concert!.festival;
      _hasFestival = widget.concert!.festival.trim().isNotEmpty;
      _venueController.text = widget.concert!.venue;
      _cityController.text = widget.concert!.city;
      _nameController.text = widget.concert?.name ?? '';
      if (widget.concert!.price > 0) {
        _priceController.text = widget.concert!.price.toStringAsFixed(2);
      }
      if (widget.concert!.notes.isNotEmpty) {
        _notesController.text = widget.concert!.notes;
      }
      if (widget.concert!.genre.isNotEmpty) {
        _genreController.text = widget.concert!.genre;
      }
      _selectedDate = widget.concert!.date;
      _dateController.text =
          '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';
      if (widget.concert!.imageUrl.isNotEmpty) {
        _imageUrl = widget.concert!.imageUrl;
      }
      _taggedFriendIds = List.from(widget.concert!.participantIds);

      final currentUserId = AuthController.instance.user?.id ?? '';
      final ownerId = widget.concert!.userId;

      // Siempre excluir al usuario actual (no puede etiquetarse a sí mismo)
      _taggedFriendIds.remove(currentUserId);

      // Si el editor NO es el dueño, añadir al dueño como preseleccionado
      if (currentUserId != ownerId &&
          ownerId.isNotEmpty &&
          !_taggedFriendIds.contains(ownerId)) {
        _taggedFriendIds.add(ownerId);
      }
    }

    // Pre-rellenar fecha cuando se viene del calendario (solo en modo crear)
    if (widget.concert == null && widget.initialDate != null) {
      _selectedDate = widget.initialDate;
      _dateController.text =
          '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';
    }
  }

  /// Busca el género en Spotify cuando el artista pierde el foco.
  /// Solo rellena si el campo está vacío.
  Future<void> _suggestGenreFromSpotify() async {
    final artist = _artistController.text.trim();
    if (artist.isEmpty || _genreController.text.trim().isNotEmpty) return;
    setState(() => _fetchingGenre = true);
    try {
      final spotifyArtist = await _spotifyService.searchArtist(artist);
      if (!mounted) return;
      if (spotifyArtist != null && spotifyArtist.genres.isNotEmpty) {
        // Capitaliza el primer género
        final genre = spotifyArtist.genres.first
            .split(' ')
            .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
            .join(' ');
        setState(() => _genreController.text = genre);
      }
    } catch (_) {} finally {
      if (mounted) setState(() => _fetchingGenre = false);
    }
  }

  Future<void> _showTutorialIfNeeded() async {
    final should = await TutorialService.shouldShow(TutorialService.addConcert);
    if (!should || !mounted) return;
    await TutorialService.markShown(TutorialService.addConcert);
    if (!mounted) return;
    await TutorialOverlay.show(context, steps: TutorialContent.addConcert(AppLocalizations.of(context)));
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return;
    setState(() {
      _selectedDate = pickedDate;
      _dateController.text =
          '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
    });
  }

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 95,
    );
    if (image == null) return;
    setState(() => _saving = true);
    final l = AppLocalizations.of(context);
    try {
      final imageUrl = await _uploadService.uploadImage(image.path);
      if (!mounted) return;
      setState(() {
        _selectedImage = File(image.path);
        _imageUrl = imageUrl;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.imageUploadedSuccess)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.imageUploadError)),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _saveConcert() async {
    if (!_formKey.currentState!.validate()) return;
    debugPrint('🏷️ taggedFriendIds al guardar: $_taggedFriendIds');
    setState(() => _saving = true);
    final l = AppLocalizations.of(context);

    try {
      final concert = ConcertModel(
        id: widget.concert?.id ?? '',
        artist: _artistController.text.trim(),
        festival: _festivalController.text.trim(),
        name: _nameController.text.trim(),
        date: _selectedDate!,
        imageUrl: _imageUrl ?? '',
        rating: _rating,
        liked: _liked,
        favorite: _favorite,
        venue: _venueController.text.trim(),
        city: _cityController.text.trim(),
        price: double.tryParse(_priceController.text.replaceAll(',', '.')) ?? 0.0,
        notes: _notesController.text.trim(),
        genre: _genreController.text.trim(),
        taggedFriendIds: _taggedFriendIds,
        participantIds: widget.concert?.participantIds ?? [],
        participants: widget.concert?.participants ?? [],
        userId: widget.concert?.userId ?? '',
      );

      if (widget.concert == null) {
        // Llamamos directamente a la API — devuelve el concierto con su ID real
        final created = await ConcertApiService().addConcert(concert);

        // Actualizamos el provider en background
        ref.read(concertsProvider.notifier).reload().ignore();

        if (!mounted) return;

        // Navegamos al detalle usando el concierto recién creado
        context.pushReplacement('/concert-detail', extra: created);
      } else {
        // Edición — actualizamos y volvemos
        await ConcertApiService().updateConcert(concert);
        if (!mounted) return;
        context.pop(true);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.concertSaveError)),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _artistController.dispose();
    _festivalController.dispose();
    _dateController.dispose();
    _venueController.dispose();
    _cityController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    _genreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppPage(
      title: widget.concert == null
          ? '➕ ${l.addConcertTitle}'
          : '✏️ ${l.editConcertTitle}',
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.concert == null ? l.addConcertTitle : l.editConcertTitle,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              TextFormField(
                controller: _artistController,
                decoration: InputDecoration(
                  labelText: l.artistLabel,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person),
                ),
                onEditingComplete: _suggestGenreFromSpotify,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l.artistRequired;
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _genreController,
                decoration: InputDecoration(
                  labelText: '🎸 Género musical',
                  hintText: 'Rock, Pop, Metal, Jazz…',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.library_music_outlined),
                  suffixIcon: _fetchingGenre
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : null,
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _festivalController,
                decoration: InputDecoration(
                  labelText: l.festivalLabel,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.festival),
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _venueController,
                decoration: InputDecoration(
                  labelText: l.venueLabel,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.stadium),
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: l.cityLabel,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.location_city),
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: _hasFestival ? 'Precio del festival' : 'Precio de la entrada',
                  hintText: '0.00',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.euro_rounded),
                  suffixText: '€',
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l.concertNameLabel,
                  hintText: l.concertNameHint,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.music_note),
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: _selectDate,
                decoration: InputDecoration(
                  labelText: l.dateLabel,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.calendar_month),
                  suffixIcon: const Icon(Icons.arrow_drop_down),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l.dateRequired;
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.photo),
                      label: Text(l.selectImage),
                    ),
                  ),
                  if (_selectedImage != null || (_imageUrl != null && _imageUrl!.isNotEmpty)) ...[
                    const SizedBox(width: 10),
                    OutlinedButton.icon(
                      onPressed: () => setState(() {
                        _selectedImage = null;
                        _imageUrl = null;
                      }),
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      label: Text(
                        l.delete,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.redAccent),
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 16),

              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 220,
                  child: _selectedImage != null
                      ? Image.file(
                          _selectedImage!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : (_imageUrl != null && _imageUrl!.isNotEmpty)
                      ? Image.network(
                          _imageUrl!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholderImage(),
                        )
                      : _placeholderImage(),
                ),
              ),

              const SizedBox(height: 32),

              if (_isPastConcert)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.ratingTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(5, (index) {
                          final active = index < _rating;
                          return GestureDetector(
                            onTap: () => setState(
                              () => _rating = (_rating == index + 1)
                                  ? 0
                                  : index + 1,
                            ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              child: Icon(
                                active
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                color: Colors.amber,
                                size: active ? 44 : 40,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        _rating == 0
                            ? l.ratingNone
                            : l.ratingStars(_rating),
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l.howWasItTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => setState(() => _liked = !_liked),
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              Icons.thumb_up_rounded,
                              key: ValueKey(_liked),
                              color: _liked ? Colors.blueAccent : Colors.grey,
                              size: 28,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _liked = !_liked),
                            child: Text(
                              _liked ? l.likedYes : l.likedNo,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: _liked
                                    ? Colors.blueAccent
                                    : Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l.favoritesTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () =>
                              setState(() => _favorite = !_favorite),
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              _favorite ? Icons.star : Icons.star_border,
                              key: ValueKey(_favorite),
                              color: _favorite ? Colors.amber : Colors.grey,
                              size: 30,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _favorite = !_favorite),
                            child: Text(
                              _favorite
                                  ? l.addedToFavorites
                                  : l.markAsFavorite,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: _favorite
                                    ? Colors.amber
                                    : Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),

              // ── Notas / diario ────────────────────────────────────
              const SizedBox(height: 24),
              TextFormField(
                controller: _notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: '📝 Notas / diario',
                  hintText: '¿Qué recordás de este concierto?',
                  border: const OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),

              // ── Etiquetar amigos ───────────────────────────────────
              const SizedBox(height: 32),
              TagFriendsSelector(
                key: const ValueKey('tag_friends'),
                initialSelectedIds: _taggedFriendIds,
                isPast: _isPastConcert,
                onChanged: (ids) {
                  _taggedFriendIds = List.from(ids);
                  debugPrint('🏷️ onChanged padre: $_taggedFriendIds');
                },
              ),

              const SizedBox(height: 32),

              SizedBox(
                height: 55,
                child: FilledButton.icon(
                  onPressed: _saving ? null : _saveConcert,
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(
                    _saving
                        ? l.savingLabel
                        : widget.concert == null
                        ? l.saveConcert
                        : l.saveChanges,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE53935), Color(0xFF7B1FA2), Color(0xFF111111)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(Icons.photo_camera, color: Colors.white30, size: 80),
      ),
    );
  }
}
