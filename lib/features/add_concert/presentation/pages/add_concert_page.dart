import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/widgets/app_page.dart';
import '../../../concerts/data/services/concert_api_service.dart';
import '../../../concerts/domain/entities/concert.dart';

import '../../../concerts/data/services/upload_service.dart';

class AddConcertPage extends StatefulWidget {
  final Concert? concert;

  const AddConcertPage({super.key, this.concert});

  @override
  State<AddConcertPage> createState() => _AddConcertPageState();
}

class _AddConcertPageState extends State<AddConcertPage> {
  final _formKey = GlobalKey<FormState>();

  final _artistController = TextEditingController();
  final _festivalController = TextEditingController();
  final _dateController = TextEditingController();
  final _venueController = TextEditingController();
  final _cityController = TextEditingController();
  final _nameController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  final UploadService _uploadService = UploadService();

  DateTime? _selectedDate;

  File? _selectedImage;
  String? _imageUrl;

  bool _saving = false;
  int _rating = 0;
  bool _liked = false;

  bool get _isPastConcert {
    if (_selectedDate == null) return false;

    final today = DateTime.now();

    final todayWithoutTime = DateTime(today.year, today.month, today.day);

    final concertDate = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
    );

    return concertDate.isBefore(todayWithoutTime);
  }

  @override
  void initState() {
    super.initState();

    if (widget.concert != null) {
      _rating = widget.concert!.rating;
      _liked = widget.concert!.liked;
      _artistController.text = widget.concert!.artist;
      _festivalController.text = widget.concert!.festival;
      _venueController.text = widget.concert!.venue;
      _cityController.text = widget.concert!.city;
      _nameController.text = widget.concert?.name ?? '';

      _selectedDate = widget.concert!.date;

      _dateController.text =
          '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';

      if (widget.concert!.imageUrl.isNotEmpty) {
        _imageUrl = widget.concert!.imageUrl;
      }
    }
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
      imageQuality: 85,
    );

    if (image == null) return;

    setState(() {
      _saving = true;
    });

    try {
      final imageUrl = await _uploadService.uploadImage(image.path);

      if (!mounted) return;

      setState(() {
        _selectedImage = File(image.path);
        _imageUrl = imageUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Imagen subida correctamente'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo subir la imagen. Inténtalo de nuevo.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  Future<void> _saveConcert() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final concert = Concert(
        id:
            widget.concert?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        artist: _artistController.text.trim(),
        festival: _festivalController.text.trim(),
        name: _nameController.text.trim(),
        date: _selectedDate!,
        imageUrl: _imageUrl ?? '',
        rating: _rating,
        liked: _liked,
        venue: _venueController.text.trim(),
        city: _cityController.text.trim(),
      );

      if (widget.concert == null) {
        await ConcertApiService().addConcert(concert);
      } else {
        await ConcertApiService().updateConcert(concert);
      }

      if (!mounted) return;

      context.pop(true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo guardar el concierto. Inténtalo de nuevo.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: widget.concert == null
          ? '➕ Nuevo concierto'
          : '✏️ Editar concierto',
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.concert == null ? 'Nuevo concierto' : 'Editar concierto',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              TextFormField(
                controller: _artistController,
                decoration: const InputDecoration(
                  labelText: 'Artista',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Introduce el nombre del artista';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _festivalController,
                decoration: const InputDecoration(
                  labelText: 'Festival',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.festival),
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _venueController,
                decoration: const InputDecoration(
                  labelText: 'Sala / Estadio',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.stadium),
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'Ciudad',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_city),
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                labelText: 'Nombre del concierto',
                hintText: 'Ej. Iron Maiden - Future Past Tour',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.music_note),
              ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: _selectDate,
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_month),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecciona una fecha';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo),
                label: const Text('Seleccionar imagen'),
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
                      : (widget.concert?.imageUrl.isNotEmpty ?? false)
                      ? Image.network(
                          widget.concert!.imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _placeholderImage();
                          },
                        )
                      : _placeholderImage(),
                ),
              ),

              const SizedBox(height: 32),

              if (_isPastConcert)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Valoración',
                      style: TextStyle(
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
                            onTap: () {
                              setState(() {
                                _rating = index + 1;
                              });
                            },
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
                            ? 'Sin valorar'
                            : '$_rating de 5 estrellas',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 15,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      '¿Qué te pareció?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _liked = !_liked;
                            });
                          },
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
                            onTap: () {
                              setState(() {
                                _liked = !_liked;
                              });
                            },
                            child: Text(
                              _liked ? 'Lo recomendaría' : '¿Lo recomendarías?',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: _liked
                                    ? Colors.blueAccent
                                    : Colors.white70,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                  ],
                ),

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
                        ? 'Guardando...'
                        : widget.concert == null
                        ? 'Guardar concierto'
                        : 'Guardar cambios',
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
