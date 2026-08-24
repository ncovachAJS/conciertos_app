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
          'Tu diario musical personal. El dashboard te muestra de un vistazo tus próximos conciertos, estadísticas clave, actividad de amigos y mucho más.',
    ),
    TutorialStep(
      icon: Icons.add_circle_outline_rounded,
      title: 'Añade un concierto',
      description:
          'Toca el botón + en cualquier momento para registrar un concierto: artista, recinto, fecha, precio, foto y valoración detallada por criterios.',
    ),
    TutorialStep(
      icon: Icons.star_outline_rounded,
      title: 'Por valorar',
      description:
          'El widget "Por valorar" lista los conciertos pasados que todavía no tienen puntuación. Desliza entre ellos y toca uno para valorarlo en 5 criterios.',
    ),
    TutorialStep(
      icon: Icons.headphones_rounded,
      title: 'Tus canciones favoritas',
      description:
          'El widget de Spotify muestra tu playlist personal directamente en la app. Cada usuario ve la suya propia. Necesitas vincular tu cuenta de Spotify para activarlo.',
    ),
    TutorialStep(
      icon: Icons.local_fire_department_rounded,
      title: 'Conciertos recomendados',
      description:
          'Descubre eventos próximos cerca de ti basados en tus artistas. Toca uno para ver detalles y acceder al enlace de compra de entradas.',
    ),
    TutorialStep(
      icon: Icons.tune_rounded,
      title: 'Personalizar el dashboard (Pro)',
      description:
          'Con la versión Pro puedes reorganizar, mostrar u ocultar los widgets del dashboard pulsando el icono de edición junto al saludo.',
    ),
  ];

  // ── Añadir / Editar concierto ─────────────────────────────────────────────

  static List<TutorialStep> addConcert(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.music_note_rounded,
      title: 'Registra el concierto',
      description:
          'Completa artista, recinto, ciudad, fecha y precio. El género musical se sugiere automáticamente desde Spotify al escribir el nombre del artista.',
    ),
    TutorialStep(
      icon: Icons.photo_camera_rounded,
      title: 'Foto del concierto',
      description:
          'Añade una foto desde tu galería para darle vida al recuerdo. Puedes cambiarla o eliminarla más adelante desde la pantalla de edición.',
    ),
    TutorialStep(
      icon: Icons.tune_rounded,
      title: 'Valoración por criterios',
      description:
          'Valora 5 criterios con estrellas: Artista, Sonido, Ambiente, Setlist y Precio/valor. La puntuación general se calcula automáticamente como la media.',
    ),
    TutorialStep(
      icon: Icons.auto_graph_rounded,
      title: 'Nota calculada automáticamente',
      description:
          'No hay puntuación manual: la nota que aparece en tu historial y estadísticas es siempre la media de tus 5 criterios. Más justa y más detallada.',
    ),
    TutorialStep(
      icon: Icons.festival_rounded,
      title: 'Festival o concierto individual',
      description:
          'Indica si fue un festival para que tus estadísticas distingan entre ambos formatos y puedas ver el reparto en la sección "Festival vs. individual".',
    ),
    TutorialStep(
      icon: Icons.people_rounded,
      title: 'Etiquetar amigos',
      description:
          '¿Fuiste acompañado? Etiqueta a tus amigos para que el concierto aparezca también en su historial compartido y puedan verlo desde su perfil.',
    ),
  ];

  // ── Detalle de concierto ─────────────────────────────────────────────────

  static List<TutorialStep> concertDetail(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.info_outline_rounded,
      title: 'Todo sobre el concierto',
      description:
          'Aquí ves la info completa: fecha, recinto, ciudad, precio, foto, tus notas personales y la valoración detallada por criterios con barras de progreso.',
    ),
    TutorialStep(
      icon: Icons.tune_rounded,
      title: 'Valoración detallada',
      description:
          'Si puntuaste el concierto, se muestra una tarjeta con la nota de cada criterio: Artista, Sonido, Ambiente, Setlist y Precio/valor, además de la media.',
    ),
    TutorialStep(
      icon: Icons.edit_outlined,
      title: 'Editar en cualquier momento',
      description:
          'Toca el botón de edición (lápiz) para cambiar cualquier dato, añadir o modificar las valoraciones, la foto o las notas cuando quieras.',
    ),
    TutorialStep(
      icon: Icons.queue_music_rounded,
      title: 'Setlist automático',
      description:
          'La app busca el setlist real del concierto en Setlist.fm para que puedas revivir canción por canción lo que tocaron esa noche.',
    ),
    TutorialStep(
      icon: Icons.headphones_rounded,
      title: 'Artista en Spotify',
      description:
          'Se vincula automáticamente el artista en Spotify: foto, géneros, seguidores y las canciones más populares con su popularidad y duración.',
    ),
    TutorialStep(
      icon: Icons.add_a_photo_rounded,
      title: 'Fotos y recuerdos',
      description:
          'Añade fotos del concierto y etiqueta a las personas que estuvieron. Quedan guardadas en tu galería personal de recuerdos.',
    ),
    TutorialStep(
      icon: Icons.place_rounded,
      title: 'Recinto y ubicación',
      description:
          'Toca el nombre del recinto para ver todos los conciertos que tienes registrados en ese mismo lugar y explorar su ubicación en el mapa.',
    ),
    TutorialStep(
      icon: Icons.chat_bubble_outline_rounded,
      title: 'Comentarios',
      description:
          'Tus amigos pueden comentar el concierto si los etiquetaste. Abre la sección de comentarios para ver o continuar la conversación.',
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
      title: 'Valoración visible',
      description:
          'Cada concierto pasado muestra su nota calculada (media de criterios) o "Sin valorar" si todavía no lo has puntuado. Tócalo para valorarlo.',
    ),
    TutorialStep(
      icon: Icons.view_module_rounded,
      title: 'Tres vistas disponibles',
      description:
          'Cambia entre vista de lista, cuadrícula compacta o calendario según cómo prefieras explorar tu historial.',
    ),
    TutorialStep(
      icon: Icons.calendar_month_rounded,
      title: 'Vista calendario',
      description:
          'El calendario marca los días en que tuviste un concierto. Toca cualquier fecha para ver el detalle o añadir uno nuevo en ese día.',
    ),
    TutorialStep(
      icon: Icons.search_rounded,
      title: 'Buscar y filtrar',
      description:
          'Usa la barra de búsqueda para encontrar conciertos por artista, recinto o ciudad, y filtra por año para navegar rápidamente por tu historial.',
    ),
    TutorialStep(
      icon: Icons.map_rounded,
      title: 'Mapa de conciertos',
      description:
          'Toca el icono de mapa para ver todos tus conciertos geolocalizados. Explora en qué ciudades y recintos has estado y descubre patrones.',
    ),
  ];

  // ── Estadísticas ─────────────────────────────────────────────────────────

  static List<TutorialStep> statistics(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.bar_chart_rounded,
      title: 'Tus estadísticas musicales',
      description:
          'Un análisis completo de tu historial: total de conciertos, artistas únicos, ciudades visitadas, géneros favoritos, gasto total y mucho más.',
    ),
    TutorialStep(
      icon: Icons.auto_graph_rounded,
      title: 'Conciertos por año y mes',
      description:
          'Gráficas de barras que muestran cómo se distribuyen tus conciertos a lo largo del tiempo. Descubre tus temporadas más activas.',
    ),
    TutorialStep(
      icon: Icons.emoji_events_rounded,
      title: 'Top artistas, géneros y recintos',
      description:
          'Rankings de los artistas más vistos, géneros más escuchados en vivo y recintos más visitados. Con foto de Spotify cuando está disponible.',
    ),
    TutorialStep(
      icon: Icons.star_half_rounded,
      title: 'Valoraciones y distribución',
      description:
          'Histograma de tus notas, valoración media por año y tus artistas mejor valorados. Solo se cuentan los conciertos puntuados con el sistema de criterios.',
    ),
    TutorialStep(
      icon: Icons.festival_rounded,
      title: 'Festival vs. individual',
      description:
          'Gráfico circular que muestra el reparto entre tus conciertos de festival y los individuales, para conocer tu perfil como espectador.',
    ),
    TutorialStep(
      icon: Icons.auto_awesome_rounded,
      title: 'Resumen anual',
      description:
          'Desde el icono de calendario accedes al Wrapped de cualquier año: artista estrella, ciudad favorita, valoración media y los momentos más destacados.',
    ),
    TutorialStep(
      icon: Icons.tune_rounded,
      title: 'Personalizar secciones (Pro)',
      description:
          'Con la versión Pro puedes elegir qué secciones de estadísticas quieres ver y reordenarlas a tu gusto pulsando el icono de edición.',
    ),
  ];

  // ── Perfil ───────────────────────────────────────────────────────────────

  static List<TutorialStep> profile(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.account_circle_rounded,
      title: 'Tu acreditación',
      description:
          'Tu perfil resume todo tu historial musical: número de conciertos, fotos, favoritos y tu nivel de fan basado en cuántos shows llevas acumulados.',
    ),
    TutorialStep(
      icon: Icons.emoji_events_rounded,
      title: 'Logros desbloqueables',
      description:
          'Ganas medallas por hitos musicales: 10 conciertos, primer festival, ver un artista repetido, conseguir una valoración perfecta y mucho más.',
    ),
    TutorialStep(
      icon: Icons.headphones_rounded,
      title: 'Mis artistas',
      description:
          'Ranking de tus artistas más vistos, enriquecido con datos de Spotify: foto, seguidores, cuántas veces los has visto y tu valoración media de sus shows.',
    ),
    TutorialStep(
      icon: Icons.auto_awesome_rounded,
      title: 'Wrapped anual',
      description:
          'Accede al resumen animado de cada año desde tu perfil: artista del año, ciudad favorita, valoración media y todos tus conciertos destacados.',
    ),
    TutorialStep(
      icon: Icons.palette_rounded,
      title: 'Tema de color (Pro)',
      description:
          'Con la versión Pro puedes personalizar el color principal de la app desde los ajustes. Elige el que mejor refleje tu estilo musical.',
    ),
  ];

  // ── Amigos ───────────────────────────────────────────────────────────────

  static List<TutorialStep> friends(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.people_rounded,
      title: 'Conecta con tu gente',
      description:
          'Busca amigos por nombre o email y envía solicitudes de amistad. Cuando te acepten, puedes ver sus conciertos y comparar historiales.',
    ),
    TutorialStep(
      icon: Icons.tab_rounded,
      title: 'Amigos y solicitudes',
      description:
          'La primera pestaña lista tus amigos actuales. La segunda gestiona las solicitudes pendientes que hayas recibido.',
    ),
    TutorialStep(
      icon: Icons.person_rounded,
      title: 'Perfil de amigo',
      description:
          'Toca a un amigo para ver su perfil: sus conciertos, artistas favoritos y logros. Puedes explorar su historial aunque sea privado si sois amigos.',
    ),
    TutorialStep(
      icon: Icons.compare_arrows_rounded,
      title: 'Comparar estadísticas',
      description:
          'Desde el perfil de un amigo toca "Comparar" para ver vuestras estadísticas frente a frente: total de conciertos, artistas en común y valoración media.',
    ),
    TutorialStep(
      icon: Icons.notifications_rounded,
      title: 'Notificaciones de actividad',
      description:
          'Recibes una notificación cuando un amigo añade un concierto o te etiqueta en uno. También puedes comentar su actividad desde el feed.',
    ),
  ];

  // ── Feed de actividad ────────────────────────────────────────────────────

  static List<TutorialStep> feed(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.view_timeline_rounded,
      title: 'Feed de amigos',
      description:
          'Sigue la actividad musical de tus amigos en tiempo real: qué conciertos añadieron, cuándo y con quién fueron.',
    ),
    TutorialStep(
      icon: Icons.chat_bubble_outline_rounded,
      title: 'Comentar conciertos',
      description:
          'Toca "Comentar" en cualquier actividad para dejar un mensaje. Abre el hilo completo para ver la conversación y responder.',
    ),
    TutorialStep(
      icon: Icons.photo_library_rounded,
      title: 'Galería compartida',
      description:
          'En la pestaña de fotos ves todas las imágenes que tú y tus amigos subisteis a vuestros conciertos, ordenadas cronológicamente.',
    ),
  ];

  // ── Recomendaciones ──────────────────────────────────────────────────────

  static List<TutorialStep> recommendations(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.local_fire_department_rounded,
      title: 'Conciertos cerca de ti',
      description:
          'Descubre eventos próximos basados en tu ubicación y los artistas que ya sigues en la app. Datos en tiempo real de Ticketmaster.',
    ),
    TutorialStep(
      icon: Icons.confirmation_number_rounded,
      title: 'Quiero ir',
      description:
          'Marca un evento como "Quiero ir" para guardarlo y acceder rápidamente al enlace de compra cuando estés listo para comprarlo.',
    ),
    TutorialStep(
      icon: Icons.add_circle_outline_rounded,
      title: 'Añadir directamente',
      description:
          'Si ya tienes entradas para un evento recomendado, toca "Añadir" para registrarlo en tu historial como concierto futuro.',
    ),
  ];

  // ── Importar conciertos ──────────────────────────────────────────────────

  static List<TutorialStep> import_(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.search_rounded,
      title: 'Buscar en Setlist.fm',
      description:
          'En la pestaña "Setlist.fm" escribe el nombre de un artista. La app mostrará sus conciertos pasados para que elijas los que hayas asistido.',
    ),
    TutorialStep(
      icon: Icons.download_done_rounded,
      title: 'Seleccionar e importar',
      description:
          'Marca los conciertos de la lista y toca "Importar". Se añaden automáticamente a tu historial; después puedes editar cada uno para añadir foto, precio y valoración.',
    ),
    TutorialStep(
      icon: Icons.backup_rounded,
      title: 'Copia de seguridad',
      description:
          'En la pestaña "Copia de seguridad" puedes exportar todos tus conciertos a un archivo o restaurarlos desde una copia anterior para no perder nada.',
    ),
  ];

  // ── Spotify: mis canciones favoritas ─────────────────────────────────────

  static List<TutorialStep> spotifyPlaylist(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.headphones_rounded,
      title: 'Tu playlist de Spotify',
      description:
          'Esta pantalla muestra el reproductor embebido de Spotify con tu playlist personal. Cada usuario ve la suya propia gracias al acceso OAuth.',
    ),
    TutorialStep(
      icon: Icons.link_rounded,
      title: 'Vincular tu cuenta',
      description:
          'Si aún no has vinculado Spotify, toca "Conectar con Spotify" para autorizar el acceso. Solo necesitas hacerlo una vez.',
    ),
    TutorialStep(
      icon: Icons.sync_rounded,
      title: 'Actualizar permisos',
      description:
          'Si ves el botón "Re-vincular Spotify" significa que tu sesión necesita un permiso adicional para acceder a playlists. Tócalo para actualizarla.',
    ),
  ];

  // ── Importar desde Spotify (artistas) ────────────────────────────────────

  static List<TutorialStep> spotifyImport(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.headphones_rounded,
      title: 'Tus artistas de Spotify',
      description:
          'Al vincular tu cuenta de Spotify, la app muestra aquí los artistas que más escuchas. Toca uno para buscar sus conciertos pasados en Setlist.fm.',
    ),
    TutorialStep(
      icon: Icons.music_note_rounded,
      title: 'Importar conciertos del artista',
      description:
          'Al tocar un artista se abre la lista de sus conciertos pasados. Selecciona los que hayas visto y se añaden directamente a tu historial.',
    ),
    TutorialStep(
      icon: Icons.logout_rounded,
      title: 'Desconectar Spotify',
      description:
          'Toca el icono de salida en la esquina superior derecha para desvincular tu cuenta de Spotify en cualquier momento.',
    ),
  ];

  // ── Mapa de conciertos ───────────────────────────────────────────────────

  static List<TutorialStep> concertMap(AppLocalizations l) => [
    TutorialStep(
      icon: Icons.map_rounded,
      title: 'Tu mapa musical',
      description:
          'Todos tus conciertos geolocalizados en el mapa. Cada pin representa un concierto; las ciudades más visitadas se destacan con marcadores más grandes.',
    ),
    TutorialStep(
      icon: Icons.place_rounded,
      title: 'Explorar conciertos',
      description:
          'Toca cualquier pin para ver el nombre del artista, el recinto y la fecha. Desde ahí puedes abrir el detalle completo del concierto.',
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
      label: 'Añadir / Editar concierto',
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
    TutorialEntry(
      label: 'Spotify: canciones favoritas',
      icon: Icons.headphones_rounded,
      steps: spotifyPlaylist(l),
    ),
    TutorialEntry(
      label: 'Importar desde Spotify',
      icon: Icons.download_rounded,
      steps: spotifyImport(l),
    ),
    TutorialEntry(
      label: 'Mapa de conciertos',
      icon: Icons.map_rounded,
      steps: concertMap(l),
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
