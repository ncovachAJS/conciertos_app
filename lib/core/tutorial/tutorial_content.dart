import 'package:flutter/material.dart';
import 'tutorial_overlay.dart';

/// Contenido de los tutoriales de la app
class TutorialContent {
  static const List<TutorialStep> dashboard = [
    TutorialStep(
      icon: Icons.waving_hand_rounded,
      title: '¡Bienvenido a La Vida en Directo!',
      description:
          'Tu diario personal de conciertos. Aquí encontrarás todo lo que necesitas para recordar cada directo.',
    ),
    TutorialStep(
      icon: Icons.add_circle_outline_rounded,
      title: 'Añade tu primer concierto',
      description:
          'Pulsa el botón "Añadir" para registrar un concierto. Puedes añadir la fecha, el recinto, fotos y valorarlo.',
    ),
    TutorialStep(
      icon: Icons.download_rounded,
      title: 'Importa desde Setlist.fm',
      description:
          'Usa el botón "Importar" para traer conciertos automáticamente desde Setlist.fm con un solo toque.',
    ),
    TutorialStep(
      icon: Icons.favorite_rounded,
      title: 'Guarda tus favoritos',
      description:
          'Marca los artistas que más te gustan como favoritos. Los encontrarás agrupados en la pestaña Favoritos.',
    ),
    TutorialStep(
      icon: Icons.photo_library_rounded,
      title: 'Guarda tus recuerdos',
      description:
          'En la pestaña Recuerdos puedes ver todas las fotos de tus conciertos organizadas por año.',
    ),
  ];

  static const List<TutorialStep> addConcert = [
    TutorialStep(
      icon: Icons.music_note_rounded,
      title: 'Añade un concierto',
      description:
          'Rellena el nombre del artista, la fecha y el recinto. El resto es opcional.',
    ),
    TutorialStep(
      icon: Icons.photo_camera_rounded,
      title: 'Añade una imagen',
      description:
          'Puedes añadir una foto del concierto o del artista. Se usará como portada en tu colección.',
    ),
    TutorialStep(
      icon: Icons.star_rounded,
      title: 'Valora tu experiencia',
      description:
          'Para conciertos pasados puedes añadir una valoración de 1 a 5 estrellas. Toca la estrella activa para quitarla.',
    ),
    TutorialStep(
      icon: Icons.thumb_up_rounded,
      title: 'Me gusta y Favorito',
      description:
          '👍 "Me gusta" marca conciertos que disfrutaste. ⭐ "Favorito" agrupa el artista en tu lista de favoritos.',
    ),
  ];

  static const List<TutorialStep> concertDetail = [
    TutorialStep(
      icon: Icons.info_outline_rounded,
      title: 'Detalle del concierto',
      description:
          'Aquí ves toda la información del concierto: fecha, recinto, ciudad y tus fotos.',
    ),
    TutorialStep(
      icon: Icons.edit_outlined,
      title: 'Edita cuando quieras',
      description:
          'Pulsa el icono ✏️ arriba a la derecha para editar cualquier detalle o cambiar la imagen.',
    ),
    TutorialStep(
      icon: Icons.queue_music_rounded,
      title: 'Setlist automático',
      description:
          'Si el concierto está en Setlist.fm, verás automáticamente las canciones que tocaron esa noche.',
    ),
    TutorialStep(
      icon: Icons.add_a_photo_rounded,
      title: 'Añade tus fotos',
      description:
          'En la sección Recuerdos puedes añadir todas las fotos que quieras del concierto. Selección múltiple.',
    ),
  ];
}
