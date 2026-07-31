import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:conciertos_app/l10n/generated/app_localizations.dart';
import 'package:conciertos_app/app/locale_provider.dart';

import '../../../../app/theme_provider.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/services/user_api_service.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _userService = UserApiService();
  final _auth = AuthController.instance;

  bool _notifications = true;

  Future<void> _changeName() async {
    final l = AppLocalizations.of(context);
    final controller = TextEditingController(text: _auth.user?.name ?? '');

    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.changeNameTitle),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: l.newNameLabel),
          autofocus: true,
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: Text(l.save),
          ),
        ],
      ),
    );

    if (newName == null || newName.isEmpty || !mounted) return;

    try {
      await _userService.updateName(newName);
      _auth.updateName(newName);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.nameUpdated)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _changePassword() async {
    final l = AppLocalizations.of(context);
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.changePasswordTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentCtrl,
              obscureText: true,
              decoration: InputDecoration(labelText: l.currentPasswordLabel),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newCtrl,
              obscureText: true,
              decoration: InputDecoration(labelText: l.newPasswordLabel),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: l.confirmPasswordLabel,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () {
              if (newCtrl.text != confirmCtrl.text) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(content: Text(l.passwordsNoMatch)),
                );
                return;
              }
              Navigator.pop(ctx, true);
            },
            child: Text(l.changePassword),
          ),
        ],
      ),
    );

    if (ok != true || !mounted) return;

    try {
      await _userService.updatePassword(
        currentPassword: currentCtrl.text,
        newPassword: newCtrl.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.passwordUpdated)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _changeTheme() async {
    final l = AppLocalizations.of(context);
    final current = ref.read(themeProvider);
    final selected = await showDialog<ThemeMode>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l.appearanceSection),
        children:
            [
                  _ThemeOption(
                    Icons.brightness_auto,
                    'Por defecto del sistema',
                    ThemeMode.system,
                    current,
                  ),
                  _ThemeOption(
                    Icons.dark_mode,
                    'Oscuro',
                    ThemeMode.dark,
                    current,
                  ),
                  _ThemeOption(
                    Icons.light_mode,
                    'Claro',
                    ThemeMode.light,
                    current,
                  ),
                ]
                .map(
                  (opt) => SimpleDialogOption(
                    onPressed: () => Navigator.pop(ctx, opt.mode),
                    child: Row(
                      children: [
                        Icon(
                          opt.icon,
                          color: opt.mode == current
                              ? const Color(0xFFE53935)
                              : null,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(opt.label),
                        if (opt.mode == current) ...[
                          const Spacer(),
                          const Icon(
                            Icons.check,
                            color: Color(0xFFE53935),
                            size: 18,
                          ),
                        ],
                      ],
                    ),
                  ),
                )
                .toList(),
      ),
    );
    if (selected != null) {
      ref.read(themeProvider.notifier).setTheme(selected);
    }
  }

  Future<void> _changeLanguage() async {
    final l = AppLocalizations.of(context);
    final currentLocale = ref.read(localeProvider);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.changeLanguageTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(l.languageSpanish),
              value: 'es',
              groupValue: currentLocale.languageCode,
              onChanged: (v) {
                ref.read(localeProvider.notifier).setLocale(const Locale('es'));
                Navigator.pop(ctx);
              },
            ),
            RadioListTile<String>(
              title: Text(l.languageEnglish),
              value: 'en',
              groupValue: currentLocale.languageCode,
              onChanged: (v) {
                ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: ListView(
        children: [
          _SectionHeader(title: l.accountSection),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(l.usernameLabel),
            subtitle: Text(_auth.user?.name ?? '—'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _changeName,
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: Text(l.changePassword),
            trailing: const Icon(Icons.chevron_right),
            onTap: _changePassword,
          ),

          _SectionHeader(title: l.preferencesSection),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: Text(l.notificationsLabel),
            subtitle: Text(l.upcomingConcertAlerts),
            value: _notifications,
            activeColor: const Color(0xFFE53935),
            onChanged: (v) => setState(() => _notifications = v),
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l.languageSection),
            subtitle: Text(currentLocale.languageCode == 'es' ? l.languageSpanish : l.languageEnglish),
            trailing: const Icon(Icons.chevron_right),
            onTap: _changeLanguage,
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.brightness_6_outlined),
            title: Text(l.appearanceSection),
            subtitle: Text(_themeName(ref.watch(themeProvider))),
            trailing: const Icon(Icons.chevron_right),
            onTap: _changeTheme,
          ),
        ],
      ),
    );
  }
}

String _themeName(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.light:
      return 'Claro';
    case ThemeMode.dark:
      return 'Oscuro';
    case ThemeMode.system:
      return 'Por defecto del sistema';
  }
}

class _ThemeOption {
  final IconData icon;
  final String label;
  final ThemeMode mode;
  final ThemeMode current;
  const _ThemeOption(this.icon, this.label, this.mode, this.current);
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
