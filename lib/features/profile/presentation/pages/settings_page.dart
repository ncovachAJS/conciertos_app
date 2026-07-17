import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  String _language = 'Español';

  Future<void> _changeName() async {
    final controller = TextEditingController(text: _auth.user?.name ?? '');

    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cambiar nombre'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Nuevo nombre'),
          autofocus: true,
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Guardar'),
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
      ).showSnackBar(const SnackBar(content: Text('Nombre actualizado ✅')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _changePassword() async {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cambiar contraseña'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña actual'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Nueva contraseña'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmar nueva contraseña',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (newCtrl.text != confirmCtrl.text) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('Las contraseñas no coinciden')),
                );
                return;
              }
              Navigator.pop(ctx, true);
            },
            child: const Text('Cambiar'),
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
      ).showSnackBar(const SnackBar(content: Text('Contraseña actualizada ✅')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _changeTheme() async {
    final current = ref.read(themeProvider);
    final selected = await showDialog<ThemeMode>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Apariencia'),
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
    final selected = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Idioma'),
        children: ['Español', 'English'].map((lang) {
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, lang),
            child: Row(
              children: [
                Icon(
                  _language == lang
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: const Color(0xFFE53935),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(lang),
              ],
            ),
          );
        }).toList(),
      ),
    );

    if (selected != null && mounted) {
      setState(() => _language = selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(
        children: [
          // Cuenta
          _SectionHeader(title: 'Cuenta'),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Nombre de usuario'),
            subtitle: Text(_auth.user?.name ?? '—'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _changeName,
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Cambiar contraseña'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _changePassword,
          ),

          // Preferencias
          _SectionHeader(title: 'Preferencias'),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('Notificaciones'),
            subtitle: const Text('Avisos de conciertos próximos'),
            value: _notifications,
            activeColor: const Color(0xFFE53935),
            onChanged: (v) => setState(() => _notifications = v),
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Idioma'),
            subtitle: Text(_language),
            trailing: const Icon(Icons.chevron_right),
            onTap: _changeLanguage,
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.brightness_6_outlined),
            title: const Text('Apariencia'),
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
