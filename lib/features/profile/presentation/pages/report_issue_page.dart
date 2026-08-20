import 'package:flutter/material.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/services/jira_service.dart';

class ReportIssuePage extends StatefulWidget {
  const ReportIssuePage({super.key});

  @override
  State<ReportIssuePage> createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  final _formKey     = GlobalKey<FormState>();
  final _descCtrl    = TextEditingController();
  IssueType _type    = IssueType.bug;
  bool _sending      = false;
  String? _successKey; // clave del issue creado (p.ej. "APP-42")
  String? _errorMsg;

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _sending    = true;
      _errorMsg   = null;
      _successKey = null;
    });

    try {
      final email = AuthController.instance.user?.email ?? 'desconocido';
      final key = await JiraService.createIssue(
        type:          _type,
        description:   _descCtrl.text.trim(),
        reporterEmail: email,
      );
      if (!mounted) return;
      setState(() {
        _successKey = key;
        _sending    = false;
      });
      _descCtrl.clear();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMsg = e.toString();
        _sending  = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportar incidencia'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Cabecera ───────────────────────────────────────────────────
              const Text(
                '¿Algo no funciona como esperabas?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Cuéntanos qué ha pasado y lo revisaremos lo antes posible.',
                style: TextStyle(
                    fontSize: 14,
                    color: cs.onSurface.withValues(alpha: .55),
                    height: 1.5),
              ),
              const SizedBox(height: 28),

              // ── Tipo de incidencia ─────────────────────────────────────────
              const Text(
                'Tipo',
                style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              SegmentedButton<IssueType>(
                segments: IssueType.values
                    .map((t) => ButtonSegment<IssueType>(
                          value: t,
                          label: Text(t.label),
                        ))
                    .toList(),
                selected: {_type},
                onSelectionChanged: (s) =>
                    setState(() => _type = s.first),
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor:
                      const Color(0xFFE53935).withValues(alpha: .15),
                  selectedForegroundColor: const Color(0xFFE53935),
                  side: BorderSide(
                      color: cs.onSurface.withValues(alpha: .15)),
                ),
              ),
              const SizedBox(height: 24),

              // ── Descripción ────────────────────────────────────────────────
              const Text(
                'Descripción',
                style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descCtrl,
                maxLines: 7,
                minLines: 5,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: _type == IssueType.bug
                      ? 'Describe el problema: qué hiciste, qué esperabas y qué pasó…'
                      : _type == IssueType.mejora
                          ? 'Explica la mejora que te gustaría ver…'
                          : 'Escribe tu comentario o sugerencia…',
                  filled: true,
                  fillColor: cs.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                        color: Color(0xFFE53935), width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Escribe una descripción antes de enviar';
                  }
                  if (v.trim().length < 10) {
                    return 'La descripción es demasiado corta';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Nota sobre info automática ─────────────────────────────────
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: .07),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: cs.primary.withValues(alpha: .18)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded,
                        color: cs.primary, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Se incluirá automáticamente la versión de la app, '
                        'plataforma y tu email para poder contactarte si hace falta.',
                        style: TextStyle(
                            fontSize: 12,
                            color: cs.onSurface.withValues(alpha: .65),
                            height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Éxito ──────────────────────────────────────────────────────
              if (_successKey != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: Colors.green.withValues(alpha: .3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          color: Colors.green, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '¡Incidencia enviada! 🎉',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Ticket creado: $_successKey',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: cs.onSurface.withValues(alpha: .6)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // ── Error ──────────────────────────────────────────────────────
              if (_errorMsg != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: cs.error.withValues(alpha: .08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: cs.error.withValues(alpha: .25)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.error_outline_rounded,
                          color: cs.error, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _errorMsg!,
                          style: TextStyle(
                              color: cs.error, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 28),

              // ── Botón enviar ───────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _sending ? null : _submit,
                  icon: _sending
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.send_rounded, size: 18),
                  label: Text(_sending ? 'Enviando…' : 'Enviar incidencia'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
