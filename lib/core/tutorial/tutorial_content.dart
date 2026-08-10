import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import 'tutorial_overlay.dart';

class TutorialContent {
  // ── Pantallas existentes ────────────────────────────────────────────────

  static List<TutorialStep> dashboard(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.waving_hand_rounded,
      title: l.tutorialWelcomeTitle,
      description: l.tutorialWelcomeDesc,
    ),
    TutorialStep(
      icon: Icons.add_circle_outline_rounded,
      title: l.tutorialAddTitle,
      description: l.tutorialAddDesc,
    ),
    TutorialStep(
      icon: Icons.download_rounded,
      title: l.tutorialImportTitle,
      description: l.tutorialImportDesc,
    ),
    TutorialStep(
      icon: Icons.favorite_rounded,
      title: l.tutorialFavoritesTitle,
      description: l.tutorialFavoritesDesc,
    ),
    TutorialStep(
      icon: Icons.photo_library_rounded,
      title: l.tutorialMemoriesTitle,
      description: l.tutorialMemoriesDesc,
    ),
  ];

  static List<TutorialStep> addConcert(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.music_note_rounded,
      title: l.tutorialAddConcertTitle,
      description: l.tutorialAddConcertDesc,
    ),
    TutorialStep(
      icon: Icons.photo_camera_rounded,
      title: l.tutorialAddImageTitle,
      description: l.tutorialAddImageDesc,
    ),
    TutorialStep(
      icon: Icons.star_rounded,
      title: l.tutorialRateTitle,
      description: l.tutorialRateDesc,
    ),
    TutorialStep(
      icon: Icons.thumb_up_rounded,
      title: l.tutorialLikeTitle,
      description: l.tutorialLikeDesc,
    ),
  ];

  static List<TutorialStep> concertDetail(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.info_outline_rounded,
      title: l.tutorialDetailTitle,
      description: l.tutorialDetailDesc,
    ),
    TutorialStep(
      icon: Icons.edit_outlined,
      title: l.tutorialEditTitle,
      description: l.tutorialEditDesc,
    ),
    TutorialStep(
      icon: Icons.queue_music_rounded,
      title: l.tutorialSetlistTitle,
      description: l.tutorialSetlistDesc,
    ),
    TutorialStep(
      icon: Icons.add_a_photo_rounded,
      title: l.tutorialPhotosTitle,
      description: l.tutorialPhotosDesc,
    ),
  ];

  // ── Pantallas nuevas ────────────────────────────────────────────────────

  static List<TutorialStep> concerts(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.library_music_rounded,
      title: l.tutorialConcertsTitle,
      description: l.tutorialConcertsDesc,
    ),
    TutorialStep(
      icon: Icons.view_module_rounded,
      title: l.tutorialConcertsViewTitle,
      description: l.tutorialConcertsViewDesc,
    ),
    TutorialStep(
      icon: Icons.calendar_month_rounded,
      title: l.tutorialConcertsCalTitle,
      description: l.tutorialConcertsCalDesc,
    ),
  ];

  static List<TutorialStep> statistics(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.bar_chart_rounded,
      title: l.tutorialStatsOverviewTitle,
      description: l.tutorialStatsOverviewDesc,
    ),
    TutorialStep(
      icon: Icons.show_chart_rounded,
      title: l.tutorialStatsChartTitle,
      description: l.tutorialStatsChartDesc,
    ),
    TutorialStep(
      icon: Icons.emoji_events_rounded,
      title: l.tutorialStatsTopTitle,
      description: l.tutorialStatsTopDesc,
    ),
  ];

  static List<TutorialStep> profile(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.account_circle_rounded,
      title: l.tutorialProfileOverviewTitle,
      description: l.tutorialProfileOverviewDesc,
    ),
    TutorialStep(
      icon: Icons.emoji_events_rounded,
      title: l.tutorialProfileAchTitle,
      description: l.tutorialProfileAchDesc,
    ),
  ];

  static List<TutorialStep> friends(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.people_rounded,
      title: l.tutorialFriendsConnectTitle,
      description: l.tutorialFriendsConnectDesc,
    ),
    TutorialStep(
      icon: Icons.tab_rounded,
      title: l.tutorialFriendsTabsTitle,
      description: l.tutorialFriendsTabsDesc,
    ),
    TutorialStep(
      icon: Icons.notifications_rounded,
      title: l.tutorialFriendsActivityTitle,
      description: l.tutorialFriendsActivityDesc,
    ),
  ];

  static List<TutorialStep> feed(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.photo_library_rounded,
      title: l.tutorialFeedPhotosTitle,
      description: l.tutorialFeedPhotosDesc,
    ),
    TutorialStep(
      icon: Icons.view_timeline_rounded,
      title: l.tutorialFeedViewTitle,
      description: l.tutorialFeedViewDesc,
    ),
  ];

  static List<TutorialStep> recommendations(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.local_fire_department_rounded,
      title: l.tutorialRecsDiscoverTitle,
      description: l.tutorialRecsDiscoverDesc,
    ),
    TutorialStep(
      icon: Icons.confirmation_number_rounded,
      title: l.tutorialRecsWantTitle,
      description: l.tutorialRecsWantDesc,
    ),
  ];

  static List<TutorialStep> import_(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.search_rounded,
      title: l.tutorialImportSearchTitle,
      description: l.tutorialImportSearchDesc,
    ),
    TutorialStep(
      icon: Icons.download_done_rounded,
      title: l.tutorialImportSelectTitle,
      description: l.tutorialImportSelectDesc,
    ),
  ];

  // ── Mapa para el picker de ajustes ────────────────────────────────────────
  /// Retorna todas las entradas de tutorial disponibles para el picker.
  static List<TutorialEntry> allEntries(AppLocalizations l) => [
    TutorialEntry(
      label: l.tutorialPickerDashboard,
      icon: Icons.home_rounded,
      steps: dashboard(l),
    ),
    TutorialEntry(
      label: l.tutorialPickerConcerts,
      icon: Icons.library_music_rounded,
      steps: concerts(l),
    ),
    TutorialEntry(
      label: l.tutorialPickerAddConcert,
      icon: Icons.add_circle_outline_rounded,
      steps: addConcert(l),
    ),
    TutorialEntry(
      label: l.tutorialPickerDetail,
      icon: Icons.info_outline_rounded,
      steps: concertDetail(l),
    ),
    TutorialEntry(
      label: l.tutorialPickerStats,
      icon: Icons.bar_chart_rounded,
      steps: statistics(l),
    ),
    TutorialEntry(
      label: l.tutorialPickerProfile,
      icon: Icons.account_circle_rounded,
      steps: profile(l),
    ),
    TutorialEntry(
      label: l.tutorialPickerFriends,
      icon: Icons.people_rounded,
      steps: friends(l),
    ),
    TutorialEntry(
      label: l.tutorialPickerFeed,
      icon: Icons.photo_library_rounded,
      steps: feed(l),
    ),
    TutorialEntry(
      label: l.tutorialPickerRecs,
      icon: Icons.local_fire_department_rounded,
      steps: recommendations(l),
    ),
    TutorialEntry(
      label: l.tutorialPickerImport,
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
