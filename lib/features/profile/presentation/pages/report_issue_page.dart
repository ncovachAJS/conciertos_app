import 'package:flutter/material.dart';
import 'package:conciertos_app/l10n/generated/app_localizations.dart';

import '../../../../app/app_shell.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/services/jira_service.dart';

String _issueTypeLabel(AppLocalizations l, IssueType type) => switch (type) {
      IssueType.bug => l.issueTypeBug,
      IssueType.mejora => l.issueTypeImprovement,
      IssueType.otro => l.issueTypeOther,
    };

class ReportIssuePage extends StatefulWidget {
  const ReportIssuePage({super.key});

  @override
  State<ReportIssuePage> createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  final _formKey     = GlobalKey<FormState>();
  final _titleCtrl   = TextEditingController();
  final _descCtrl    = TextEditingController();
  IssueType _type    = IssueType.bug;
  bool _sending      = false;
  String? _successKey; // clave del issue creado (p.ej. "APP-42")
  String? _errorMsg;

  @override
  void dispose() {
    _titleCtrl.dispose();
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
        title:         _titleCtrl.text.trim(),
        description:   _descCtrl.text.trim(),
        reporterEmail: email,
      );
      if (!mounted) return;
      setState(() {
        _successKey = key;
        _sending    = false;
      });
      _titleCtrl.clear();
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
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.reportIssueLabel),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20,
          24,
          20,
          40 + floatingNavBarClearance(context),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Cabecera ───────────────────────────────────────────────────
              Text(
                l.reportIssueIntroTitle,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                l.reportIssueIntroDesc,
                style: TextStyle(
                    fontSize: 14,
                    color: cs.onSurface.withValues(alpha: .55),
                    height: 1.5),
              ),
              const SizedBox(height: 28),

              // ── Tipo de incidencia ─────────────────────────────────────────
              Text(
                l.typeLabel,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              SegmentedButton<IssueType>(
                segments: IssueType.values
                    .map((t) => ButtonSegment<IssueType>(
                          value: t,
                          label: Text(_issueTypeLabel(l, t)),
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

              // ── Título ────────────────────────────────────────────────────
              Text(
                l.titleLabel,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _titleCtrl,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: l.titleHint,
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
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return l.titleRequiredError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // ── Descripción ────────────────────────────────────────────────
              Text(
                l.descriptionLabel,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descCtrl,
                maxLines: 7,
                minLines: 5,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: _type == IssueType.bug
                      ? l.descBugHint
                      : _type == IssueType.mejora
                          ? l.descImprovementHint
                          : l.descOtherHint,
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
                    return l.descRequiredError;
                  }
                  if (v.trim().length < 10) {
                    return l.descTooShortError;
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
                        l.autoInfoNote,
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
                            Text(
                              l.issueSentTitle,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              l.ticketCreatedLabel(_successKey!),
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
                  label: Text(_sending ? l.sendingLabel : l.sendIssueButton),
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
