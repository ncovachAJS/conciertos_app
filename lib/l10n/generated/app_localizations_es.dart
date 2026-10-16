// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get retry => 'Reintentar';

  @override
  String get close => 'Cerrar';

  @override
  String get search => 'Buscar';

  @override
  String get add => 'Añadir';

  @override
  String get publish => 'Publicar';

  @override
  String get done => 'Listo';

  @override
  String get tag => 'Etiquetar';

  @override
  String get all => 'Todos';

  @override
  String get understood => 'Entendido';

  @override
  String get error => 'Error';

  @override
  String get loading => 'Cargando...';

  @override
  String get importing => 'Importando...';

  @override
  String get deleting => 'Eliminando...';

  @override
  String get year => 'Año';

  @override
  String get country => 'País';

  @override
  String get loginTitle => 'Iniciar sesión';

  @override
  String get registerTitle => 'Crear cuenta';

  @override
  String get forgotPasswordTitle => 'Recuperar contraseña';

  @override
  String get forgotPasswordLink => '¿Olvidaste tu contraseña?';

  @override
  String get noAccountSignUp => '¿No tienes cuenta? Crear una cuenta';

  @override
  String get sendLink => 'Enviar enlace';

  @override
  String get backToLogin => 'Volver al login';

  @override
  String get connectionError => 'Error de conexión. Inténtalo de nuevo.';

  @override
  String get concertsTitle => 'Conciertos';

  @override
  String get searchConcertsHint => 'Artista, festival, ciudad, recinto...';

  @override
  String get deleteConcert => 'Eliminar concierto';

  @override
  String get sharedBadge => 'Compartido';

  @override
  String get viewConcert => 'Ver concierto';

  @override
  String get couldNotUpdateFavorite => 'No se pudo actualizar el favorito';

  @override
  String get couldNotUpdateLike => 'No se pudo actualizar \"Me gusta\"';

  @override
  String get deletingConcert => 'Eliminando...';

  @override
  String get searchArtistSpotify => 'Buscar artista en Spotify';

  @override
  String get artistNameHint => 'Nombre del artista...';

  @override
  String get dateLabel => 'Fecha';

  @override
  String get venueLabel => 'Sala / Estadio';

  @override
  String get cityLabel => 'Ciudad';

  @override
  String get concertLabel => 'Concierto';

  @override
  String get addConcertsForStats =>
      'Añade conciertos para ver tus estadísticas.';

  @override
  String get noConcerts => 'Todavía no hay conciertos.';

  @override
  String get noConcertsYet => 'Todavía no tienes conciertos.';

  @override
  String get addConcertTitle => 'Añadir concierto';

  @override
  String get editConcertTitle => 'Editar concierto';

  @override
  String get artistLabel => 'Artista';

  @override
  String get festivalLabel => 'Festival';

  @override
  String get concertNameLabel => 'Nombre de gira/tour';

  @override
  String get concertNameHint => 'Ej. Iron Maiden - Future Past Tour';

  @override
  String get imageUploadedSuccess => '✅ Imagen subida correctamente';

  @override
  String get imageUploadError =>
      'No se pudo subir la imagen. Inténtalo de nuevo.';

  @override
  String get concertSaveError =>
      'No se pudo guardar el concierto. Inténtalo de nuevo.';

  @override
  String get onThisDay => 'EN TAL DÍA COMO HOY';

  @override
  String get upcomingConcerts => 'PRÓXIMOS CONCIERTOS';

  @override
  String get statisticsSection => 'ESTADÍSTICAS';

  @override
  String get recommendedSection => 'RECOMENDADOS';

  @override
  String get yourFavorites => 'TUS FAVORITOS';

  @override
  String get recentlyAdded => 'ÚLTIMOS AÑADIDOS';

  @override
  String errorLoadingData(String error) {
    return 'Error al cargar: $error';
  }

  @override
  String get noConcertsUpcoming => 'No hay conciertos próximos 🎸';

  @override
  String get concertToday => '🎉 ¡Hoy hay concierto!';

  @override
  String get concertTomorrow => '🔥 Mañana vuelves al directo';

  @override
  String daysLeft(int days) {
    return '⏳ Faltan $days días';
  }

  @override
  String get today => 'Hoy';

  @override
  String get live => 'Directo';

  @override
  String get noFavorites => 'Todavía no tienes conciertos favoritos.';

  @override
  String get greetingMorning => 'Buenos días';

  @override
  String get greetingAfternoon => 'Buenas tardes';

  @override
  String get greetingEvening => 'Buenas noches';

  @override
  String get tagline => 'Cada concierto cuenta una historia.';

  @override
  String get readyForNext => 'Todo listo para volver al directo.';

  @override
  String get defaultNickname => 'Rockero';

  @override
  String get epicMonth => '¡Mes épico!';

  @override
  String epicMonthDesc(int count) {
    return '$count conciertos este mes — estás en racha';
  }

  @override
  String get goodMonth => 'Buen mes';

  @override
  String goodMonthDesc(int count) {
    return '$count conciertos este mes';
  }

  @override
  String get justGotOut => 'Acabas de salir';

  @override
  String lastConcertDaysAgo(int days) {
    return 'Último concierto hace $days días';
  }

  @override
  String get longTime => 'Llevas tiempo sin ir';

  @override
  String longTimeDesc(int days) {
    return '$days días sin conciertos — ¡es hora de volver!';
  }

  @override
  String howWasArtist(String artist) {
    return '¿Qué tal estuvo $artist?';
  }

  @override
  String get noRatingYet => 'Aún no has valorado este concierto';

  @override
  String onThisDayYearsAgo(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'años',
      one: 'año',
    );
    return 'Tal día como hoy, hace $years $_temp0';
  }

  @override
  String onThisDayInDays(int days, int years) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'días',
      one: 'día',
    );
    String _temp1 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'años',
      one: 'año',
    );
    return 'En $days $_temp0, hace $years $_temp1';
  }

  @override
  String onThisDayAgoDays(int days, int years) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'días',
      one: 'día',
    );
    String _temp1 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'años',
      one: 'año',
    );
    return 'Hace $days $_temp0, hace $years $_temp1';
  }

  @override
  String onThisDaySeeMore(int count) {
    return 'Ver $count más';
  }

  @override
  String get onThisDaySeeLess => 'Ver menos';

  @override
  String get statisticsTitle => 'Estadísticas';

  @override
  String get totalConcertsLabel => 'Conciertos';

  @override
  String get uniqueArtistsLabel => 'Artistas';

  @override
  String get uniqueFestivalsLabel => 'Festivales';

  @override
  String get avgRatingLabel => 'Valoración media';

  @override
  String get activeYearLabel => 'Año activo';

  @override
  String get activeYearsLabel => 'Años activo';

  @override
  String get favoriteMonthLabel => 'Mes favorito';

  @override
  String get concertsByYear => 'Conciertos por año';

  @override
  String get topArtists => 'Artistas más vistos';

  @override
  String get topFestivals => 'Festivales más visitados';

  @override
  String get favoriteCities => 'Ciudades favoritas';

  @override
  String get ratingDistribution => 'Distribución de valoraciones';

  @override
  String get noDataDash => '—';

  @override
  String get monthJanuary => 'Enero';

  @override
  String get monthFebruary => 'Febrero';

  @override
  String get monthMarch => 'Marzo';

  @override
  String get monthApril => 'Abril';

  @override
  String get monthMay => 'Mayo';

  @override
  String get monthJune => 'Junio';

  @override
  String get monthJuly => 'Julio';

  @override
  String get monthAugust => 'Agosto';

  @override
  String get monthSeptember => 'Septiembre';

  @override
  String get monthOctober => 'Octubre';

  @override
  String get monthNovember => 'Noviembre';

  @override
  String get monthDecember => 'Diciembre';

  @override
  String get myProfile => 'Mi perfil';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get friendsTitle => 'Amigos';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get aboutTitle => 'Acerca de';

  @override
  String get chooseFromGallery => 'Elegir de la galería';

  @override
  String get takePhoto => 'Hacer una foto';

  @override
  String get profilePhotoUpdated => 'Foto de perfil actualizada ✅';

  @override
  String get concertsStatLabel => 'Conciertos';

  @override
  String get favoritesStatLabel => 'Favoritos';

  @override
  String get memoriesStatLabel => 'Recuerdos';

  @override
  String get likedLabel => 'Te gustan';

  @override
  String get accountSection => 'Cuenta';

  @override
  String get changeName => 'Cambiar nombre';

  @override
  String get usernameLabel => 'Nombre de usuario';

  @override
  String get changePassword => 'Cambiar contraseña';

  @override
  String get preferencesSection => 'Preferencias';

  @override
  String get notificationsLabel => 'Notificaciones';

  @override
  String get upcomingConcertAlerts => 'Avisos de conciertos próximos';

  @override
  String get languageSection => 'Idioma';

  @override
  String get appearanceSection => 'Apariencia';

  @override
  String get newNameLabel => 'Nuevo nombre';

  @override
  String get currentPasswordLabel => 'Contraseña actual';

  @override
  String get newPasswordLabel => 'Nueva contraseña';

  @override
  String get confirmPasswordLabel => 'Confirmar contraseña';

  @override
  String get passwordsNoMatch => 'Las contraseñas no coinciden';

  @override
  String get nameUpdated => 'Nombre actualizado ✅';

  @override
  String get passwordUpdated => 'Contraseña actualizada ✅';

  @override
  String get changeNameTitle => 'Cambiar nombre';

  @override
  String get changePasswordTitle => 'Cambiar contraseña';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageEnglish => 'English';

  @override
  String get changeLanguageTitle => 'Idioma';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get creditsLabel => 'Créditos';

  @override
  String get technologiesUsed => 'Tecnologías utilizadas:';

  @override
  String get contact => 'Contacto';

  @override
  String get deleteFriendTitle => 'Eliminar amigo';

  @override
  String get friendRequestReceived => 'Quiere ser tu amigo';

  @override
  String get searchFriendHint => 'Buscar por nombre o email...';

  @override
  String get friendsSearchPeople => 'Buscar personas';

  @override
  String friendsTabFriends(int count) {
    return 'Amigos ($count)';
  }

  @override
  String get friendsTabRequests => 'Solicitudes';

  @override
  String friendsTabRequestsCount(int count) {
    return 'Solicitudes ($count)';
  }

  @override
  String get friendsTypeToSearch => 'Escribe al menos 2 caracteres';

  @override
  String get friendsNoUsersFound => 'No se encontraron usuarios';

  @override
  String get friendAlreadyFriend => 'Amigo ✓';

  @override
  String get friendRequestSent => 'Enviada';

  @override
  String get friendAccept => 'Aceptar';

  @override
  String get friendReject => 'Rechazar';

  @override
  String get friendAdd => 'Añadir';

  @override
  String get friendsNoFriendsHere =>
      'Aún no tienes amigos.\nBúscalos con el icono de arriba.';

  @override
  String friendDeleteConfirm(String name) {
    return '¿Seguro que quieres eliminar a $name?';
  }

  @override
  String get friendsNoPendingRequests => 'No tienes solicitudes pendientes.';

  @override
  String get notificationsTitle => 'Notificaciones';

  @override
  String get markRead => 'Leído';

  @override
  String get deleteAll => 'Eliminar todo';

  @override
  String get deleteNotificationsTitle => 'Eliminar notificaciones';

  @override
  String get deleteNotificationsConfirm =>
      '¿Seguro que quieres eliminar todas las notificaciones?';

  @override
  String get noNotifications => 'Sin notificaciones';

  @override
  String get favoritesTitle => 'Favoritos';

  @override
  String get favoritesError => 'Error al cargar favoritos';

  @override
  String get searchArtistHint => 'Buscar artista...';

  @override
  String get noFavoritesMessage => 'Todavía no tienes favoritos.';

  @override
  String concertCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count conciertos',
      one: '1 concierto',
    );
    return '$_temp0';
  }

  @override
  String get memoriesTitle => 'Recuerdos';

  @override
  String get deletePhotosTitle => 'Eliminar fotos';

  @override
  String deletePhotosConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'fotos',
      one: 'foto',
    );
    return '¿Seguro que quieres eliminar $count $_temp0?\nEsta acción no se puede deshacer.';
  }

  @override
  String get deletePhotoTitle => 'Eliminar foto';

  @override
  String get deletePhotoConfirm =>
      '¿Seguro que quieres eliminar este recuerdo?';

  @override
  String get noMemories =>
      'Aún no hay recuerdos.\nAñade fotos desde el detalle de un concierto.';

  @override
  String get noMemoriesShort =>
      'Todavía no hay recuerdos. ¡Añade tus fotos del concierto!';

  @override
  String get deletingPhotos => 'Eliminando fotos...';

  @override
  String get tagPeople => 'Etiquetar personas';

  @override
  String get newMemory => 'Nuevo recuerdo';

  @override
  String get captionHint => 'Pie de foto (opcional)';

  @override
  String photoUploadError(String error) {
    return 'Error al subir foto: $error';
  }

  @override
  String get gridView => 'Ver en cuadrícula';

  @override
  String get timelineView => 'Ver en timeline';

  @override
  String get noDate => 'Sin fecha';

  @override
  String get deleteSelection => 'Eliminar selección';

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$count seleccionada$_temp0';
  }

  @override
  String uploadingPhotos(int current, int total) {
    return 'Subiendo $current/$total...';
  }

  @override
  String get importTitle => 'Importar conciertos';

  @override
  String get importSearchArtist => 'Busca un artista';

  @override
  String get importFromSetlist => 'Importa conciertos desde Setlist.fm';

  @override
  String get artistHint => 'Artista...';

  @override
  String importFoundCount(int count) {
    return '$count encontrados';
  }

  @override
  String importSelectedCount(int count) {
    return '$count seleccionados';
  }

  @override
  String get importSearchPrompt => 'Busca un artista para\nver sus conciertos';

  @override
  String get loadMore => 'Cargar más';

  @override
  String importButton(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Importar $count conciertos',
      one: 'Importar 1 concierto',
    );
    return '$_temp0';
  }

  @override
  String importSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count conciertos importados 🎸',
      one: '1 concierto importado 🎸',
    );
    return '$_temp0';
  }

  @override
  String get recommendedTitle => 'Recomendados';

  @override
  String get noLikesForRecommendations =>
      'Marca artistas con \"me gusta\" para recibir recomendaciones.';

  @override
  String becauseYouLike(String artist) {
    return 'Porque te gusta $artist';
  }

  @override
  String get viewOnTicketmaster => 'Ver en Ticketmaster';

  @override
  String get noConcertsAddForRec =>
      'Añade conciertos para ver recomendaciones.';

  @override
  String get noUpcomingEvents =>
      'No encontramos eventos próximos. Tus artistas más vistos:';

  @override
  String get searchHintBar => 'Buscar artista o festival...';

  @override
  String get artistConcertSingular => 'concierto';

  @override
  String get artistConcertPlural => 'conciertos';

  @override
  String get artistAvgRating => 'valoración media';

  @override
  String get artistCitySingular => 'ciudad';

  @override
  String get artistCityPlural => 'ciudades';

  @override
  String get artistFirstConcert => 'Primer concierto';

  @override
  String get artistBest => 'El mejor';

  @override
  String get artistUpcoming => 'PRÓXIMOS';

  @override
  String get artistHistory => 'HISTORIAL';

  @override
  String get actionAdd => 'Añadir';

  @override
  String get actionEvents => 'Eventos';

  @override
  String get actionStats => 'Stats';

  @override
  String get actionImport => 'Importar';

  @override
  String get ticketWalletTitle => 'Mi entrada';

  @override
  String get ticketWalletEmptyDescription =>
      'Guarda aquí tu entrada (foto o PDF). Se queda solo en este dispositivo, nunca se sube a nuestros servidores.';

  @override
  String get ticketWalletFestivalTitle => 'Entrada del festival';

  @override
  String get ticketWalletFestivalEmptyDescription =>
      'Guarda aquí el pase del festival (foto o PDF). Se comparte entre todos los conciertos de este festival y se queda solo en este dispositivo.';

  @override
  String get ticketWalletAddPhoto => 'Foto';

  @override
  String get ticketWalletAddPdf => 'PDF';

  @override
  String get ticketWalletView => 'Ver';

  @override
  String get ticketWalletDelete => 'Eliminar';

  @override
  String get ticketWalletLocalBadge => 'Solo en este dispositivo';

  @override
  String get ticketWalletConfirmDeleteTitle => '¿Eliminar entrada?';

  @override
  String get ticketWalletConfirmDeleteBody =>
      'Se eliminará únicamente de este dispositivo.';

  @override
  String get ticketWalletPdfFile => 'Entrada en PDF';

  @override
  String get tutorialWelcomeTitle => '¡Bienvenido a La Vida en Directo!';

  @override
  String get tutorialWelcomeDesc =>
      'Tu diario personal de conciertos. Aquí encontrarás todo lo que necesitas para recordar cada directo.';

  @override
  String get tutorialAddTitle => 'Añade tu primer concierto';

  @override
  String get tutorialAddDesc =>
      'Pulsa el botón \"Añadir\" para registrar un concierto. Puedes añadir la fecha, el recinto, fotos y valorarlo.';

  @override
  String get tutorialImportTitle => 'Importa desde Setlist.fm';

  @override
  String get tutorialImportDesc =>
      'Usa el botón \"Importar\" para traer conciertos automáticamente desde Setlist.fm con un solo toque.';

  @override
  String get tutorialFavoritesTitle => 'Guarda tus favoritos';

  @override
  String get tutorialFavoritesDesc =>
      'Marca los artistas que más te gustan como favoritos. Los encontrarás agrupados en la pestaña Favoritos.';

  @override
  String get tutorialMemoriesTitle => 'Guarda tus recuerdos';

  @override
  String get tutorialMemoriesDesc =>
      'En la pestaña Recuerdos puedes ver todas las fotos de tus conciertos organizadas por año.';

  @override
  String get tutorialAddConcertTitle => 'Añade un concierto';

  @override
  String get tutorialAddConcertDesc =>
      'Rellena el nombre del artista, la fecha y el recinto. El resto es opcional.';

  @override
  String get tutorialAddImageTitle => 'Añade una imagen';

  @override
  String get tutorialAddImageDesc =>
      'Puedes añadir una foto del concierto o del artista. Se usará como portada en tu colección.';

  @override
  String get tutorialRateTitle => 'Valora tu experiencia';

  @override
  String get tutorialRateDesc =>
      'Para conciertos pasados puedes añadir una valoración de 1 a 5 estrellas. Toca la estrella activa para quitarla.';

  @override
  String get tutorialLikeTitle => 'Me gusta y Favorito';

  @override
  String get tutorialLikeDesc =>
      '👍 \"Me gusta\" marca conciertos que disfrutaste. ⭐ \"Favorito\" agrupa el artista en tu lista de favoritos.';

  @override
  String get tutorialDetailTitle => 'Detalle del concierto';

  @override
  String get tutorialDetailDesc =>
      'Aquí ves toda la información del concierto: fecha, recinto, ciudad y tus fotos.';

  @override
  String get tutorialEditTitle => 'Edita cuando quieras';

  @override
  String get tutorialEditDesc =>
      'Pulsa el icono ✏️ arriba a la derecha para editar cualquier detalle o cambiar la imagen.';

  @override
  String get tutorialSetlistTitle => 'Setlist automático';

  @override
  String get tutorialSetlistDesc =>
      'Si el concierto está en Setlist.fm, verás automáticamente las canciones que tocaron esa noche.';

  @override
  String get tutorialPhotosTitle => 'Añade tus fotos';

  @override
  String get tutorialPhotosDesc =>
      'En la sección Recuerdos puedes añadir todas las fotos que quieras del concierto. Selección múltiple.';

  @override
  String get tutorialConcertsTitle => 'Tu colección de conciertos';

  @override
  String get tutorialConcertsDesc =>
      'Aquí tienes todos los conciertos que has registrado. Usa el buscador para filtrar por artista, ciudad o festival.';

  @override
  String get tutorialConcertsViewTitle => 'Tres formas de verlos';

  @override
  String get tutorialConcertsViewDesc =>
      'Cambia entre lista, cuadrícula o calendario con los iconos de arriba a la derecha. Cada vista tiene su momento.';

  @override
  String get tutorialConcertsCalTitle => 'Vista calendario';

  @override
  String get tutorialConcertsCalDesc =>
      'En el calendario puedes ver tus conciertos por fecha y añadir uno nuevo tocando cualquier día.';

  @override
  String get tutorialStatsOverviewTitle => 'Tu historial musical';

  @override
  String get tutorialStatsOverviewDesc =>
      'Un resumen de toda tu actividad: conciertos, artistas únicos, festivales y ciudades que has visitado.';

  @override
  String get tutorialStatsChartTitle => 'Evolución por año';

  @override
  String get tutorialStatsChartDesc =>
      'La gráfica muestra cuántos conciertos has asistido cada año. Descubre tus épocas más activas.';

  @override
  String get tutorialStatsTopTitle => 'Tus tops personales';

  @override
  String get tutorialStatsTopDesc =>
      'Rankings de artistas, ciudades y festivales más visitados. ¿Alguien gana por goleada?';

  @override
  String get tutorialProfileOverviewTitle => 'Tu perfil';

  @override
  String get tutorialProfileOverviewDesc =>
      'Aquí ves tu resumen personal: conciertos, fotos, y acceso a ajustes. Toca tu avatar para cambiarlo.';

  @override
  String get tutorialProfileAchTitle => 'Logros y trofeos';

  @override
  String get tutorialProfileAchDesc =>
      'Gana logros asistiendo a conciertos. La lista se despliega para ver todos. Toca uno para ver qué se necesita.';

  @override
  String get tutorialFriendsConnectTitle => 'Conecta con amigos';

  @override
  String get tutorialFriendsConnectDesc =>
      'Busca a tus amigos por nombre y envíales una solicitud. Así podréis ver los conciertos de los demás.';

  @override
  String get tutorialFriendsTabsTitle => 'Amigos y solicitudes';

  @override
  String get tutorialFriendsTabsDesc =>
      'La primera pestaña muestra tus amigos actuales. La segunda gestiona las solicitudes pendientes que hayas recibido.';

  @override
  String get tutorialFriendsActivityTitle => 'Actividad de amigos';

  @override
  String get tutorialFriendsActivityDesc =>
      'Cuando un amigo añada un concierto recibirás una notificación. También puedes ver su perfil y lista de conciertos.';

  @override
  String get tutorialFeedPhotosTitle => 'Recuerdos en fotos';

  @override
  String get tutorialFeedPhotosDesc =>
      'Aquí aparecen las fotos de tus conciertos y de tus amigos. Un álbum compartido del mundo del directo.';

  @override
  String get tutorialFeedViewTitle => 'Cuadrícula o línea de tiempo';

  @override
  String get tutorialFeedViewDesc =>
      'Alterna entre la cuadrícula y la vista cronológica con el icono de arriba. La vista cronológica agrupa las fotos por concierto.';

  @override
  String get tutorialRecsDiscoverTitle => 'Descubre nuevos conciertos';

  @override
  String get tutorialRecsDiscoverDesc =>
      'Basándonos en los artistas que ya has visto, te sugerimos conciertos próximos. Filtra por país para afinar.';

  @override
  String get tutorialRecsWantTitle => 'Quiero ir';

  @override
  String get tutorialRecsWantDesc =>
      'Toca el 🎟️ en cualquier evento para guardarlo en tu lista «Quiero ir». Lo encontrarás en la segunda pestaña.';

  @override
  String get tutorialImportSearchTitle => 'Importa desde Setlist.fm';

  @override
  String get tutorialImportSearchDesc =>
      'Escribe el nombre de un artista para ver todos sus conciertos pasados disponibles en Setlist.fm.';

  @override
  String get tutorialImportSelectTitle => 'Selecciona e importa';

  @override
  String get tutorialImportSelectDesc =>
      'Marca los conciertos a los que fuiste y pulsa Importar. La app buscará imagen y género automáticamente.';

  @override
  String get tutorialSettingsSection => 'Ayuda';

  @override
  String get tutorialSettingsLabel => 'Guías de uso';

  @override
  String get tutorialSettingsSubtitle =>
      'Repasa el tutorial de cualquier pantalla';

  @override
  String get tutorialPickerTitle => '¿Qué quieres repasar?';

  @override
  String get tutorialPickerDashboard => 'Inicio';

  @override
  String get tutorialPickerConcerts => 'Conciertos';

  @override
  String get tutorialPickerAddConcert => 'Añadir concierto';

  @override
  String get tutorialPickerDetail => 'Detalle de concierto';

  @override
  String get tutorialPickerStats => 'Estadísticas';

  @override
  String get tutorialPickerProfile => 'Perfil';

  @override
  String get tutorialPickerFriends => 'Amigos';

  @override
  String get tutorialPickerFeed => 'Recuerdos';

  @override
  String get tutorialPickerRecs => 'Descubrir';

  @override
  String get tutorialPickerImport => 'Importar';

  @override
  String get splashTagline => 'Cada concierto cuenta una historia.';

  @override
  String get navHome => 'Inicio';

  @override
  String get navConcerts => 'Conciertos';

  @override
  String get navMemories => 'Recuerdos';

  @override
  String get navFavorites => 'Favoritos';

  @override
  String get navStats => 'Stats';

  @override
  String get setlistTitle => 'Setlist';

  @override
  String setlistSongCount(int count) {
    return '$count canciones';
  }

  @override
  String get setlistNotFound =>
      'No se encontró ningún setlist para este concierto.';

  @override
  String get setlistShowLess => 'Ver menos';

  @override
  String setlistShowRemaining(int count) {
    return 'Ver las $count canciones restantes';
  }

  @override
  String setlistCoverOf(String artist) {
    return 'Versión de $artist';
  }

  @override
  String setlistWith(String artist) {
    return 'con $artist';
  }

  @override
  String get notifMarkAllRead => 'Marcar todo como leído';

  @override
  String get notifMemoriesToday => 'Recuerdos de hoy';

  @override
  String notifYearsAgoArtist(int years, String artist) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'años',
      one: 'año',
    );
    return 'Hace $years $_temp0: $artist';
  }

  @override
  String get notifUpcomingSection => 'Conciertos próximos';

  @override
  String notifTodaySubtitle(String venue, String city) {
    return '¡Es hoy! · $venue, $city';
  }

  @override
  String notifTomorrowSubtitle(String venue, String city) {
    return '¡Mañana! · $venue, $city';
  }

  @override
  String notifDaysSubtitle(int days, String venue, String city) {
    return 'Faltan $days días · $venue, $city';
  }

  @override
  String get notifRecommendationsSection => 'Recomendaciones';

  @override
  String get notifNoRecsHint =>
      'Añade conciertos favoritos para recibir recomendaciones.';

  @override
  String get notifEmpty =>
      'Sin notificaciones por ahora.\nAñade conciertos para empezar.';

  @override
  String get buyTickets => 'Comprar entradas';

  @override
  String get appTitleLine1 => 'LA VIDA';

  @override
  String get appTitleLine2 => 'EN DIRECTO';

  @override
  String memberNumber(String number) {
    return 'MIEMBRO #$number';
  }

  @override
  String deleteConcertConfirm(String name) {
    return '¿Seguro que quieres eliminar \"$name\"?\nEsta acción no se puede deshacer.';
  }

  @override
  String concertDeleteError(String error) {
    return 'No se pudo eliminar: $error';
  }

  @override
  String artistNotFound(String error) {
    return 'No se encontró el artista: $error';
  }

  @override
  String get setlistComingSoon =>
      'El setlist estará disponible\ntras el concierto.';

  @override
  String spotifyFollowers(String count) {
    return '$count seguidores';
  }

  @override
  String get openInSpotify => 'Abrir en Spotify';

  @override
  String get participantsAlsoWere => 'También estuvieron';

  @override
  String get participantsAlsoGoing => 'También irán';

  @override
  String get artistRequired => 'Introduce el nombre del artista';

  @override
  String get dateRequired => 'Selecciona una fecha';

  @override
  String get selectImage => 'Seleccionar imagen';

  @override
  String get ratingTitle => 'Valoración';

  @override
  String get ratingNone => 'Sin valorar';

  @override
  String ratingStars(int rating) {
    return '$rating de 5 estrellas';
  }

  @override
  String get howWasItTitle => '¿Qué te pareció?';

  @override
  String get likedYes => 'Me gusta';

  @override
  String get likedNo => '¿Te gustó?';

  @override
  String get addedToFavorites => 'Añadido a favoritos';

  @override
  String get markAsFavorite => '¿Marcar como favorito?';

  @override
  String get savingLabel => 'Guardando...';

  @override
  String get saveConcert => 'Guardar concierto';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get noFriendsYet => 'Aún no tienes amigos. Añádelos desde tu perfil.';

  @override
  String get whoElseWas => '¿Quién más estuvo?';

  @override
  String get whoElseGoing => '¿Quién más irá?';

  @override
  String get splashLoading1 => '🎸 Preparando escenario...';

  @override
  String get splashLoading2 => '🔊 Probando sonido...';

  @override
  String get splashLoading3 => '💡 Encendiendo las luces...';

  @override
  String get splashLoading4 => '🎫 Cargando conciertos...';

  @override
  String get splashLoading5 => '📸 Organizando recuerdos...';

  @override
  String get splashLoading6 => '🤘 ¡Que empiece el concierto!';

  @override
  String get tabPast => 'Pasados';

  @override
  String get tabUpcoming => 'Próximos';

  @override
  String get tabShared => 'Compartidos';

  @override
  String get listViewTooltip => 'Vista lista';

  @override
  String get cardViewTooltip => 'Vista tarjetas';

  @override
  String concertDeleted(String name) {
    return '\"$name\" eliminado';
  }

  @override
  String get concertDeleteFailed => 'No se pudo eliminar el concierto';

  @override
  String get noPastConcerts => 'Aún no tienes conciertos pasados.';

  @override
  String get noUpcomingConcertsAdd =>
      'No tienes conciertos próximos.\n¡Añade uno!';

  @override
  String get noSharedConcerts =>
      'Ningún amigo ha compartido conciertos contigo todavía.';

  @override
  String get mapVenueLocation => 'Ubicación del recinto';

  @override
  String get mapOpenIn => 'Abrir en mapas';

  @override
  String get mapNotAvailable => 'Mapa no disponible';

  @override
  String get concertMapTitle => 'Mapa de conciertos';

  @override
  String get concertMapDashboardSubtitle => 'Todos tus recintos en un mapa';

  @override
  String get concertMapLoading => 'Localizando recintos…';

  @override
  String concertMapProgress(int done, int total) {
    return '$done de $total recintos';
  }

  @override
  String get concertMapNoData =>
      'Añade conciertos con recinto o ciudad\npara verlos en el mapa.';

  @override
  String get concertMapConcertsHere => 'Conciertos aquí';

  @override
  String get concertMapOpenInMaps => 'Abrir en Maps';

  @override
  String profileAvatarUploadError(String error) {
    return 'Error al subir la foto: $error';
  }

  @override
  String get fanLevelLegend => '🤘 LEYENDA DEL DIRECTO';

  @override
  String get fanLevelHeadliner => '🥇 HEADLINER';

  @override
  String get fanLevelRoadie => '🥈 ROADIE';

  @override
  String get fanLevelRookie => '🥉 ROOKIE';

  @override
  String get fanSinceThisYear => 'Fan desde este año';

  @override
  String fanSinceYear(int year) {
    return 'Fan desde $year';
  }

  @override
  String get deleteAccountTitle => '⚠️ Eliminar cuenta';

  @override
  String get deleteAccountWarning =>
      'Esta acción es irreversible. Se borrarán todos tus conciertos, fotos, amigos y datos de la cuenta.';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get confirmPasswordTitle => 'Confirma tu contraseña';

  @override
  String get deleteAccountButton => 'Eliminar cuenta';

  @override
  String genericErrorDetail(String error) {
    return 'Error: $error';
  }

  @override
  String get profileAccreditationTitle => 'Tu acreditación';

  @override
  String get profileAccreditationSubtitle =>
      'Tu historial musical en un vistazo.';

  @override
  String get guestLabel => 'Invitado';

  @override
  String get wrappedCardTitle => 'Tu año en conciertos';

  @override
  String get wrappedCardSubtitle => 'Resumen anual · compartible';

  @override
  String get pastYearsLabel => 'Años anteriores';

  @override
  String get toolsSectionTitle => 'Herramientas';

  @override
  String appFooterVersion(String version) {
    return 'Versión $version';
  }

  @override
  String get uploadingAvatarLabel => 'Subiendo foto...';

  @override
  String get annualGoalTitle => 'Meta anual de conciertos';

  @override
  String get annualGoalQuestion => '¿Cuántos conciertos quieres ver este año?';

  @override
  String get annualGoalNumberLabel => 'Número de conciertos';

  @override
  String get removeGoal => 'Quitar meta';

  @override
  String get changeEmailTitle => 'Cambiar email';

  @override
  String get newEmailLabel => 'Nuevo email';

  @override
  String get emailUpdated => 'Email actualizado';

  @override
  String get noConcertsToExport => 'No hay conciertos para exportar';

  @override
  String get exportCsvHeader =>
      'artista,nombre,fecha,recinto,ciudad,festival,género,valoracion,favorito,precio,notas';

  @override
  String get csvYes => 'sí';

  @override
  String get csvNo => 'no';

  @override
  String get exportShareSubject => 'Mis conciertos — La Vida en Directo';

  @override
  String exportError(String error) {
    return 'Error al exportar: $error';
  }

  @override
  String get exportDataTitle => 'Exportar mis datos';

  @override
  String get exportCsvLabel => 'CSV — Excel/Sheets';

  @override
  String get exportCsvDesc => 'Compatible con cualquier hoja de cálculo';

  @override
  String get exportJsonLabel => 'JSON — copia de seguridad';

  @override
  String get exportJsonDesc => 'Formato completo para importar en el futuro';

  @override
  String get noUpcomingConcertsToSync =>
      'No tienes conciertos próximos para añadir';

  @override
  String get calendarNoEventsAdded => 'No se pudo añadir ningún evento';

  @override
  String calendarEventsAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count conciertos añadidos al calendario',
      one: '1 concierto añadido al calendario',
    );
    return '$_temp0';
  }

  @override
  String get cacheCleared => 'Caché de imágenes limpiada';

  @override
  String get themeSystemDefault => 'Por defecto del sistema';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeLight => 'Claro';

  @override
  String get emailLabel => 'Email';

  @override
  String get friendActivityNotifTitle => 'Actividad de amigos';

  @override
  String get friendActivityNotifDesc => 'Cuando un amigo añade un concierto';

  @override
  String get recommendationsNotifTitle => 'Recomendaciones';

  @override
  String get recommendationsNotifDesc =>
      'Conciertos sugeridos basados en tus gustos';

  @override
  String get colorPaletteLabel => 'Paleta de color';

  @override
  String get splashSoundLabel => 'Sonido de inicio';

  @override
  String get splashSoundDesc => 'Ambiente de público al abrir la app';

  @override
  String get myDataSectionTitle => 'Mis datos';

  @override
  String annualGoalSubtitleSet(int count) {
    return 'Este año: $count conciertos';
  }

  @override
  String get annualGoalSubtitleUnset => 'Sin meta configurada';

  @override
  String get exportConcertsLabel => 'Exportar mis conciertos';

  @override
  String get exportConcertsDesc => 'CSV o JSON — ábrelo en Excel o guárdalo';

  @override
  String get syncCalendarLabel => 'Sincronizar con el calendario';

  @override
  String get syncCalendarDesc =>
      'Añade tus próximos conciertos al calendario del móvil';

  @override
  String get clearCacheLabel => 'Limpiar caché de imágenes';

  @override
  String get clearCacheDesc => 'Libera espacio del almacenamiento';

  @override
  String get supportSectionTitle => 'Soporte';

  @override
  String get reportIssueLabel => 'Reportar incidencia';

  @override
  String get reportIssueDesc => 'Envía un bug, sugerencia o comentario';

  @override
  String get jiraNotConfigured =>
      'Integración Jira no configurada — rellena el .env';

  @override
  String get exportingDialogTitle => 'Preparando exportación…';

  @override
  String get exportingDialogSubtitle => 'Cargando fotos de cada concierto';

  @override
  String get proBadgeLabel => 'Pro';

  @override
  String get mailtoSubject => 'La Vida en Directo - Contacto';

  @override
  String get emailClientError => 'No se pudo abrir el cliente de correo';

  @override
  String get privacyPolicyBody =>
      'La Vida en Directo recoge únicamente los datos necesarios para el funcionamiento de la aplicación: nombre, correo electrónico y los conciertos que añades.\n\nTus datos se almacenan de forma segura y nunca se comparten con terceros ni se usan con fines publicitarios.\n\nPuedes eliminar tu cuenta y todos tus datos en cualquier momento desde la app o contactando con nosotros.';

  @override
  String get creditsDevelopedBy => 'Desarrollado con ❤️ por Nico';

  @override
  String get creditFrontend => 'Frontend móvil';

  @override
  String get creditBackend => 'Backend API';

  @override
  String get creditDatabase => 'Base de datos';

  @override
  String get creditImageStorage => 'Almacenamiento de imágenes';

  @override
  String get creditSetlistData => 'Datos de setlists';

  @override
  String get creditArtistData => 'Datos de artistas';

  @override
  String get creditRecommendedEvents => 'Eventos recomendados';

  @override
  String get aboutFooterTagline =>
      'Hecho con ❤️ para los que viven la música en directo.';

  @override
  String get reportIssueIntroTitle => '¿Algo no funciona como esperabas?';

  @override
  String get reportIssueIntroDesc =>
      'Cuéntanos qué ha pasado y lo revisaremos lo antes posible.';

  @override
  String get typeLabel => 'Tipo';

  @override
  String get titleLabel => 'Título';

  @override
  String get titleHint => 'Resumen breve del problema…';

  @override
  String get titleRequiredError => 'Escribe un título para el ticket';

  @override
  String get descriptionLabel => 'Descripción';

  @override
  String get descBugHint =>
      'Describe el problema: qué hiciste, qué esperabas y qué pasó…';

  @override
  String get descImprovementHint => 'Explica la mejora que te gustaría ver…';

  @override
  String get descOtherHint => 'Escribe tu comentario o sugerencia…';

  @override
  String get descRequiredError => 'Escribe una descripción antes de enviar';

  @override
  String get descTooShortError => 'La descripción es demasiado corta';

  @override
  String get autoInfoNote =>
      'Se incluirá automáticamente la versión de la app, plataforma y tu email para poder contactarte si hace falta.';

  @override
  String get issueSentTitle => '¡Incidencia enviada! 🎉';

  @override
  String ticketCreatedLabel(String key) {
    return 'Ticket creado: $key';
  }

  @override
  String get sendingLabel => 'Enviando…';

  @override
  String get sendIssueButton => 'Enviar incidencia';

  @override
  String get issueTypeBug => '🐛 Bug';

  @override
  String get issueTypeImprovement => '✨ Mejora';

  @override
  String get issueTypeOther => '💬 Otro';

  @override
  String get achievementsSectionTitle => 'LOGROS';

  @override
  String achievementsSeeMoreCount(int count) {
    return 'Ver todos los logros ($count más)';
  }

  @override
  String get achievementLocked => 'Bloqueado';

  @override
  String get achievementUnlocked => '¡Desbloqueado!';

  @override
  String get achievementUnlockedBanner => '🏆 Logro desbloqueado';

  @override
  String get topArtistsTitle => 'Mis artistas';

  @override
  String get topArtistsSubtitle => 'Por conciertos y valoración';

  @override
  String get achvFirstConcertTitle => 'Primer directo';

  @override
  String get achvFirstConcertDesc => 'Asiste a tu primer concierto';

  @override
  String get achvFiveConcertsTitle => 'Habitual';

  @override
  String get achvFiveConcertsDesc => '5 conciertos en el cuerpo';

  @override
  String get achvTwentyFiveTitle => 'Veterano';

  @override
  String get achvTwentyFiveDesc => '25 conciertos no es para cualquiera';

  @override
  String get achvFiftyConcertsTitle => 'Experto';

  @override
  String get achvFiftyConcertsDesc => '50 conciertos. Ya lo has visto todo';

  @override
  String get achvHundredConcertsTitle => 'Leyenda';

  @override
  String get achvHundredConcertsDesc =>
      '100 conciertos. Eres una leyenda del directo';

  @override
  String get achvTwoHundredTitle => 'Inmortal';

  @override
  String get achvTwoHundredDesc => '200 conciertos. A otro nivel';

  @override
  String get achvRockeroTitle => 'Rockero';

  @override
  String get achvRockeroDesc => '3 conciertos de rock';

  @override
  String get achvRockeroProTitle => 'Rock Puro';

  @override
  String get achvRockeroProDesc => '10 conciertos de rock';

  @override
  String get achvMetaleroTitle => 'Metalero';

  @override
  String get achvMetaleroDesc => '3 conciertos de metal o heavy';

  @override
  String get achvUrbanoTitle => 'Urbano';

  @override
  String get achvUrbanoDesc => '3 conciertos de hip-hop, rap o trap';

  @override
  String get achvFirstFestivalTitle => 'Festivalero';

  @override
  String get achvFirstFestivalDesc => 'Tu primer festival';

  @override
  String get achvFiveFestivalsTitle => 'Festival Addict';

  @override
  String get achvFiveFestivalsDesc => '5 festivales distintos';

  @override
  String get achvTenFestivalsTitle => 'Rey del Festival';

  @override
  String get achvTenFestivalsDesc => '10 festivales distintos';

  @override
  String get achvEclecticoTitle => 'Ecléctico';

  @override
  String get achvEclecticoDesc => '10 artistas distintos';

  @override
  String get achvExploradorTitle => 'Explorador';

  @override
  String get achvExploradorDesc => '25 artistas distintos';

  @override
  String get achvColeccionistaTitle => 'Coleccionista';

  @override
  String get achvColeccionistaDesc => '50 artistas distintos';

  @override
  String get achvSuperfanTitle => 'Superfan';

  @override
  String get achvSuperfanDesc => 'Viste al mismo artista 3 veces';

  @override
  String get achvObsesionadoTitle => 'Obsesionado';

  @override
  String get achvObsesionadoDesc => 'Viste al mismo artista 5 veces';

  @override
  String get achvViajeroTitle => 'Viajero';

  @override
  String get achvViajeroDesc => 'Conciertos en 3 ciudades distintas';

  @override
  String get achvTuristaTitle => 'Turista Musical';

  @override
  String get achvTuristaDesc => 'Conciertos en 10 ciudades distintas';

  @override
  String get achvCriticoTitle => 'Crítico';

  @override
  String get achvCriticoDesc => 'Valora tu primer concierto';

  @override
  String get achvGranCriticoTitle => 'Gran Crítico';

  @override
  String get achvGranCriticoDesc => 'Valora 10 conciertos';

  @override
  String get achvAnaliticoTitle => 'Analítico';

  @override
  String get achvAnaliticoDesc => 'Valora 25 conciertos';

  @override
  String get achvPerfeccionistaTitle => 'Perfeccionista';

  @override
  String get achvPerfeccionistaDesc => 'Da 5 estrellas a un concierto';

  @override
  String get achvApasionadoTitle => 'Apasionado';

  @override
  String get achvApasionadoDesc => '10 conciertos en favoritos';

  @override
  String get achvManirotoTitle => 'Maniroto';

  @override
  String get achvManirotoDesc => 'Más de 500 € gastados en entradas';

  @override
  String get achvHistoricoTitle => 'Fan Histórico';

  @override
  String get achvHistoricoDesc => 'Llevas más de 5 años yendo a conciertos';

  @override
  String get achvDecadaTitle => 'Una Década';

  @override
  String get achvDecadaDesc => 'Más de 10 años en la brecha';

  @override
  String get compareStatsButton => 'Comparar estadísticas';

  @override
  String friendUpcomingTitle(String name) {
    return 'PRÓXIMOS CONCIERTOS DE $name';
  }

  @override
  String get friendNoUpcoming => 'No tiene conciertos próximos';

  @override
  String get upcomingTogetherTitle => 'PRÓXIMOS CONCIERTOS JUNTOS';

  @override
  String get numbersTogetherTitle => 'NÚMEROS JUNTOS';

  @override
  String get emptySharedLine1 =>
      'Aún no habéis ido a ningún\nconcierto juntos.';

  @override
  String get emptySharedLine2 => '¡Etiquetad vuestros próximos directos!';

  @override
  String get youLabel => 'Tú';

  @override
  String compareStatsAppBarTitle(String me, String friend) {
    return '$me vs $friend';
  }

  @override
  String get commonArtistsTitle => 'ARTISTAS EN COMÚN';

  @override
  String get onlyYouSawTitle => 'SOLO TÚ HAS VISTO';

  @override
  String onlyFriendSawTitle(String name) {
    return 'SOLO $name HA VISTO';
  }

  @override
  String get vsLabel => 'VS';

  @override
  String get compareTotalConcertsLabel => 'Total conciertos';

  @override
  String get compareUniqueArtistsLabel => 'Artistas únicos';

  @override
  String get compareAvgRatingLabel => 'Media rating';

  @override
  String get compareThisYearLabel => 'Este año';

  @override
  String get compareTopArtistLabel => 'Artista top';

  @override
  String get tutorialSkip => 'Saltar';

  @override
  String get tutorialNext => 'Siguiente';

  @override
  String get tutorialStart => '¡Empezar! 🎸';

  @override
  String tutorialStepsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pasos',
      one: '1 paso',
    );
    return '$_temp0';
  }

  @override
  String get tutEntryDashboard => 'Inicio / Dashboard';

  @override
  String get tutEntryConcerts => 'Mis conciertos';

  @override
  String get tutEntryAddConcert => 'Añadir / Editar concierto';

  @override
  String get tutEntryDetail => 'Detalle de concierto';

  @override
  String get tutEntryStats => 'Estadísticas';

  @override
  String get tutEntryProfile => 'Mi perfil';

  @override
  String get tutEntryFriends => 'Amigos';

  @override
  String get tutEntryFeed => 'Feed de actividad';

  @override
  String get tutEntryRecs => 'Recomendaciones';

  @override
  String get tutEntryImport => 'Importar conciertos';

  @override
  String get tutDash1Title => '¡Bienvenido a La Vida en Directo!';

  @override
  String get tutDash1Desc =>
      'Tu diario musical personal. El dashboard te muestra de un vistazo tus próximos conciertos, estadísticas clave, actividad de amigos y mucho más.';

  @override
  String get tutDash2Title => 'Añade un concierto';

  @override
  String get tutDash2Desc =>
      'Toca el botón + en cualquier momento para registrar un concierto: artista, recinto, fecha, precio, foto y valoración detallada por criterios.';

  @override
  String get tutDash3Title => 'Por valorar';

  @override
  String get tutDash3Desc =>
      'El widget \"Por valorar\" lista los conciertos pasados que todavía no tienen puntuación. Desliza entre ellos y toca uno para valorarlo en 5 criterios.';

  @override
  String get tutDash4Title => 'Conciertos recomendados';

  @override
  String get tutDash4Desc =>
      'Descubre eventos próximos cerca de ti basados en tus artistas. Toca uno para ver todos sus detalles.';

  @override
  String get tutDash5Title => 'Personalizar el dashboard';

  @override
  String get tutDash5Desc =>
      'Reorganiza, muestra u oculta los widgets del dashboard pulsando el icono de edición junto al saludo.';

  @override
  String get tutAdd1Title => 'Registra el concierto';

  @override
  String get tutAdd1Desc =>
      'Completa artista, recinto, ciudad, fecha y precio. El género musical se sugiere automáticamente desde Spotify al escribir el nombre del artista.';

  @override
  String get tutAdd2Title => 'Foto del concierto';

  @override
  String get tutAdd2Desc =>
      'Añade una foto desde tu galería para darle vida al recuerdo. Puedes cambiarla o eliminarla más adelante desde la pantalla de edición.';

  @override
  String get tutAdd3Title => 'Valoración por criterios';

  @override
  String get tutAdd3Desc =>
      'Valora 5 criterios con estrellas: Artista, Sonido, Ambiente, Setlist y Precio/valor. La puntuación general se calcula automáticamente como la media.';

  @override
  String get tutAdd4Title => 'Nota calculada automáticamente';

  @override
  String get tutAdd4Desc =>
      'No hay puntuación manual: la nota que aparece en tu historial y estadísticas es siempre la media de tus 5 criterios. Más justa y más detallada.';

  @override
  String get tutAdd5Title => 'Festival o concierto individual';

  @override
  String get tutAdd5Desc =>
      'Indica si fue un festival para que tus estadísticas distingan entre ambos formatos y puedas ver el reparto en la sección \"Festival vs. individual\".';

  @override
  String get tutAdd6Title => 'Etiquetar amigos';

  @override
  String get tutAdd6Desc =>
      '¿Fuiste acompañado? Etiqueta a tus amigos para que el concierto aparezca también en su historial compartido y puedan verlo desde su perfil.';

  @override
  String get tutDetail1Title => 'Todo sobre el concierto';

  @override
  String get tutDetail1Desc =>
      'Aquí ves la info completa: fecha, recinto, ciudad, precio, foto, tus notas personales y la valoración detallada por criterios con barras de progreso.';

  @override
  String get tutDetail2Title => 'Valoración detallada';

  @override
  String get tutDetail2Desc =>
      'Si puntuaste el concierto, se muestra una tarjeta con la nota de cada criterio: Artista, Sonido, Ambiente, Setlist y Precio/valor, además de la media.';

  @override
  String get tutDetail3Title => 'Editar en cualquier momento';

  @override
  String get tutDetail3Desc =>
      'Toca el botón de edición (lápiz) para cambiar cualquier dato, añadir o modificar las valoraciones, la foto o las notas cuando quieras.';

  @override
  String get tutDetail4Title => 'Setlist automático';

  @override
  String get tutDetail4Desc =>
      'La app busca el setlist real del concierto en Setlist.fm para que puedas revivir canción por canción lo que tocaron esa noche.';

  @override
  String get tutDetail5Title => 'Artista en Spotify';

  @override
  String get tutDetail5Desc =>
      'Se vincula automáticamente el artista en Spotify: foto, géneros, seguidores y las canciones más populares con su popularidad y duración.';

  @override
  String get tutDetail6Title => 'Fotos y recuerdos';

  @override
  String get tutDetail6Desc =>
      'Añade fotos del concierto y etiqueta a las personas que estuvieron. Quedan guardadas en tu galería personal de recuerdos.';

  @override
  String get tutDetail7Title => 'Recinto y ubicación';

  @override
  String get tutDetail7Desc =>
      'Toca el nombre del recinto para ver todos los conciertos que tienes registrados en ese mismo lugar y explorar su ubicación en el mapa.';

  @override
  String get tutDetail8Title => 'Comentarios';

  @override
  String get tutDetail8Desc =>
      'Tus amigos pueden comentar el concierto si los etiquetaste. Abre la sección de comentarios para ver o continuar la conversación.';

  @override
  String get tutDetail9Title => 'Guarda tu entrada';

  @override
  String get tutDetail9Desc =>
      'Sube una foto o PDF de tu entrada para tenerla siempre a mano. Se guarda solo en tu dispositivo: nunca se sube a ningún servidor.';

  @override
  String get tutConcerts1Title => 'Tu historial musical';

  @override
  String get tutConcerts1Desc =>
      'Todos tus conciertos en un solo lugar. Los pasados muestran la valoración media de sus criterios; los futuros se marcan como \"próximos\".';

  @override
  String get tutConcerts2Title => 'Valoración visible';

  @override
  String get tutConcerts2Desc =>
      'Cada concierto pasado muestra su nota calculada (media de criterios) o \"Sin valorar\" si todavía no lo has puntuado. Tócalo para valorarlo.';

  @override
  String get tutConcerts3Title => 'Tres vistas disponibles';

  @override
  String get tutConcerts3Desc =>
      'Cambia entre vista de lista, cuadrícula compacta o calendario según cómo prefieras explorar tu historial.';

  @override
  String get tutConcerts4Title => 'Vista calendario';

  @override
  String get tutConcerts4Desc =>
      'El calendario marca los días en que tuviste un concierto. Toca cualquier fecha para ver el detalle o añadir uno nuevo en ese día.';

  @override
  String get tutConcerts5Title => 'Buscar y filtrar';

  @override
  String get tutConcerts5Desc =>
      'Usa la barra de búsqueda para encontrar conciertos por artista, recinto o ciudad, y filtra por año para navegar rápidamente por tu historial.';

  @override
  String get tutConcerts6Title => 'Mapa de conciertos';

  @override
  String get tutConcerts6Desc =>
      'Toca el icono de mapa para ver todos tus conciertos geolocalizados. Explora en qué ciudades y recintos has estado y descubre patrones.';

  @override
  String get tutConcerts7Title => 'Compartidos';

  @override
  String get tutConcerts7Desc =>
      'La pestaña \"Compartidos\" reúne los conciertos que han añadido tus amigos y en los que te han etiquetado, aunque no los hayas registrado tú.';

  @override
  String get tutStats1Title => 'Tus estadísticas musicales';

  @override
  String get tutStats1Desc =>
      'Un análisis completo de tu historial: total de conciertos, artistas únicos, ciudades visitadas, géneros favoritos, gasto total y mucho más.';

  @override
  String get tutStats2Title => 'Conciertos por año y mes';

  @override
  String get tutStats2Desc =>
      'Gráficas de barras que muestran cómo se distribuyen tus conciertos a lo largo del tiempo. Descubre tus temporadas más activas.';

  @override
  String get tutStats3Title => 'Top artistas, géneros y recintos';

  @override
  String get tutStats3Desc =>
      'Rankings de los artistas más vistos, géneros más escuchados en vivo y recintos más visitados. Con foto de Spotify cuando está disponible.';

  @override
  String get tutStats4Title => 'Valoraciones y distribución';

  @override
  String get tutStats4Desc =>
      'Histograma de tus notas, valoración media por año y tus artistas mejor valorados. Solo se cuentan los conciertos puntuados con el sistema de criterios.';

  @override
  String get tutStats5Title => 'Festival vs. individual';

  @override
  String get tutStats5Desc =>
      'Gráfico circular que muestra el reparto entre tus conciertos de festival y los individuales, para conocer tu perfil como espectador.';

  @override
  String get tutStats6Title => 'Resumen anual';

  @override
  String get tutStats6Desc =>
      'Desde el icono de calendario accedes al Wrapped de cualquier año: artista estrella, ciudad favorita, valoración media y los momentos más destacados.';

  @override
  String get tutStats7Title => 'Personalizar secciones';

  @override
  String get tutStats7Desc =>
      'Elige qué secciones de estadísticas quieres ver y reordénalas a tu gusto pulsando el icono de edición.';

  @override
  String get tutProfile1Title => 'Tu acreditación';

  @override
  String get tutProfile1Desc =>
      'Tu perfil resume todo tu historial musical: número de conciertos, fotos, favoritos y tu nivel de fan basado en cuántos shows llevas acumulados.';

  @override
  String get tutProfile2Title => 'Logros desbloqueables';

  @override
  String get tutProfile2Desc =>
      'Ganas medallas por hitos musicales: 10 conciertos, primer festival, ver un artista repetido, conseguir una valoración perfecta y mucho más.';

  @override
  String get tutProfile3Title => 'Mis artistas';

  @override
  String get tutProfile3Desc =>
      'Ranking de tus artistas más vistos, enriquecido con datos de Spotify: foto, seguidores, cuántas veces los has visto y tu valoración media de sus shows.';

  @override
  String get tutProfile4Title => 'Wrapped anual';

  @override
  String get tutProfile4Desc =>
      'Accede al resumen animado de cada año desde tu perfil: artista del año, ciudad favorita, valoración media y todos tus conciertos destacados.';

  @override
  String get tutProfile5Title => 'Tema de color';

  @override
  String get tutProfile5Desc =>
      'Personaliza el color principal de la app desde los ajustes. Elige el que mejor refleje tu estilo musical.';

  @override
  String get tutFriends1Title => 'Conecta con tu gente';

  @override
  String get tutFriends1Desc =>
      'Busca amigos por nombre o email y envía solicitudes de amistad. Cuando te acepten, puedes ver sus conciertos y comparar historiales.';

  @override
  String get tutFriends2Title => 'Amigos y solicitudes';

  @override
  String get tutFriends2Desc =>
      'La primera pestaña lista tus amigos actuales. La segunda gestiona las solicitudes pendientes que hayas recibido.';

  @override
  String get tutFriends3Title => 'Perfil de amigo';

  @override
  String get tutFriends3Desc =>
      'Toca a un amigo para ver su perfil: sus conciertos, artistas favoritos y logros. Puedes explorar su historial aunque sea privado si sois amigos.';

  @override
  String get tutFriends4Title => 'Comparar estadísticas';

  @override
  String get tutFriends4Desc =>
      'Desde el perfil de un amigo toca \"Comparar\" para ver vuestras estadísticas frente a frente: total de conciertos, artistas en común y valoración media.';

  @override
  String get tutFriends5Title => 'Notificaciones de actividad';

  @override
  String get tutFriends5Desc =>
      'Recibes una notificación cuando un amigo añade un concierto o te etiqueta en uno. También puedes comentar su actividad desde el feed.';

  @override
  String get tutFeed1Title => 'Feed de amigos';

  @override
  String get tutFeed1Desc =>
      'Sigue la actividad musical de tus amigos en tiempo real: qué conciertos añadieron, cuándo y con quién fueron.';

  @override
  String get tutFeed2Title => 'Comentar conciertos';

  @override
  String get tutFeed2Desc =>
      'Toca \"Comentar\" en cualquier actividad para dejar un mensaje. Abre el hilo completo para ver la conversación y responder.';

  @override
  String get tutFeed3Title => 'Galería compartida';

  @override
  String get tutFeed3Desc =>
      'En la pestaña de fotos ves todas las imágenes que tú y tus amigos subisteis a vuestros conciertos, ordenadas cronológicamente.';

  @override
  String get tutRecs1Title => 'Conciertos cerca de ti';

  @override
  String get tutRecs1Desc =>
      'Descubre eventos próximos basados en tu ubicación y los artistas que ya sigues en la app. Datos en tiempo real de Ticketmaster.';

  @override
  String get tutRecs2Title => 'Quiero ir';

  @override
  String get tutRecs2Desc =>
      'Marca un evento como \"Quiero ir\" para guardarlo en tu lista y encontrarlo rápido más adelante.';

  @override
  String get tutRecs3Title => 'Añadir directamente';

  @override
  String get tutRecs3Desc =>
      'Si ya tienes entrada para un evento recomendado, toca \"Añadir\" para registrarlo en tu historial como concierto futuro.';

  @override
  String get tutImport1Title => 'Buscar en Setlist.fm';

  @override
  String get tutImport1Desc =>
      'En la pestaña \"Setlist.fm\" escribe el nombre de un artista. La app mostrará sus conciertos pasados para que elijas los que hayas asistido.';

  @override
  String get tutImport2Title => 'Seleccionar e importar';

  @override
  String get tutImport2Desc =>
      'Marca los conciertos de la lista y toca \"Importar\". Se añaden automáticamente a tu historial; después puedes editar cada uno para añadir foto, precio y valoración.';

  @override
  String get tutImport3Title => 'Copia de seguridad';

  @override
  String get tutImport3Desc =>
      'En la pestaña \"Copia de seguridad\" puedes exportar todos tus conciertos a un archivo o restaurarlos desde una copia anterior para no perder nada.';

  @override
  String get tutSpotifyPlaylist1Title => 'Tu playlist de Spotify';

  @override
  String get tutSpotifyPlaylist1Desc =>
      'Esta pantalla muestra el reproductor embebido de Spotify con tu playlist personal. Cada usuario ve la suya propia gracias al acceso OAuth.';

  @override
  String get tutSpotifyPlaylist2Title => 'Vincular tu cuenta';

  @override
  String get tutSpotifyPlaylist2Desc =>
      'Si aún no has vinculado Spotify, toca \"Conectar con Spotify\" para autorizar el acceso. Solo necesitas hacerlo una vez.';

  @override
  String get tutSpotifyPlaylist3Title => 'Actualizar permisos';

  @override
  String get tutSpotifyPlaylist3Desc =>
      'Si ves el botón \"Re-vincular Spotify\" significa que tu sesión necesita un permiso adicional para acceder a playlists. Tócalo para actualizarla.';

  @override
  String get tutSpotifyImport1Title => 'Tus artistas de Spotify';

  @override
  String get tutSpotifyImport1Desc =>
      'Al vincular tu cuenta de Spotify, la app muestra aquí los artistas que más escuchas. Toca uno para buscar sus conciertos pasados en Setlist.fm.';

  @override
  String get tutSpotifyImport2Title => 'Importar conciertos del artista';

  @override
  String get tutSpotifyImport2Desc =>
      'Al tocar un artista se abre la lista de sus conciertos pasados. Selecciona los que hayas visto y se añaden directamente a tu historial.';

  @override
  String get tutSpotifyImport3Title => 'Desconectar Spotify';

  @override
  String get tutSpotifyImport3Desc =>
      'Toca el icono de salida en la esquina superior derecha para desvincular tu cuenta de Spotify en cualquier momento.';

  @override
  String get tutMap1Title => 'Tu mapa musical';

  @override
  String get tutMap1Desc =>
      'Todos tus conciertos geolocalizados en el mapa. Cada pin representa un concierto; las ciudades más visitadas se destacan con marcadores más grandes.';

  @override
  String get tutMap2Title => 'Explorar conciertos';

  @override
  String get tutMap2Desc =>
      'Toca cualquier pin para ver el nombre del artista, el recinto y la fecha. Desde ahí puedes abrir el detalle completo del concierto.';

  @override
  String get usernameRequired => 'Introduce tu nombre de usuario';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get emailRequired => 'Introduce tu correo';

  @override
  String get emailInvalid => 'Email no válido';

  @override
  String get passwordRequired => 'Introduce tu contraseña';

  @override
  String get passwordMinLength => 'Mínimo 6 caracteres';

  @override
  String get serverTimeout =>
      'El servidor tardó demasiado. Inténtalo de nuevo.';

  @override
  String get loginErrorGeneric => 'No se ha podido iniciar sesión.';

  @override
  String get loginErrorInvalidCredentials => 'Correo o contraseña incorrectos.';

  @override
  String get registerErrorGeneric => 'Ha ocurrido un error.';

  @override
  String get registerErrorInvalidEmail =>
      'Introduce un correo electrónico válido.';

  @override
  String get registerErrorEmailTaken => 'Ya existe una cuenta con ese correo.';

  @override
  String get registerErrorInvalidPassword => 'La contraseña no es válida.';

  @override
  String get forgotPasswordIntro =>
      'Introduce tu email y te enviaremos un enlace para crear una nueva contraseña.';

  @override
  String get emailSentTitle => '¡Email enviado!';

  @override
  String get emailSentBody =>
      'Si el email existe, recibirás un enlace para restablecer tu contraseña.\n\nRevisa también la carpeta de spam.';

  @override
  String get themePickerTitle => '¿Cómo prefieres\nver la app?';

  @override
  String get themePickerHint => 'Puedes cambiarlo después en Ajustes.';

  @override
  String get themeSystemDesc => 'Sigue el ajuste de tu móvil';

  @override
  String get themeDarkDesc => 'Fondo negro, ideal para conciertos';

  @override
  String get themeLightDesc => 'Fondo blanco, máxima legibilidad';

  @override
  String get getStartedLabel => 'Empezar';

  @override
  String get useSystemThemeLabel => 'Usar el del sistema';

  @override
  String get appErrorNoInternet => 'Sin conexión a internet';

  @override
  String get appErrorTimeout => 'El servidor tardó demasiado en responder';

  @override
  String get appErrorSessionExpired =>
      'Sesión expirada. Vuelve a iniciar sesión';

  @override
  String get appErrorForbidden => 'No tienes permiso para ver esto';

  @override
  String get appErrorNotFound => 'No se encontró el contenido';

  @override
  String get appErrorServer => 'Error en el servidor. Inténtalo más tarde';

  @override
  String get appErrorGeneric => 'Algo salió mal. Inténtalo de nuevo';

  @override
  String get paywallTitle => 'Lleva tu experiencia al siguiente nivel';

  @override
  String get paywallDesc =>
      'Hazte Pro para añadir conciertos sin límites y desbloquear todo lo que la app tiene para ofrecerte.';

  @override
  String get paywallBenefitConcerts => 'Conciertos ilimitados';

  @override
  String get paywallBenefitPhotos => 'Fotos ilimitadas por concierto';

  @override
  String get paywallBenefitPdf => 'Exportar estadísticas a PDF';

  @override
  String get paywallBenefitCustom => 'Dashboard y estadísticas personalizables';

  @override
  String get paywallBenefitThemes => 'Temas de color exclusivos';

  @override
  String get paywallCta => 'Hacerse Pro';

  @override
  String get paywallLater => 'Ahora no';

  @override
  String get dashEditTitle => 'Personalizar dashboard';

  @override
  String get layoutResetTitle => 'Restablecer orden';

  @override
  String get dashEditResetConfirm =>
      '¿Restaurar la disposición por defecto del dashboard?';

  @override
  String get statsEditResetConfirm => '¿Restaurar la disposición por defecto?';

  @override
  String get resetLabel => 'Restablecer';

  @override
  String get layoutLoadError => 'Error cargando la configuración';

  @override
  String get layoutEditHint =>
      'Arrastra   para reordenar · activa o desactiva cada sección';

  @override
  String get hiddenLabel => 'Oculta';

  @override
  String get dashSectionStreak => 'Racha de conciertos';

  @override
  String get dashSectionAnnualGoal => 'Meta anual';

  @override
  String get dashRatePendingTitle => 'Por valorar';

  @override
  String get dashSectionOnThisDay => 'En tal día como hoy';

  @override
  String get dashSectionUpcoming => 'Próximos conciertos';

  @override
  String get dashSectionStats => 'Estadísticas rápidas';

  @override
  String get dashSectionRecommended => 'Recomendaciones';

  @override
  String get dashSectionFavorites => 'Favoritos';

  @override
  String get dashSectionRecent => 'Últimos añadidos';

  @override
  String get dashSectionSpotify => 'Canciones favoritas (Spotify)';

  @override
  String get dashCalendarAction => 'Calendario';

  @override
  String get dashLastConcertTitle => 'Tu último concierto';

  @override
  String annualGoalMyConcerts(int year) {
    return 'Mis conciertos de $year';
  }

  @override
  String annualGoalNoConcerts(int year) {
    return 'Aún no has ido a ningún concierto en $year';
  }

  @override
  String annualGoalDoneInYear(int count, int year) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count conciertos en $year',
      one: '1 concierto en $year',
    );
    return '$_temp0';
  }

  @override
  String get annualGoalConfigure => 'Configura tu meta en Ajustes';

  @override
  String annualGoalReached(int year) {
    return '¡Meta alcanzada en $year! 🎉';
  }

  @override
  String annualGoalProgressTitle(int year, int goal) {
    String _temp0 = intl.Intl.pluralLogic(
      goal,
      locale: localeName,
      other: '$goal conciertos',
      one: '1 concierto',
    );
    return 'Meta $year: $_temp0';
  }

  @override
  String annualGoalRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Te quedan $count conciertos para conseguirlo',
      one: 'Te queda 1 concierto para conseguirlo',
    );
    return '$_temp0';
  }

  @override
  String get statsCustomizeTooltip => 'Personalizar';

  @override
  String get statsByMonth => 'Conciertos por mes';

  @override
  String get statsByWeekday => 'Día de la semana favorito';

  @override
  String get statsGenres => 'Géneros musicales';

  @override
  String get statsVenues => 'Recintos más visitados';

  @override
  String get statsFestivalVsSingle => 'Festival vs. individual';

  @override
  String get statsAvgRatingByYear => 'Valoración media por año';

  @override
  String get statsTopRatedArtists => 'Artistas mejor valorados';

  @override
  String get statsTotalSpent => 'Gasto total';

  @override
  String statsMonthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meses',
      one: '1 mes',
    );
    return '$_temp0';
  }

  @override
  String get statsLongestStreak => 'Racha más larga';

  @override
  String statsDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días',
      one: '1 día',
    );
    return '$_temp0';
  }

  @override
  String get statsLongestGap => 'Mayor hueco';

  @override
  String get statsRepeatedArtists => 'Artistas repetidos';

  @override
  String get statsSingleConcerts => 'Individuales';

  @override
  String get weekdayShortMon => 'Lun';

  @override
  String get weekdayShortTue => 'Mar';

  @override
  String get weekdayShortWed => 'Mié';

  @override
  String get weekdayShortThu => 'Jue';

  @override
  String get weekdayShortFri => 'Vie';

  @override
  String get weekdayShortSat => 'Sáb';

  @override
  String get weekdayShortSun => 'Dom';

  @override
  String get statsEditTitle => 'Personalizar estadísticas';

  @override
  String get statsEditSummary => 'Resumen (tarjetas)';

  @override
  String get statsEditTopArtists => 'Top artistas';

  @override
  String get statsEditTopFestivals => 'Top festivales';

  @override
  String wrappedShareText(int year) {
    return '🎸 Mi Wrapped $year | La Vida en Directo';
  }

  @override
  String get wrappedLoadError => 'Error cargando conciertos';

  @override
  String get wrappedIntroTitle => 'Tu año\nen conciertos';

  @override
  String get wrappedStart => 'Empieza';

  @override
  String get wrappedTotalLead => 'Este año fuiste a';

  @override
  String wrappedConcertsWord(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'conciertos',
      one: 'concierto',
    );
    return '$_temp0';
  }

  @override
  String get wrappedTier50 => '🔥 ¡Año legendario!';

  @override
  String get wrappedTier20 => '🎉 ¡Gran año en directo!';

  @override
  String get wrappedTier10 => '👏 Muy buen año';

  @override
  String get wrappedTier0 => '🎵 Empezando fuerte';

  @override
  String get wrappedArtistTitle => 'Tu artista del año';

  @override
  String get wrappedSharedBadge => 'Concierto compartido';

  @override
  String wrappedSeenTimes(int times) {
    return 'Lo viste $times veces';
  }

  @override
  String get wrappedWasThere => 'Estuviste allí';

  @override
  String get wrappedWasSpecial => 'Fue especial';

  @override
  String get wrappedVarietyTitle => 'Nunca te cansas';

  @override
  String wrappedArtistsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'artistas distintos',
      one: 'artista distinto',
    );
    return '$_temp0';
  }

  @override
  String wrappedCitiesLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ciudades diferentes',
      one: 'ciudad',
    );
    return '$_temp0';
  }

  @override
  String wrappedFestivalsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'festivales',
      one: 'festival',
    );
    return '$_temp0';
  }

  @override
  String get wrappedCityTitle => 'Tu ciudad favorita';

  @override
  String get wrappedMonthTitle => 'Tu mes más activo';

  @override
  String get wrappedRatingTitle => 'Tu valoración media';

  @override
  String get wrappedOutOf5 => 'sobre 5';

  @override
  String get wrappedPhotosTitle => 'Tus memorias';

  @override
  String wrappedMemoriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recuerdos este año',
      one: '1 recuerdo este año',
    );
    return '$_temp0';
  }

  @override
  String get wrappedClosingTitle => 'Tu resumen';

  @override
  String get wrappedPreparing => 'Preparando...';

  @override
  String get wrappedShareButton => 'Compartir mi Wrapped';

  @override
  String get wrappedFavArtist => 'Artista favorito';

  @override
  String get wrappedFavCity => 'Ciudad favorita';

  @override
  String get wrappedActiveMonth => 'Mes más activo';

  @override
  String get wrappedMiniArtists => 'artistas';

  @override
  String get wrappedMiniCities => 'ciudades';

  @override
  String get wrappedMiniRating => 'valoración';

  @override
  String get wrappedTeaserPre => 'Tu ';

  @override
  String wrappedTeaserYear(int year) {
    return 'del $year';
  }

  @override
  String get wrappedTeaserComing => 'llega en diciembre';

  @override
  String get wrappedTeaserProgress => 'PROGRESO DEL AÑO';

  @override
  String wrappedTeaserMonthsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meses para diciembre',
      one: '1 mes para diciembre',
    );
    return '$_temp0';
  }

  @override
  String get wrappedTeaserStory => 'TU HISTORIA ESTE AÑO';

  @override
  String get addGenreLabel => '🎸 Género musical';

  @override
  String get addGenreHint => 'Rock, Pop, Metal, Jazz…';

  @override
  String get priceFestivalLabel => 'Precio del festival';

  @override
  String get priceTicketLabel => 'Precio de la entrada';

  @override
  String get timeLabel => 'Hora';

  @override
  String get optionalHint => 'Opcional';

  @override
  String get ratingAutoNote =>
      'La valoración general se calcula como la media de los criterios.';

  @override
  String get ratingCriterionArtist => 'Artista';

  @override
  String get ratingCriterionSound => 'Sonido';

  @override
  String get ratingCriterionAtmosphere => 'Ambiente';

  @override
  String get ratingCriterionSetlist => 'Setlist';

  @override
  String get ratingCriterionValue => 'Precio / valor';

  @override
  String get notesDiaryLabel => '📝 Notas / diario';

  @override
  String get notesDiaryHint => '¿Qué recordás de este concierto?';

  @override
  String get visibleToFriendsTitle => 'Visible para mis amigos';

  @override
  String get visibleToFriendsOn =>
      'Aparece en tu feed de amigos y en las comparativas';

  @override
  String get visibleToFriendsOff => 'Solo tú lo verás — oculto para tus amigos';

  @override
  String get genreLabel => 'Género';

  @override
  String get detailHiddenTitle => 'Oculto para tus amigos';

  @override
  String get detailHiddenDesc => 'Solo tú puedes ver este concierto';

  @override
  String get detailLinkSpotifyTitle => 'Vincular artista de Spotify';

  @override
  String get detailLinkSpotifyDesc => 'Ver canciones populares y perfil';

  @override
  String detailSpotifyNotFound(String query) {
    return 'Artista no encontrado en Spotify: \"$query\"';
  }

  @override
  String detailSpotifySearchError(String error) {
    return 'Error al buscar en Spotify: $error';
  }

  @override
  String get notesTitle => 'Notas';

  @override
  String get shareLabel => 'Compartir';

  @override
  String get preparingLabel => 'Preparando...';

  @override
  String get commentsTitle => 'Comentarios';

  @override
  String get commentsEmpty => 'Sé el primero en comentar';

  @override
  String get commentHint => 'Escribe un comentario…';

  @override
  String get timeNow => 'ahora';

  @override
  String timeMinutesAgo(int count) {
    return 'hace $count min';
  }

  @override
  String timeHoursAgo(int count) {
    return 'hace $count h';
  }

  @override
  String timeDaysAgo(int count) {
    return 'hace $count d';
  }

  @override
  String get detailedRatingTitle => 'Valoración detallada';

  @override
  String get deleteConcertsTitle => 'Eliminar conciertos';

  @override
  String deleteConcertsConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'conciertos',
      one: 'concierto',
    );
    return '¿Eliminar $count $_temp0?\nEsta acción no se puede deshacer.';
  }

  @override
  String concertsDeletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count conciertos eliminados',
      one: '1 concierto eliminado',
    );
    return '$_temp0';
  }

  @override
  String concertsSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seleccionados',
      one: '1 seleccionado',
    );
    return '$_temp0';
  }

  @override
  String get selectAllLabel => 'Todo';

  @override
  String get deleteSelectedTooltip => 'Eliminar seleccionados';

  @override
  String get cancelSelectionTooltip => 'Cancelar selección';

  @override
  String get selectTooltip => 'Seleccionar';

  @override
  String get filterLiked => 'Me gustan';

  @override
  String get clearLabel => 'Limpiar';

  @override
  String get viewList => 'Lista';

  @override
  String get viewGrid => 'Cuadrícula';

  @override
  String get viewCalendar => 'Calendario';

  @override
  String get emptyPastSubtitle => 'Tus conciertos pasados aparecerán aquí';

  @override
  String get emptyUpcomingSubtitle =>
      'Añade un concierto futuro para no perderte nada';

  @override
  String get emptySharedSubtitle =>
      'Cuando tus amigos compartan conciertos, los verás aquí';

  @override
  String get filterSheetTitle => 'Filtrar conciertos';

  @override
  String get filterMinRating => 'Valoración mínima';

  @override
  String get filterShowOnly => 'Mostrar solo';

  @override
  String get applyFilters => 'Aplicar filtros';

  @override
  String venueArtistsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'artistas',
      one: 'artista',
    );
    return '$_temp0';
  }

  @override
  String venueUpcomingLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'próximos',
      one: 'próximo',
    );
    return '$_temp0';
  }

  @override
  String venueFirstVisit(String date) {
    return 'Primera visita: $date';
  }

  @override
  String venueLastVisit(String date) {
    return 'Última: $date';
  }

  @override
  String get venueNoConcerts => 'No hay conciertos en este recinto';

  @override
  String get calendarWeekdayInitials => 'L,M,X,J,V,S,D';

  @override
  String calendarDayLabel(int day, String month) {
    return '$day de $month';
  }

  @override
  String get calendarAddOnDate => 'Añadir concierto en esta fecha';

  @override
  String get mapCenterTooltip => 'Centrar';

  @override
  String favoritesArtistCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count artistas',
      one: '1 artista',
    );
    return '$_temp0';
  }

  @override
  String get favoritesEmptySubtitle =>
      'Marca conciertos como favoritos para verlos aquí agrupados por artista';

  @override
  String get refreshTooltip => 'Actualizar';

  @override
  String get friendsActivityEmpty =>
      'Tus amigos no han agregado\nconciertos todavía';

  @override
  String get friendDefaultName => 'Amigo';

  @override
  String get commentAction => 'Comentar';

  @override
  String get userDefaultName => 'Usuario';

  @override
  String get notificationsEmptyHint =>
      'Aquí aparecerán tus avisos y actividad de amigos';

  @override
  String get recsViewCardTooltip => 'Vista tarjeta';

  @override
  String get recsViewCompactTooltip => 'Vista compacta';

  @override
  String get recsResultsTab => 'Resultados';

  @override
  String get wantToGoTab => 'Quiero ir';

  @override
  String get recsWantEmpty => 'Aún no has marcado ningún concierto.';

  @override
  String get recsAttending => 'Apuntado';

  @override
  String get recsRemoveFromList => 'Quitar de mi lista';

  @override
  String get recsWantToAttend => 'Quiero asistir';

  @override
  String get setlistDataFrom => 'Datos de setlist.fm';

  @override
  String get colorPaletteIntro =>
      'Cambia el acento de color de toda la app. Las paletas Pro requieren suscripción activa.';

  @override
  String get themeNameEscenario => 'Escenario';

  @override
  String get themeNameVinilo => 'Vinilo';

  @override
  String get themeNameFestival => 'Festival';

  @override
  String get themeNameNeonPunk => 'Neon Punk';

  @override
  String get themeNameAcustico => 'Acústico';

  @override
  String get themeNameBackstage => 'Backstage';

  @override
  String get themeNameJazzClub => 'Jazz Club';

  @override
  String get concertNotFoundError => 'No se encontró el concierto';

  @override
  String get concertNotFoundTitle => 'Concierto no encontrado';

  @override
  String get concertNotFoundHint =>
      'Puede que ya no formes parte de este concierto';

  @override
  String get backLabel => 'Volver';

  @override
  String get importBackupTab => 'Copia de seguridad';

  @override
  String get importFromSpotifyTitle => 'Importar desde Spotify';

  @override
  String get importFromSpotifyDesc =>
      'Conecta tu cuenta y ve tus artistas favoritos';

  @override
  String get limitSheetTitle => 'Límite de conciertos gratuito';

  @override
  String limitSheetBody(int current, int max, int selected, int room) {
    String _temp0 = intl.Intl.pluralLogic(
      room,
      locale: localeName,
      other: ', pero solo caben $room más.',
      zero: ' y ya has alcanzado el límite.',
    );
    return 'Tienes $current conciertos de un máximo de $max en la versión gratuita. Has seleccionado $selected conciertos para importar$_temp0';
  }

  @override
  String limitImportFirstTitle(int count) {
    return 'Importar los primeros $count';
  }

  @override
  String limitImportFirstDesc(int count) {
    return 'Se importarán los primeros $count conciertos seleccionados';
  }

  @override
  String get limitChooseTitle => 'Elegir manualmente';

  @override
  String get limitChooseDesc =>
      'Vuelve a la lista y selecciona solo los que quieras';

  @override
  String get limitProTitle => 'Hazte Pro';

  @override
  String get limitProDesc => 'Sin límite de conciertos y más funciones';

  @override
  String get backupRestoreTitle => 'Restaurar copia de seguridad';

  @override
  String get backupRestoreIntro =>
      'Selecciona el archivo JSON generado desde Ajustes → Exportar mis conciertos para recuperar todos tus conciertos.';

  @override
  String get backupHowTo =>
      'Para crear una copia de seguridad ve a Ajustes → \"Exportar mis conciertos\" y elige JSON. El archivo incluye todos los datos e imágenes.';

  @override
  String get backupPickFile => 'Seleccionar archivo JSON';

  @override
  String backupInvalidFile(String detail) {
    return 'Archivo no válido: $detail';
  }

  @override
  String get backupFormatUnrecognized =>
      'formato de copia de seguridad no reconocido';

  @override
  String backupOwnCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count conciertos propios',
      one: '1 concierto propio',
    );
    return '$_temp0';
  }

  @override
  String get backupDeselectAll => 'Deseleccionar todo';

  @override
  String get backupSelectAll => 'Seleccionar todo';

  @override
  String get backupRestoreAll => 'Restaurar todo';

  @override
  String backupRestoreSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Restaurar $count seleccionados',
      one: 'Restaurar 1 seleccionado',
    );
    return '$_temp0';
  }

  @override
  String backupSharedNotRestorable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count compartidos (no restaurables)',
      one: '1 compartido (no restaurable)',
    );
    return '$_temp0';
  }

  @override
  String backupRestoredOk(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count conciertos restaurados correctamente ✅',
      one: '1 concierto restaurado correctamente ✅',
    );
    return '$_temp0';
  }

  @override
  String backupRestoredPartial(int restored, int failed) {
    return '$restored restaurados · $failed fallaron';
  }

  @override
  String get backupFailedTitle => 'Conciertos que fallaron:';

  @override
  String backupRetryFailed(int count) {
    return 'Reintentar $count fallidos';
  }

  @override
  String get backupRestoring => 'Restaurando...';

  @override
  String sharedFromUser(String name) {
    return 'De: $name';
  }

  @override
  String get spotifyConnect => 'Conectar con Spotify';

  @override
  String get spotifyConnecting => 'Conectando…';

  @override
  String get spotifyDisconnect => 'Desconectar Spotify';

  @override
  String get spotifyConnectTitle => 'Conecta tu cuenta de Spotify';

  @override
  String get spotifyImportConnectDesc =>
      'Verás tus artistas más escuchados y podrás añadir conciertos con un toque.';

  @override
  String get spotifyYourFavoriteArtists => 'Tus artistas favoritos';

  @override
  String get spotifyTapArtistHint => 'Toca un artista para añadir un concierto';

  @override
  String get spotifyConnectError => 'No se pudo conectar con Spotify';

  @override
  String get spotifyPlaylistTitle => 'Tus canciones favoritas';

  @override
  String get spotifyPlaylistConnectDesc =>
      'Vincula Spotify para ver aquí tu playlist de canciones favoritas.';

  @override
  String get spotifyRelinkTitle => 'Actualiza tu conexión con Spotify';

  @override
  String get spotifyRelinkDesc =>
      'Para ver tu playlist necesitamos un permiso adicional. Desconecta y vuelve a conectar tu cuenta de Spotify.';

  @override
  String get spotifyRelinkButton => 'Re-vincular Spotify';

  @override
  String get spotifyPlaylistLoadError => 'No se pudo cargar tu playlist';

  @override
  String get spotifyAccessDenied =>
      'Spotify rechazó el acceso a esta cuenta. Puede que la app esté en modo de desarrollo y esta cuenta no esté en la lista de usuarios permitidos.';

  @override
  String spotifyLinkError(String error) {
    return 'No se pudo vincular Spotify: $error';
  }

  @override
  String get spotifyTopTracksTitle => 'Mis canciones favoritas';

  @override
  String get spotifyTopTracksConnectTitle => 'Tus canciones más escuchadas';

  @override
  String get spotifyTopTracksConnectDesc =>
      'Conecta tu cuenta de Spotify para ver aquí tus canciones favoritas.';

  @override
  String spotifyTopTracksCount(int count) {
    return 'Tus $count canciones más escuchadas';
  }

  @override
  String get spotifyDataFrom => 'Datos de Spotify';

  @override
  String get spotifyLoadError => 'No se pudo cargar';
}
