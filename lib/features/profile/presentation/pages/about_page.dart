import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const _version = '1.0.0';
  static const _contactEmail = 'soporte@lavidaendirecto.app';

  Future<void> _openEmail(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: _contactEmail,
      query: 'subject=La Vida en Directo - Contacto',
    );
    if (!await launchUrl(uri)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el cliente de correo')),
      );
    }
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Política de privacidad'),
        content: const SingleChildScrollView(
          child: Text(
            'La Vida en Directo recoge únicamente los datos necesarios para '
            'el funcionamiento de la aplicación: nombre, correo electrónico '
            'y los conciertos que añades.\n\n'
            'Tus datos se almacenan de forma segura y nunca se comparten con '
            'terceros ni se usan con fines publicitarios.\n\n'
            'Puedes eliminar tu cuenta y todos tus datos en cualquier momento '
            'desde la app o contactando con nosotros.',
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  void _showCredits(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Créditos'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Desarrollado con ❤️ por Nico',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Tecnologías utilizadas:'),
            SizedBox(height: 8),
            _CreditRow(name: 'Flutter', description: 'Frontend móvil'),
            _CreditRow(name: 'NestJS', description: 'Backend API'),
            _CreditRow(name: 'Prisma', description: 'Base de datos'),
            _CreditRow(
              name: 'Cloudinary',
              description: 'Almacenamiento de imágenes',
            ),
            _CreditRow(name: 'Setlist.fm', description: 'Datos de setlists'),
            _CreditRow(name: 'Spotify API', description: 'Datos de artistas'),
            _CreditRow(
              name: 'Ticketmaster',
              description: 'Eventos recomendados',
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: ListView(
        children: [
          // Logo / header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40),
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.music_note,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'La Vida en Directo',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Versión $_version',
                  style: const TextStyle(color: Colors.white54),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('Créditos'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showCredits(context),
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Política de privacidad'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPrivacyPolicy(context),
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.mail_outline),
            title: const Text('Contacto'),
            subtitle: const Text(_contactEmail),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openEmail(context),
          ),

          const SizedBox(height: 40),

          const Center(
            child: Text(
              'Hecho con ❤️ para los que viven la música en directo.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38, fontSize: 13),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _CreditRow extends StatelessWidget {
  final String name;
  final String description;

  const _CreditRow({required this.name, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 6, color: Color(0xFFE53935)),
          const SizedBox(width: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Text(' — '),
          Text(description, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
