import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:conciertos_app/app/locale_provider.dart';
import 'package:conciertos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/services/jira_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/theme_pack_provider.dart';
import '../../../../app/theme_provider.dart';
import '../../../../shared/widgets/pro_paywall_sheet.dart';
import '../../../../core/notifiers/annual_goal_notifier.dart';
import '../../../../core/tutorial/tutorial_content.dart';
import '../../../../core/tutorial/tutorial_overlay.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../concerts/data/models/concert_model.dart';
import '../../../concerts/presentation/providers/concerts_provider.dart';
import '../../../photos/data/services/photo_api_service.dart';
import '../../data/services/user_api_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Claves de SharedPreferences
// ─────────────────────────────────────────────────────────────────────────────
const _kNotifFriends = 'notif_friend_activity';
const _kNotifRecs    = 'notif_recommendations';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _userService = UserApiService();
  final _auth = AuthController.instance;

  // Prefs de notificaciones
  bool _notifFriends = true;
  bool _notifRecs    = true;

  // Meta anual de conciertos
  int? _annualGoal;

  String get _goalPrefKey {
    final userId = AuthController.instance.user?.id ?? 'guest';
    return 'annual_concert_goal_$userId';
  }

  @override
  void initState() {
    super.initState();
    _loadNotifPrefs();
    _loadAnnualGoal();
  }

  Future<void> _loadNotifPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _notifFriends = prefs.getBool(_kNotifFriends) ?? true;
      _notifRecs    = prefs.getBool(_kNotifRecs)    ?? true;
    });
  }

  Future<void> _loadAnnualGoal() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _annualGoal = prefs.getInt(_goalPrefKey));
  }

  Future<void> _editAnnualGoal() async {
    final current = _annualGoal;
    final controller = TextEditingController(
      text: current != null ? '$current' : '',
    );

    final result = await showDialog<int?>(
      context: context,
      builder: (ctx) {
        int? parsed = current;
        return StatefulBuilder(
          builder: (ctx2, setS) => AlertDialog(
            title: const Text('Meta anual de conciertos'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '¿Cuántos conciertos quieres ver este año?',
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: controller,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Número de conciertos',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.flag_rounded,
                        color: Color(0xFFE53935)),
                  ),
                  onChanged: (v) {
                    setS(() => parsed = int.tryParse(v));
                  },
                ),
              ],
            ),
            actions: [
              if (current != null)
                TextButton(
                  onPressed: () => Navigator.pop(ctx, -1), // señal borrar
                  child: const Text(
                    'Quitar meta',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, null),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: parsed != null && parsed! > 0
                    ? () => Navigator.pop(ctx, parsed)
                    : null,
                child: const Text('Guardar'),
              ),
            ],
          ),
        );
      },
    );

    if (result == null) return; // cancelado

    final prefs = await SharedPreferences.getInstance();
    if (result == -1) {
      // borrar meta
      await prefs.remove(_goalPrefKey);
      AnnualGoalNotifier.instance.value = null;
      if (mounted) setState(() => _annualGoal = null);
    } else {
      await prefs.setInt(_goalPrefKey, result);
      AnnualGoalNotifier.instance.value = result;
      if (mounted) setState(() => _annualGoal = result);
    }
  }

  Future<void> _setNotifPref(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  // ── Cuenta ──────────────────────────────────────────────────────────────────

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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.nameUpdated)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _changePassword() async {
    final l = AppLocalizations.of(context);
    final currentCtrl = TextEditingController();
    final newCtrl     = TextEditingController();
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
              decoration:
                  InputDecoration(labelText: l.confirmPasswordLabel),
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
        newPassword:     newCtrl.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.passwordUpdated)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _changeEmail() async {
    final emailCtrl    = TextEditingController(text: _auth.user?.email ?? '');
    final passwordCtrl = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cambiar email'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Nuevo email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'Contraseña actual'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFE53935)),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (ok != true || !mounted) return;

    try {
      final newEmail = await _userService.updateEmail(
        email:           emailCtrl.text.trim(),
        currentPassword: passwordCtrl.text,
      );
      _auth.updateEmail(newEmail);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email actualizado')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _deleteAccount() async {
    final passwordCtrl = TextEditingController();

    // Paso 1 — advertencia
    final step1 = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('⚠️ Eliminar cuenta'),
        content: const Text(
          'Esta acción es irreversible. Se borrarán todos tus conciertos, '
          'fotos, amigos y datos de la cuenta.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade700),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
    if (step1 != true || !mounted) return;

    // Paso 2 — confirmar con contraseña
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirma tu contraseña'),
        content: TextField(
          controller: passwordCtrl,
          obscureText: true,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Contraseña actual'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade700),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar cuenta'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;

    try {
      await _userService.deleteAccount(
          currentPassword: passwordCtrl.text);
      if (!mounted) return;
      await _auth.logout();
      if (!mounted) return;
      context.go('/login');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // ── Mis datos ────────────────────────────────────────────────────────────────

  Future<void> _exportData(String format) async {
    final concerts = ref.read(concertsProvider).asData?.value ?? [];
    if (concerts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay conciertos para exportar')),
      );
      return;
    }

    // Para JSON mostramos un diálogo de progreso porque implica N peticiones HTTP
    // (una por concierto para cargar sus fotos) y puede tardar varios segundos.
    if (format == 'json') {
      unawaited(showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const _ExportingDialog(),
      ));
    }

    String content;
    String filename;
    String mime;

    try {
      if (format == 'csv') {
        final sb = StringBuffer();
        sb.writeln('artista,nombre,fecha,recinto,ciudad,festival,género,valoracion,favorito,precio,notas');
        for (final c in concerts) {
          String esc(String s) => '"${s.replaceAll('"', '""')}"';
          sb.writeln([
            esc(c.artist),
            esc(c.name),
            '${c.date.year}-${c.date.month.toString().padLeft(2,'0')}-${c.date.day.toString().padLeft(2,'0')}',
            esc(c.venue),
            esc(c.city),
            esc(c.festival),
            esc(c.genre),
            c.rating,
            c.favorite ? 'sí' : 'no',
            c.price.toStringAsFixed(2),
            esc(c.notes),
          ].join(','));
        }
        content  = sb.toString();
        filename = 'conciertos_${DateTime.now().year}.csv';
        mime     = 'text/csv';
      } else {
        // Exportamos en formato completo (todos los campos + imageUrl + fotos de recuerdos)
        // compatible con la restauración desde la pestaña "Copia de seguridad"
        final now = DateTime.now();
        String pad(int n) => n.toString().padLeft(2, '0');
        final dateStr = '${now.year}${pad(now.month)}${pad(now.day)}';

        // Incluir fotos de recuerdos de cada concierto
        final photoService = PhotoApiService();
        final concertList = <Map<String, dynamic>>[];
        for (final c in concerts) {
          final model = c is ConcertModel ? c : ConcertModel.fromEntity(c);
          final concertJson = model.toCacheJson();
          if (c.id.isNotEmpty) {
            try {
              final photos = await photoService.getConcertPhotos(c.id);
              if (photos.isNotEmpty) {
                concertJson['photos'] = photos.map((p) {
                  final m = <String, dynamic>{'imageUrl': p.imageUrl};
                  if (p.caption.isNotEmpty) m['caption'] = p.caption;
                  return m;
                }).toList();
              }
            } catch (_) {
              // Si falla la carga de fotos, el concierto se exporta igualmente sin ellas
            }
          }
          concertList.add(concertJson);
        }

        content = const JsonEncoder.withIndent('  ').convert({
          'version': 2,
          'exportedAt': now.toIso8601String(),
          'app': 'lavd',
          'concerts': concertList,
        });
        filename = 'lavd_backup_$dateStr.json';
        mime     = 'application/json';
      }

      final dir  = await getTemporaryDirectory();
      final file = File('${dir.path}/$filename');
      await file.writeAsString(content, encoding: utf8);

      // Cerramos el diálogo de progreso antes de abrir el share sheet
      if (format == 'json' && mounted) Navigator.of(context).pop();

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: mime)],
          subject: 'Mis conciertos — La Vida en Directo',
        ),
      );
    } catch (e) {
      if (format == 'json' && mounted) Navigator.of(context).pop();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al exportar: $e')),
        );
      }
    }
  }

  void _showExportPicker() {
    final isPro = _auth.user?.isPro ?? false;
    if (!isPro) {
      ProPaywallSheet.showPaywall(context);
      return;
    }
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Exportar mis datos',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.table_chart_outlined,
                  color: Color(0xFF43A047)),
              title: const Text('CSV — Excel/Sheets'),
              subtitle: const Text('Compatible con cualquier hoja de cálculo'),
              onTap: () { Navigator.pop(context); _exportData('csv'); },
            ),
            ListTile(
              leading: const Icon(Icons.data_object_rounded,
                  color: Color(0xFF1E88E5)),
              title: const Text('JSON — copia de seguridad'),
              subtitle: const Text('Formato completo para importar en el futuro'),
              onTap: () { Navigator.pop(context); _exportData('json'); },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _syncCalendar() async {
    final concerts = ref.read(concertsProvider).asData?.value ?? [];
    final upcoming = concerts
        .where((c) => !c.isPastConcert)
        .toList();

    if (upcoming.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No tienes conciertos próximos para añadir'),
        ),
      );
      return;
    }

    int added = 0;
    for (final c in upcoming) {
      final event = Event(
        title: c.artist.isNotEmpty ? c.artist : c.name,
        description: [
          if (c.name.isNotEmpty && c.name != c.artist) c.name,
          if (c.venue.isNotEmpty) c.venue,
          if (c.city.isNotEmpty) c.city,
        ].join(' · '),
        location: [c.venue, c.city]
            .where((s) => s.isNotEmpty)
            .join(', '),
        startDate: c.date,
        endDate: c.date.add(const Duration(hours: 3)),
        allDay: false,
      );
      final ok = await Add2Calendar.addEvent2Cal(event);
      if (ok) added++;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          added == 0
              ? 'No se pudo añadir ningún evento'
              : '$added concierto${added > 1 ? 's' : ''} añadido${added > 1 ? 's' : ''} al calendario',
        ),
      ),
    );
  }

  Future<void> _clearCache() async {
    await DefaultCacheManager().emptyCache();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Caché de imágenes limpiada')),
    );
  }

  // ── Apariencia / idioma ──────────────────────────────────────────────────────

  Future<void> _changeTheme() async {
    final l = AppLocalizations.of(context);
    final current = ref.read(themeProvider);
    final selected = await showDialog<ThemeMode>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l.appearanceSection),
        children: [
          _ThemeOption(Icons.brightness_auto, 'Por defecto del sistema',
              ThemeMode.system, current),
          _ThemeOption(Icons.dark_mode, 'Oscuro', ThemeMode.dark, current),
          _ThemeOption(Icons.light_mode, 'Claro', ThemeMode.light, current),
        ]
            .map(
              (opt) => SimpleDialogOption(
                onPressed: () => Navigator.pop(ctx, opt.mode),
                child: Row(
                  children: [
                    Icon(opt.icon,
                        color: opt.mode == current
                            ? const Color(0xFFE53935)
                            : null,
                        size: 20),
                    const SizedBox(width: 12),
                    Text(opt.label),
                    if (opt.mode == current) ...[
                      const Spacer(),
                      const Icon(Icons.check,
                          color: Color(0xFFE53935), size: 18),
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
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l.languageSpanish),
              trailing: currentLocale.languageCode == 'es'
                  ? const Icon(Icons.check, color: Color(0xFFE53935))
                  : null,
              onTap: () {
                ref
                    .read(localeProvider.notifier)
                    .setLocale(const Locale('es'));
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l.languageEnglish),
              trailing: currentLocale.languageCode == 'en'
                  ? const Icon(Icons.check, color: Color(0xFFE53935))
                  : null,
              onTap: () {
                ref
                    .read(localeProvider.notifier)
                    .setLocale(const Locale('en'));
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── Tutorial picker ──────────────────────────────────────────────────────────

  void _showTutorialPicker() {
    final l = AppLocalizations.of(context);
    final entries = TutorialContent.allEntries(l);
    final cs = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: cs.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.55,
        maxChildSize: 0.9,
        builder: (_, controller) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: cs.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Text(
                l.tutorialPickerTitle,
                style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            Divider(height: 1, color: cs.onSurface.withValues(alpha: 0.08)),
            Expanded(
              child: ListView.separated(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                itemCount: entries.length,
                separatorBuilder: (_, idx) => const SizedBox(height: 6),
                itemBuilder: (bCtx, i) {
                  final entry = entries[i];
                  return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                    tileColor: cs.onSurface.withValues(alpha: 0.04),
                    leading: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(entry.icon,
                          color: const Color(0xFFE53935), size: 20),
                    ),
                    title: Text(entry.label,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      '${entry.steps.length} pasos',
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurface.withValues(alpha: 0.45),
                      ),
                    ),
                    trailing: const Icon(Icons.play_circle_outline_rounded,
                        color: Color(0xFFE53935), size: 22),
                    onTap: () {
                      Navigator.pop(ctx);
                      TutorialOverlay.show(bCtx, steps: entry.steps);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l           = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: ListView(
        children: [
          // ── Cuenta ────────────────────────────────────────────────────────
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
            leading: const Icon(Icons.email_outlined),
            title: const Text('Email'),
            subtitle: Text(_auth.user?.email ?? '—'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _changeEmail,
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: Text(l.changePassword),
            trailing: const Icon(Icons.chevron_right),
            onTap: _changePassword,
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.delete_forever_outlined,
                color: Colors.redAccent),
            title: const Text('Eliminar cuenta',
                style: TextStyle(color: Colors.redAccent)),
            trailing: const Icon(Icons.chevron_right, color: Colors.redAccent),
            onTap: _deleteAccount,
          ),

          // ── Notificaciones ────────────────────────────────────────────────
          const _SectionHeader(title: 'Notificaciones'),
          SwitchListTile(
            secondary: const Icon(Icons.people_outline),
            title: const Text('Actividad de amigos'),
            subtitle: const Text('Cuando un amigo añade un concierto'),
            value: _notifFriends,
            activeThumbColor: const Color(0xFFE53935),
            onChanged: (v) {
              setState(() => _notifFriends = v);
              _setNotifPref(_kNotifFriends, v);
            },
          ),
          const Divider(height: 1, indent: 56),
          SwitchListTile(
            secondary: const Icon(Icons.local_fire_department_outlined),
            title: const Text('Recomendaciones'),
            subtitle: const Text('Conciertos sugeridos basados en tus gustos'),
            value: _notifRecs,
            activeThumbColor: const Color(0xFFE53935),
            onChanged: (v) {
              setState(() => _notifRecs = v);
              _setNotifPref(_kNotifRecs, v);
            },
          ),

          // ── Preferencias ──────────────────────────────────────────────────
          _SectionHeader(title: l.preferencesSection),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l.languageSection),
            subtitle: Text(currentLocale.languageCode == 'es'
                ? l.languageSpanish
                : l.languageEnglish),
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
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Paleta de color'),
            subtitle: Text(
              ref.watch(themePackProvider).name,
              style: TextStyle(color: ref.watch(themePackProvider).previewPrimary),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (ref.watch(themePackProvider).isPro)
                  const _ProBadge(),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right),
              ],
            ),
            onTap: () => context.push('/color-theme'),
          ),

          // ── Mis datos ─────────────────────────────────────────────────────
          const _SectionHeader(title: 'Mis datos'),
          ListTile(
            leading: const Icon(Icons.flag_rounded, color: Color(0xFFE53935)),
            title: const Text('Meta anual de conciertos'),
            subtitle: Text(
              _annualGoal != null
                  ? 'Este año: $_annualGoal conciertos'
                  : 'Sin meta configurada',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: _editAnnualGoal,
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.download_rounded,
                color: Color(0xFF43A047)),
            title: const Text('Exportar mis conciertos'),
            subtitle: const Text('CSV o JSON — ábrelo en Excel o guárdalo'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showExportPicker,
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.calendar_today_outlined,
                color: Color(0xFF1E88E5)),
            title: const Text('Sincronizar con el calendario'),
            subtitle:
                const Text('Añade tus próximos conciertos al calendario del móvil'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _syncCalendar,
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.cleaning_services_outlined,
                color: Color(0xFFFFB300)),
            title: const Text('Limpiar caché de imágenes'),
            subtitle: const Text('Libera espacio del almacenamiento'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _clearCache,
          ),

          // ── Ayuda ─────────────────────────────────────────────────────────
          _SectionHeader(title: l.tutorialSettingsSection),
          ListTile(
            leading: const Icon(Icons.school_outlined),
            title: Text(l.tutorialSettingsLabel),
            subtitle: Text(l.tutorialSettingsSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showTutorialPicker,
          ),

          // ── Soporte ───────────────────────────────────────────────────────
          const _SectionHeader(title: 'Soporte'),
          ListTile(
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF0052CC).withValues(alpha: .12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bug_report_outlined,
                color: Color(0xFF0052CC),
                size: 20,
              ),
            ),
            title: const Text('Reportar incidencia'),
            subtitle: Text(
              JiraService.isConfigured
                  ? 'Envía un bug, sugerencia o comentario'
                  : 'Integración Jira no configurada — rellena el .env',
              style: JiraService.isConfigured
                  ? null
                  : const TextStyle(color: Colors.orange, fontSize: 12),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/report-issue'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────────────────────────────────────
// Diálogo de progreso durante la exportación JSON
// ─────────────────────────────────────────────────────────────────────────────

class _ExportingDialog extends StatelessWidget {
  const _ExportingDialog();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: cs.primary,
              ),
            ),
            const SizedBox(width: 20),
            const Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preparando exportación…',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Cargando fotos de cada concierto',
                    style: TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

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

class _ProBadge extends StatelessWidget {
  const _ProBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF7C3AED).withValues(alpha: .12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        'Pro',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Color(0xFF7C3AED),
        ),
      ),
    );
  }
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
