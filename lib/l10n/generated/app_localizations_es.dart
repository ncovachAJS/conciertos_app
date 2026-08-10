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
  String get concertNameLabel => 'Nombre del concierto';

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
    return 'Hace $years $_temp0';
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
  String get actionTickets => 'Entradas';

  @override
  String get actionStats => 'Stats';

  @override
  String get actionImport => 'Importar';

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
}
