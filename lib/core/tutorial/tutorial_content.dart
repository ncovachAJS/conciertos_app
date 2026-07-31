import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import 'tutorial_overlay.dart';

class TutorialContent {
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
}
