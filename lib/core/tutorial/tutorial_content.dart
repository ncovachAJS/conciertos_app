import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import 'tutorial_overlay.dart';

class TutorialContent {
  // ── Dashboard ────────────────────────────────────────────────────────────

  static List<TutorialStep> dashboard(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.waving_hand_rounded,
      title: l.tutDash1Title,
      description: l.tutDash1Desc,
    ),
    TutorialStep(
      icon: Icons.add_circle_outline_rounded,
      title: l.tutDash2Title,
      description: l.tutDash2Desc,
    ),
    TutorialStep(
      icon: Icons.star_outline_rounded,
      title: l.tutDash3Title,
      description: l.tutDash3Desc,
    ),
    TutorialStep(
      icon: Icons.local_fire_department_rounded,
      title: l.tutDash4Title,
      description: l.tutDash4Desc,
    ),
    TutorialStep(
      icon: Icons.tune_rounded,
      title: l.tutDash5Title,
      description: l.tutDash5Desc,
    ),
  ];

  // ── Añadir / Editar concierto ─────────────────────────────────────────────

  static List<TutorialStep> addConcert(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.music_note_rounded,
      title: l.tutAdd1Title,
      description: l.tutAdd1Desc,
    ),
    TutorialStep(
      icon: Icons.photo_camera_rounded,
      title: l.tutAdd2Title,
      description: l.tutAdd2Desc,
    ),
    TutorialStep(
      icon: Icons.tune_rounded,
      title: l.tutAdd3Title,
      description: l.tutAdd3Desc,
    ),
    TutorialStep(
      icon: Icons.auto_graph_rounded,
      title: l.tutAdd4Title,
      description: l.tutAdd4Desc,
    ),
    TutorialStep(
      icon: Icons.festival_rounded,
      title: l.tutAdd5Title,
      description: l.tutAdd5Desc,
    ),
    TutorialStep(
      icon: Icons.people_rounded,
      title: l.tutAdd6Title,
      description: l.tutAdd6Desc,
    ),
  ];

  // ── Detalle de concierto ─────────────────────────────────────────────────

  static List<TutorialStep> concertDetail(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.info_outline_rounded,
      title: l.tutDetail1Title,
      description: l.tutDetail1Desc,
    ),
    TutorialStep(
      icon: Icons.tune_rounded,
      title: l.tutDetail2Title,
      description: l.tutDetail2Desc,
    ),
    TutorialStep(
      icon: Icons.edit_outlined,
      title: l.tutDetail3Title,
      description: l.tutDetail3Desc,
    ),
    TutorialStep(
      icon: Icons.queue_music_rounded,
      title: l.tutDetail4Title,
      description: l.tutDetail4Desc,
    ),
    TutorialStep(
      icon: Icons.headphones_rounded,
      title: l.tutDetail5Title,
      description: l.tutDetail5Desc,
    ),
    TutorialStep(
      icon: Icons.add_a_photo_rounded,
      title: l.tutDetail6Title,
      description: l.tutDetail6Desc,
    ),
    TutorialStep(
      icon: Icons.place_rounded,
      title: l.tutDetail7Title,
      description: l.tutDetail7Desc,
    ),
    TutorialStep(
      icon: Icons.chat_bubble_outline_rounded,
      title: l.tutDetail8Title,
      description: l.tutDetail8Desc,
    ),
    TutorialStep(
      icon: Icons.qr_code_2_rounded,
      title: l.tutDetail9Title,
      description: l.tutDetail9Desc,
    ),
  ];

  // ── Lista de conciertos ──────────────────────────────────────────────────

  static List<TutorialStep> concerts(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.library_music_rounded,
      title: l.tutConcerts1Title,
      description: l.tutConcerts1Desc,
    ),
    TutorialStep(
      icon: Icons.star_outline_rounded,
      title: l.tutConcerts2Title,
      description: l.tutConcerts2Desc,
    ),
    TutorialStep(
      icon: Icons.view_module_rounded,
      title: l.tutConcerts3Title,
      description: l.tutConcerts3Desc,
    ),
    TutorialStep(
      icon: Icons.calendar_month_rounded,
      title: l.tutConcerts4Title,
      description: l.tutConcerts4Desc,
    ),
    TutorialStep(
      icon: Icons.search_rounded,
      title: l.tutConcerts5Title,
      description: l.tutConcerts5Desc,
    ),
    TutorialStep(
      icon: Icons.map_rounded,
      title: l.tutConcerts6Title,
      description: l.tutConcerts6Desc,
    ),
    TutorialStep(
      icon: Icons.groups_rounded,
      title: l.tutConcerts7Title,
      description: l.tutConcerts7Desc,
    ),
  ];

  // ── Estadísticas ─────────────────────────────────────────────────────────

  static List<TutorialStep> statistics(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.bar_chart_rounded,
      title: l.tutStats1Title,
      description: l.tutStats1Desc,
    ),
    TutorialStep(
      icon: Icons.auto_graph_rounded,
      title: l.tutStats2Title,
      description: l.tutStats2Desc,
    ),
    TutorialStep(
      icon: Icons.emoji_events_rounded,
      title: l.tutStats3Title,
      description: l.tutStats3Desc,
    ),
    TutorialStep(
      icon: Icons.star_half_rounded,
      title: l.tutStats4Title,
      description: l.tutStats4Desc,
    ),
    TutorialStep(
      icon: Icons.festival_rounded,
      title: l.tutStats5Title,
      description: l.tutStats5Desc,
    ),
    TutorialStep(
      icon: Icons.auto_awesome_rounded,
      title: l.tutStats6Title,
      description: l.tutStats6Desc,
    ),
    TutorialStep(
      icon: Icons.tune_rounded,
      title: l.tutStats7Title,
      description: l.tutStats7Desc,
    ),
  ];

  // ── Perfil ───────────────────────────────────────────────────────────────

  static List<TutorialStep> profile(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.account_circle_rounded,
      title: l.tutProfile1Title,
      description: l.tutProfile1Desc,
    ),
    TutorialStep(
      icon: Icons.emoji_events_rounded,
      title: l.tutProfile2Title,
      description: l.tutProfile2Desc,
    ),
    TutorialStep(
      icon: Icons.headphones_rounded,
      title: l.tutProfile3Title,
      description: l.tutProfile3Desc,
    ),
    TutorialStep(
      icon: Icons.auto_awesome_rounded,
      title: l.tutProfile4Title,
      description: l.tutProfile4Desc,
    ),
    TutorialStep(
      icon: Icons.palette_rounded,
      title: l.tutProfile5Title,
      description: l.tutProfile5Desc,
    ),
  ];

  // ── Amigos ───────────────────────────────────────────────────────────────

  static List<TutorialStep> friends(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.people_rounded,
      title: l.tutFriends1Title,
      description: l.tutFriends1Desc,
    ),
    TutorialStep(
      icon: Icons.tab_rounded,
      title: l.tutFriends2Title,
      description: l.tutFriends2Desc,
    ),
    TutorialStep(
      icon: Icons.person_rounded,
      title: l.tutFriends3Title,
      description: l.tutFriends3Desc,
    ),
    TutorialStep(
      icon: Icons.compare_arrows_rounded,
      title: l.tutFriends4Title,
      description: l.tutFriends4Desc,
    ),
    TutorialStep(
      icon: Icons.notifications_rounded,
      title: l.tutFriends5Title,
      description: l.tutFriends5Desc,
    ),
  ];

  // ── Feed de actividad ────────────────────────────────────────────────────

  static List<TutorialStep> feed(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.view_timeline_rounded,
      title: l.tutFeed1Title,
      description: l.tutFeed1Desc,
    ),
    TutorialStep(
      icon: Icons.chat_bubble_outline_rounded,
      title: l.tutFeed2Title,
      description: l.tutFeed2Desc,
    ),
    TutorialStep(
      icon: Icons.photo_library_rounded,
      title: l.tutFeed3Title,
      description: l.tutFeed3Desc,
    ),
  ];

  // ── Recomendaciones ──────────────────────────────────────────────────────

  static List<TutorialStep> recommendations(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.local_fire_department_rounded,
      title: l.tutRecs1Title,
      description: l.tutRecs1Desc,
    ),
    TutorialStep(
      icon: Icons.confirmation_number_rounded,
      title: l.tutRecs2Title,
      description: l.tutRecs2Desc,
    ),
    TutorialStep(
      icon: Icons.add_circle_outline_rounded,
      title: l.tutRecs3Title,
      description: l.tutRecs3Desc,
    ),
  ];

  // ── Importar conciertos ──────────────────────────────────────────────────

  static List<TutorialStep> import_(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.search_rounded,
      title: l.tutImport1Title,
      description: l.tutImport1Desc,
    ),
    TutorialStep(
      icon: Icons.download_done_rounded,
      title: l.tutImport2Title,
      description: l.tutImport2Desc,
    ),
    TutorialStep(
      icon: Icons.backup_rounded,
      title: l.tutImport3Title,
      description: l.tutImport3Desc,
    ),
  ];

  // ── Spotify: mis canciones favoritas ─────────────────────────────────────

  static List<TutorialStep> spotifyPlaylist(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.headphones_rounded,
      title: l.tutSpotifyPlaylist1Title,
      description: l.tutSpotifyPlaylist1Desc,
    ),
    TutorialStep(
      icon: Icons.link_rounded,
      title: l.tutSpotifyPlaylist2Title,
      description: l.tutSpotifyPlaylist2Desc,
    ),
    TutorialStep(
      icon: Icons.sync_rounded,
      title: l.tutSpotifyPlaylist3Title,
      description: l.tutSpotifyPlaylist3Desc,
    ),
  ];

  // ── Importar desde Spotify (artistas) ────────────────────────────────────

  static List<TutorialStep> spotifyImport(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.headphones_rounded,
      title: l.tutSpotifyImport1Title,
      description: l.tutSpotifyImport1Desc,
    ),
    TutorialStep(
      icon: Icons.music_note_rounded,
      title: l.tutSpotifyImport2Title,
      description: l.tutSpotifyImport2Desc,
    ),
    TutorialStep(
      icon: Icons.logout_rounded,
      title: l.tutSpotifyImport3Title,
      description: l.tutSpotifyImport3Desc,
    ),
  ];

  // ── Mapa de conciertos ───────────────────────────────────────────────────

  static List<TutorialStep> concertMap(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.map_rounded,
      title: l.tutMap1Title,
      description: l.tutMap1Desc,
    ),
    TutorialStep(
      icon: Icons.place_rounded,
      title: l.tutMap2Title,
      description: l.tutMap2Desc,
    ),
  ];

  // ── Mapa para el picker de ajustes ───────────────────────────────────────

  static List<TutorialEntry> allEntries(AppLocalizations l) => [
    TutorialEntry(
      label: l.tutEntryDashboard,
      icon: Icons.home_rounded,
      steps: dashboard(l),
    ),
    TutorialEntry(
      label: l.tutEntryConcerts,
      icon: Icons.library_music_rounded,
      steps: concerts(l),
    ),
    TutorialEntry(
      label: l.tutEntryAddConcert,
      icon: Icons.add_circle_outline_rounded,
      steps: addConcert(l),
    ),
    TutorialEntry(
      label: l.tutEntryDetail,
      icon: Icons.info_outline_rounded,
      steps: concertDetail(l),
    ),
    TutorialEntry(
      label: l.tutEntryStats,
      icon: Icons.bar_chart_rounded,
      steps: statistics(l),
    ),
    TutorialEntry(
      label: l.tutEntryProfile,
      icon: Icons.account_circle_rounded,
      steps: profile(l),
    ),
    TutorialEntry(
      label: l.tutEntryFriends,
      icon: Icons.people_rounded,
      steps: friends(l),
    ),
    TutorialEntry(
      label: l.tutEntryFeed,
      icon: Icons.view_timeline_rounded,
      steps: feed(l),
    ),
    TutorialEntry(
      label: l.tutEntryRecs,
      icon: Icons.local_fire_department_rounded,
      steps: recommendations(l),
    ),
    TutorialEntry(
      label: l.tutEntryImport,
      icon: Icons.download_rounded,
      steps: import_(l),
    ),
  ];
}

/// Entrada en el picker de tutoriales de ajustes.
class TutorialEntry {
  final String label;
  final IconData icon;
  final List<TutorialStep> steps;

  const TutorialEntry({
    required this.label,
    required this.icon,
    required this.steps,
  });
}
