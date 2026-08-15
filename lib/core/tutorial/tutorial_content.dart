import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import 'tutorial_overlay.dart';

class TutorialContent {
  // ── Dashboard ────────────────────────────────────────────────────────────

  static List<TutorialStep> dashboard(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.waving_hand_rounded,
      title: '¡Bienvenido a La Vida en Directo!',
      description:
          'Tu diario musical personal. Aquí tenés un resumen rápido de tu actividad: próximos conciertos, estadísticas y todo lo que te queda por valorar.',
    ),
    TutorialStep(
      icon: Icons.star_outline_rounded,
      title: 'Por valorar',
      description:
          'El widget "Por valorar" lista todos tus conciertos pasados que todavía no tienen una valoración detallada. Deslizá entre ellos y tocá uno para puntuarlo.',
    ),
    TutorialStep(
      icon: Icons.add_circle_outline_rounded,
      title: 'Añadí tu primer concierto',
      description:
          'Tocá el botón + para registrar un concierto. Podés añadir artista, recinto, precio, foto y una valoración por criterios: artista, sonido, ambiente, setlist y precio/valor.',
    ),
    TutorialStep(
      icon: Icons.download_rounded,
      title: 'Importar desde Spotify',
      description:
          '¿Ya fuiste a un montón de conciertos? Importalos directamente desde tu historial de Spotify con un par de toques.',
    ),
    TutorialStep(
      icon: Icons.widgets_rounded,
      title: 'Dashboard personalizable',
      description:
          'Pulsá el ícono de edición para reorganizar, mostrar u ocultar los widgets del dashboard según lo que más uses.',
    ),
  ];

  // ── Añadir concierto ─────────────────────────────────────────────────────

  static List<TutorialStep> addConcert(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.music_note_rounded,
      title: 'Registrá el concierto',
      description:
          'Completá artista, recinto, ciudad, fecha y precio. El género musical se sugiere automáticamente desde Spotify al escribir el nombre del artista.',
    ),
    TutorialStep(
      icon: Icons.photo_camera_rounded,
      title: 'Foto del concierto',
      description:
          'Añadí una foto desde tu galería para darle vida al recuerdo. También podés cambiarla o eliminarla más adelante.',
    ),
    TutorialStep(
      icon: Icons.tune_rounded,
      title: 'Valoración por criterios',
      description:
          'Para conciertos pasados, valorá 5 criterios con estrellas: Artista, Sonido, Ambiente, Setlist y Precio/valor. La puntuación general se calcula automáticamente como la media.',
    ),
    TutorialStep(
      icon: Icons.auto_graph_rounded,
      title: 'Nota calculada automáticamente',
      description:
          'No hay puntuación manual: la nota que aparece en tu historial, estadísticas y Wrapped es siempre la media de tus 5 criterios. Más justa y más detallada.',
    ),
    TutorialStep(
      icon: Icons.people_rounded,
      title: 'Etiquetar amigos',
      description:
          '¿Fuiste acompañado? Etiquetá a tus amigos para que el concierto aparezca también en su historial compartido.',
    ),
  ];

  // ── Detalle de concierto ─────────────────────────────────────────────────

  static List<TutorialStep> concertDetail(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.info_outline_rounded,
      title: 'Todo sobre el concierto',
      description:
          'Aquí ves la info completa: fecha, recinto, precio, foto, tus notas y la valoración detallada por criterios con barras de progreso.',
    ),
    TutorialStep(
      icon: Icons.tune_rounded,
      title: 'Valoración detallada',
      description:
          'Si valoraste el concierto, se muestra una tarjeta con la puntuación de cada criterio: Artista, Sonido, Ambiente, Setlist y Precio/valor.',
    ),
    TutorialStep(
      icon: Icons.edit_outlined,
      title: 'Editar en cualquier momento',
      description:
          'Tocá el botón de edición para cambiar cualquier dato o añadir/modificar las valoraciones cuando quieras.',
    ),
    TutorialStep(
      icon: Icons.queue_music_rounded,
      title: 'Setlist automático',
      description:
          'La app busca el setlist real del concierto en Setlist.fm para que puedas revivir canción por canción lo que tocaron.',
    ),
    TutorialStep(
      icon: Icons.headphones_rounded,
      title: 'Sección de Spotify',
      description:
          'Se vincula automáticamente el artista en Spotify: foto, géneros, seguidores y las canciones más populares con su popularidad y duración.',
    ),
    TutorialStep(
      icon: Icons.add_a_photo_rounded,
      title: 'Fotos y recuerdos',
      description:
          'Añadí fotos del concierto y etiquetá a las personas que estuvieron. Quedan guardadas en tu galería de recuerdos.',
    ),
  ];

  // ── Lista de conciertos ──────────────────────────────────────────────────

  static List<TutorialStep> concerts(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.library_music_rounded,
      title: 'Tu historial musical',
      description:
          'Todos tus conciertos en un solo lugar. Los pasados muestran la valoración media de sus criterios; los futuros se marcan como "próximos".',
    ),
    TutorialStep(
      icon: Icons.star_outline_rounded,
      title: 'Valoración media visible',
      description:
          'Cada concierto pasado muestra directamente su nota calculada (media de criterios) o "Sin valorar" si todavía no lo puntuaste.',
    ),
    TutorialStep(
      icon: Icons.view_module_rounded,
      title: 'Tres vistas disponibles',
      description:
          'Cambiá entre vista de lista, cuadrícula o calendario según cómo prefieras explorar tu historial.',
    ),
    TutorialStep(
      icon: Icons.calendar_month_rounded,
      title: 'Vista calendario',
      description:
          'En el calendario podés ver qué días tuviste conciertos y tocar cualquier fecha para ver el detalle.',
    ),
  ];

  // ── Estadísticas ─────────────────────────────────────────────────────────

  static List<TutorialStep> statistics(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.bar_chart_rounded,
      title: 'Tus estadísticas musicales',
      description:
          'Un análisis completo de tu historial: total de conciertos, artistas únicos, ciudades, géneros, gasto total y mucho más.',
    ),
    TutorialStep(
      icon: Icons.auto_graph_rounded,
      title: 'Valoraciones reales',
      description:
          'Todas las métricas de valoración usan la media de tus criterios detallados. Solo cuentan los conciertos que hayas valorado con el sistema actual.',
    ),
    TutorialStep(
      icon: Icons.emoji_events_rounded,
      title: 'Top artistas y festivales',
      description:
          'Descubrí cuáles son los artistas que más veces viste, los mejores valorados y los festivales que más te marcaron.',
    ),
    TutorialStep(
      icon: Icons.tune_rounded,
      title: 'Personalizar secciones',
      description:
          'Tocá el ícono de edición para elegir qué secciones de estadísticas querés ver y en qué orden.',
    ),
  ];

  // ── Perfil ───────────────────────────────────────────────────────────────

  static List<TutorialStep> profile(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.account_circle_rounded,
      title: 'Tu acreditación',
      description:
          'Tu perfil resume todo tu historial musical: conciertos, fotos, favoritos y tu nivel de fan basado en cuántos shows llevás.',
    ),
    TutorialStep(
      icon: Icons.emoji_events_rounded,
      title: 'Logros desbloqueables',
      description:
          'Ganás medallas por hitos musicales: 10 conciertos, primer festival, artista repetido, alta valoración y mucho más. ¿Cuántos podés coleccionar?',
    ),
    TutorialStep(
      icon: Icons.headphones_rounded,
      title: 'Mis artistas',
      description:
          'Un ranking de tus artistas más presentes enriquecido con Spotify: foto, seguidores, cuántas veces los viste y tu valoración media de sus conciertos.',
    ),
    TutorialStep(
      icon: Icons.auto_awesome_rounded,
      title: 'Tu año en conciertos',
      description:
          'Accedé al Wrapped anual desde tu perfil: un resumen animado con artista del año, ciudad favorita, valoración media y todos tus momentos del año.',
    ),
  ];

  // ── Amigos ───────────────────────────────────────────────────────────────

  static List<TutorialStep> friends(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.people_rounded,
      title: 'Conectá con tu gente',
      description:
          'Buscá amigos por nombre o email y enviá solicitudes de amistad. Cuando te acepten, podés ver sus conciertos y comparar historiales.',
    ),
    TutorialStep(
      icon: Icons.tab_rounded,
      title: 'Amigos y solicitudes',
      description:
          'La primera pestaña muestra tus amigos actuales. La segunda gestiona las solicitudes pendientes que hayas recibido.',
    ),
    TutorialStep(
      icon: Icons.compare_arrows_rounded,
      title: 'Comparar estadísticas',
      description:
          'Desde el perfil de un amigo podés comparar tus estadísticas frente a frente: total de conciertos, artistas en común, valoración media y artista favorito.',
    ),
    TutorialStep(
      icon: Icons.notifications_rounded,
      title: 'Actividad de amigos',
      description:
          'Recibís notificaciones cuando un amigo añade un concierto. También podés comentar en su actividad desde el feed de amigos.',
    ),
  ];

  // ── Feed de actividad ────────────────────────────────────────────────────

  static List<TutorialStep> feed(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.view_timeline_rounded,
      title: 'Feed de amigos',
      description:
          'Seguí la actividad musical de tus amigos en tiempo real: qué conciertos añadieron y cuándo.',
    ),
    TutorialStep(
      icon: Icons.chat_bubble_outline_rounded,
      title: 'Comentar conciertos',
      description:
          'Tocá "Comentar" en cualquier actividad para dejar un mensaje. Abrí el hilo de comentarios para ver la conversación completa.',
    ),
    TutorialStep(
      icon: Icons.photo_library_rounded,
      title: 'Galería compartida',
      description:
          'En la pestaña de fotos ves las imágenes que vos y tus amigos subieron a sus conciertos.',
    ),
  ];

  // ── Recomendaciones ──────────────────────────────────────────────────────

  static List<TutorialStep> recommendations(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.local_fire_department_rounded,
      title: 'Conciertos cerca de vos',
      description:
          'Descubrí eventos próximos basados en tu ubicación y los artistas que ya seguís. Datos en tiempo real de Ticketmaster.',
    ),
    TutorialStep(
      icon: Icons.confirmation_number_rounded,
      title: 'Quiero ir',
      description:
          'Marcá un evento como "Quiero ir" para guardarlo y acceder rápidamente al link de compra de entradas cuando estés listo.',
    ),
  ];

  // ── Importar desde Spotify ───────────────────────────────────────────────

  static List<TutorialStep> import_(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.search_rounded,
      title: 'Buscar conciertos pasados',
      description:
          'Escribí el nombre de un artista y la app buscará sus conciertos anteriores en Setlist.fm para que puedas importar los que hayas visto.',
    ),
    TutorialStep(
      icon: Icons.download_done_rounded,
      title: 'Seleccionar e importar',
      description:
          'Elegí los conciertos de la lista y se añaden automáticamente a tu historial. Después podés editarlos para agregar foto, precio y valoración detallada.',
    ),
  ];

  // ── Mapa para el picker de ajustes ───────────────────────────────────────

  static List<TutorialEntry> allEntries(AppLocalizations l) => [
    TutorialEntry(
      label: 'Inicio / Dashboard',
      icon: Icons.home_rounded,
      steps: dashboard(l),
    ),
    TutorialEntry(
      label: 'Mis conciertos',
      icon: Icons.library_music_rounded,
      steps: concerts(l),
    ),
    TutorialEntry(
      label: 'Valorar / Añadir concierto',
      icon: Icons.add_circle_outline_rounded,
      steps: addConcert(l),
    ),
    TutorialEntry(
      label: 'Detalle de concierto',
      icon: Icons.info_outline_rounded,
      steps: concertDetail(l),
    ),
    TutorialEntry(
      label: 'Estadísticas',
      icon: Icons.bar_chart_rounded,
      steps: statistics(l),
    ),
    TutorialEntry(
      label: 'Mi perfil',
      icon: Icons.account_circle_rounded,
      steps: profile(l),
    ),
    TutorialEntry(
      label: 'Amigos',
      icon: Icons.people_rounded,
      steps: friends(l),
    ),
    TutorialEntry(
      label: 'Feed de actividad',
      icon: Icons.view_timeline_rounded,
      steps: feed(l),
    ),
    TutorialEntry(
      label: 'Recomendaciones',
      icon: Icons.local_fire_department_rounded,
      steps: recommendations(l),
    ),
    TutorialEntry(
      label: 'Importar conciertos',
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
