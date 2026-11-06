import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_shell.dart' show floatingNavBarClearance;
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/whats_new_entry.dart';

/// Tablón con las últimas mejoras. Cada una se explica en detalle y, al
/// tocarla, lleva a la pantalla correspondiente.
class WhatsNewPage extends StatelessWidget {
  const WhatsNewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.whatsNewTitle)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          16,
          8,
          16,
          32 + floatingNavBarClearance(context),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              l.whatsNewIntro,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          for (final e in kWhatsNewEntries) _EntryCard(entry: e),
        ],
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  final WhatsNewEntry entry;

  const _EntryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final route = entry.route;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: route == null ? null : () => context.push(route),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    foregroundColor: theme.colorScheme.onPrimaryContainer,
                    child: Icon(entry.icon),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.title(l),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          l.whatsNewVersion(entry.version),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(entry.body(l), style: theme.textTheme.bodyMedium),
              if (route != null) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => context.push(route),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                    label: Text(l.whatsNewTryIt),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
