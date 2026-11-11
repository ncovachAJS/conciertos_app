import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';

/// Una mejora o funcionalidad del tablón de Novedades.
///
/// El texto vive en los ARB (ES/EN); aquí solo se enlaza cada entrada con sus
/// cadenas, su versión y la ruta a la que lleva al tocarla.
class WhatsNewEntry {
  final String id;

  /// Versión de la app en la que llegó (solo informativa).
  final String version;
  final IconData icon;

  /// Ruta de go_router a la que lleva la mejora; null = solo informativa.
  final String? route;
  final String Function(AppLocalizations l) title;
  final String Function(AppLocalizations l) body;

  const WhatsNewEntry({
    required this.id,
    required this.version,
    required this.icon,
    required this.title,
    required this.body,
    this.route,
  });
}

/// Novedades, de la más reciente a la más antigua. Para anunciar una mejora
/// nueva: añade sus textos a los ARB, una entrada aquí al principio y, si
/// quieres avisar, manda un aviso desde el panel de admin con destino
/// «Abrir Novedades».
final List<WhatsNewEntry> kWhatsNewEntries = [
  WhatsNewEntry(
    id: 'quick_actions',
    version: '1.4.2',
    icon: Icons.drag_indicator_rounded,
    route: '/quick-actions-edit',
    title: (l) => l.whatsNewQuickActionsTitle,
    body: (l) => l.whatsNewQuickActionsBody,
  ),
  WhatsNewEntry(
    id: 'records',
    version: '1.4.2',
    icon: Icons.album_rounded,
    route: '/records',
    title: (l) => l.whatsNewRecordsTitle,
    body: (l) => l.whatsNewRecordsBody,
  ),
];
