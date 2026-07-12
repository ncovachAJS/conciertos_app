import 'package:flutter/material.dart';
import '../widgets/profile_card.dart';

import '../../../concerts/data/services/concert_api_service.dart';
import '../../../concerts/domain/entities/concert.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';

import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ConcertApiService _api = ConcertApiService();

  final AuthController auth = AuthController.instance;

  List<Concert> concerts = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    auth.addListener(_refresh);
    load();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> load() async {
    concerts = await _api.getConcerts();

    if (!mounted) return;

    setState(() {
      loading = false;
    });
  }

  String fanLevel(int concerts) {
    if (concerts >= 150) return '🤘 LEYENDA DEL DIRECTO';
    if (concerts >= 75) return '🥇 HEADLINER';
    if (concerts >= 25) return '🥈 ROADIE';
    return '🥉 ROOKIE';
  }

  String fanSince() {
    if (concerts.isEmpty) {
      return 'Fan desde este año';
    }

    int oldestYear = concerts.first.date.year;

    for (final concert in concerts) {
      if (concert.date.year < oldestYear) {
        oldestYear = concert.date.year;
      }
    }

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
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Tu acreditación',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 6),

          Text(
            'Tu historial musical en un vistazo.',
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),

          SizedBox(height: 24),
          ProfileCard(
            name: auth.user?.name ?? 'Invitado',
            subtitle: auth.user != null
                ? auth.user!.email
                : '${fanLevel(concerts.length)}\n${fanSince()}',
            totalConcerts: concerts.length,
            totalFavorites: concerts.where((c) => c.favorite).length,
            totalPhotos: 0,
            level: auth.user == null ? '' : fanLevel(concerts.length),
          ),

          const SizedBox(height: 30),

          if (auth.user == null) ...[
            FilledButton.icon(
              onPressed: () {
                context.push('/login');
              },
              icon: const Icon(Icons.login),
              label: const Text('Iniciar sesión'),
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text('Crear cuenta'),
            ),
          ] else ...[
            FilledButton.icon(
              onPressed: () async {
                await auth.logout();

                if (!context.mounted) return;

                context.go('/login');
              },
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
            ),
          ],

          const SizedBox(height: 12),

          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.person_add_alt_1),
            label: const Text('Crear cuenta'),
          ),

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
                  leading: const Icon(Icons.upload_file),
                  title: const Text('Exportar colección'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Ajustes'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Acerca de'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
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
    );
  }
}
