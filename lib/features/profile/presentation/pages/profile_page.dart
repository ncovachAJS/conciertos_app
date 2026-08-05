import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:conciertos_app/l10n/generated/app_localizations.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../concerts/data/services/concert_api_service.dart';
import '../../../concerts/data/services/upload_service.dart';
import '../../../concerts/domain/entities/concert.dart';
import '../../../concerts/presentation/providers/concerts_provider.dart';
import '../../../photos/data/services/photo_api_service.dart';
import '../../data/services/achievements_service.dart';
import '../../data/services/avatar_api_service.dart';
import '../../domain/achievement.dart';
import '../widgets/achievement_toast.dart';
import '../widgets/achievements_widget.dart';
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

    _checkAchievements();
  }

  /// Calcula UserStats a partir de la lista de conciertos del usuario.
  UserStats _buildStats(List<Concert> list) {
    final uniqueArtists = list
        .map((c) => c.artist.trim().toLowerCase())
        .where((a) => a.isNotEmpty)
        .toSet()
        .length;
    final uniqueFestivals = list
        .map((c) => c.festival.trim().toLowerCase())
        .where((f) => f.isNotEmpty)
        .toSet()
        .length;
    final uniqueCities = list
        .map((c) => c.city.trim().toLowerCase())
        .where((c) => c.isNotEmpty)
        .toSet()
        .length;
    final totalRated = list.where((c) => c.rating > 0).length;
    final dates = list.map((c) => c.date.year).toList();
    final oldestYear =
        dates.isNotEmpty ? dates.reduce((a, b) => a < b ? a : b) : 0;

    // Géneros — comparación flexible en minúsculas
    bool hasGenre(Concert c, List<String> keywords) {
      final g = c.genre.toLowerCase();
      return keywords.any((k) => g.contains(k));
    }

    final rockConcerts = list
        .where((c) => hasGenre(c, ['rock', 'punk', 'grunge', 'indie']))
        .length;
    final metalConcerts = list
        .where((c) => hasGenre(c, ['metal', 'heavy', 'thrash', 'death', 'black metal']))
        .length;
    final jazzConcerts = list
        .where((c) => hasGenre(c, ['jazz', 'blues', 'soul', 'funk']))
        .length;
    final urbanConcerts = list
        .where((c) => hasGenre(c, ['hip', 'rap', 'trap', 'reggaeton', 'urban', 'r&b']))
        .length;

    final fiveStarConcerts = list.where((c) => c.rating >= 5).length;
    final totalFavorites = list.where((c) => c.favorite).length;
    final totalSpent = list.fold<double>(0, (sum, c) => sum + c.price);

    // maxSameArtist: cuántas veces fue al artista más repetido
    final artistCount = <String, int>{};
    for (final c in list) {
      final a = c.artist.trim().toLowerCase();
      if (a.isNotEmpty) artistCount[a] = (artistCount[a] ?? 0) + 1;
    }
    final maxSameArtist =
        artistCount.values.fold<int>(0, (m, v) => v > m ? v : m);

    return UserStats(
      totalConcerts: list.length,
      uniqueArtists: uniqueArtists,
      uniqueFestivals: uniqueFestivals,
      uniqueCities: uniqueCities,
      totalRated: totalRated,
      oldestYear: oldestYear,
      rockConcerts: rockConcerts,
      metalConcerts: metalConcerts,
      jazzConcerts: jazzConcerts,
      urbanConcerts: urbanConcerts,
      fiveStarConcerts: fiveStarConcerts,
      maxSameArtist: maxSameArtist,
      totalSpent: totalSpent,
      totalFavorites: totalFavorites,
    );
  }

  Future<void> _checkAchievements() async {
    final stats = _buildStats(concerts);
    final achievements = AchievementsEngine.compute(stats);
    final newOnes = await AchievementsService.checkNewUnlocks(achievements);

    if (!mounted || newOnes.isEmpty) return;
    await showAchievementToasts(context, newOnes);
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
              title: Text(AppLocalizations.of(context).chooseFromGallery),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(AppLocalizations.of(context).takePhoto),
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
        SnackBar(content: Text(AppLocalizations.of(context).profilePhotoUpdated)),
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
    final l = AppLocalizations.of(context);
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.myProfile), centerTitle: true),
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

              // ── Logros ────────────────────────────────────────────────
              AchievementsWidget(
                achievements: AchievementsEngine.compute(_buildStats(concerts)),
              ),

              const SizedBox(height: 30),

              if (auth.user == null) ...[
                FilledButton.icon(
                  onPressed: () => context.push('/login'),
                  icon: const Icon(Icons.login),
                  label: Text(l.signIn),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => context.push('/register'),
                  icon: const Icon(Icons.person_add_alt_1),
                  label: Text(l.createAccount),
                ),
              ] else ...[
                FilledButton.icon(
                  onPressed: () async {
                    // NO reseteamos el tutorial — debe mantenerse entre sesiones
                    ref.invalidate(concertsProvider);
                    await auth.logout();
                    if (!context.mounted) return;
                    context.go('/login');
                  },
                  icon: const Icon(Icons.logout),
                  label: Text(l.signOut),
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
                      leading: const Icon(
                        Icons.group_rounded,
                        color: Color(0xFFE53935),
                      ),
                      title: Text(l.friendsTitle),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/friends'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: Text(l.settingsTitle),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SettingsPage()),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: Text(l.aboutTitle),
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
