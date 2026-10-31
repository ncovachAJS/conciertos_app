import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:conciertos_app/l10n/generated/app_localizations.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const _version = '1.0.0';
  static const _contactEmail = 'soporte@lavidaendirecto.app';

  Future<void> _openEmail(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final uri = Uri(
      scheme: 'mailto',
      path: _contactEmail,
      query: 'subject=${l.mailtoSubject}',
    );
    if (!await launchUrl(uri)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.emailClientError)),
      );
    }
  }

  void _showPrivacyPolicy(BuildContext context) {
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.privacyPolicy),
        content: SingleChildScrollView(
          child: Text(l.privacyPolicyBody),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.understood),
          ),
        ],
      ),
    );
  }

  void _showCredits(BuildContext context) {
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.creditsLabel),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.creditsDevelopedBy,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(l.technologiesUsed),
            const SizedBox(height: 8),
            _CreditRow(name: 'Flutter', description: l.creditFrontend),
            _CreditRow(name: 'NestJS', description: l.creditBackend),
            _CreditRow(name: 'Prisma', description: l.creditDatabase),
            _CreditRow(
              name: 'Cloudinary',
              description: l.creditImageStorage,
            ),
            _CreditRow(name: 'Setlist.fm', description: l.creditSetlistData),
            _CreditRow(name: 'Spotify API', description: l.creditArtistData),
            _CreditRow(
              name: 'Ticketmaster',
              description: l.creditRecommendedEvents,
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.close),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.aboutTitle)),
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
                  l.appFooterVersion(_version),
                  style: const TextStyle(color: Colors.white54),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          ListTile(
            leading: const Icon(Icons.code),
            title: Text(l.creditsLabel),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showCredits(context),
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l.privacyPolicy),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPrivacyPolicy(context),
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.mail_outline),
            title: Text(l.contact),
            subtitle: const Text(_contactEmail),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openEmail(context),
          ),

          const SizedBox(height: 40),

          Center(
            child: Text(
              l.aboutFooterTagline,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white38, fontSize: 13),
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
