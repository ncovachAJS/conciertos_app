import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/tutorial/tutorial_service.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../concerts/data/services/concert_api_service.dart';
import '../../../concerts/data/services/upload_service.dart';
import '../../../concerts/domain/entities/concert.dart';
import '../../../concerts/presentation/providers/concerts_provider.dart';
import '../../../photos/data/services/photo_api_service.dart';
import '../../data/services/avatar_api_service.dart';
import '../widgets/profile_card.dart';
import 'about_page.dart';
import 'settings_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final ConcertApiService _api = ConcertApiService();
  final PhotoApiService _photosApi = PhotoApiService();
  final UploadService _uploadService = UploadService();
  final AvatarApiService _avatarService = AvatarApiService();
  final AuthController auth = AuthController.instance;

  List<Concert> concerts = [];
  int totalPhotos = 0;
  bool loading = true;
  bool _uploadingAvatar = false;

  @override
  void initState() {
    super.initState();
    auth.addListener(_refresh);
    load();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  Future<void> load() async {
    try {
      final result = await _api.getConcerts();
      concerts = result;
    } catch (_) {}

    try {
      final photos = await _photosApi.getFeed();
      totalPhotos = photos.length;
    } catch (_) {}

    if (!mounted) return;
    setState(() => loading = false);
  }

  Future<void> _changeAvatar() async {
    final picker = ImagePicker();

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Elegir de la galería'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Hacer una foto'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final picked = await picker.pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (picked == null) return;

    setState(() => _uploadingAvatar = true);

    try {
      final imageUrl = await _uploadService.uploadImage(picked.path);
      await _avatarService.updateAvatar(imageUrl);
      if (auth.user != null) auth.updateAvatarUrl(imageUrl);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto de perfil actualizada ✅')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al subir la foto: $e')));
    } finally {
      if (mounted) setState(() => _uploadingAvatar = false);
    }
  }

  String fanLevel(int concerts) {
    if (concerts >= 150) return '🤘 LEYENDA DEL DIRECTO';
    if (concerts >= 75) return '🥇 HEADLINER';
    if (concerts >= 25) return '🥈 ROADIE';
    return '🥉 ROOKIE';
  }

  String fanSince() {
    if (concerts.isEmpty) return 'Fan desde este año';
    int oldestYear = concerts
        .map((c) => c.date.year)
        .reduce((a, b) => a < b ? a : b);
    return 'Fan desde $oldestYear';
  }

  @override
  void dispose() {
    auth.removeListener(_refresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Mi perfil'), centerTitle: true),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Tu acreditación',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                'Tu historial musical en un vistazo.',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
              const SizedBox(height: 24),

              ProfileCard(
                name: auth.user?.name ?? 'Invitado',
                subtitle: auth.user != null
                    ? auth.user!.email
                    : '${fanLevel(concerts.length)}\n${fanSince()}',
                totalConcerts: concerts.length,
                totalFavorites: concerts.where((c) => c.favorite).length,
                totalPhotos: totalPhotos,
                level: auth.user == null ? '' : fanLevel(concerts.length),
                memberNumber: auth.user?.memberNumber ?? 0,
                avatarUrl: auth.user?.avatarUrl,
                onAvatarTap: _uploadingAvatar ? null : _changeAvatar,
              ),

              const SizedBox(height: 30),

              if (auth.user == null) ...[
                FilledButton.icon(
                  onPressed: () => context.push('/login'),
                  icon: const Icon(Icons.login),
                  label: const Text('Iniciar sesión'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => context.push('/register'),
                  icon: const Icon(Icons.person_add_alt_1),
                  label: const Text('Crear cuenta'),
                ),
              ] else ...[
                FilledButton.icon(
                  onPressed: () async {
                    await TutorialService.resetAll();
                    // Limpiamos el provider antes de cerrar sesión
                    ref.invalidate(concertsProvider);
                    await auth.logout();
                    if (!context.mounted) return;
                    context.go('/login');
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Cerrar sesión'),
                ),
              ],

              const SizedBox(height: 35),

              const Text(
                'Herramientas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Ajustes'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SettingsPage()),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text('Acerca de'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AboutPage()),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              Center(
                child: Text(
                  'La Vida en Directo\nVersión 1.0',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),
            ],
          ),

          if (_uploadingAvatar)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Subiendo foto...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
