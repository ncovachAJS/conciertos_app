import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get edit;

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// No description provided for @close.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get close;

  /// No description provided for @search.
  ///
  /// In es, this message translates to:
  /// **'Buscar'**
  String get search;

  /// No description provided for @add.
  ///
  /// In es, this message translates to:
  /// **'Añadir'**
  String get add;

  /// No description provided for @publish.
  ///
  /// In es, this message translates to:
  /// **'Publicar'**
  String get publish;

  /// No description provided for @done.
  ///
  /// In es, this message translates to:
  /// **'Listo'**
  String get done;

  /// No description provided for @tag.
  ///
  /// In es, this message translates to:
  /// **'Etiquetar'**
  String get tag;

  /// No description provided for @all.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get all;

  /// No description provided for @understood.
  ///
  /// In es, this message translates to:
  /// **'Entendido'**
  String get understood;

  /// No description provided for @error.
  ///
  /// In es, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @loading.
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get loading;

  /// No description provided for @importing.
  ///
  /// In es, this message translates to:
  /// **'Importando...'**
  String get importing;

  /// No description provided for @deleting.
  ///
  /// In es, this message translates to:
  /// **'Eliminando...'**
  String get deleting;

  /// No description provided for @year.
  ///
  /// In es, this message translates to:
  /// **'Año'**
  String get year;

  /// No description provided for @country.
  ///
  /// In es, this message translates to:
  /// **'País'**
  String get country;

  /// No description provided for @loginTitle.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get loginTitle;

  /// No description provided for @registerTitle.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get registerTitle;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In es, this message translates to:
  /// **'Recuperar contraseña'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordLink.
  ///
  /// In es, this message translates to:
  /// **'¿Olvidaste tu contraseña?'**
  String get forgotPasswordLink;

  /// No description provided for @noAccountSignUp.
  ///
  /// In es, this message translates to:
  /// **'¿No tienes cuenta? Crear una cuenta'**
  String get noAccountSignUp;

  /// No description provided for @sendLink.
  ///
  /// In es, this message translates to:
  /// **'Enviar enlace'**
  String get sendLink;

  /// No description provided for @backToLogin.
  ///
  /// In es, this message translates to:
  /// **'Volver al login'**
  String get backToLogin;

  /// No description provided for @connectionError.
  ///
  /// In es, this message translates to:
  /// **'Error de conexión. Inténtalo de nuevo.'**
  String get connectionError;

  /// No description provided for @concertsTitle.
  ///
  /// In es, this message translates to:
  /// **'Conciertos'**
  String get concertsTitle;

  /// No description provided for @searchConcertsHint.
  ///
  /// In es, this message translates to:
  /// **'Artista, festival, ciudad, recinto...'**
  String get searchConcertsHint;

  /// No description provided for @deleteConcert.
  ///
  /// In es, this message translates to:
  /// **'Eliminar concierto'**
  String get deleteConcert;

  /// No description provided for @sharedBadge.
  ///
  /// In es, this message translates to:
  /// **'Compartido'**
  String get sharedBadge;

  /// No description provided for @viewConcert.
  ///
  /// In es, this message translates to:
  /// **'Ver concierto'**
  String get viewConcert;

  /// No description provided for @couldNotUpdateFavorite.
  ///
  /// In es, this message translates to:
  /// **'No se pudo actualizar el favorito'**
  String get couldNotUpdateFavorite;

  /// No description provided for @couldNotUpdateLike.
  ///
  /// In es, this message translates to:
  /// **'No se pudo actualizar \"Me gusta\"'**
  String get couldNotUpdateLike;

  /// No description provided for @deletingConcert.
  ///
  /// In es, this message translates to:
  /// **'Eliminando...'**
  String get deletingConcert;

  /// No description provided for @searchArtistSpotify.
  ///
  /// In es, this message translates to:
  /// **'Buscar artista en Spotify'**
  String get searchArtistSpotify;

  /// No description provided for @artistNameHint.
  ///
  /// In es, this message translates to:
  /// **'Nombre del artista...'**
  String get artistNameHint;

  /// No description provided for @dateLabel.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get dateLabel;

  /// No description provided for @venueLabel.
  ///
  /// In es, this message translates to:
  /// **'Sala / Estadio'**
  String get venueLabel;

  /// No description provided for @cityLabel.
  ///
  /// In es, this message translates to:
  /// **'Ciudad'**
  String get cityLabel;

  /// No description provided for @concertLabel.
  ///
  /// In es, this message translates to:
  /// **'Concierto'**
  String get concertLabel;

  /// No description provided for @addConcertsForStats.
  ///
  /// In es, this message translates to:
  /// **'Añade conciertos para ver tus estadísticas.'**
  String get addConcertsForStats;

  /// No description provided for @noConcerts.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay conciertos.'**
  String get noConcerts;

  /// No description provided for @noConcertsYet.
  ///
  /// In es, this message translates to:
  /// **'Todavía no tienes conciertos.'**
  String get noConcertsYet;

  /// No description provided for @addConcertTitle.
  ///
  /// In es, this message translates to:
  /// **'Añadir concierto'**
  String get addConcertTitle;

  /// No description provided for @editConcertTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar concierto'**
  String get editConcertTitle;

  /// No description provided for @artistLabel.
  ///
  /// In es, this message translates to:
  /// **'Artista'**
  String get artistLabel;

  /// No description provided for @festivalLabel.
  ///
  /// In es, this message translates to:
  /// **'Festival'**
  String get festivalLabel;

  /// No description provided for @concertNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre de gira/tour'**
  String get concertNameLabel;

  /// No description provided for @concertNameHint.
  ///
  /// In es, this message translates to:
  /// **'Ej. Iron Maiden - Future Past Tour'**
  String get concertNameHint;

  /// No description provided for @imageUploadedSuccess.
  ///
  /// In es, this message translates to:
  /// **'✅ Imagen subida correctamente'**
  String get imageUploadedSuccess;

  /// No description provided for @imageUploadError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo subir la imagen. Inténtalo de nuevo.'**
  String get imageUploadError;

  /// No description provided for @concertSaveError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo guardar el concierto. Inténtalo de nuevo.'**
  String get concertSaveError;

  /// No description provided for @onThisDay.
  ///
  /// In es, this message translates to:
  /// **'EN TAL DÍA COMO HOY'**
  String get onThisDay;

  /// No description provided for @upcomingConcerts.
  ///
  /// In es, this message translates to:
  /// **'PRÓXIMOS CONCIERTOS'**
  String get upcomingConcerts;

  /// No description provided for @statisticsSection.
  ///
  /// In es, this message translates to:
  /// **'ESTADÍSTICAS'**
  String get statisticsSection;

  /// No description provided for @recommendedSection.
  ///
  /// In es, this message translates to:
  /// **'RECOMENDADOS'**
  String get recommendedSection;

  /// No description provided for @yourFavorites.
  ///
  /// In es, this message translates to:
  /// **'TUS FAVORITOS'**
  String get yourFavorites;

  /// No description provided for @recentlyAdded.
  ///
  /// In es, this message translates to:
  /// **'ÚLTIMOS AÑADIDOS'**
  String get recentlyAdded;

  /// No description provided for @errorLoadingData.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar: {error}'**
  String errorLoadingData(String error);

  /// No description provided for @noConcertsUpcoming.
  ///
  /// In es, this message translates to:
  /// **'No hay conciertos próximos 🎸'**
  String get noConcertsUpcoming;

  /// No description provided for @concertToday.
  ///
  /// In es, this message translates to:
  /// **'🎉 ¡Hoy hay concierto!'**
  String get concertToday;

  /// No description provided for @concertTomorrow.
  ///
  /// In es, this message translates to:
  /// **'🔥 Mañana vuelves al directo'**
  String get concertTomorrow;

  /// No description provided for @daysLeft.
  ///
  /// In es, this message translates to:
  /// **'⏳ Faltan {days} días'**
  String daysLeft(int days);

  /// No description provided for @today.
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get today;

  /// No description provided for @live.
  ///
  /// In es, this message translates to:
  /// **'Directo'**
  String get live;

  /// No description provided for @noFavorites.
  ///
  /// In es, this message translates to:
  /// **'Todavía no tienes conciertos favoritos.'**
  String get noFavorites;

  /// No description provided for @greetingMorning.
  ///
  /// In es, this message translates to:
  /// **'Buenos días'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In es, this message translates to:
  /// **'Buenas tardes'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In es, this message translates to:
  /// **'Buenas noches'**
  String get greetingEvening;

  /// No description provided for @tagline.
  ///
  /// In es, this message translates to:
  /// **'Cada concierto cuenta una historia.'**
  String get tagline;

  /// No description provided for @readyForNext.
  ///
  /// In es, this message translates to:
  /// **'Todo listo para volver al directo.'**
  String get readyForNext;

  /// No description provided for @defaultNickname.
  ///
  /// In es, this message translates to:
  /// **'Rockero'**
  String get defaultNickname;

  /// No description provided for @epicMonth.
  ///
  /// In es, this message translates to:
  /// **'¡Mes épico!'**
  String get epicMonth;

  /// No description provided for @epicMonthDesc.
  ///
  /// In es, this message translates to:
  /// **'{count} conciertos este mes — estás en racha'**
  String epicMonthDesc(int count);

  /// No description provided for @goodMonth.
  ///
  /// In es, this message translates to:
  /// **'Buen mes'**
  String get goodMonth;

  /// No description provided for @goodMonthDesc.
  ///
  /// In es, this message translates to:
  /// **'{count} conciertos este mes'**
  String goodMonthDesc(int count);

  /// No description provided for @justGotOut.
  ///
  /// In es, this message translates to:
  /// **'Acabas de salir'**
  String get justGotOut;

  /// No description provided for @lastConcertDaysAgo.
  ///
  /// In es, this message translates to:
  /// **'Último concierto hace {days} días'**
  String lastConcertDaysAgo(int days);

  /// No description provided for @longTime.
  ///
  /// In es, this message translates to:
  /// **'Llevas tiempo sin ir'**
  String get longTime;

  /// No description provided for @longTimeDesc.
  ///
  /// In es, this message translates to:
  /// **'{days} días sin conciertos — ¡es hora de volver!'**
  String longTimeDesc(int days);

  /// No description provided for @howWasArtist.
  ///
  /// In es, this message translates to:
  /// **'¿Qué tal estuvo {artist}?'**
  String howWasArtist(String artist);

  /// No description provided for @noRatingYet.
  ///
  /// In es, this message translates to:
  /// **'Aún no has valorado este concierto'**
  String get noRatingYet;

  /// No description provided for @onThisDayYearsAgo.
  ///
  /// In es, this message translates to:
  /// **'Tal día como hoy, hace {years} {years, plural, =1{año} other{años}}'**
  String onThisDayYearsAgo(int years);

  /// No description provided for @onThisDayInDays.
  ///
  /// In es, this message translates to:
  /// **'En {days} {days, plural, =1{día} other{días}}, hace {years} {years, plural, =1{año} other{años}}'**
  String onThisDayInDays(int days, int years);

  /// No description provided for @onThisDayAgoDays.
  ///
  /// In es, this message translates to:
  /// **'Hace {days} {days, plural, =1{día} other{días}}, hace {years} {years, plural, =1{año} other{años}}'**
  String onThisDayAgoDays(int days, int years);

  /// No description provided for @onThisDaySeeMore.
  ///
  /// In es, this message translates to:
  /// **'Ver {count} más'**
  String onThisDaySeeMore(int count);

  /// No description provided for @onThisDaySeeLess.
  ///
  /// In es, this message translates to:
  /// **'Ver menos'**
  String get onThisDaySeeLess;

  /// No description provided for @statisticsTitle.
  ///
  /// In es, this message translates to:
  /// **'Estadísticas'**
  String get statisticsTitle;

  /// No description provided for @totalConcertsLabel.
  ///
  /// In es, this message translates to:
  /// **'Conciertos'**
  String get totalConcertsLabel;

  /// No description provided for @uniqueArtistsLabel.
  ///
  /// In es, this message translates to:
  /// **'Artistas'**
  String get uniqueArtistsLabel;

  /// No description provided for @uniqueFestivalsLabel.
  ///
  /// In es, this message translates to:
  /// **'Festivales'**
  String get uniqueFestivalsLabel;

  /// No description provided for @avgRatingLabel.
  ///
  /// In es, this message translates to:
  /// **'Valoración media'**
  String get avgRatingLabel;

  /// No description provided for @activeYearLabel.
  ///
  /// In es, this message translates to:
  /// **'Año activo'**
  String get activeYearLabel;

  /// No description provided for @activeYearsLabel.
  ///
  /// In es, this message translates to:
  /// **'Años activo'**
  String get activeYearsLabel;

  /// No description provided for @favoriteMonthLabel.
  ///
  /// In es, this message translates to:
  /// **'Mes favorito'**
  String get favoriteMonthLabel;

  /// No description provided for @concertsByYear.
  ///
  /// In es, this message translates to:
  /// **'Conciertos por año'**
  String get concertsByYear;

  /// No description provided for @topArtists.
  ///
  /// In es, this message translates to:
  /// **'Artistas más vistos'**
  String get topArtists;

  /// No description provided for @topFestivals.
  ///
  /// In es, this message translates to:
  /// **'Festivales más visitados'**
  String get topFestivals;

  /// No description provided for @favoriteCities.
  ///
  /// In es, this message translates to:
  /// **'Ciudades favoritas'**
  String get favoriteCities;

  /// No description provided for @ratingDistribution.
  ///
  /// In es, this message translates to:
  /// **'Distribución de valoraciones'**
  String get ratingDistribution;

  /// No description provided for @noDataDash.
  ///
  /// In es, this message translates to:
  /// **'—'**
  String get noDataDash;

  /// No description provided for @monthJanuary.
  ///
  /// In es, this message translates to:
  /// **'Enero'**
  String get monthJanuary;

  /// No description provided for @monthFebruary.
  ///
  /// In es, this message translates to:
  /// **'Febrero'**
  String get monthFebruary;

  /// No description provided for @monthMarch.
  ///
  /// In es, this message translates to:
  /// **'Marzo'**
  String get monthMarch;

  /// No description provided for @monthApril.
  ///
  /// In es, this message translates to:
  /// **'Abril'**
  String get monthApril;

  /// No description provided for @monthMay.
  ///
  /// In es, this message translates to:
  /// **'Mayo'**
  String get monthMay;

  /// No description provided for @monthJune.
  ///
  /// In es, this message translates to:
  /// **'Junio'**
  String get monthJune;

  /// No description provided for @monthJuly.
  ///
  /// In es, this message translates to:
  /// **'Julio'**
  String get monthJuly;

  /// No description provided for @monthAugust.
  ///
  /// In es, this message translates to:
  /// **'Agosto'**
  String get monthAugust;

  /// No description provided for @monthSeptember.
  ///
  /// In es, this message translates to:
  /// **'Septiembre'**
  String get monthSeptember;

  /// No description provided for @monthOctober.
  ///
  /// In es, this message translates to:
  /// **'Octubre'**
  String get monthOctober;

  /// No description provided for @monthNovember.
  ///
  /// In es, this message translates to:
  /// **'Noviembre'**
  String get monthNovember;

  /// No description provided for @monthDecember.
  ///
  /// In es, this message translates to:
  /// **'Diciembre'**
  String get monthDecember;

  /// No description provided for @myProfile.
  ///
  /// In es, this message translates to:
  /// **'Mi perfil'**
  String get myProfile;

  /// No description provided for @signIn.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get signIn;

  /// No description provided for @createAccount.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get createAccount;

  /// No description provided for @signOut.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get signOut;

  /// No description provided for @friendsTitle.
  ///
  /// In es, this message translates to:
  /// **'Amigos'**
  String get friendsTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settingsTitle;

  /// No description provided for @aboutTitle.
  ///
  /// In es, this message translates to:
  /// **'Acerca de'**
  String get aboutTitle;

  /// No description provided for @chooseFromGallery.
  ///
  /// In es, this message translates to:
  /// **'Elegir de la galería'**
  String get chooseFromGallery;

  /// No description provided for @takePhoto.
  ///
  /// In es, this message translates to:
  /// **'Hacer una foto'**
  String get takePhoto;

  /// No description provided for @profilePhotoUpdated.
  ///
  /// In es, this message translates to:
  /// **'Foto de perfil actualizada ✅'**
  String get profilePhotoUpdated;

  /// No description provided for @concertsStatLabel.
  ///
  /// In es, this message translates to:
  /// **'Conciertos'**
  String get concertsStatLabel;

  /// No description provided for @favoritesStatLabel.
  ///
  /// In es, this message translates to:
  /// **'Favoritos'**
  String get favoritesStatLabel;

  /// No description provided for @memoriesStatLabel.
  ///
  /// In es, this message translates to:
  /// **'Recuerdos'**
  String get memoriesStatLabel;

  /// No description provided for @likedLabel.
  ///
  /// In es, this message translates to:
  /// **'Te gustan'**
  String get likedLabel;

  /// No description provided for @accountSection.
  ///
  /// In es, this message translates to:
  /// **'Cuenta'**
  String get accountSection;

  /// No description provided for @changeName.
  ///
  /// In es, this message translates to:
  /// **'Cambiar nombre'**
  String get changeName;

  /// No description provided for @usernameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre de usuario'**
  String get usernameLabel;

  /// No description provided for @changePassword.
  ///
  /// In es, this message translates to:
  /// **'Cambiar contraseña'**
  String get changePassword;

  /// No description provided for @preferencesSection.
  ///
  /// In es, this message translates to:
  /// **'Preferencias'**
  String get preferencesSection;

  /// No description provided for @notificationsLabel.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get notificationsLabel;

  /// No description provided for @upcomingConcertAlerts.
  ///
  /// In es, this message translates to:
  /// **'Avisos de conciertos próximos'**
  String get upcomingConcertAlerts;

  /// No description provided for @languageSection.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get languageSection;

  /// No description provided for @appearanceSection.
  ///
  /// In es, this message translates to:
  /// **'Apariencia'**
  String get appearanceSection;

  /// No description provided for @newNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nuevo nombre'**
  String get newNameLabel;

  /// No description provided for @currentPasswordLabel.
  ///
  /// In es, this message translates to:
  /// **'Contraseña actual'**
  String get currentPasswordLabel;

  /// No description provided for @newPasswordLabel.
  ///
  /// In es, this message translates to:
  /// **'Nueva contraseña'**
  String get newPasswordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In es, this message translates to:
  /// **'Confirmar contraseña'**
  String get confirmPasswordLabel;

  /// No description provided for @passwordsNoMatch.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get passwordsNoMatch;

  /// No description provided for @nameUpdated.
  ///
  /// In es, this message translates to:
  /// **'Nombre actualizado ✅'**
  String get nameUpdated;

  /// No description provided for @passwordUpdated.
  ///
  /// In es, this message translates to:
  /// **'Contraseña actualizada ✅'**
  String get passwordUpdated;

  /// No description provided for @changeNameTitle.
  ///
  /// In es, this message translates to:
  /// **'Cambiar nombre'**
  String get changeNameTitle;

  /// No description provided for @changePasswordTitle.
  ///
  /// In es, this message translates to:
  /// **'Cambiar contraseña'**
  String get changePasswordTitle;

  /// No description provided for @languageSpanish.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @languageEnglish.
  ///
  /// In es, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @changeLanguageTitle.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get changeLanguageTitle;

  /// No description provided for @privacyPolicy.
  ///
  /// In es, this message translates to:
  /// **'Política de privacidad'**
  String get privacyPolicy;

  /// No description provided for @creditsLabel.
  ///
  /// In es, this message translates to:
  /// **'Créditos'**
  String get creditsLabel;

  /// No description provided for @technologiesUsed.
  ///
  /// In es, this message translates to:
  /// **'Tecnologías utilizadas:'**
  String get technologiesUsed;

  /// No description provided for @contact.
  ///
  /// In es, this message translates to:
  /// **'Contacto'**
  String get contact;

  /// No description provided for @deleteFriendTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar amigo'**
  String get deleteFriendTitle;

  /// No description provided for @friendRequestReceived.
  ///
  /// In es, this message translates to:
  /// **'Quiere ser tu amigo'**
  String get friendRequestReceived;

  /// No description provided for @searchFriendHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar por nombre o email...'**
  String get searchFriendHint;

  /// No description provided for @friendsSearchPeople.
  ///
  /// In es, this message translates to:
  /// **'Buscar personas'**
  String get friendsSearchPeople;

  /// No description provided for @friendsTabFriends.
  ///
  /// In es, this message translates to:
  /// **'Amigos ({count})'**
  String friendsTabFriends(int count);

  /// No description provided for @friendsTabRequests.
  ///
  /// In es, this message translates to:
  /// **'Solicitudes'**
  String get friendsTabRequests;

  /// No description provided for @friendsTabRequestsCount.
  ///
  /// In es, this message translates to:
  /// **'Solicitudes ({count})'**
  String friendsTabRequestsCount(int count);

  /// No description provided for @friendsTypeToSearch.
  ///
  /// In es, this message translates to:
  /// **'Escribe al menos 2 caracteres'**
  String get friendsTypeToSearch;

  /// No description provided for @friendsNoUsersFound.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron usuarios'**
  String get friendsNoUsersFound;

  /// No description provided for @friendAlreadyFriend.
  ///
  /// In es, this message translates to:
  /// **'Amigo ✓'**
  String get friendAlreadyFriend;

  /// No description provided for @friendRequestSent.
  ///
  /// In es, this message translates to:
  /// **'Enviada'**
  String get friendRequestSent;

  /// No description provided for @friendAccept.
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get friendAccept;

  /// No description provided for @friendReject.
  ///
  /// In es, this message translates to:
  /// **'Rechazar'**
  String get friendReject;

  /// No description provided for @friendAdd.
  ///
  /// In es, this message translates to:
  /// **'Añadir'**
  String get friendAdd;

  /// No description provided for @friendsNoFriendsHere.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes amigos.\nBúscalos con el icono de arriba.'**
  String get friendsNoFriendsHere;

  /// No description provided for @friendDeleteConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres eliminar a {name}?'**
  String friendDeleteConfirm(String name);

  /// No description provided for @friendsNoPendingRequests.
  ///
  /// In es, this message translates to:
  /// **'No tienes solicitudes pendientes.'**
  String get friendsNoPendingRequests;

  /// No description provided for @notificationsTitle.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get notificationsTitle;

  /// No description provided for @markRead.
  ///
  /// In es, this message translates to:
  /// **'Leído'**
  String get markRead;

  /// No description provided for @deleteAll.
  ///
  /// In es, this message translates to:
  /// **'Eliminar todo'**
  String get deleteAll;

  /// No description provided for @deleteNotificationsTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar notificaciones'**
  String get deleteNotificationsTitle;

  /// No description provided for @deleteNotificationsConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres eliminar todas las notificaciones?'**
  String get deleteNotificationsConfirm;

  /// No description provided for @noNotifications.
  ///
  /// In es, this message translates to:
  /// **'Sin notificaciones'**
  String get noNotifications;

  /// No description provided for @favoritesTitle.
  ///
  /// In es, this message translates to:
  /// **'Favoritos'**
  String get favoritesTitle;

  /// No description provided for @favoritesError.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar favoritos'**
  String get favoritesError;

  /// No description provided for @searchArtistHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar artista...'**
  String get searchArtistHint;

  /// No description provided for @noFavoritesMessage.
  ///
  /// In es, this message translates to:
  /// **'Todavía no tienes favoritos.'**
  String get noFavoritesMessage;

  /// No description provided for @concertCountLabel.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 concierto} other{{count} conciertos}}'**
  String concertCountLabel(int count);

  /// No description provided for @memoriesTitle.
  ///
  /// In es, this message translates to:
  /// **'Recuerdos'**
  String get memoriesTitle;

  /// No description provided for @deletePhotosTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar fotos'**
  String get deletePhotosTitle;

  /// No description provided for @deletePhotosConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres eliminar {count} {count, plural, =1{foto} other{fotos}}?\nEsta acción no se puede deshacer.'**
  String deletePhotosConfirm(int count);

  /// No description provided for @deletePhotoTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar foto'**
  String get deletePhotoTitle;

  /// No description provided for @deletePhotoConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres eliminar este recuerdo?'**
  String get deletePhotoConfirm;

  /// No description provided for @noMemories.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay recuerdos.\nAñade fotos desde el detalle de un concierto.'**
  String get noMemories;

  /// No description provided for @noMemoriesShort.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay recuerdos. ¡Añade tus fotos del concierto!'**
  String get noMemoriesShort;

  /// No description provided for @deletingPhotos.
  ///
  /// In es, this message translates to:
  /// **'Eliminando fotos...'**
  String get deletingPhotos;

  /// No description provided for @tagPeople.
  ///
  /// In es, this message translates to:
  /// **'Etiquetar personas'**
  String get tagPeople;

  /// No description provided for @newMemory.
  ///
  /// In es, this message translates to:
  /// **'Nuevo recuerdo'**
  String get newMemory;

  /// No description provided for @captionHint.
  ///
  /// In es, this message translates to:
  /// **'Pie de foto (opcional)'**
  String get captionHint;

  /// No description provided for @photoUploadError.
  ///
  /// In es, this message translates to:
  /// **'Error al subir foto: {error}'**
  String photoUploadError(String error);

  /// No description provided for @gridView.
  ///
  /// In es, this message translates to:
  /// **'Ver en cuadrícula'**
  String get gridView;

  /// No description provided for @timelineView.
  ///
  /// In es, this message translates to:
  /// **'Ver en timeline'**
  String get timelineView;

  /// No description provided for @noDate.
  ///
  /// In es, this message translates to:
  /// **'Sin fecha'**
  String get noDate;

  /// No description provided for @deleteSelection.
  ///
  /// In es, this message translates to:
  /// **'Eliminar selección'**
  String get deleteSelection;

  /// No description provided for @selectedCount.
  ///
  /// In es, this message translates to:
  /// **'{count} seleccionada{count, plural, =1{} other{s}}'**
  String selectedCount(int count);

  /// No description provided for @uploadingPhotos.
  ///
  /// In es, this message translates to:
  /// **'Subiendo {current}/{total}...'**
  String uploadingPhotos(int current, int total);

  /// No description provided for @importTitle.
  ///
  /// In es, this message translates to:
  /// **'Importar conciertos'**
  String get importTitle;

  /// No description provided for @importSearchArtist.
  ///
  /// In es, this message translates to:
  /// **'Busca un artista'**
  String get importSearchArtist;

  /// No description provided for @importFromSetlist.
  ///
  /// In es, this message translates to:
  /// **'Importa conciertos desde Setlist.fm'**
  String get importFromSetlist;

  /// No description provided for @artistHint.
  ///
  /// In es, this message translates to:
  /// **'Artista...'**
  String get artistHint;

  /// No description provided for @importFoundCount.
  ///
  /// In es, this message translates to:
  /// **'{count} encontrados'**
  String importFoundCount(int count);

  /// No description provided for @importSelectedCount.
  ///
  /// In es, this message translates to:
  /// **'{count} seleccionados'**
  String importSelectedCount(int count);

  /// No description provided for @importSearchPrompt.
  ///
  /// In es, this message translates to:
  /// **'Busca un artista para\nver sus conciertos'**
  String get importSearchPrompt;

  /// No description provided for @loadMore.
  ///
  /// In es, this message translates to:
  /// **'Cargar más'**
  String get loadMore;

  /// No description provided for @importButton.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{Importar 1 concierto} other{Importar {count} conciertos}}'**
  String importButton(int count);

  /// No description provided for @importSuccess.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 concierto importado 🎸} other{{count} conciertos importados 🎸}}'**
  String importSuccess(int count);

  /// No description provided for @recommendedTitle.
  ///
  /// In es, this message translates to:
  /// **'Recomendados'**
  String get recommendedTitle;

  /// No description provided for @noLikesForRecommendations.
  ///
  /// In es, this message translates to:
  /// **'Marca artistas con \"me gusta\" para recibir recomendaciones.'**
  String get noLikesForRecommendations;

  /// No description provided for @becauseYouLike.
  ///
  /// In es, this message translates to:
  /// **'Porque te gusta {artist}'**
  String becauseYouLike(String artist);

  /// No description provided for @viewOnTicketmaster.
  ///
  /// In es, this message translates to:
  /// **'Ver en Ticketmaster'**
  String get viewOnTicketmaster;

  /// No description provided for @noConcertsAddForRec.
  ///
  /// In es, this message translates to:
  /// **'Añade conciertos para ver recomendaciones.'**
  String get noConcertsAddForRec;

  /// No description provided for @noUpcomingEvents.
  ///
  /// In es, this message translates to:
  /// **'No encontramos eventos próximos. Tus artistas más vistos:'**
  String get noUpcomingEvents;

  /// No description provided for @searchHintBar.
  ///
  /// In es, this message translates to:
  /// **'Buscar artista o festival...'**
  String get searchHintBar;

  /// No description provided for @artistConcertSingular.
  ///
  /// In es, this message translates to:
  /// **'concierto'**
  String get artistConcertSingular;

  /// No description provided for @artistConcertPlural.
  ///
  /// In es, this message translates to:
  /// **'conciertos'**
  String get artistConcertPlural;

  /// No description provided for @artistAvgRating.
  ///
  /// In es, this message translates to:
  /// **'valoración media'**
  String get artistAvgRating;

  /// No description provided for @artistCitySingular.
  ///
  /// In es, this message translates to:
  /// **'ciudad'**
  String get artistCitySingular;

  /// No description provided for @artistCityPlural.
  ///
  /// In es, this message translates to:
  /// **'ciudades'**
  String get artistCityPlural;

  /// No description provided for @artistFirstConcert.
  ///
  /// In es, this message translates to:
  /// **'Primer concierto'**
  String get artistFirstConcert;

  /// No description provided for @artistBest.
  ///
  /// In es, this message translates to:
  /// **'El mejor'**
  String get artistBest;

  /// No description provided for @artistUpcoming.
  ///
  /// In es, this message translates to:
  /// **'PRÓXIMOS'**
  String get artistUpcoming;

  /// No description provided for @artistHistory.
  ///
  /// In es, this message translates to:
  /// **'HISTORIAL'**
  String get artistHistory;

  /// No description provided for @actionAdd.
  ///
  /// In es, this message translates to:
  /// **'Añadir'**
  String get actionAdd;

  /// No description provided for @actionEvents.
  ///
  /// In es, this message translates to:
  /// **'Eventos'**
  String get actionEvents;

  /// No description provided for @actionStats.
  ///
  /// In es, this message translates to:
  /// **'Stats'**
  String get actionStats;

  /// No description provided for @actionImport.
  ///
  /// In es, this message translates to:
  /// **'Importar'**
  String get actionImport;

  /// No description provided for @ticketWalletTitle.
  ///
  /// In es, this message translates to:
  /// **'Mi entrada'**
  String get ticketWalletTitle;

  /// No description provided for @ticketWalletEmptyDescription.
  ///
  /// In es, this message translates to:
  /// **'Guarda aquí tu entrada (foto o PDF). Se queda solo en este dispositivo, nunca se sube a nuestros servidores.'**
  String get ticketWalletEmptyDescription;

  /// No description provided for @ticketWalletFestivalTitle.
  ///
  /// In es, this message translates to:
  /// **'Entrada del festival'**
  String get ticketWalletFestivalTitle;

  /// No description provided for @ticketWalletFestivalEmptyDescription.
  ///
  /// In es, this message translates to:
  /// **'Guarda aquí el pase del festival (foto o PDF). Se comparte entre todos los conciertos de este festival y se queda solo en este dispositivo.'**
  String get ticketWalletFestivalEmptyDescription;

  /// No description provided for @ticketWalletAddPhoto.
  ///
  /// In es, this message translates to:
  /// **'Foto'**
  String get ticketWalletAddPhoto;

  /// No description provided for @ticketWalletAddPdf.
  ///
  /// In es, this message translates to:
  /// **'PDF'**
  String get ticketWalletAddPdf;

  /// No description provided for @ticketWalletView.
  ///
  /// In es, this message translates to:
  /// **'Ver'**
  String get ticketWalletView;

  /// No description provided for @ticketWalletDelete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get ticketWalletDelete;

  /// No description provided for @ticketWalletLocalBadge.
  ///
  /// In es, this message translates to:
  /// **'Solo en este dispositivo'**
  String get ticketWalletLocalBadge;

  /// No description provided for @ticketWalletConfirmDeleteTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar entrada?'**
  String get ticketWalletConfirmDeleteTitle;

  /// No description provided for @ticketWalletConfirmDeleteBody.
  ///
  /// In es, this message translates to:
  /// **'Se eliminará únicamente de este dispositivo.'**
  String get ticketWalletConfirmDeleteBody;

  /// No description provided for @ticketWalletPdfFile.
  ///
  /// In es, this message translates to:
  /// **'Entrada en PDF'**
  String get ticketWalletPdfFile;

  /// No description provided for @tutorialWelcomeTitle.
  ///
  /// In es, this message translates to:
  /// **'¡Bienvenido a La Vida en Directo!'**
  String get tutorialWelcomeTitle;

  /// No description provided for @tutorialWelcomeDesc.
  ///
  /// In es, this message translates to:
  /// **'Tu diario personal de conciertos. Aquí encontrarás todo lo que necesitas para recordar cada directo.'**
  String get tutorialWelcomeDesc;

  /// No description provided for @tutorialAddTitle.
  ///
  /// In es, this message translates to:
  /// **'Añade tu primer concierto'**
  String get tutorialAddTitle;

  /// No description provided for @tutorialAddDesc.
  ///
  /// In es, this message translates to:
  /// **'Pulsa el botón \"Añadir\" para registrar un concierto. Puedes añadir la fecha, el recinto, fotos y valorarlo.'**
  String get tutorialAddDesc;

  /// No description provided for @tutorialImportTitle.
  ///
  /// In es, this message translates to:
  /// **'Importa desde Setlist.fm'**
  String get tutorialImportTitle;

  /// No description provided for @tutorialImportDesc.
  ///
  /// In es, this message translates to:
  /// **'Usa el botón \"Importar\" para traer conciertos automáticamente desde Setlist.fm con un solo toque.'**
  String get tutorialImportDesc;

  /// No description provided for @tutorialFavoritesTitle.
  ///
  /// In es, this message translates to:
  /// **'Guarda tus favoritos'**
  String get tutorialFavoritesTitle;

  /// No description provided for @tutorialFavoritesDesc.
  ///
  /// In es, this message translates to:
  /// **'Marca los artistas que más te gustan como favoritos. Los encontrarás agrupados en la pestaña Favoritos.'**
  String get tutorialFavoritesDesc;

  /// No description provided for @tutorialMemoriesTitle.
  ///
  /// In es, this message translates to:
  /// **'Guarda tus recuerdos'**
  String get tutorialMemoriesTitle;

  /// No description provided for @tutorialMemoriesDesc.
  ///
  /// In es, this message translates to:
  /// **'En la pestaña Recuerdos puedes ver todas las fotos de tus conciertos organizadas por año.'**
  String get tutorialMemoriesDesc;

  /// No description provided for @tutorialAddConcertTitle.
  ///
  /// In es, this message translates to:
  /// **'Añade un concierto'**
  String get tutorialAddConcertTitle;

  /// No description provided for @tutorialAddConcertDesc.
  ///
  /// In es, this message translates to:
  /// **'Rellena el nombre del artista, la fecha y el recinto. El resto es opcional.'**
  String get tutorialAddConcertDesc;

  /// No description provided for @tutorialAddImageTitle.
  ///
  /// In es, this message translates to:
  /// **'Añade una imagen'**
  String get tutorialAddImageTitle;

  /// No description provided for @tutorialAddImageDesc.
  ///
  /// In es, this message translates to:
  /// **'Puedes añadir una foto del concierto o del artista. Se usará como portada en tu colección.'**
  String get tutorialAddImageDesc;

  /// No description provided for @tutorialRateTitle.
  ///
  /// In es, this message translates to:
  /// **'Valora tu experiencia'**
  String get tutorialRateTitle;

  /// No description provided for @tutorialRateDesc.
  ///
  /// In es, this message translates to:
  /// **'Para conciertos pasados puedes añadir una valoración de 1 a 5 estrellas. Toca la estrella activa para quitarla.'**
  String get tutorialRateDesc;

  /// No description provided for @tutorialLikeTitle.
  ///
  /// In es, this message translates to:
  /// **'Me gusta y Favorito'**
  String get tutorialLikeTitle;

  /// No description provided for @tutorialLikeDesc.
  ///
  /// In es, this message translates to:
  /// **'👍 \"Me gusta\" marca conciertos que disfrutaste. ⭐ \"Favorito\" agrupa el artista en tu lista de favoritos.'**
  String get tutorialLikeDesc;

  /// No description provided for @tutorialDetailTitle.
  ///
  /// In es, this message translates to:
  /// **'Detalle del concierto'**
  String get tutorialDetailTitle;

  /// No description provided for @tutorialDetailDesc.
  ///
  /// In es, this message translates to:
  /// **'Aquí ves toda la información del concierto: fecha, recinto, ciudad y tus fotos.'**
  String get tutorialDetailDesc;

  /// No description provided for @tutorialEditTitle.
  ///
  /// In es, this message translates to:
  /// **'Edita cuando quieras'**
  String get tutorialEditTitle;

  /// No description provided for @tutorialEditDesc.
  ///
  /// In es, this message translates to:
  /// **'Pulsa el icono ✏️ arriba a la derecha para editar cualquier detalle o cambiar la imagen.'**
  String get tutorialEditDesc;

  /// No description provided for @tutorialSetlistTitle.
  ///
  /// In es, this message translates to:
  /// **'Setlist automático'**
  String get tutorialSetlistTitle;

  /// No description provided for @tutorialSetlistDesc.
  ///
  /// In es, this message translates to:
  /// **'Si el concierto está en Setlist.fm, verás automáticamente las canciones que tocaron esa noche.'**
  String get tutorialSetlistDesc;

  /// No description provided for @tutorialPhotosTitle.
  ///
  /// In es, this message translates to:
  /// **'Añade tus fotos'**
  String get tutorialPhotosTitle;

  /// No description provided for @tutorialPhotosDesc.
  ///
  /// In es, this message translates to:
  /// **'En la sección Recuerdos puedes añadir todas las fotos que quieras del concierto. Selección múltiple.'**
  String get tutorialPhotosDesc;

  /// No description provided for @tutorialConcertsTitle.
  ///
  /// In es, this message translates to:
  /// **'Tu colección de conciertos'**
  String get tutorialConcertsTitle;

  /// No description provided for @tutorialConcertsDesc.
  ///
  /// In es, this message translates to:
  /// **'Aquí tienes todos los conciertos que has registrado. Usa el buscador para filtrar por artista, ciudad o festival.'**
  String get tutorialConcertsDesc;

  /// No description provided for @tutorialConcertsViewTitle.
  ///
  /// In es, this message translates to:
  /// **'Tres formas de verlos'**
  String get tutorialConcertsViewTitle;

  /// No description provided for @tutorialConcertsViewDesc.
  ///
  /// In es, this message translates to:
  /// **'Cambia entre lista, cuadrícula o calendario con los iconos de arriba a la derecha. Cada vista tiene su momento.'**
  String get tutorialConcertsViewDesc;

  /// No description provided for @tutorialConcertsCalTitle.
  ///
  /// In es, this message translates to:
  /// **'Vista calendario'**
  String get tutorialConcertsCalTitle;

  /// No description provided for @tutorialConcertsCalDesc.
  ///
  /// In es, this message translates to:
  /// **'En el calendario puedes ver tus conciertos por fecha y añadir uno nuevo tocando cualquier día.'**
  String get tutorialConcertsCalDesc;

  /// No description provided for @tutorialStatsOverviewTitle.
  ///
  /// In es, this message translates to:
  /// **'Tu historial musical'**
  String get tutorialStatsOverviewTitle;

  /// No description provided for @tutorialStatsOverviewDesc.
  ///
  /// In es, this message translates to:
  /// **'Un resumen de toda tu actividad: conciertos, artistas únicos, festivales y ciudades que has visitado.'**
  String get tutorialStatsOverviewDesc;

  /// No description provided for @tutorialStatsChartTitle.
  ///
  /// In es, this message translates to:
  /// **'Evolución por año'**
  String get tutorialStatsChartTitle;

  /// No description provided for @tutorialStatsChartDesc.
  ///
  /// In es, this message translates to:
  /// **'La gráfica muestra cuántos conciertos has asistido cada año. Descubre tus épocas más activas.'**
  String get tutorialStatsChartDesc;

  /// No description provided for @tutorialStatsTopTitle.
  ///
  /// In es, this message translates to:
  /// **'Tus tops personales'**
  String get tutorialStatsTopTitle;

  /// No description provided for @tutorialStatsTopDesc.
  ///
  /// In es, this message translates to:
  /// **'Rankings de artistas, ciudades y festivales más visitados. ¿Alguien gana por goleada?'**
  String get tutorialStatsTopDesc;

  /// No description provided for @tutorialProfileOverviewTitle.
  ///
  /// In es, this message translates to:
  /// **'Tu perfil'**
  String get tutorialProfileOverviewTitle;

  /// No description provided for @tutorialProfileOverviewDesc.
  ///
  /// In es, this message translates to:
  /// **'Aquí ves tu resumen personal: conciertos, fotos, y acceso a ajustes. Toca tu avatar para cambiarlo.'**
  String get tutorialProfileOverviewDesc;

  /// No description provided for @tutorialProfileAchTitle.
  ///
  /// In es, this message translates to:
  /// **'Logros y trofeos'**
  String get tutorialProfileAchTitle;

  /// No description provided for @tutorialProfileAchDesc.
  ///
  /// In es, this message translates to:
  /// **'Gana logros asistiendo a conciertos. La lista se despliega para ver todos. Toca uno para ver qué se necesita.'**
  String get tutorialProfileAchDesc;

  /// No description provided for @tutorialFriendsConnectTitle.
  ///
  /// In es, this message translates to:
  /// **'Conecta con amigos'**
  String get tutorialFriendsConnectTitle;

  /// No description provided for @tutorialFriendsConnectDesc.
  ///
  /// In es, this message translates to:
  /// **'Busca a tus amigos por nombre y envíales una solicitud. Así podréis ver los conciertos de los demás.'**
  String get tutorialFriendsConnectDesc;

  /// No description provided for @tutorialFriendsTabsTitle.
  ///
  /// In es, this message translates to:
  /// **'Amigos y solicitudes'**
  String get tutorialFriendsTabsTitle;

  /// No description provided for @tutorialFriendsTabsDesc.
  ///
  /// In es, this message translates to:
  /// **'La primera pestaña muestra tus amigos actuales. La segunda gestiona las solicitudes pendientes que hayas recibido.'**
  String get tutorialFriendsTabsDesc;

  /// No description provided for @tutorialFriendsActivityTitle.
  ///
  /// In es, this message translates to:
  /// **'Actividad de amigos'**
  String get tutorialFriendsActivityTitle;

  /// No description provided for @tutorialFriendsActivityDesc.
  ///
  /// In es, this message translates to:
  /// **'Cuando un amigo añada un concierto recibirás una notificación. También puedes ver su perfil y lista de conciertos.'**
  String get tutorialFriendsActivityDesc;

  /// No description provided for @tutorialFeedPhotosTitle.
  ///
  /// In es, this message translates to:
  /// **'Recuerdos en fotos'**
  String get tutorialFeedPhotosTitle;

  /// No description provided for @tutorialFeedPhotosDesc.
  ///
  /// In es, this message translates to:
  /// **'Aquí aparecen las fotos de tus conciertos y de tus amigos. Un álbum compartido del mundo del directo.'**
  String get tutorialFeedPhotosDesc;

  /// No description provided for @tutorialFeedViewTitle.
  ///
  /// In es, this message translates to:
  /// **'Cuadrícula o línea de tiempo'**
  String get tutorialFeedViewTitle;

  /// No description provided for @tutorialFeedViewDesc.
  ///
  /// In es, this message translates to:
  /// **'Alterna entre la cuadrícula y la vista cronológica con el icono de arriba. La vista cronológica agrupa las fotos por concierto.'**
  String get tutorialFeedViewDesc;

  /// No description provided for @tutorialRecsDiscoverTitle.
  ///
  /// In es, this message translates to:
  /// **'Descubre nuevos conciertos'**
  String get tutorialRecsDiscoverTitle;

  /// No description provided for @tutorialRecsDiscoverDesc.
  ///
  /// In es, this message translates to:
  /// **'Basándonos en los artistas que ya has visto, te sugerimos conciertos próximos. Filtra por país para afinar.'**
  String get tutorialRecsDiscoverDesc;

  /// No description provided for @tutorialRecsWantTitle.
  ///
  /// In es, this message translates to:
  /// **'Quiero ir'**
  String get tutorialRecsWantTitle;

  /// No description provided for @tutorialRecsWantDesc.
  ///
  /// In es, this message translates to:
  /// **'Toca el 🎟️ en cualquier evento para guardarlo en tu lista «Quiero ir». Lo encontrarás en la segunda pestaña.'**
  String get tutorialRecsWantDesc;

  /// No description provided for @tutorialImportSearchTitle.
  ///
  /// In es, this message translates to:
  /// **'Importa desde Setlist.fm'**
  String get tutorialImportSearchTitle;

  /// No description provided for @tutorialImportSearchDesc.
  ///
  /// In es, this message translates to:
  /// **'Escribe el nombre de un artista para ver todos sus conciertos pasados disponibles en Setlist.fm.'**
  String get tutorialImportSearchDesc;

  /// No description provided for @tutorialImportSelectTitle.
  ///
  /// In es, this message translates to:
  /// **'Selecciona e importa'**
  String get tutorialImportSelectTitle;

  /// No description provided for @tutorialImportSelectDesc.
  ///
  /// In es, this message translates to:
  /// **'Marca los conciertos a los que fuiste y pulsa Importar. La app buscará imagen y género automáticamente.'**
  String get tutorialImportSelectDesc;

  /// No description provided for @tutorialSettingsSection.
  ///
  /// In es, this message translates to:
  /// **'Ayuda'**
  String get tutorialSettingsSection;

  /// No description provided for @tutorialSettingsLabel.
  ///
  /// In es, this message translates to:
  /// **'Guías de uso'**
  String get tutorialSettingsLabel;

  /// No description provided for @tutorialSettingsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Repasa el tutorial de cualquier pantalla'**
  String get tutorialSettingsSubtitle;

  /// No description provided for @tutorialPickerTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Qué quieres repasar?'**
  String get tutorialPickerTitle;

  /// No description provided for @tutorialPickerDashboard.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get tutorialPickerDashboard;

  /// No description provided for @tutorialPickerConcerts.
  ///
  /// In es, this message translates to:
  /// **'Conciertos'**
  String get tutorialPickerConcerts;

  /// No description provided for @tutorialPickerAddConcert.
  ///
  /// In es, this message translates to:
  /// **'Añadir concierto'**
  String get tutorialPickerAddConcert;

  /// No description provided for @tutorialPickerDetail.
  ///
  /// In es, this message translates to:
  /// **'Detalle de concierto'**
  String get tutorialPickerDetail;

  /// No description provided for @tutorialPickerStats.
  ///
  /// In es, this message translates to:
  /// **'Estadísticas'**
  String get tutorialPickerStats;

  /// No description provided for @tutorialPickerProfile.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get tutorialPickerProfile;

  /// No description provided for @tutorialPickerFriends.
  ///
  /// In es, this message translates to:
  /// **'Amigos'**
  String get tutorialPickerFriends;

  /// No description provided for @tutorialPickerFeed.
  ///
  /// In es, this message translates to:
  /// **'Recuerdos'**
  String get tutorialPickerFeed;

  /// No description provided for @tutorialPickerRecs.
  ///
  /// In es, this message translates to:
  /// **'Descubrir'**
  String get tutorialPickerRecs;

  /// No description provided for @tutorialPickerImport.
  ///
  /// In es, this message translates to:
  /// **'Importar'**
  String get tutorialPickerImport;

  /// No description provided for @splashTagline.
  ///
  /// In es, this message translates to:
  /// **'Cada concierto cuenta una historia.'**
  String get splashTagline;

  /// No description provided for @navHome.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get navHome;

  /// No description provided for @navConcerts.
  ///
  /// In es, this message translates to:
  /// **'Conciertos'**
  String get navConcerts;

  /// No description provided for @navMemories.
  ///
  /// In es, this message translates to:
  /// **'Recuerdos'**
  String get navMemories;

  /// No description provided for @navFavorites.
  ///
  /// In es, this message translates to:
  /// **'Favoritos'**
  String get navFavorites;

  /// No description provided for @navStats.
  ///
  /// In es, this message translates to:
  /// **'Stats'**
  String get navStats;

  /// No description provided for @setlistTitle.
  ///
  /// In es, this message translates to:
  /// **'Setlist'**
  String get setlistTitle;

  /// No description provided for @setlistSongCount.
  ///
  /// In es, this message translates to:
  /// **'{count} canciones'**
  String setlistSongCount(int count);

  /// No description provided for @setlistNotFound.
  ///
  /// In es, this message translates to:
  /// **'No se encontró ningún setlist para este concierto.'**
  String get setlistNotFound;

  /// No description provided for @setlistShowLess.
  ///
  /// In es, this message translates to:
  /// **'Ver menos'**
  String get setlistShowLess;

  /// No description provided for @setlistShowRemaining.
  ///
  /// In es, this message translates to:
  /// **'Ver las {count} canciones restantes'**
  String setlistShowRemaining(int count);

  /// No description provided for @setlistCoverOf.
  ///
  /// In es, this message translates to:
  /// **'Versión de {artist}'**
  String setlistCoverOf(String artist);

  /// No description provided for @setlistWith.
  ///
  /// In es, this message translates to:
  /// **'con {artist}'**
  String setlistWith(String artist);

  /// No description provided for @notifMarkAllRead.
  ///
  /// In es, this message translates to:
  /// **'Marcar todo como leído'**
  String get notifMarkAllRead;

  /// No description provided for @notifMemoriesToday.
  ///
  /// In es, this message translates to:
  /// **'Recuerdos de hoy'**
  String get notifMemoriesToday;

  /// No description provided for @notifYearsAgoArtist.
  ///
  /// In es, this message translates to:
  /// **'Hace {years} {years, plural, =1{año} other{años}}: {artist}'**
  String notifYearsAgoArtist(int years, String artist);

  /// No description provided for @notifUpcomingSection.
  ///
  /// In es, this message translates to:
  /// **'Conciertos próximos'**
  String get notifUpcomingSection;

  /// No description provided for @notifTodaySubtitle.
  ///
  /// In es, this message translates to:
  /// **'¡Es hoy! · {venue}, {city}'**
  String notifTodaySubtitle(String venue, String city);

  /// No description provided for @notifTomorrowSubtitle.
  ///
  /// In es, this message translates to:
  /// **'¡Mañana! · {venue}, {city}'**
  String notifTomorrowSubtitle(String venue, String city);

  /// No description provided for @notifDaysSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Faltan {days} días · {venue}, {city}'**
  String notifDaysSubtitle(int days, String venue, String city);

  /// No description provided for @notifRecommendationsSection.
  ///
  /// In es, this message translates to:
  /// **'Recomendaciones'**
  String get notifRecommendationsSection;

  /// No description provided for @notifNoRecsHint.
  ///
  /// In es, this message translates to:
  /// **'Añade conciertos favoritos para recibir recomendaciones.'**
  String get notifNoRecsHint;

  /// No description provided for @notifEmpty.
  ///
  /// In es, this message translates to:
  /// **'Sin notificaciones por ahora.\nAñade conciertos para empezar.'**
  String get notifEmpty;

  /// No description provided for @buyTickets.
  ///
  /// In es, this message translates to:
  /// **'Comprar entradas'**
  String get buyTickets;

  /// No description provided for @appTitleLine1.
  ///
  /// In es, this message translates to:
  /// **'LA VIDA'**
  String get appTitleLine1;

  /// No description provided for @appTitleLine2.
  ///
  /// In es, this message translates to:
  /// **'EN DIRECTO'**
  String get appTitleLine2;

  /// No description provided for @memberNumber.
  ///
  /// In es, this message translates to:
  /// **'MIEMBRO #{number}'**
  String memberNumber(String number);

  /// No description provided for @deleteConcertConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres eliminar \"{name}\"?\nEsta acción no se puede deshacer.'**
  String deleteConcertConfirm(String name);

  /// No description provided for @concertDeleteError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo eliminar: {error}'**
  String concertDeleteError(String error);

  /// No description provided for @artistNotFound.
  ///
  /// In es, this message translates to:
  /// **'No se encontró el artista: {error}'**
  String artistNotFound(String error);

  /// No description provided for @setlistComingSoon.
  ///
  /// In es, this message translates to:
  /// **'El setlist estará disponible\ntras el concierto.'**
  String get setlistComingSoon;

  /// No description provided for @spotifyFollowers.
  ///
  /// In es, this message translates to:
  /// **'{count} seguidores'**
  String spotifyFollowers(String count);

  /// No description provided for @openInSpotify.
  ///
  /// In es, this message translates to:
  /// **'Abrir en Spotify'**
  String get openInSpotify;

  /// No description provided for @participantsAlsoWere.
  ///
  /// In es, this message translates to:
  /// **'También estuvieron'**
  String get participantsAlsoWere;

  /// No description provided for @participantsAlsoGoing.
  ///
  /// In es, this message translates to:
  /// **'También irán'**
  String get participantsAlsoGoing;

  /// No description provided for @artistRequired.
  ///
  /// In es, this message translates to:
  /// **'Introduce el nombre del artista'**
  String get artistRequired;

  /// No description provided for @dateRequired.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una fecha'**
  String get dateRequired;

  /// No description provided for @selectImage.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar imagen'**
  String get selectImage;

  /// No description provided for @ratingTitle.
  ///
  /// In es, this message translates to:
  /// **'Valoración'**
  String get ratingTitle;

  /// No description provided for @ratingNone.
  ///
  /// In es, this message translates to:
  /// **'Sin valorar'**
  String get ratingNone;

  /// No description provided for @ratingStars.
  ///
  /// In es, this message translates to:
  /// **'{rating} de 5 estrellas'**
  String ratingStars(int rating);

  /// No description provided for @howWasItTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Qué te pareció?'**
  String get howWasItTitle;

  /// No description provided for @likedYes.
  ///
  /// In es, this message translates to:
  /// **'Me gusta'**
  String get likedYes;

  /// No description provided for @likedNo.
  ///
  /// In es, this message translates to:
  /// **'¿Te gustó?'**
  String get likedNo;

  /// No description provided for @addedToFavorites.
  ///
  /// In es, this message translates to:
  /// **'Añadido a favoritos'**
  String get addedToFavorites;

  /// No description provided for @markAsFavorite.
  ///
  /// In es, this message translates to:
  /// **'¿Marcar como favorito?'**
  String get markAsFavorite;

  /// No description provided for @savingLabel.
  ///
  /// In es, this message translates to:
  /// **'Guardando...'**
  String get savingLabel;

  /// No description provided for @saveConcert.
  ///
  /// In es, this message translates to:
  /// **'Guardar concierto'**
  String get saveConcert;

  /// No description provided for @saveChanges.
  ///
  /// In es, this message translates to:
  /// **'Guardar cambios'**
  String get saveChanges;

  /// No description provided for @noFriendsYet.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes amigos. Añádelos desde tu perfil.'**
  String get noFriendsYet;

  /// No description provided for @whoElseWas.
  ///
  /// In es, this message translates to:
  /// **'¿Quién más estuvo?'**
  String get whoElseWas;

  /// No description provided for @whoElseGoing.
  ///
  /// In es, this message translates to:
  /// **'¿Quién más irá?'**
  String get whoElseGoing;

  /// No description provided for @splashLoading1.
  ///
  /// In es, this message translates to:
  /// **'🎸 Preparando escenario...'**
  String get splashLoading1;

  /// No description provided for @splashLoading2.
  ///
  /// In es, this message translates to:
  /// **'🔊 Probando sonido...'**
  String get splashLoading2;

  /// No description provided for @splashLoading3.
  ///
  /// In es, this message translates to:
  /// **'💡 Encendiendo las luces...'**
  String get splashLoading3;

  /// No description provided for @splashLoading4.
  ///
  /// In es, this message translates to:
  /// **'🎫 Cargando conciertos...'**
  String get splashLoading4;

  /// No description provided for @splashLoading5.
  ///
  /// In es, this message translates to:
  /// **'📸 Organizando recuerdos...'**
  String get splashLoading5;

  /// No description provided for @splashLoading6.
  ///
  /// In es, this message translates to:
  /// **'🤘 ¡Que empiece el concierto!'**
  String get splashLoading6;

  /// No description provided for @tabPast.
  ///
  /// In es, this message translates to:
  /// **'Pasados'**
  String get tabPast;

  /// No description provided for @tabUpcoming.
  ///
  /// In es, this message translates to:
  /// **'Próximos'**
  String get tabUpcoming;

  /// No description provided for @tabShared.
  ///
  /// In es, this message translates to:
  /// **'Compartidos'**
  String get tabShared;

  /// No description provided for @listViewTooltip.
  ///
  /// In es, this message translates to:
  /// **'Vista lista'**
  String get listViewTooltip;

  /// No description provided for @cardViewTooltip.
  ///
  /// In es, this message translates to:
  /// **'Vista tarjetas'**
  String get cardViewTooltip;

  /// No description provided for @concertDeleted.
  ///
  /// In es, this message translates to:
  /// **'\"{name}\" eliminado'**
  String concertDeleted(String name);

  /// No description provided for @concertDeleteFailed.
  ///
  /// In es, this message translates to:
  /// **'No se pudo eliminar el concierto'**
  String get concertDeleteFailed;

  /// No description provided for @noPastConcerts.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes conciertos pasados.'**
  String get noPastConcerts;

  /// No description provided for @noUpcomingConcertsAdd.
  ///
  /// In es, this message translates to:
  /// **'No tienes conciertos próximos.\n¡Añade uno!'**
  String get noUpcomingConcertsAdd;

  /// No description provided for @noSharedConcerts.
  ///
  /// In es, this message translates to:
  /// **'Ningún amigo ha compartido conciertos contigo todavía.'**
  String get noSharedConcerts;

  /// No description provided for @mapVenueLocation.
  ///
  /// In es, this message translates to:
  /// **'Ubicación del recinto'**
  String get mapVenueLocation;

  /// No description provided for @mapOpenIn.
  ///
  /// In es, this message translates to:
  /// **'Abrir en mapas'**
  String get mapOpenIn;

  /// No description provided for @mapNotAvailable.
  ///
  /// In es, this message translates to:
  /// **'Mapa no disponible'**
  String get mapNotAvailable;

  /// No description provided for @concertMapTitle.
  ///
  /// In es, this message translates to:
  /// **'Mapa de conciertos'**
  String get concertMapTitle;

  /// No description provided for @concertMapDashboardSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Todos tus recintos en un mapa'**
  String get concertMapDashboardSubtitle;

  /// No description provided for @concertMapLoading.
  ///
  /// In es, this message translates to:
  /// **'Localizando recintos…'**
  String get concertMapLoading;

  /// No description provided for @concertMapProgress.
  ///
  /// In es, this message translates to:
  /// **'{done} de {total} recintos'**
  String concertMapProgress(int done, int total);

  /// No description provided for @concertMapNoData.
  ///
  /// In es, this message translates to:
  /// **'Añade conciertos con recinto o ciudad\npara verlos en el mapa.'**
  String get concertMapNoData;

  /// No description provided for @concertMapConcertsHere.
  ///
  /// In es, this message translates to:
  /// **'Conciertos aquí'**
  String get concertMapConcertsHere;

  /// No description provided for @concertMapOpenInMaps.
  ///
  /// In es, this message translates to:
  /// **'Abrir en Maps'**
  String get concertMapOpenInMaps;

  /// No description provided for @profileAvatarUploadError.
  ///
  /// In es, this message translates to:
  /// **'Error al subir la foto: {error}'**
  String profileAvatarUploadError(String error);

  /// No description provided for @fanLevelLegend.
  ///
  /// In es, this message translates to:
  /// **'🤘 LEYENDA DEL DIRECTO'**
  String get fanLevelLegend;

  /// No description provided for @fanLevelHeadliner.
  ///
  /// In es, this message translates to:
  /// **'🥇 HEADLINER'**
  String get fanLevelHeadliner;

  /// No description provided for @fanLevelRoadie.
  ///
  /// In es, this message translates to:
  /// **'🥈 ROADIE'**
  String get fanLevelRoadie;

  /// No description provided for @fanLevelRookie.
  ///
  /// In es, this message translates to:
  /// **'🥉 ROOKIE'**
  String get fanLevelRookie;

  /// No description provided for @fanSinceThisYear.
  ///
  /// In es, this message translates to:
  /// **'Fan desde este año'**
  String get fanSinceThisYear;

  /// No description provided for @fanSinceYear.
  ///
  /// In es, this message translates to:
  /// **'Fan desde {year}'**
  String fanSinceYear(int year);

  /// No description provided for @deleteAccountTitle.
  ///
  /// In es, this message translates to:
  /// **'⚠️ Eliminar cuenta'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In es, this message translates to:
  /// **'Esta acción es irreversible. Se borrarán todos tus conciertos, fotos, amigos y datos de la cuenta.'**
  String get deleteAccountWarning;

  /// No description provided for @continueLabel.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get continueLabel;

  /// No description provided for @confirmPasswordTitle.
  ///
  /// In es, this message translates to:
  /// **'Confirma tu contraseña'**
  String get confirmPasswordTitle;

  /// No description provided for @deleteAccountButton.
  ///
  /// In es, this message translates to:
  /// **'Eliminar cuenta'**
  String get deleteAccountButton;

  /// No description provided for @genericErrorDetail.
  ///
  /// In es, this message translates to:
  /// **'Error: {error}'**
  String genericErrorDetail(String error);

  /// No description provided for @profileAccreditationTitle.
  ///
  /// In es, this message translates to:
  /// **'Tu acreditación'**
  String get profileAccreditationTitle;

  /// No description provided for @profileAccreditationSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Tu historial musical en un vistazo.'**
  String get profileAccreditationSubtitle;

  /// No description provided for @guestLabel.
  ///
  /// In es, this message translates to:
  /// **'Invitado'**
  String get guestLabel;

  /// No description provided for @wrappedCardTitle.
  ///
  /// In es, this message translates to:
  /// **'Tu año en conciertos'**
  String get wrappedCardTitle;

  /// No description provided for @wrappedCardSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Resumen anual · compartible'**
  String get wrappedCardSubtitle;

  /// No description provided for @pastYearsLabel.
  ///
  /// In es, this message translates to:
  /// **'Años anteriores'**
  String get pastYearsLabel;

  /// No description provided for @toolsSectionTitle.
  ///
  /// In es, this message translates to:
  /// **'Herramientas'**
  String get toolsSectionTitle;

  /// No description provided for @appFooterVersion.
  ///
  /// In es, this message translates to:
  /// **'Versión {version}'**
  String appFooterVersion(String version);

  /// No description provided for @uploadingAvatarLabel.
  ///
  /// In es, this message translates to:
  /// **'Subiendo foto...'**
  String get uploadingAvatarLabel;

  /// No description provided for @annualGoalTitle.
  ///
  /// In es, this message translates to:
  /// **'Meta anual de conciertos'**
  String get annualGoalTitle;

  /// No description provided for @annualGoalQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Cuántos conciertos quieres ver este año?'**
  String get annualGoalQuestion;

  /// No description provided for @annualGoalNumberLabel.
  ///
  /// In es, this message translates to:
  /// **'Número de conciertos'**
  String get annualGoalNumberLabel;

  /// No description provided for @removeGoal.
  ///
  /// In es, this message translates to:
  /// **'Quitar meta'**
  String get removeGoal;

  /// No description provided for @changeEmailTitle.
  ///
  /// In es, this message translates to:
  /// **'Cambiar email'**
  String get changeEmailTitle;

  /// No description provided for @newEmailLabel.
  ///
  /// In es, this message translates to:
  /// **'Nuevo email'**
  String get newEmailLabel;

  /// No description provided for @emailUpdated.
  ///
  /// In es, this message translates to:
  /// **'Email actualizado'**
  String get emailUpdated;

  /// No description provided for @noConcertsToExport.
  ///
  /// In es, this message translates to:
  /// **'No hay conciertos para exportar'**
  String get noConcertsToExport;

  /// No description provided for @exportCsvHeader.
  ///
  /// In es, this message translates to:
  /// **'artista,nombre,fecha,recinto,ciudad,festival,género,valoracion,favorito,precio,notas'**
  String get exportCsvHeader;

  /// No description provided for @csvYes.
  ///
  /// In es, this message translates to:
  /// **'sí'**
  String get csvYes;

  /// No description provided for @csvNo.
  ///
  /// In es, this message translates to:
  /// **'no'**
  String get csvNo;

  /// No description provided for @exportShareSubject.
  ///
  /// In es, this message translates to:
  /// **'Mis conciertos — La Vida en Directo'**
  String get exportShareSubject;

  /// No description provided for @exportError.
  ///
  /// In es, this message translates to:
  /// **'Error al exportar: {error}'**
  String exportError(String error);

  /// No description provided for @exportDataTitle.
  ///
  /// In es, this message translates to:
  /// **'Exportar mis datos'**
  String get exportDataTitle;

  /// No description provided for @exportCsvLabel.
  ///
  /// In es, this message translates to:
  /// **'CSV — Excel/Sheets'**
  String get exportCsvLabel;

  /// No description provided for @exportCsvDesc.
  ///
  /// In es, this message translates to:
  /// **'Compatible con cualquier hoja de cálculo'**
  String get exportCsvDesc;

  /// No description provided for @exportJsonLabel.
  ///
  /// In es, this message translates to:
  /// **'JSON — copia de seguridad'**
  String get exportJsonLabel;

  /// No description provided for @exportJsonDesc.
  ///
  /// In es, this message translates to:
  /// **'Formato completo para importar en el futuro'**
  String get exportJsonDesc;

  /// No description provided for @noUpcomingConcertsToSync.
  ///
  /// In es, this message translates to:
  /// **'No tienes conciertos próximos para añadir'**
  String get noUpcomingConcertsToSync;

  /// No description provided for @calendarNoEventsAdded.
  ///
  /// In es, this message translates to:
  /// **'No se pudo añadir ningún evento'**
  String get calendarNoEventsAdded;

  /// No description provided for @calendarEventsAdded.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 concierto añadido al calendario} other{{count} conciertos añadidos al calendario}}'**
  String calendarEventsAdded(int count);

  /// No description provided for @cacheCleared.
  ///
  /// In es, this message translates to:
  /// **'Caché de imágenes limpiada'**
  String get cacheCleared;

  /// No description provided for @themeSystemDefault.
  ///
  /// In es, this message translates to:
  /// **'Por defecto del sistema'**
  String get themeSystemDefault;

  /// No description provided for @themeDark.
  ///
  /// In es, this message translates to:
  /// **'Oscuro'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In es, this message translates to:
  /// **'Claro'**
  String get themeLight;

  /// No description provided for @emailLabel.
  ///
  /// In es, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @friendActivityNotifTitle.
  ///
  /// In es, this message translates to:
  /// **'Actividad de amigos'**
  String get friendActivityNotifTitle;

  /// No description provided for @friendActivityNotifDesc.
  ///
  /// In es, this message translates to:
  /// **'Cuando un amigo añade un concierto'**
  String get friendActivityNotifDesc;

  /// No description provided for @recommendationsNotifTitle.
  ///
  /// In es, this message translates to:
  /// **'Recomendaciones'**
  String get recommendationsNotifTitle;

  /// No description provided for @recommendationsNotifDesc.
  ///
  /// In es, this message translates to:
  /// **'Conciertos sugeridos basados en tus gustos'**
  String get recommendationsNotifDesc;

  /// No description provided for @colorPaletteLabel.
  ///
  /// In es, this message translates to:
  /// **'Paleta de color'**
  String get colorPaletteLabel;

  /// No description provided for @splashSoundLabel.
  ///
  /// In es, this message translates to:
  /// **'Sonido de inicio'**
  String get splashSoundLabel;

  /// No description provided for @splashSoundDesc.
  ///
  /// In es, this message translates to:
  /// **'Ambiente de público al abrir la app'**
  String get splashSoundDesc;

  /// No description provided for @myDataSectionTitle.
  ///
  /// In es, this message translates to:
  /// **'Mis datos'**
  String get myDataSectionTitle;

  /// No description provided for @annualGoalSubtitleSet.
  ///
  /// In es, this message translates to:
  /// **'Este año: {count} conciertos'**
  String annualGoalSubtitleSet(int count);

  /// No description provided for @annualGoalSubtitleUnset.
  ///
  /// In es, this message translates to:
  /// **'Sin meta configurada'**
  String get annualGoalSubtitleUnset;

  /// No description provided for @exportConcertsLabel.
  ///
  /// In es, this message translates to:
  /// **'Exportar mis conciertos'**
  String get exportConcertsLabel;

  /// No description provided for @exportConcertsDesc.
  ///
  /// In es, this message translates to:
  /// **'CSV o JSON — ábrelo en Excel o guárdalo'**
  String get exportConcertsDesc;

  /// No description provided for @syncCalendarLabel.
  ///
  /// In es, this message translates to:
  /// **'Sincronizar con el calendario'**
  String get syncCalendarLabel;

  /// No description provided for @syncCalendarDesc.
  ///
  /// In es, this message translates to:
  /// **'Añade tus próximos conciertos al calendario del móvil'**
  String get syncCalendarDesc;

  /// No description provided for @clearCacheLabel.
  ///
  /// In es, this message translates to:
  /// **'Limpiar caché de imágenes'**
  String get clearCacheLabel;

  /// No description provided for @clearCacheDesc.
  ///
  /// In es, this message translates to:
  /// **'Libera espacio del almacenamiento'**
  String get clearCacheDesc;

  /// No description provided for @supportSectionTitle.
  ///
  /// In es, this message translates to:
  /// **'Soporte'**
  String get supportSectionTitle;

  /// No description provided for @reportIssueLabel.
  ///
  /// In es, this message translates to:
  /// **'Reportar incidencia'**
  String get reportIssueLabel;

  /// No description provided for @reportIssueDesc.
  ///
  /// In es, this message translates to:
  /// **'Envía un bug, sugerencia o comentario'**
  String get reportIssueDesc;

  /// No description provided for @jiraNotConfigured.
  ///
  /// In es, this message translates to:
  /// **'Integración Jira no configurada — rellena el .env'**
  String get jiraNotConfigured;

  /// No description provided for @exportingDialogTitle.
  ///
  /// In es, this message translates to:
  /// **'Preparando exportación…'**
  String get exportingDialogTitle;

  /// No description provided for @exportingDialogSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Cargando fotos de cada concierto'**
  String get exportingDialogSubtitle;

  /// No description provided for @proBadgeLabel.
  ///
  /// In es, this message translates to:
  /// **'Pro'**
  String get proBadgeLabel;

  /// No description provided for @mailtoSubject.
  ///
  /// In es, this message translates to:
  /// **'La Vida en Directo - Contacto'**
  String get mailtoSubject;

  /// No description provided for @emailClientError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo abrir el cliente de correo'**
  String get emailClientError;

  /// No description provided for @privacyPolicyBody.
  ///
  /// In es, this message translates to:
  /// **'La Vida en Directo recoge únicamente los datos necesarios para el funcionamiento de la aplicación: nombre, correo electrónico y los conciertos que añades.\n\nTus datos se almacenan de forma segura y nunca se comparten con terceros ni se usan con fines publicitarios.\n\nPuedes eliminar tu cuenta y todos tus datos en cualquier momento desde la app o contactando con nosotros.'**
  String get privacyPolicyBody;

  /// No description provided for @creditsDevelopedBy.
  ///
  /// In es, this message translates to:
  /// **'Desarrollado con ❤️ por Nico'**
  String get creditsDevelopedBy;

  /// No description provided for @creditFrontend.
  ///
  /// In es, this message translates to:
  /// **'Frontend móvil'**
  String get creditFrontend;

  /// No description provided for @creditBackend.
  ///
  /// In es, this message translates to:
  /// **'Backend API'**
  String get creditBackend;

  /// No description provided for @creditDatabase.
  ///
  /// In es, this message translates to:
  /// **'Base de datos'**
  String get creditDatabase;

  /// No description provided for @creditImageStorage.
  ///
  /// In es, this message translates to:
  /// **'Almacenamiento de imágenes'**
  String get creditImageStorage;

  /// No description provided for @creditSetlistData.
  ///
  /// In es, this message translates to:
  /// **'Datos de setlists'**
  String get creditSetlistData;

  /// No description provided for @creditArtistData.
  ///
  /// In es, this message translates to:
  /// **'Datos de artistas'**
  String get creditArtistData;

  /// No description provided for @creditRecommendedEvents.
  ///
  /// In es, this message translates to:
  /// **'Eventos recomendados'**
  String get creditRecommendedEvents;

  /// No description provided for @aboutFooterTagline.
  ///
  /// In es, this message translates to:
  /// **'Hecho con ❤️ para los que viven la música en directo.'**
  String get aboutFooterTagline;

  /// No description provided for @reportIssueIntroTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Algo no funciona como esperabas?'**
  String get reportIssueIntroTitle;

  /// No description provided for @reportIssueIntroDesc.
  ///
  /// In es, this message translates to:
  /// **'Cuéntanos qué ha pasado y lo revisaremos lo antes posible.'**
  String get reportIssueIntroDesc;

  /// No description provided for @typeLabel.
  ///
  /// In es, this message translates to:
  /// **'Tipo'**
  String get typeLabel;

  /// No description provided for @titleLabel.
  ///
  /// In es, this message translates to:
  /// **'Título'**
  String get titleLabel;

  /// No description provided for @titleHint.
  ///
  /// In es, this message translates to:
  /// **'Resumen breve del problema…'**
  String get titleHint;

  /// No description provided for @titleRequiredError.
  ///
  /// In es, this message translates to:
  /// **'Escribe un título para el ticket'**
  String get titleRequiredError;

  /// No description provided for @descriptionLabel.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get descriptionLabel;

  /// No description provided for @descBugHint.
  ///
  /// In es, this message translates to:
  /// **'Describe el problema: qué hiciste, qué esperabas y qué pasó…'**
  String get descBugHint;

  /// No description provided for @descImprovementHint.
  ///
  /// In es, this message translates to:
  /// **'Explica la mejora que te gustaría ver…'**
  String get descImprovementHint;

  /// No description provided for @descOtherHint.
  ///
  /// In es, this message translates to:
  /// **'Escribe tu comentario o sugerencia…'**
  String get descOtherHint;

  /// No description provided for @descRequiredError.
  ///
  /// In es, this message translates to:
  /// **'Escribe una descripción antes de enviar'**
  String get descRequiredError;

  /// No description provided for @descTooShortError.
  ///
  /// In es, this message translates to:
  /// **'La descripción es demasiado corta'**
  String get descTooShortError;

  /// No description provided for @autoInfoNote.
  ///
  /// In es, this message translates to:
  /// **'Se incluirá automáticamente la versión de la app, plataforma y tu email para poder contactarte si hace falta.'**
  String get autoInfoNote;

  /// No description provided for @issueSentTitle.
  ///
  /// In es, this message translates to:
  /// **'¡Incidencia enviada! 🎉'**
  String get issueSentTitle;

  /// No description provided for @ticketCreatedLabel.
  ///
  /// In es, this message translates to:
  /// **'Ticket creado: {key}'**
  String ticketCreatedLabel(String key);

  /// No description provided for @sendingLabel.
  ///
  /// In es, this message translates to:
  /// **'Enviando…'**
  String get sendingLabel;

  /// No description provided for @sendIssueButton.
  ///
  /// In es, this message translates to:
  /// **'Enviar incidencia'**
  String get sendIssueButton;

  /// No description provided for @issueTypeBug.
  ///
  /// In es, this message translates to:
  /// **'🐛 Bug'**
  String get issueTypeBug;

  /// No description provided for @issueTypeImprovement.
  ///
  /// In es, this message translates to:
  /// **'✨ Mejora'**
  String get issueTypeImprovement;

  /// No description provided for @issueTypeOther.
  ///
  /// In es, this message translates to:
  /// **'💬 Otro'**
  String get issueTypeOther;

  /// No description provided for @achievementsSectionTitle.
  ///
  /// In es, this message translates to:
  /// **'LOGROS'**
  String get achievementsSectionTitle;

  /// No description provided for @achievementsSeeMoreCount.
  ///
  /// In es, this message translates to:
  /// **'Ver todos los logros ({count} más)'**
  String achievementsSeeMoreCount(int count);

  /// No description provided for @achievementLocked.
  ///
  /// In es, this message translates to:
  /// **'Bloqueado'**
  String get achievementLocked;

  /// No description provided for @achievementUnlocked.
  ///
  /// In es, this message translates to:
  /// **'¡Desbloqueado!'**
  String get achievementUnlocked;

  /// No description provided for @achievementUnlockedBanner.
  ///
  /// In es, this message translates to:
  /// **'🏆 Logro desbloqueado'**
  String get achievementUnlockedBanner;

  /// No description provided for @topArtistsTitle.
  ///
  /// In es, this message translates to:
  /// **'Mis artistas'**
  String get topArtistsTitle;

  /// No description provided for @topArtistsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Por conciertos y valoración'**
  String get topArtistsSubtitle;

  /// No description provided for @achvFirstConcertTitle.
  ///
  /// In es, this message translates to:
  /// **'Primer directo'**
  String get achvFirstConcertTitle;

  /// No description provided for @achvFirstConcertDesc.
  ///
  /// In es, this message translates to:
  /// **'Asiste a tu primer concierto'**
  String get achvFirstConcertDesc;

  /// No description provided for @achvFiveConcertsTitle.
  ///
  /// In es, this message translates to:
  /// **'Habitual'**
  String get achvFiveConcertsTitle;

  /// No description provided for @achvFiveConcertsDesc.
  ///
  /// In es, this message translates to:
  /// **'5 conciertos en el cuerpo'**
  String get achvFiveConcertsDesc;

  /// No description provided for @achvTwentyFiveTitle.
  ///
  /// In es, this message translates to:
  /// **'Veterano'**
  String get achvTwentyFiveTitle;

  /// No description provided for @achvTwentyFiveDesc.
  ///
  /// In es, this message translates to:
  /// **'25 conciertos no es para cualquiera'**
  String get achvTwentyFiveDesc;

  /// No description provided for @achvFiftyConcertsTitle.
  ///
  /// In es, this message translates to:
  /// **'Experto'**
  String get achvFiftyConcertsTitle;

  /// No description provided for @achvFiftyConcertsDesc.
  ///
  /// In es, this message translates to:
  /// **'50 conciertos. Ya lo has visto todo'**
  String get achvFiftyConcertsDesc;

  /// No description provided for @achvHundredConcertsTitle.
  ///
  /// In es, this message translates to:
  /// **'Leyenda'**
  String get achvHundredConcertsTitle;

  /// No description provided for @achvHundredConcertsDesc.
  ///
  /// In es, this message translates to:
  /// **'100 conciertos. Eres una leyenda del directo'**
  String get achvHundredConcertsDesc;

  /// No description provided for @achvTwoHundredTitle.
  ///
  /// In es, this message translates to:
  /// **'Inmortal'**
  String get achvTwoHundredTitle;

  /// No description provided for @achvTwoHundredDesc.
  ///
  /// In es, this message translates to:
  /// **'200 conciertos. A otro nivel'**
  String get achvTwoHundredDesc;

  /// No description provided for @achvRockeroTitle.
  ///
  /// In es, this message translates to:
  /// **'Rockero'**
  String get achvRockeroTitle;

  /// No description provided for @achvRockeroDesc.
  ///
  /// In es, this message translates to:
  /// **'3 conciertos de rock'**
  String get achvRockeroDesc;

  /// No description provided for @achvRockeroProTitle.
  ///
  /// In es, this message translates to:
  /// **'Rock Puro'**
  String get achvRockeroProTitle;

  /// No description provided for @achvRockeroProDesc.
  ///
  /// In es, this message translates to:
  /// **'10 conciertos de rock'**
  String get achvRockeroProDesc;

  /// No description provided for @achvMetaleroTitle.
  ///
  /// In es, this message translates to:
  /// **'Metalero'**
  String get achvMetaleroTitle;

  /// No description provided for @achvMetaleroDesc.
  ///
  /// In es, this message translates to:
  /// **'3 conciertos de metal o heavy'**
  String get achvMetaleroDesc;

  /// No description provided for @achvUrbanoTitle.
  ///
  /// In es, this message translates to:
  /// **'Urbano'**
  String get achvUrbanoTitle;

  /// No description provided for @achvUrbanoDesc.
  ///
  /// In es, this message translates to:
  /// **'3 conciertos de hip-hop, rap o trap'**
  String get achvUrbanoDesc;

  /// No description provided for @achvFirstFestivalTitle.
  ///
  /// In es, this message translates to:
  /// **'Festivalero'**
  String get achvFirstFestivalTitle;

  /// No description provided for @achvFirstFestivalDesc.
  ///
  /// In es, this message translates to:
  /// **'Tu primer festival'**
  String get achvFirstFestivalDesc;

  /// No description provided for @achvFiveFestivalsTitle.
  ///
  /// In es, this message translates to:
  /// **'Festival Addict'**
  String get achvFiveFestivalsTitle;

  /// No description provided for @achvFiveFestivalsDesc.
  ///
  /// In es, this message translates to:
  /// **'5 festivales distintos'**
  String get achvFiveFestivalsDesc;

  /// No description provided for @achvTenFestivalsTitle.
  ///
  /// In es, this message translates to:
  /// **'Rey del Festival'**
  String get achvTenFestivalsTitle;

  /// No description provided for @achvTenFestivalsDesc.
  ///
  /// In es, this message translates to:
  /// **'10 festivales distintos'**
  String get achvTenFestivalsDesc;

  /// No description provided for @achvEclecticoTitle.
  ///
  /// In es, this message translates to:
  /// **'Ecléctico'**
  String get achvEclecticoTitle;

  /// No description provided for @achvEclecticoDesc.
  ///
  /// In es, this message translates to:
  /// **'10 artistas distintos'**
  String get achvEclecticoDesc;

  /// No description provided for @achvExploradorTitle.
  ///
  /// In es, this message translates to:
  /// **'Explorador'**
  String get achvExploradorTitle;

  /// No description provided for @achvExploradorDesc.
  ///
  /// In es, this message translates to:
  /// **'25 artistas distintos'**
  String get achvExploradorDesc;

  /// No description provided for @achvColeccionistaTitle.
  ///
  /// In es, this message translates to:
  /// **'Coleccionista'**
  String get achvColeccionistaTitle;

  /// No description provided for @achvColeccionistaDesc.
  ///
  /// In es, this message translates to:
  /// **'50 artistas distintos'**
  String get achvColeccionistaDesc;

  /// No description provided for @achvSuperfanTitle.
  ///
  /// In es, this message translates to:
  /// **'Superfan'**
  String get achvSuperfanTitle;

  /// No description provided for @achvSuperfanDesc.
  ///
  /// In es, this message translates to:
  /// **'Viste al mismo artista 3 veces'**
  String get achvSuperfanDesc;

  /// No description provided for @achvObsesionadoTitle.
  ///
  /// In es, this message translates to:
  /// **'Obsesionado'**
  String get achvObsesionadoTitle;

  /// No description provided for @achvObsesionadoDesc.
  ///
  /// In es, this message translates to:
  /// **'Viste al mismo artista 5 veces'**
  String get achvObsesionadoDesc;

  /// No description provided for @achvViajeroTitle.
  ///
  /// In es, this message translates to:
  /// **'Viajero'**
  String get achvViajeroTitle;

  /// No description provided for @achvViajeroDesc.
  ///
  /// In es, this message translates to:
  /// **'Conciertos en 3 ciudades distintas'**
  String get achvViajeroDesc;

  /// No description provided for @achvTuristaTitle.
  ///
  /// In es, this message translates to:
  /// **'Turista Musical'**
  String get achvTuristaTitle;

  /// No description provided for @achvTuristaDesc.
  ///
  /// In es, this message translates to:
  /// **'Conciertos en 10 ciudades distintas'**
  String get achvTuristaDesc;

  /// No description provided for @achvCriticoTitle.
  ///
  /// In es, this message translates to:
  /// **'Crítico'**
  String get achvCriticoTitle;

  /// No description provided for @achvCriticoDesc.
  ///
  /// In es, this message translates to:
  /// **'Valora tu primer concierto'**
  String get achvCriticoDesc;

  /// No description provided for @achvGranCriticoTitle.
  ///
  /// In es, this message translates to:
  /// **'Gran Crítico'**
  String get achvGranCriticoTitle;

  /// No description provided for @achvGranCriticoDesc.
  ///
  /// In es, this message translates to:
  /// **'Valora 10 conciertos'**
  String get achvGranCriticoDesc;

  /// No description provided for @achvAnaliticoTitle.
  ///
  /// In es, this message translates to:
  /// **'Analítico'**
  String get achvAnaliticoTitle;

  /// No description provided for @achvAnaliticoDesc.
  ///
  /// In es, this message translates to:
  /// **'Valora 25 conciertos'**
  String get achvAnaliticoDesc;

  /// No description provided for @achvPerfeccionistaTitle.
  ///
  /// In es, this message translates to:
  /// **'Perfeccionista'**
  String get achvPerfeccionistaTitle;

  /// No description provided for @achvPerfeccionistaDesc.
  ///
  /// In es, this message translates to:
  /// **'Da 5 estrellas a un concierto'**
  String get achvPerfeccionistaDesc;

  /// No description provided for @achvApasionadoTitle.
  ///
  /// In es, this message translates to:
  /// **'Apasionado'**
  String get achvApasionadoTitle;

  /// No description provided for @achvApasionadoDesc.
  ///
  /// In es, this message translates to:
  /// **'10 conciertos en favoritos'**
  String get achvApasionadoDesc;

  /// No description provided for @achvManirotoTitle.
  ///
  /// In es, this message translates to:
  /// **'Maniroto'**
  String get achvManirotoTitle;

  /// No description provided for @achvManirotoDesc.
  ///
  /// In es, this message translates to:
  /// **'Más de 500 € gastados en entradas'**
  String get achvManirotoDesc;

  /// No description provided for @achvHistoricoTitle.
  ///
  /// In es, this message translates to:
  /// **'Fan Histórico'**
  String get achvHistoricoTitle;

  /// No description provided for @achvHistoricoDesc.
  ///
  /// In es, this message translates to:
  /// **'Llevas más de 5 años yendo a conciertos'**
  String get achvHistoricoDesc;

  /// No description provided for @achvDecadaTitle.
  ///
  /// In es, this message translates to:
  /// **'Una Década'**
  String get achvDecadaTitle;

  /// No description provided for @achvDecadaDesc.
  ///
  /// In es, this message translates to:
  /// **'Más de 10 años en la brecha'**
  String get achvDecadaDesc;

  /// No description provided for @compareStatsButton.
  ///
  /// In es, this message translates to:
  /// **'Comparar estadísticas'**
  String get compareStatsButton;

  /// No description provided for @friendUpcomingTitle.
  ///
  /// In es, this message translates to:
  /// **'PRÓXIMOS CONCIERTOS DE {name}'**
  String friendUpcomingTitle(String name);

  /// No description provided for @friendNoUpcoming.
  ///
  /// In es, this message translates to:
  /// **'No tiene conciertos próximos'**
  String get friendNoUpcoming;

  /// No description provided for @upcomingTogetherTitle.
  ///
  /// In es, this message translates to:
  /// **'PRÓXIMOS CONCIERTOS JUNTOS'**
  String get upcomingTogetherTitle;

  /// No description provided for @numbersTogetherTitle.
  ///
  /// In es, this message translates to:
  /// **'NÚMEROS JUNTOS'**
  String get numbersTogetherTitle;

  /// No description provided for @emptySharedLine1.
  ///
  /// In es, this message translates to:
  /// **'Aún no habéis ido a ningún\nconcierto juntos.'**
  String get emptySharedLine1;

  /// No description provided for @emptySharedLine2.
  ///
  /// In es, this message translates to:
  /// **'¡Etiquetad vuestros próximos directos!'**
  String get emptySharedLine2;

  /// No description provided for @youLabel.
  ///
  /// In es, this message translates to:
  /// **'Tú'**
  String get youLabel;

  /// No description provided for @compareStatsAppBarTitle.
  ///
  /// In es, this message translates to:
  /// **'{me} vs {friend}'**
  String compareStatsAppBarTitle(String me, String friend);

  /// No description provided for @commonArtistsTitle.
  ///
  /// In es, this message translates to:
  /// **'ARTISTAS EN COMÚN'**
  String get commonArtistsTitle;

  /// No description provided for @onlyYouSawTitle.
  ///
  /// In es, this message translates to:
  /// **'SOLO TÚ HAS VISTO'**
  String get onlyYouSawTitle;

  /// No description provided for @onlyFriendSawTitle.
  ///
  /// In es, this message translates to:
  /// **'SOLO {name} HA VISTO'**
  String onlyFriendSawTitle(String name);

  /// No description provided for @vsLabel.
  ///
  /// In es, this message translates to:
  /// **'VS'**
  String get vsLabel;

  /// No description provided for @compareTotalConcertsLabel.
  ///
  /// In es, this message translates to:
  /// **'Total conciertos'**
  String get compareTotalConcertsLabel;

  /// No description provided for @compareUniqueArtistsLabel.
  ///
  /// In es, this message translates to:
  /// **'Artistas únicos'**
  String get compareUniqueArtistsLabel;

  /// No description provided for @compareAvgRatingLabel.
  ///
  /// In es, this message translates to:
  /// **'Media rating'**
  String get compareAvgRatingLabel;

  /// No description provided for @compareThisYearLabel.
  ///
  /// In es, this message translates to:
  /// **'Este año'**
  String get compareThisYearLabel;

  /// No description provided for @compareTopArtistLabel.
  ///
  /// In es, this message translates to:
  /// **'Artista top'**
  String get compareTopArtistLabel;

  /// No description provided for @tutorialSkip.
  ///
  /// In es, this message translates to:
  /// **'Saltar'**
  String get tutorialSkip;

  /// No description provided for @tutorialNext.
  ///
  /// In es, this message translates to:
  /// **'Siguiente'**
  String get tutorialNext;

  /// No description provided for @tutorialStart.
  ///
  /// In es, this message translates to:
  /// **'¡Empezar! 🎸'**
  String get tutorialStart;

  /// No description provided for @tutorialStepsCount.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 paso} other{{count} pasos}}'**
  String tutorialStepsCount(int count);

  /// No description provided for @tutEntryDashboard.
  ///
  /// In es, this message translates to:
  /// **'Inicio / Dashboard'**
  String get tutEntryDashboard;

  /// No description provided for @tutEntryConcerts.
  ///
  /// In es, this message translates to:
  /// **'Mis conciertos'**
  String get tutEntryConcerts;

  /// No description provided for @tutEntryAddConcert.
  ///
  /// In es, this message translates to:
  /// **'Añadir / Editar concierto'**
  String get tutEntryAddConcert;

  /// No description provided for @tutEntryDetail.
  ///
  /// In es, this message translates to:
  /// **'Detalle de concierto'**
  String get tutEntryDetail;

  /// No description provided for @tutEntryStats.
  ///
  /// In es, this message translates to:
  /// **'Estadísticas'**
  String get tutEntryStats;

  /// No description provided for @tutEntryProfile.
  ///
  /// In es, this message translates to:
  /// **'Mi perfil'**
  String get tutEntryProfile;

  /// No description provided for @tutEntryFriends.
  ///
  /// In es, this message translates to:
  /// **'Amigos'**
  String get tutEntryFriends;

  /// No description provided for @tutEntryFeed.
  ///
  /// In es, this message translates to:
  /// **'Feed de actividad'**
  String get tutEntryFeed;

  /// No description provided for @tutEntryRecs.
  ///
  /// In es, this message translates to:
  /// **'Recomendaciones'**
  String get tutEntryRecs;

  /// No description provided for @tutEntryImport.
  ///
  /// In es, this message translates to:
  /// **'Importar conciertos'**
  String get tutEntryImport;

  /// No description provided for @tutDash1Title.
  ///
  /// In es, this message translates to:
  /// **'¡Bienvenido a La Vida en Directo!'**
  String get tutDash1Title;

  /// No description provided for @tutDash1Desc.
  ///
  /// In es, this message translates to:
  /// **'Tu diario musical personal. El dashboard te muestra de un vistazo tus próximos conciertos, estadísticas clave, actividad de amigos y mucho más.'**
  String get tutDash1Desc;

  /// No description provided for @tutDash2Title.
  ///
  /// In es, this message translates to:
  /// **'Añade un concierto'**
  String get tutDash2Title;

  /// No description provided for @tutDash2Desc.
  ///
  /// In es, this message translates to:
  /// **'Toca el botón + en cualquier momento para registrar un concierto: artista, recinto, fecha, precio, foto y valoración detallada por criterios.'**
  String get tutDash2Desc;

  /// No description provided for @tutDash3Title.
  ///
  /// In es, this message translates to:
  /// **'Por valorar'**
  String get tutDash3Title;

  /// No description provided for @tutDash3Desc.
  ///
  /// In es, this message translates to:
  /// **'El widget \"Por valorar\" lista los conciertos pasados que todavía no tienen puntuación. Desliza entre ellos y toca uno para valorarlo en 5 criterios.'**
  String get tutDash3Desc;

  /// No description provided for @tutDash4Title.
  ///
  /// In es, this message translates to:
  /// **'Conciertos recomendados'**
  String get tutDash4Title;

  /// No description provided for @tutDash4Desc.
  ///
  /// In es, this message translates to:
  /// **'Descubre eventos próximos cerca de ti basados en tus artistas. Toca uno para ver todos sus detalles.'**
  String get tutDash4Desc;

  /// No description provided for @tutDash5Title.
  ///
  /// In es, this message translates to:
  /// **'Personalizar el dashboard'**
  String get tutDash5Title;

  /// No description provided for @tutDash5Desc.
  ///
  /// In es, this message translates to:
  /// **'Reorganiza, muestra u oculta los widgets del dashboard pulsando el icono de edición junto al saludo.'**
  String get tutDash5Desc;

  /// No description provided for @tutAdd1Title.
  ///
  /// In es, this message translates to:
  /// **'Registra el concierto'**
  String get tutAdd1Title;

  /// No description provided for @tutAdd1Desc.
  ///
  /// In es, this message translates to:
  /// **'Completa artista, recinto, ciudad, fecha y precio. El género musical se sugiere automáticamente desde Spotify al escribir el nombre del artista.'**
  String get tutAdd1Desc;

  /// No description provided for @tutAdd2Title.
  ///
  /// In es, this message translates to:
  /// **'Foto del concierto'**
  String get tutAdd2Title;

  /// No description provided for @tutAdd2Desc.
  ///
  /// In es, this message translates to:
  /// **'Añade una foto desde tu galería para darle vida al recuerdo. Puedes cambiarla o eliminarla más adelante desde la pantalla de edición.'**
  String get tutAdd2Desc;

  /// No description provided for @tutAdd3Title.
  ///
  /// In es, this message translates to:
  /// **'Valoración por criterios'**
  String get tutAdd3Title;

  /// No description provided for @tutAdd3Desc.
  ///
  /// In es, this message translates to:
  /// **'Valora 5 criterios con estrellas: Artista, Sonido, Ambiente, Setlist y Precio/valor. La puntuación general se calcula automáticamente como la media.'**
  String get tutAdd3Desc;

  /// No description provided for @tutAdd4Title.
  ///
  /// In es, this message translates to:
  /// **'Nota calculada automáticamente'**
  String get tutAdd4Title;

  /// No description provided for @tutAdd4Desc.
  ///
  /// In es, this message translates to:
  /// **'No hay puntuación manual: la nota que aparece en tu historial y estadísticas es siempre la media de tus 5 criterios. Más justa y más detallada.'**
  String get tutAdd4Desc;

  /// No description provided for @tutAdd5Title.
  ///
  /// In es, this message translates to:
  /// **'Festival o concierto individual'**
  String get tutAdd5Title;

  /// No description provided for @tutAdd5Desc.
  ///
  /// In es, this message translates to:
  /// **'Indica si fue un festival para que tus estadísticas distingan entre ambos formatos y puedas ver el reparto en la sección \"Festival vs. individual\".'**
  String get tutAdd5Desc;

  /// No description provided for @tutAdd6Title.
  ///
  /// In es, this message translates to:
  /// **'Etiquetar amigos'**
  String get tutAdd6Title;

  /// No description provided for @tutAdd6Desc.
  ///
  /// In es, this message translates to:
  /// **'¿Fuiste acompañado? Etiqueta a tus amigos para que el concierto aparezca también en su historial compartido y puedan verlo desde su perfil.'**
  String get tutAdd6Desc;

  /// No description provided for @tutDetail1Title.
  ///
  /// In es, this message translates to:
  /// **'Todo sobre el concierto'**
  String get tutDetail1Title;

  /// No description provided for @tutDetail1Desc.
  ///
  /// In es, this message translates to:
  /// **'Aquí ves la info completa: fecha, recinto, ciudad, precio, foto, tus notas personales y la valoración detallada por criterios con barras de progreso.'**
  String get tutDetail1Desc;

  /// No description provided for @tutDetail2Title.
  ///
  /// In es, this message translates to:
  /// **'Valoración detallada'**
  String get tutDetail2Title;

  /// No description provided for @tutDetail2Desc.
  ///
  /// In es, this message translates to:
  /// **'Si puntuaste el concierto, se muestra una tarjeta con la nota de cada criterio: Artista, Sonido, Ambiente, Setlist y Precio/valor, además de la media.'**
  String get tutDetail2Desc;

  /// No description provided for @tutDetail3Title.
  ///
  /// In es, this message translates to:
  /// **'Editar en cualquier momento'**
  String get tutDetail3Title;

  /// No description provided for @tutDetail3Desc.
  ///
  /// In es, this message translates to:
  /// **'Toca el botón de edición (lápiz) para cambiar cualquier dato, añadir o modificar las valoraciones, la foto o las notas cuando quieras.'**
  String get tutDetail3Desc;

  /// No description provided for @tutDetail4Title.
  ///
  /// In es, this message translates to:
  /// **'Setlist automático'**
  String get tutDetail4Title;

  /// No description provided for @tutDetail4Desc.
  ///
  /// In es, this message translates to:
  /// **'La app busca el setlist real del concierto en Setlist.fm para que puedas revivir canción por canción lo que tocaron esa noche.'**
  String get tutDetail4Desc;

  /// No description provided for @tutDetail5Title.
  ///
  /// In es, this message translates to:
  /// **'Artista en Spotify'**
  String get tutDetail5Title;

  /// No description provided for @tutDetail5Desc.
  ///
  /// In es, this message translates to:
  /// **'Se vincula automáticamente el artista en Spotify: foto, géneros, seguidores y las canciones más populares con su popularidad y duración.'**
  String get tutDetail5Desc;

  /// No description provided for @tutDetail6Title.
  ///
  /// In es, this message translates to:
  /// **'Fotos y recuerdos'**
  String get tutDetail6Title;

  /// No description provided for @tutDetail6Desc.
  ///
  /// In es, this message translates to:
  /// **'Añade fotos del concierto y etiqueta a las personas que estuvieron. Quedan guardadas en tu galería personal de recuerdos.'**
  String get tutDetail6Desc;

  /// No description provided for @tutDetail7Title.
  ///
  /// In es, this message translates to:
  /// **'Recinto y ubicación'**
  String get tutDetail7Title;

  /// No description provided for @tutDetail7Desc.
  ///
  /// In es, this message translates to:
  /// **'Toca el nombre del recinto para ver todos los conciertos que tienes registrados en ese mismo lugar y explorar su ubicación en el mapa.'**
  String get tutDetail7Desc;

  /// No description provided for @tutDetail8Title.
  ///
  /// In es, this message translates to:
  /// **'Comentarios'**
  String get tutDetail8Title;

  /// No description provided for @tutDetail8Desc.
  ///
  /// In es, this message translates to:
  /// **'Tus amigos pueden comentar el concierto si los etiquetaste. Abre la sección de comentarios para ver o continuar la conversación.'**
  String get tutDetail8Desc;

  /// No description provided for @tutDetail9Title.
  ///
  /// In es, this message translates to:
  /// **'Guarda tu entrada'**
  String get tutDetail9Title;

  /// No description provided for @tutDetail9Desc.
  ///
  /// In es, this message translates to:
  /// **'Sube una foto o PDF de tu entrada para tenerla siempre a mano. Se guarda solo en tu dispositivo: nunca se sube a ningún servidor.'**
  String get tutDetail9Desc;

  /// No description provided for @tutConcerts1Title.
  ///
  /// In es, this message translates to:
  /// **'Tu historial musical'**
  String get tutConcerts1Title;

  /// No description provided for @tutConcerts1Desc.
  ///
  /// In es, this message translates to:
  /// **'Todos tus conciertos en un solo lugar. Los pasados muestran la valoración media de sus criterios; los futuros se marcan como \"próximos\".'**
  String get tutConcerts1Desc;

  /// No description provided for @tutConcerts2Title.
  ///
  /// In es, this message translates to:
  /// **'Valoración visible'**
  String get tutConcerts2Title;

  /// No description provided for @tutConcerts2Desc.
  ///
  /// In es, this message translates to:
  /// **'Cada concierto pasado muestra su nota calculada (media de criterios) o \"Sin valorar\" si todavía no lo has puntuado. Tócalo para valorarlo.'**
  String get tutConcerts2Desc;

  /// No description provided for @tutConcerts3Title.
  ///
  /// In es, this message translates to:
  /// **'Tres vistas disponibles'**
  String get tutConcerts3Title;

  /// No description provided for @tutConcerts3Desc.
  ///
  /// In es, this message translates to:
  /// **'Cambia entre vista de lista, cuadrícula compacta o calendario según cómo prefieras explorar tu historial.'**
  String get tutConcerts3Desc;

  /// No description provided for @tutConcerts4Title.
  ///
  /// In es, this message translates to:
  /// **'Vista calendario'**
  String get tutConcerts4Title;

  /// No description provided for @tutConcerts4Desc.
  ///
  /// In es, this message translates to:
  /// **'El calendario marca los días en que tuviste un concierto. Toca cualquier fecha para ver el detalle o añadir uno nuevo en ese día.'**
  String get tutConcerts4Desc;

  /// No description provided for @tutConcerts5Title.
  ///
  /// In es, this message translates to:
  /// **'Buscar y filtrar'**
  String get tutConcerts5Title;

  /// No description provided for @tutConcerts5Desc.
  ///
  /// In es, this message translates to:
  /// **'Usa la barra de búsqueda para encontrar conciertos por artista, recinto o ciudad, y filtra por año para navegar rápidamente por tu historial.'**
  String get tutConcerts5Desc;

  /// No description provided for @tutConcerts6Title.
  ///
  /// In es, this message translates to:
  /// **'Mapa de conciertos'**
  String get tutConcerts6Title;

  /// No description provided for @tutConcerts6Desc.
  ///
  /// In es, this message translates to:
  /// **'Toca el icono de mapa para ver todos tus conciertos geolocalizados. Explora en qué ciudades y recintos has estado y descubre patrones.'**
  String get tutConcerts6Desc;

  /// No description provided for @tutConcerts7Title.
  ///
  /// In es, this message translates to:
  /// **'Compartidos'**
  String get tutConcerts7Title;

  /// No description provided for @tutConcerts7Desc.
  ///
  /// In es, this message translates to:
  /// **'La pestaña \"Compartidos\" reúne los conciertos que han añadido tus amigos y en los que te han etiquetado, aunque no los hayas registrado tú.'**
  String get tutConcerts7Desc;

  /// No description provided for @tutStats1Title.
  ///
  /// In es, this message translates to:
  /// **'Tus estadísticas musicales'**
  String get tutStats1Title;

  /// No description provided for @tutStats1Desc.
  ///
  /// In es, this message translates to:
  /// **'Un análisis completo de tu historial: total de conciertos, artistas únicos, ciudades visitadas, géneros favoritos, gasto total y mucho más.'**
  String get tutStats1Desc;

  /// No description provided for @tutStats2Title.
  ///
  /// In es, this message translates to:
  /// **'Conciertos por año y mes'**
  String get tutStats2Title;

  /// No description provided for @tutStats2Desc.
  ///
  /// In es, this message translates to:
  /// **'Gráficas de barras que muestran cómo se distribuyen tus conciertos a lo largo del tiempo. Descubre tus temporadas más activas.'**
  String get tutStats2Desc;

  /// No description provided for @tutStats3Title.
  ///
  /// In es, this message translates to:
  /// **'Top artistas, géneros y recintos'**
  String get tutStats3Title;

  /// No description provided for @tutStats3Desc.
  ///
  /// In es, this message translates to:
  /// **'Rankings de los artistas más vistos, géneros más escuchados en vivo y recintos más visitados. Con foto de Spotify cuando está disponible.'**
  String get tutStats3Desc;

  /// No description provided for @tutStats4Title.
  ///
  /// In es, this message translates to:
  /// **'Valoraciones y distribución'**
  String get tutStats4Title;

  /// No description provided for @tutStats4Desc.
  ///
  /// In es, this message translates to:
  /// **'Histograma de tus notas, valoración media por año y tus artistas mejor valorados. Solo se cuentan los conciertos puntuados con el sistema de criterios.'**
  String get tutStats4Desc;

  /// No description provided for @tutStats5Title.
  ///
  /// In es, this message translates to:
  /// **'Festival vs. individual'**
  String get tutStats5Title;

  /// No description provided for @tutStats5Desc.
  ///
  /// In es, this message translates to:
  /// **'Gráfico circular que muestra el reparto entre tus conciertos de festival y los individuales, para conocer tu perfil como espectador.'**
  String get tutStats5Desc;

  /// No description provided for @tutStats6Title.
  ///
  /// In es, this message translates to:
  /// **'Resumen anual'**
  String get tutStats6Title;

  /// No description provided for @tutStats6Desc.
  ///
  /// In es, this message translates to:
  /// **'Desde el icono de calendario accedes al Wrapped de cualquier año: artista estrella, ciudad favorita, valoración media y los momentos más destacados.'**
  String get tutStats6Desc;

  /// No description provided for @tutStats7Title.
  ///
  /// In es, this message translates to:
  /// **'Personalizar secciones'**
  String get tutStats7Title;

  /// No description provided for @tutStats7Desc.
  ///
  /// In es, this message translates to:
  /// **'Elige qué secciones de estadísticas quieres ver y reordénalas a tu gusto pulsando el icono de edición.'**
  String get tutStats7Desc;

  /// No description provided for @tutProfile1Title.
  ///
  /// In es, this message translates to:
  /// **'Tu acreditación'**
  String get tutProfile1Title;

  /// No description provided for @tutProfile1Desc.
  ///
  /// In es, this message translates to:
  /// **'Tu perfil resume todo tu historial musical: número de conciertos, fotos, favoritos y tu nivel de fan basado en cuántos shows llevas acumulados.'**
  String get tutProfile1Desc;

  /// No description provided for @tutProfile2Title.
  ///
  /// In es, this message translates to:
  /// **'Logros desbloqueables'**
  String get tutProfile2Title;

  /// No description provided for @tutProfile2Desc.
  ///
  /// In es, this message translates to:
  /// **'Ganas medallas por hitos musicales: 10 conciertos, primer festival, ver un artista repetido, conseguir una valoración perfecta y mucho más.'**
  String get tutProfile2Desc;

  /// No description provided for @tutProfile3Title.
  ///
  /// In es, this message translates to:
  /// **'Mis artistas'**
  String get tutProfile3Title;

  /// No description provided for @tutProfile3Desc.
  ///
  /// In es, this message translates to:
  /// **'Ranking de tus artistas más vistos, enriquecido con datos de Spotify: foto, seguidores, cuántas veces los has visto y tu valoración media de sus shows.'**
  String get tutProfile3Desc;

  /// No description provided for @tutProfile4Title.
  ///
  /// In es, this message translates to:
  /// **'Wrapped anual'**
  String get tutProfile4Title;

  /// No description provided for @tutProfile4Desc.
  ///
  /// In es, this message translates to:
  /// **'Accede al resumen animado de cada año desde tu perfil: artista del año, ciudad favorita, valoración media y todos tus conciertos destacados.'**
  String get tutProfile4Desc;

  /// No description provided for @tutProfile5Title.
  ///
  /// In es, this message translates to:
  /// **'Tema de color'**
  String get tutProfile5Title;

  /// No description provided for @tutProfile5Desc.
  ///
  /// In es, this message translates to:
  /// **'Personaliza el color principal de la app desde los ajustes. Elige el que mejor refleje tu estilo musical.'**
  String get tutProfile5Desc;

  /// No description provided for @tutFriends1Title.
  ///
  /// In es, this message translates to:
  /// **'Conecta con tu gente'**
  String get tutFriends1Title;

  /// No description provided for @tutFriends1Desc.
  ///
  /// In es, this message translates to:
  /// **'Busca amigos por nombre o email y envía solicitudes de amistad. Cuando te acepten, puedes ver sus conciertos y comparar historiales.'**
  String get tutFriends1Desc;

  /// No description provided for @tutFriends2Title.
  ///
  /// In es, this message translates to:
  /// **'Amigos y solicitudes'**
  String get tutFriends2Title;

  /// No description provided for @tutFriends2Desc.
  ///
  /// In es, this message translates to:
  /// **'La primera pestaña lista tus amigos actuales. La segunda gestiona las solicitudes pendientes que hayas recibido.'**
  String get tutFriends2Desc;

  /// No description provided for @tutFriends3Title.
  ///
  /// In es, this message translates to:
  /// **'Perfil de amigo'**
  String get tutFriends3Title;

  /// No description provided for @tutFriends3Desc.
  ///
  /// In es, this message translates to:
  /// **'Toca a un amigo para ver su perfil: sus conciertos, artistas favoritos y logros. Puedes explorar su historial aunque sea privado si sois amigos.'**
  String get tutFriends3Desc;

  /// No description provided for @tutFriends4Title.
  ///
  /// In es, this message translates to:
  /// **'Comparar estadísticas'**
  String get tutFriends4Title;

  /// No description provided for @tutFriends4Desc.
  ///
  /// In es, this message translates to:
  /// **'Desde el perfil de un amigo toca \"Comparar\" para ver vuestras estadísticas frente a frente: total de conciertos, artistas en común y valoración media.'**
  String get tutFriends4Desc;

  /// No description provided for @tutFriends5Title.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones de actividad'**
  String get tutFriends5Title;

  /// No description provided for @tutFriends5Desc.
  ///
  /// In es, this message translates to:
  /// **'Recibes una notificación cuando un amigo añade un concierto o te etiqueta en uno. También puedes comentar su actividad desde el feed.'**
  String get tutFriends5Desc;

  /// No description provided for @tutFeed1Title.
  ///
  /// In es, this message translates to:
  /// **'Feed de amigos'**
  String get tutFeed1Title;

  /// No description provided for @tutFeed1Desc.
  ///
  /// In es, this message translates to:
  /// **'Sigue la actividad musical de tus amigos en tiempo real: qué conciertos añadieron, cuándo y con quién fueron.'**
  String get tutFeed1Desc;

  /// No description provided for @tutFeed2Title.
  ///
  /// In es, this message translates to:
  /// **'Comentar conciertos'**
  String get tutFeed2Title;

  /// No description provided for @tutFeed2Desc.
  ///
  /// In es, this message translates to:
  /// **'Toca \"Comentar\" en cualquier actividad para dejar un mensaje. Abre el hilo completo para ver la conversación y responder.'**
  String get tutFeed2Desc;

  /// No description provided for @tutFeed3Title.
  ///
  /// In es, this message translates to:
  /// **'Galería compartida'**
  String get tutFeed3Title;

  /// No description provided for @tutFeed3Desc.
  ///
  /// In es, this message translates to:
  /// **'En la pestaña de fotos ves todas las imágenes que tú y tus amigos subisteis a vuestros conciertos, ordenadas cronológicamente.'**
  String get tutFeed3Desc;

  /// No description provided for @tutRecs1Title.
  ///
  /// In es, this message translates to:
  /// **'Conciertos cerca de ti'**
  String get tutRecs1Title;

  /// No description provided for @tutRecs1Desc.
  ///
  /// In es, this message translates to:
  /// **'Descubre eventos próximos basados en tu ubicación y los artistas que ya sigues en la app. Datos en tiempo real de Ticketmaster.'**
  String get tutRecs1Desc;

  /// No description provided for @tutRecs2Title.
  ///
  /// In es, this message translates to:
  /// **'Quiero ir'**
  String get tutRecs2Title;

  /// No description provided for @tutRecs2Desc.
  ///
  /// In es, this message translates to:
  /// **'Marca un evento como \"Quiero ir\" para guardarlo en tu lista y encontrarlo rápido más adelante.'**
  String get tutRecs2Desc;

  /// No description provided for @tutRecs3Title.
  ///
  /// In es, this message translates to:
  /// **'Añadir directamente'**
  String get tutRecs3Title;

  /// No description provided for @tutRecs3Desc.
  ///
  /// In es, this message translates to:
  /// **'Si ya tienes entrada para un evento recomendado, toca \"Añadir\" para registrarlo en tu historial como concierto futuro.'**
  String get tutRecs3Desc;

  /// No description provided for @tutImport1Title.
  ///
  /// In es, this message translates to:
  /// **'Buscar en Setlist.fm'**
  String get tutImport1Title;

  /// No description provided for @tutImport1Desc.
  ///
  /// In es, this message translates to:
  /// **'En la pestaña \"Setlist.fm\" escribe el nombre de un artista. La app mostrará sus conciertos pasados para que elijas los que hayas asistido.'**
  String get tutImport1Desc;

  /// No description provided for @tutImport2Title.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar e importar'**
  String get tutImport2Title;

  /// No description provided for @tutImport2Desc.
  ///
  /// In es, this message translates to:
  /// **'Marca los conciertos de la lista y toca \"Importar\". Se añaden automáticamente a tu historial; después puedes editar cada uno para añadir foto, precio y valoración.'**
  String get tutImport2Desc;

  /// No description provided for @tutImport3Title.
  ///
  /// In es, this message translates to:
  /// **'Copia de seguridad'**
  String get tutImport3Title;

  /// No description provided for @tutImport3Desc.
  ///
  /// In es, this message translates to:
  /// **'En la pestaña \"Copia de seguridad\" puedes exportar todos tus conciertos a un archivo o restaurarlos desde una copia anterior para no perder nada.'**
  String get tutImport3Desc;

  /// No description provided for @tutSpotifyPlaylist1Title.
  ///
  /// In es, this message translates to:
  /// **'Tu playlist de Spotify'**
  String get tutSpotifyPlaylist1Title;

  /// No description provided for @tutSpotifyPlaylist1Desc.
  ///
  /// In es, this message translates to:
  /// **'Esta pantalla muestra el reproductor embebido de Spotify con tu playlist personal. Cada usuario ve la suya propia gracias al acceso OAuth.'**
  String get tutSpotifyPlaylist1Desc;

  /// No description provided for @tutSpotifyPlaylist2Title.
  ///
  /// In es, this message translates to:
  /// **'Vincular tu cuenta'**
  String get tutSpotifyPlaylist2Title;

  /// No description provided for @tutSpotifyPlaylist2Desc.
  ///
  /// In es, this message translates to:
  /// **'Si aún no has vinculado Spotify, toca \"Conectar con Spotify\" para autorizar el acceso. Solo necesitas hacerlo una vez.'**
  String get tutSpotifyPlaylist2Desc;

  /// No description provided for @tutSpotifyPlaylist3Title.
  ///
  /// In es, this message translates to:
  /// **'Actualizar permisos'**
  String get tutSpotifyPlaylist3Title;

  /// No description provided for @tutSpotifyPlaylist3Desc.
  ///
  /// In es, this message translates to:
  /// **'Si ves el botón \"Re-vincular Spotify\" significa que tu sesión necesita un permiso adicional para acceder a playlists. Tócalo para actualizarla.'**
  String get tutSpotifyPlaylist3Desc;

  /// No description provided for @tutSpotifyImport1Title.
  ///
  /// In es, this message translates to:
  /// **'Tus artistas de Spotify'**
  String get tutSpotifyImport1Title;

  /// No description provided for @tutSpotifyImport1Desc.
  ///
  /// In es, this message translates to:
  /// **'Al vincular tu cuenta de Spotify, la app muestra aquí los artistas que más escuchas. Toca uno para buscar sus conciertos pasados en Setlist.fm.'**
  String get tutSpotifyImport1Desc;

  /// No description provided for @tutSpotifyImport2Title.
  ///
  /// In es, this message translates to:
  /// **'Importar conciertos del artista'**
  String get tutSpotifyImport2Title;

  /// No description provided for @tutSpotifyImport2Desc.
  ///
  /// In es, this message translates to:
  /// **'Al tocar un artista se abre la lista de sus conciertos pasados. Selecciona los que hayas visto y se añaden directamente a tu historial.'**
  String get tutSpotifyImport2Desc;

  /// No description provided for @tutSpotifyImport3Title.
  ///
  /// In es, this message translates to:
  /// **'Desconectar Spotify'**
  String get tutSpotifyImport3Title;

  /// No description provided for @tutSpotifyImport3Desc.
  ///
  /// In es, this message translates to:
  /// **'Toca el icono de salida en la esquina superior derecha para desvincular tu cuenta de Spotify en cualquier momento.'**
  String get tutSpotifyImport3Desc;

  /// No description provided for @tutMap1Title.
  ///
  /// In es, this message translates to:
  /// **'Tu mapa musical'**
  String get tutMap1Title;

  /// No description provided for @tutMap1Desc.
  ///
  /// In es, this message translates to:
  /// **'Todos tus conciertos geolocalizados en el mapa. Cada pin representa un concierto; las ciudades más visitadas se destacan con marcadores más grandes.'**
  String get tutMap1Desc;

  /// No description provided for @tutMap2Title.
  ///
  /// In es, this message translates to:
  /// **'Explorar conciertos'**
  String get tutMap2Title;

  /// No description provided for @tutMap2Desc.
  ///
  /// In es, this message translates to:
  /// **'Toca cualquier pin para ver el nombre del artista, el recinto y la fecha. Desde ahí puedes abrir el detalle completo del concierto.'**
  String get tutMap2Desc;

  /// No description provided for @usernameRequired.
  ///
  /// In es, this message translates to:
  /// **'Introduce tu nombre de usuario'**
  String get usernameRequired;

  /// No description provided for @passwordLabel.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get passwordLabel;

  /// No description provided for @emailRequired.
  ///
  /// In es, this message translates to:
  /// **'Introduce tu correo'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In es, this message translates to:
  /// **'Email no válido'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In es, this message translates to:
  /// **'Introduce tu contraseña'**
  String get passwordRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In es, this message translates to:
  /// **'Mínimo 6 caracteres'**
  String get passwordMinLength;

  /// No description provided for @serverTimeout.
  ///
  /// In es, this message translates to:
  /// **'El servidor tardó demasiado. Inténtalo de nuevo.'**
  String get serverTimeout;

  /// No description provided for @loginErrorGeneric.
  ///
  /// In es, this message translates to:
  /// **'No se ha podido iniciar sesión.'**
  String get loginErrorGeneric;

  /// No description provided for @loginErrorInvalidCredentials.
  ///
  /// In es, this message translates to:
  /// **'Correo o contraseña incorrectos.'**
  String get loginErrorInvalidCredentials;

  /// No description provided for @registerErrorGeneric.
  ///
  /// In es, this message translates to:
  /// **'Ha ocurrido un error.'**
  String get registerErrorGeneric;

  /// No description provided for @registerErrorInvalidEmail.
  ///
  /// In es, this message translates to:
  /// **'Introduce un correo electrónico válido.'**
  String get registerErrorInvalidEmail;

  /// No description provided for @registerErrorEmailTaken.
  ///
  /// In es, this message translates to:
  /// **'Ya existe una cuenta con ese correo.'**
  String get registerErrorEmailTaken;

  /// No description provided for @registerErrorInvalidPassword.
  ///
  /// In es, this message translates to:
  /// **'La contraseña no es válida.'**
  String get registerErrorInvalidPassword;

  /// No description provided for @forgotPasswordIntro.
  ///
  /// In es, this message translates to:
  /// **'Introduce tu email y te enviaremos un enlace para crear una nueva contraseña.'**
  String get forgotPasswordIntro;

  /// No description provided for @emailSentTitle.
  ///
  /// In es, this message translates to:
  /// **'¡Email enviado!'**
  String get emailSentTitle;

  /// No description provided for @emailSentBody.
  ///
  /// In es, this message translates to:
  /// **'Si el email existe, recibirás un enlace para restablecer tu contraseña.\n\nRevisa también la carpeta de spam.'**
  String get emailSentBody;

  /// No description provided for @themePickerTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo prefieres\nver la app?'**
  String get themePickerTitle;

  /// No description provided for @themePickerHint.
  ///
  /// In es, this message translates to:
  /// **'Puedes cambiarlo después en Ajustes.'**
  String get themePickerHint;

  /// No description provided for @themeSystemDesc.
  ///
  /// In es, this message translates to:
  /// **'Sigue el ajuste de tu móvil'**
  String get themeSystemDesc;

  /// No description provided for @themeDarkDesc.
  ///
  /// In es, this message translates to:
  /// **'Fondo negro, ideal para conciertos'**
  String get themeDarkDesc;

  /// No description provided for @themeLightDesc.
  ///
  /// In es, this message translates to:
  /// **'Fondo blanco, máxima legibilidad'**
  String get themeLightDesc;

  /// No description provided for @getStartedLabel.
  ///
  /// In es, this message translates to:
  /// **'Empezar'**
  String get getStartedLabel;

  /// No description provided for @useSystemThemeLabel.
  ///
  /// In es, this message translates to:
  /// **'Usar el del sistema'**
  String get useSystemThemeLabel;

  /// No description provided for @appErrorNoInternet.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión a internet'**
  String get appErrorNoInternet;

  /// No description provided for @appErrorTimeout.
  ///
  /// In es, this message translates to:
  /// **'El servidor tardó demasiado en responder'**
  String get appErrorTimeout;

  /// No description provided for @appErrorSessionExpired.
  ///
  /// In es, this message translates to:
  /// **'Sesión expirada. Vuelve a iniciar sesión'**
  String get appErrorSessionExpired;

  /// No description provided for @appErrorForbidden.
  ///
  /// In es, this message translates to:
  /// **'No tienes permiso para ver esto'**
  String get appErrorForbidden;

  /// No description provided for @appErrorNotFound.
  ///
  /// In es, this message translates to:
  /// **'No se encontró el contenido'**
  String get appErrorNotFound;

  /// No description provided for @appErrorServer.
  ///
  /// In es, this message translates to:
  /// **'Error en el servidor. Inténtalo más tarde'**
  String get appErrorServer;

  /// No description provided for @appErrorGeneric.
  ///
  /// In es, this message translates to:
  /// **'Algo salió mal. Inténtalo de nuevo'**
  String get appErrorGeneric;

  /// No description provided for @paywallTitle.
  ///
  /// In es, this message translates to:
  /// **'Lleva tu experiencia al siguiente nivel'**
  String get paywallTitle;

  /// No description provided for @paywallDesc.
  ///
  /// In es, this message translates to:
  /// **'Hazte Pro para añadir conciertos sin límites y desbloquear todo lo que la app tiene para ofrecerte.'**
  String get paywallDesc;

  /// No description provided for @paywallBenefitConcerts.
  ///
  /// In es, this message translates to:
  /// **'Conciertos ilimitados'**
  String get paywallBenefitConcerts;

  /// No description provided for @paywallBenefitPhotos.
  ///
  /// In es, this message translates to:
  /// **'Fotos ilimitadas por concierto'**
  String get paywallBenefitPhotos;

  /// No description provided for @paywallBenefitPdf.
  ///
  /// In es, this message translates to:
  /// **'Exportar estadísticas a PDF'**
  String get paywallBenefitPdf;

  /// No description provided for @paywallBenefitCustom.
  ///
  /// In es, this message translates to:
  /// **'Dashboard y estadísticas personalizables'**
  String get paywallBenefitCustom;

  /// No description provided for @paywallBenefitThemes.
  ///
  /// In es, this message translates to:
  /// **'Temas de color exclusivos'**
  String get paywallBenefitThemes;

  /// No description provided for @paywallCta.
  ///
  /// In es, this message translates to:
  /// **'Hacerse Pro'**
  String get paywallCta;

  /// No description provided for @paywallLater.
  ///
  /// In es, this message translates to:
  /// **'Ahora no'**
  String get paywallLater;

  /// No description provided for @dashEditTitle.
  ///
  /// In es, this message translates to:
  /// **'Personalizar dashboard'**
  String get dashEditTitle;

  /// No description provided for @layoutResetTitle.
  ///
  /// In es, this message translates to:
  /// **'Restablecer orden'**
  String get layoutResetTitle;

  /// No description provided for @dashEditResetConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Restaurar la disposición por defecto del dashboard?'**
  String get dashEditResetConfirm;

  /// No description provided for @statsEditResetConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Restaurar la disposición por defecto?'**
  String get statsEditResetConfirm;

  /// No description provided for @resetLabel.
  ///
  /// In es, this message translates to:
  /// **'Restablecer'**
  String get resetLabel;

  /// No description provided for @layoutLoadError.
  ///
  /// In es, this message translates to:
  /// **'Error cargando la configuración'**
  String get layoutLoadError;

  /// No description provided for @layoutEditHint.
  ///
  /// In es, this message translates to:
  /// **'Arrastra   para reordenar · activa o desactiva cada sección'**
  String get layoutEditHint;

  /// No description provided for @hiddenLabel.
  ///
  /// In es, this message translates to:
  /// **'Oculta'**
  String get hiddenLabel;

  /// No description provided for @dashSectionStreak.
  ///
  /// In es, this message translates to:
  /// **'Racha de conciertos'**
  String get dashSectionStreak;

  /// No description provided for @dashSectionAnnualGoal.
  ///
  /// In es, this message translates to:
  /// **'Meta anual'**
  String get dashSectionAnnualGoal;

  /// No description provided for @dashRatePendingTitle.
  ///
  /// In es, this message translates to:
  /// **'Por valorar'**
  String get dashRatePendingTitle;

  /// No description provided for @dashSectionOnThisDay.
  ///
  /// In es, this message translates to:
  /// **'En tal día como hoy'**
  String get dashSectionOnThisDay;

  /// No description provided for @dashSectionUpcoming.
  ///
  /// In es, this message translates to:
  /// **'Próximos conciertos'**
  String get dashSectionUpcoming;

  /// No description provided for @dashSectionStats.
  ///
  /// In es, this message translates to:
  /// **'Estadísticas rápidas'**
  String get dashSectionStats;

  /// No description provided for @dashSectionRecommended.
  ///
  /// In es, this message translates to:
  /// **'Recomendaciones'**
  String get dashSectionRecommended;

  /// No description provided for @dashSectionFavorites.
  ///
  /// In es, this message translates to:
  /// **'Favoritos'**
  String get dashSectionFavorites;

  /// No description provided for @dashSectionRecent.
  ///
  /// In es, this message translates to:
  /// **'Últimos añadidos'**
  String get dashSectionRecent;

  /// No description provided for @dashSectionSpotify.
  ///
  /// In es, this message translates to:
  /// **'Canciones favoritas (Spotify)'**
  String get dashSectionSpotify;

  /// No description provided for @dashCalendarAction.
  ///
  /// In es, this message translates to:
  /// **'Calendario'**
  String get dashCalendarAction;

  /// No description provided for @dashLastConcertTitle.
  ///
  /// In es, this message translates to:
  /// **'Tu último concierto'**
  String get dashLastConcertTitle;

  /// No description provided for @annualGoalMyConcerts.
  ///
  /// In es, this message translates to:
  /// **'Mis conciertos de {year}'**
  String annualGoalMyConcerts(int year);

  /// No description provided for @annualGoalNoConcerts.
  ///
  /// In es, this message translates to:
  /// **'Aún no has ido a ningún concierto en {year}'**
  String annualGoalNoConcerts(int year);

  /// No description provided for @annualGoalDoneInYear.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 concierto en {year}} other{{count} conciertos en {year}}}'**
  String annualGoalDoneInYear(int count, int year);

  /// No description provided for @annualGoalConfigure.
  ///
  /// In es, this message translates to:
  /// **'Configura tu meta en Ajustes'**
  String get annualGoalConfigure;

  /// No description provided for @annualGoalReached.
  ///
  /// In es, this message translates to:
  /// **'¡Meta alcanzada en {year}! 🎉'**
  String annualGoalReached(int year);

  /// No description provided for @annualGoalProgressTitle.
  ///
  /// In es, this message translates to:
  /// **'Meta {year}: {goal, plural, =1{1 concierto} other{{goal} conciertos}}'**
  String annualGoalProgressTitle(int year, int goal);

  /// No description provided for @annualGoalRemaining.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{Te queda 1 concierto para conseguirlo} other{Te quedan {count} conciertos para conseguirlo}}'**
  String annualGoalRemaining(int count);

  /// No description provided for @statsCustomizeTooltip.
  ///
  /// In es, this message translates to:
  /// **'Personalizar'**
  String get statsCustomizeTooltip;

  /// No description provided for @statsByMonth.
  ///
  /// In es, this message translates to:
  /// **'Conciertos por mes'**
  String get statsByMonth;

  /// No description provided for @statsByWeekday.
  ///
  /// In es, this message translates to:
  /// **'Día de la semana favorito'**
  String get statsByWeekday;

  /// No description provided for @statsGenres.
  ///
  /// In es, this message translates to:
  /// **'Géneros musicales'**
  String get statsGenres;

  /// No description provided for @statsVenues.
  ///
  /// In es, this message translates to:
  /// **'Recintos más visitados'**
  String get statsVenues;

  /// No description provided for @statsFestivalVsSingle.
  ///
  /// In es, this message translates to:
  /// **'Festival vs. individual'**
  String get statsFestivalVsSingle;

  /// No description provided for @statsAvgRatingByYear.
  ///
  /// In es, this message translates to:
  /// **'Valoración media por año'**
  String get statsAvgRatingByYear;

  /// No description provided for @statsTopRatedArtists.
  ///
  /// In es, this message translates to:
  /// **'Artistas mejor valorados'**
  String get statsTopRatedArtists;

  /// No description provided for @statsTotalSpent.
  ///
  /// In es, this message translates to:
  /// **'Gasto total'**
  String get statsTotalSpent;

  /// No description provided for @statsMonthsCount.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 mes} other{{count} meses}}'**
  String statsMonthsCount(int count);

  /// No description provided for @statsLongestStreak.
  ///
  /// In es, this message translates to:
  /// **'Racha más larga'**
  String get statsLongestStreak;

  /// No description provided for @statsDaysCount.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 día} other{{count} días}}'**
  String statsDaysCount(int count);

  /// No description provided for @statsLongestGap.
  ///
  /// In es, this message translates to:
  /// **'Mayor hueco'**
  String get statsLongestGap;

  /// No description provided for @statsRepeatedArtists.
  ///
  /// In es, this message translates to:
  /// **'Artistas repetidos'**
  String get statsRepeatedArtists;

  /// No description provided for @statsSingleConcerts.
  ///
  /// In es, this message translates to:
  /// **'Individuales'**
  String get statsSingleConcerts;

  /// No description provided for @weekdayShortMon.
  ///
  /// In es, this message translates to:
  /// **'Lun'**
  String get weekdayShortMon;

  /// No description provided for @weekdayShortTue.
  ///
  /// In es, this message translates to:
  /// **'Mar'**
  String get weekdayShortTue;

  /// No description provided for @weekdayShortWed.
  ///
  /// In es, this message translates to:
  /// **'Mié'**
  String get weekdayShortWed;

  /// No description provided for @weekdayShortThu.
  ///
  /// In es, this message translates to:
  /// **'Jue'**
  String get weekdayShortThu;

  /// No description provided for @weekdayShortFri.
  ///
  /// In es, this message translates to:
  /// **'Vie'**
  String get weekdayShortFri;

  /// No description provided for @weekdayShortSat.
  ///
  /// In es, this message translates to:
  /// **'Sáb'**
  String get weekdayShortSat;

  /// No description provided for @weekdayShortSun.
  ///
  /// In es, this message translates to:
  /// **'Dom'**
  String get weekdayShortSun;

  /// No description provided for @statsEditTitle.
  ///
  /// In es, this message translates to:
  /// **'Personalizar estadísticas'**
  String get statsEditTitle;

  /// No description provided for @statsEditSummary.
  ///
  /// In es, this message translates to:
  /// **'Resumen (tarjetas)'**
  String get statsEditSummary;

  /// No description provided for @statsEditTopArtists.
  ///
  /// In es, this message translates to:
  /// **'Top artistas'**
  String get statsEditTopArtists;

  /// No description provided for @statsEditTopFestivals.
  ///
  /// In es, this message translates to:
  /// **'Top festivales'**
  String get statsEditTopFestivals;

  /// No description provided for @wrappedShareText.
  ///
  /// In es, this message translates to:
  /// **'🎸 Mi Wrapped {year} | La Vida en Directo'**
  String wrappedShareText(int year);

  /// No description provided for @wrappedLoadError.
  ///
  /// In es, this message translates to:
  /// **'Error cargando conciertos'**
  String get wrappedLoadError;

  /// No description provided for @wrappedIntroTitle.
  ///
  /// In es, this message translates to:
  /// **'Tu año\nen conciertos'**
  String get wrappedIntroTitle;

  /// No description provided for @wrappedStart.
  ///
  /// In es, this message translates to:
  /// **'Empieza'**
  String get wrappedStart;

  /// No description provided for @wrappedTotalLead.
  ///
  /// In es, this message translates to:
  /// **'Este año fuiste a'**
  String get wrappedTotalLead;

  /// No description provided for @wrappedConcertsWord.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{concierto} other{conciertos}}'**
  String wrappedConcertsWord(int count);

  /// No description provided for @wrappedTier50.
  ///
  /// In es, this message translates to:
  /// **'🔥 ¡Año legendario!'**
  String get wrappedTier50;

  /// No description provided for @wrappedTier20.
  ///
  /// In es, this message translates to:
  /// **'🎉 ¡Gran año en directo!'**
  String get wrappedTier20;

  /// No description provided for @wrappedTier10.
  ///
  /// In es, this message translates to:
  /// **'👏 Muy buen año'**
  String get wrappedTier10;

  /// No description provided for @wrappedTier0.
  ///
  /// In es, this message translates to:
  /// **'🎵 Empezando fuerte'**
  String get wrappedTier0;

  /// No description provided for @wrappedArtistTitle.
  ///
  /// In es, this message translates to:
  /// **'Tu artista del año'**
  String get wrappedArtistTitle;

  /// No description provided for @wrappedSharedBadge.
  ///
  /// In es, this message translates to:
  /// **'Concierto compartido'**
  String get wrappedSharedBadge;

  /// No description provided for @wrappedSeenTimes.
  ///
  /// In es, this message translates to:
  /// **'Lo viste {times} veces'**
  String wrappedSeenTimes(int times);

  /// No description provided for @wrappedWasThere.
  ///
  /// In es, this message translates to:
  /// **'Estuviste allí'**
  String get wrappedWasThere;

  /// No description provided for @wrappedWasSpecial.
  ///
  /// In es, this message translates to:
  /// **'Fue especial'**
  String get wrappedWasSpecial;

  /// No description provided for @wrappedVarietyTitle.
  ///
  /// In es, this message translates to:
  /// **'Nunca te cansas'**
  String get wrappedVarietyTitle;

  /// No description provided for @wrappedArtistsLabel.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{artista distinto} other{artistas distintos}}'**
  String wrappedArtistsLabel(int count);

  /// No description provided for @wrappedCitiesLabel.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{ciudad} other{ciudades diferentes}}'**
  String wrappedCitiesLabel(int count);

  /// No description provided for @wrappedFestivalsLabel.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{festival} other{festivales}}'**
  String wrappedFestivalsLabel(int count);

  /// No description provided for @wrappedCityTitle.
  ///
  /// In es, this message translates to:
  /// **'Tu ciudad favorita'**
  String get wrappedCityTitle;

  /// No description provided for @wrappedMonthTitle.
  ///
  /// In es, this message translates to:
  /// **'Tu mes más activo'**
  String get wrappedMonthTitle;

  /// No description provided for @wrappedRatingTitle.
  ///
  /// In es, this message translates to:
  /// **'Tu valoración media'**
  String get wrappedRatingTitle;

  /// No description provided for @wrappedOutOf5.
  ///
  /// In es, this message translates to:
  /// **'sobre 5'**
  String get wrappedOutOf5;

  /// No description provided for @wrappedPhotosTitle.
  ///
  /// In es, this message translates to:
  /// **'Tus memorias'**
  String get wrappedPhotosTitle;

  /// No description provided for @wrappedMemoriesCount.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 recuerdo este año} other{{count} recuerdos este año}}'**
  String wrappedMemoriesCount(int count);

  /// No description provided for @wrappedClosingTitle.
  ///
  /// In es, this message translates to:
  /// **'Tu resumen'**
  String get wrappedClosingTitle;

  /// No description provided for @wrappedPreparing.
  ///
  /// In es, this message translates to:
  /// **'Preparando...'**
  String get wrappedPreparing;

  /// No description provided for @wrappedShareButton.
  ///
  /// In es, this message translates to:
  /// **'Compartir mi Wrapped'**
  String get wrappedShareButton;

  /// No description provided for @wrappedFavArtist.
  ///
  /// In es, this message translates to:
  /// **'Artista favorito'**
  String get wrappedFavArtist;

  /// No description provided for @wrappedFavCity.
  ///
  /// In es, this message translates to:
  /// **'Ciudad favorita'**
  String get wrappedFavCity;

  /// No description provided for @wrappedActiveMonth.
  ///
  /// In es, this message translates to:
  /// **'Mes más activo'**
  String get wrappedActiveMonth;

  /// No description provided for @wrappedMiniArtists.
  ///
  /// In es, this message translates to:
  /// **'artistas'**
  String get wrappedMiniArtists;

  /// No description provided for @wrappedMiniCities.
  ///
  /// In es, this message translates to:
  /// **'ciudades'**
  String get wrappedMiniCities;

  /// No description provided for @wrappedMiniRating.
  ///
  /// In es, this message translates to:
  /// **'valoración'**
  String get wrappedMiniRating;

  /// No description provided for @wrappedTeaserPre.
  ///
  /// In es, this message translates to:
  /// **'Tu '**
  String get wrappedTeaserPre;

  /// No description provided for @wrappedTeaserYear.
  ///
  /// In es, this message translates to:
  /// **'del {year}'**
  String wrappedTeaserYear(int year);

  /// No description provided for @wrappedTeaserComing.
  ///
  /// In es, this message translates to:
  /// **'llega en diciembre'**
  String get wrappedTeaserComing;

  /// No description provided for @wrappedTeaserProgress.
  ///
  /// In es, this message translates to:
  /// **'PROGRESO DEL AÑO'**
  String get wrappedTeaserProgress;

  /// No description provided for @wrappedTeaserMonthsLeft.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 mes para diciembre} other{{count} meses para diciembre}}'**
  String wrappedTeaserMonthsLeft(int count);

  /// No description provided for @wrappedTeaserStory.
  ///
  /// In es, this message translates to:
  /// **'TU HISTORIA ESTE AÑO'**
  String get wrappedTeaserStory;

  /// No description provided for @addGenreLabel.
  ///
  /// In es, this message translates to:
  /// **'🎸 Género musical'**
  String get addGenreLabel;

  /// No description provided for @addGenreHint.
  ///
  /// In es, this message translates to:
  /// **'Rock, Pop, Metal, Jazz…'**
  String get addGenreHint;

  /// No description provided for @priceFestivalLabel.
  ///
  /// In es, this message translates to:
  /// **'Precio del festival'**
  String get priceFestivalLabel;

  /// No description provided for @priceTicketLabel.
  ///
  /// In es, this message translates to:
  /// **'Precio de la entrada'**
  String get priceTicketLabel;

  /// No description provided for @timeLabel.
  ///
  /// In es, this message translates to:
  /// **'Hora'**
  String get timeLabel;

  /// No description provided for @optionalHint.
  ///
  /// In es, this message translates to:
  /// **'Opcional'**
  String get optionalHint;

  /// No description provided for @ratingAutoNote.
  ///
  /// In es, this message translates to:
  /// **'La valoración general se calcula como la media de los criterios.'**
  String get ratingAutoNote;

  /// No description provided for @ratingCriterionArtist.
  ///
  /// In es, this message translates to:
  /// **'Artista'**
  String get ratingCriterionArtist;

  /// No description provided for @ratingCriterionSound.
  ///
  /// In es, this message translates to:
  /// **'Sonido'**
  String get ratingCriterionSound;

  /// No description provided for @ratingCriterionAtmosphere.
  ///
  /// In es, this message translates to:
  /// **'Ambiente'**
  String get ratingCriterionAtmosphere;

  /// No description provided for @ratingCriterionSetlist.
  ///
  /// In es, this message translates to:
  /// **'Setlist'**
  String get ratingCriterionSetlist;

  /// No description provided for @ratingCriterionValue.
  ///
  /// In es, this message translates to:
  /// **'Precio / valor'**
  String get ratingCriterionValue;

  /// No description provided for @notesDiaryLabel.
  ///
  /// In es, this message translates to:
  /// **'📝 Notas / diario'**
  String get notesDiaryLabel;

  /// No description provided for @notesDiaryHint.
  ///
  /// In es, this message translates to:
  /// **'¿Qué recordás de este concierto?'**
  String get notesDiaryHint;

  /// No description provided for @visibleToFriendsTitle.
  ///
  /// In es, this message translates to:
  /// **'Visible para mis amigos'**
  String get visibleToFriendsTitle;

  /// No description provided for @visibleToFriendsOn.
  ///
  /// In es, this message translates to:
  /// **'Aparece en tu feed de amigos y en las comparativas'**
  String get visibleToFriendsOn;

  /// No description provided for @visibleToFriendsOff.
  ///
  /// In es, this message translates to:
  /// **'Solo tú lo verás — oculto para tus amigos'**
  String get visibleToFriendsOff;

  /// No description provided for @genreLabel.
  ///
  /// In es, this message translates to:
  /// **'Género'**
  String get genreLabel;

  /// No description provided for @detailHiddenTitle.
  ///
  /// In es, this message translates to:
  /// **'Oculto para tus amigos'**
  String get detailHiddenTitle;

  /// No description provided for @detailHiddenDesc.
  ///
  /// In es, this message translates to:
  /// **'Solo tú puedes ver este concierto'**
  String get detailHiddenDesc;

  /// No description provided for @detailLinkSpotifyTitle.
  ///
  /// In es, this message translates to:
  /// **'Vincular artista de Spotify'**
  String get detailLinkSpotifyTitle;

  /// No description provided for @detailLinkSpotifyDesc.
  ///
  /// In es, this message translates to:
  /// **'Ver canciones populares y perfil'**
  String get detailLinkSpotifyDesc;

  /// No description provided for @detailSpotifyNotFound.
  ///
  /// In es, this message translates to:
  /// **'Artista no encontrado en Spotify: \"{query}\"'**
  String detailSpotifyNotFound(String query);

  /// No description provided for @detailSpotifySearchError.
  ///
  /// In es, this message translates to:
  /// **'Error al buscar en Spotify: {error}'**
  String detailSpotifySearchError(String error);

  /// No description provided for @notesTitle.
  ///
  /// In es, this message translates to:
  /// **'Notas'**
  String get notesTitle;

  /// No description provided for @shareLabel.
  ///
  /// In es, this message translates to:
  /// **'Compartir'**
  String get shareLabel;

  /// No description provided for @preparingLabel.
  ///
  /// In es, this message translates to:
  /// **'Preparando...'**
  String get preparingLabel;

  /// No description provided for @commentsTitle.
  ///
  /// In es, this message translates to:
  /// **'Comentarios'**
  String get commentsTitle;

  /// No description provided for @commentsEmpty.
  ///
  /// In es, this message translates to:
  /// **'Sé el primero en comentar'**
  String get commentsEmpty;

  /// No description provided for @commentHint.
  ///
  /// In es, this message translates to:
  /// **'Escribe un comentario…'**
  String get commentHint;

  /// No description provided for @timeNow.
  ///
  /// In es, this message translates to:
  /// **'ahora'**
  String get timeNow;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In es, this message translates to:
  /// **'hace {count} min'**
  String timeMinutesAgo(int count);

  /// No description provided for @timeHoursAgo.
  ///
  /// In es, this message translates to:
  /// **'hace {count} h'**
  String timeHoursAgo(int count);

  /// No description provided for @timeDaysAgo.
  ///
  /// In es, this message translates to:
  /// **'hace {count} d'**
  String timeDaysAgo(int count);

  /// No description provided for @detailedRatingTitle.
  ///
  /// In es, this message translates to:
  /// **'Valoración detallada'**
  String get detailedRatingTitle;

  /// No description provided for @deleteConcertsTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar conciertos'**
  String get deleteConcertsTitle;

  /// No description provided for @deleteConcertsConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar {count} {count, plural, =1{concierto} other{conciertos}}?\nEsta acción no se puede deshacer.'**
  String deleteConcertsConfirm(int count);

  /// No description provided for @concertsDeletedCount.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 concierto eliminado} other{{count} conciertos eliminados}}'**
  String concertsDeletedCount(int count);

  /// No description provided for @concertsSelectedCount.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 seleccionado} other{{count} seleccionados}}'**
  String concertsSelectedCount(int count);

  /// No description provided for @selectAllLabel.
  ///
  /// In es, this message translates to:
  /// **'Todo'**
  String get selectAllLabel;

  /// No description provided for @deleteSelectedTooltip.
  ///
  /// In es, this message translates to:
  /// **'Eliminar seleccionados'**
  String get deleteSelectedTooltip;

  /// No description provided for @cancelSelectionTooltip.
  ///
  /// In es, this message translates to:
  /// **'Cancelar selección'**
  String get cancelSelectionTooltip;

  /// No description provided for @selectTooltip.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar'**
  String get selectTooltip;

  /// No description provided for @filterLiked.
  ///
  /// In es, this message translates to:
  /// **'Me gustan'**
  String get filterLiked;

  /// No description provided for @clearLabel.
  ///
  /// In es, this message translates to:
  /// **'Limpiar'**
  String get clearLabel;

  /// No description provided for @viewList.
  ///
  /// In es, this message translates to:
  /// **'Lista'**
  String get viewList;

  /// No description provided for @viewGrid.
  ///
  /// In es, this message translates to:
  /// **'Cuadrícula'**
  String get viewGrid;

  /// No description provided for @viewCalendar.
  ///
  /// In es, this message translates to:
  /// **'Calendario'**
  String get viewCalendar;

  /// No description provided for @emptyPastSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Tus conciertos pasados aparecerán aquí'**
  String get emptyPastSubtitle;

  /// No description provided for @emptyUpcomingSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Añade un concierto futuro para no perderte nada'**
  String get emptyUpcomingSubtitle;

  /// No description provided for @emptySharedSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Cuando tus amigos compartan conciertos, los verás aquí'**
  String get emptySharedSubtitle;

  /// No description provided for @filterSheetTitle.
  ///
  /// In es, this message translates to:
  /// **'Filtrar conciertos'**
  String get filterSheetTitle;

  /// No description provided for @filterMinRating.
  ///
  /// In es, this message translates to:
  /// **'Valoración mínima'**
  String get filterMinRating;

  /// No description provided for @filterShowOnly.
  ///
  /// In es, this message translates to:
  /// **'Mostrar solo'**
  String get filterShowOnly;

  /// No description provided for @applyFilters.
  ///
  /// In es, this message translates to:
  /// **'Aplicar filtros'**
  String get applyFilters;

  /// No description provided for @venueArtistsLabel.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{artista} other{artistas}}'**
  String venueArtistsLabel(int count);

  /// No description provided for @venueUpcomingLabel.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{próximo} other{próximos}}'**
  String venueUpcomingLabel(int count);

  /// No description provided for @venueFirstVisit.
  ///
  /// In es, this message translates to:
  /// **'Primera visita: {date}'**
  String venueFirstVisit(String date);

  /// No description provided for @venueLastVisit.
  ///
  /// In es, this message translates to:
  /// **'Última: {date}'**
  String venueLastVisit(String date);

  /// No description provided for @venueNoConcerts.
  ///
  /// In es, this message translates to:
  /// **'No hay conciertos en este recinto'**
  String get venueNoConcerts;

  /// No description provided for @calendarWeekdayInitials.
  ///
  /// In es, this message translates to:
  /// **'L,M,X,J,V,S,D'**
  String get calendarWeekdayInitials;

  /// No description provided for @calendarDayLabel.
  ///
  /// In es, this message translates to:
  /// **'{day} de {month}'**
  String calendarDayLabel(int day, String month);

  /// No description provided for @calendarAddOnDate.
  ///
  /// In es, this message translates to:
  /// **'Añadir concierto en esta fecha'**
  String get calendarAddOnDate;

  /// No description provided for @mapCenterTooltip.
  ///
  /// In es, this message translates to:
  /// **'Centrar'**
  String get mapCenterTooltip;

  /// No description provided for @favoritesArtistCount.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 artista} other{{count} artistas}}'**
  String favoritesArtistCount(int count);

  /// No description provided for @favoritesEmptySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Marca conciertos como favoritos para verlos aquí agrupados por artista'**
  String get favoritesEmptySubtitle;

  /// No description provided for @refreshTooltip.
  ///
  /// In es, this message translates to:
  /// **'Actualizar'**
  String get refreshTooltip;

  /// No description provided for @friendsActivityEmpty.
  ///
  /// In es, this message translates to:
  /// **'Tus amigos no han agregado\nconciertos todavía'**
  String get friendsActivityEmpty;

  /// No description provided for @friendDefaultName.
  ///
  /// In es, this message translates to:
  /// **'Amigo'**
  String get friendDefaultName;

  /// No description provided for @commentAction.
  ///
  /// In es, this message translates to:
  /// **'Comentar'**
  String get commentAction;

  /// No description provided for @userDefaultName.
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get userDefaultName;

  /// No description provided for @notificationsEmptyHint.
  ///
  /// In es, this message translates to:
  /// **'Aquí aparecerán tus avisos y actividad de amigos'**
  String get notificationsEmptyHint;

  /// No description provided for @recsViewCardTooltip.
  ///
  /// In es, this message translates to:
  /// **'Vista tarjeta'**
  String get recsViewCardTooltip;

  /// No description provided for @recsViewCompactTooltip.
  ///
  /// In es, this message translates to:
  /// **'Vista compacta'**
  String get recsViewCompactTooltip;

  /// No description provided for @recsResultsTab.
  ///
  /// In es, this message translates to:
  /// **'Resultados'**
  String get recsResultsTab;

  /// No description provided for @wantToGoTab.
  ///
  /// In es, this message translates to:
  /// **'Quiero ir'**
  String get wantToGoTab;

  /// No description provided for @recsWantEmpty.
  ///
  /// In es, this message translates to:
  /// **'Aún no has marcado ningún concierto.'**
  String get recsWantEmpty;

  /// No description provided for @recsAttending.
  ///
  /// In es, this message translates to:
  /// **'Apuntado'**
  String get recsAttending;

  /// No description provided for @recsRemoveFromList.
  ///
  /// In es, this message translates to:
  /// **'Quitar de mi lista'**
  String get recsRemoveFromList;

  /// No description provided for @recsWantToAttend.
  ///
  /// In es, this message translates to:
  /// **'Quiero asistir'**
  String get recsWantToAttend;

  /// No description provided for @setlistDataFrom.
  ///
  /// In es, this message translates to:
  /// **'Datos de setlist.fm'**
  String get setlistDataFrom;

  /// No description provided for @colorPaletteIntro.
  ///
  /// In es, this message translates to:
  /// **'Cambia el acento de color de toda la app. Las paletas Pro requieren suscripción activa.'**
  String get colorPaletteIntro;

  /// No description provided for @themeNameEscenario.
  ///
  /// In es, this message translates to:
  /// **'Escenario'**
  String get themeNameEscenario;

  /// No description provided for @themeNameVinilo.
  ///
  /// In es, this message translates to:
  /// **'Vinilo'**
  String get themeNameVinilo;

  /// No description provided for @themeNameFestival.
  ///
  /// In es, this message translates to:
  /// **'Festival'**
  String get themeNameFestival;

  /// No description provided for @themeNameNeonPunk.
  ///
  /// In es, this message translates to:
  /// **'Neon Punk'**
  String get themeNameNeonPunk;

  /// No description provided for @themeNameAcustico.
  ///
  /// In es, this message translates to:
  /// **'Acústico'**
  String get themeNameAcustico;

  /// No description provided for @themeNameBackstage.
  ///
  /// In es, this message translates to:
  /// **'Backstage'**
  String get themeNameBackstage;

  /// No description provided for @themeNameJazzClub.
  ///
  /// In es, this message translates to:
  /// **'Jazz Club'**
  String get themeNameJazzClub;

  /// No description provided for @concertNotFoundError.
  ///
  /// In es, this message translates to:
  /// **'No se encontró el concierto'**
  String get concertNotFoundError;

  /// No description provided for @concertNotFoundTitle.
  ///
  /// In es, this message translates to:
  /// **'Concierto no encontrado'**
  String get concertNotFoundTitle;

  /// No description provided for @concertNotFoundHint.
  ///
  /// In es, this message translates to:
  /// **'Puede que ya no formes parte de este concierto'**
  String get concertNotFoundHint;

  /// No description provided for @backLabel.
  ///
  /// In es, this message translates to:
  /// **'Volver'**
  String get backLabel;

  /// No description provided for @importBackupTab.
  ///
  /// In es, this message translates to:
  /// **'Copia de seguridad'**
  String get importBackupTab;

  /// No description provided for @importFromSpotifyTitle.
  ///
  /// In es, this message translates to:
  /// **'Importar desde Spotify'**
  String get importFromSpotifyTitle;

  /// No description provided for @importFromSpotifyDesc.
  ///
  /// In es, this message translates to:
  /// **'Conecta tu cuenta y ve tus artistas favoritos'**
  String get importFromSpotifyDesc;

  /// No description provided for @limitSheetTitle.
  ///
  /// In es, this message translates to:
  /// **'Límite de conciertos gratuito'**
  String get limitSheetTitle;

  /// No description provided for @limitSheetBody.
  ///
  /// In es, this message translates to:
  /// **'Tienes {current} conciertos de un máximo de {max} en la versión gratuita. Has seleccionado {selected} conciertos para importar{room, plural, =0{ y ya has alcanzado el límite.} other{, pero solo caben {room} más.}}'**
  String limitSheetBody(int current, int max, int selected, int room);

  /// No description provided for @limitImportFirstTitle.
  ///
  /// In es, this message translates to:
  /// **'Importar los primeros {count}'**
  String limitImportFirstTitle(int count);

  /// No description provided for @limitImportFirstDesc.
  ///
  /// In es, this message translates to:
  /// **'Se importarán los primeros {count} conciertos seleccionados'**
  String limitImportFirstDesc(int count);

  /// No description provided for @limitChooseTitle.
  ///
  /// In es, this message translates to:
  /// **'Elegir manualmente'**
  String get limitChooseTitle;

  /// No description provided for @limitChooseDesc.
  ///
  /// In es, this message translates to:
  /// **'Vuelve a la lista y selecciona solo los que quieras'**
  String get limitChooseDesc;

  /// No description provided for @limitProTitle.
  ///
  /// In es, this message translates to:
  /// **'Hazte Pro'**
  String get limitProTitle;

  /// No description provided for @limitProDesc.
  ///
  /// In es, this message translates to:
  /// **'Sin límite de conciertos y más funciones'**
  String get limitProDesc;

  /// No description provided for @backupRestoreTitle.
  ///
  /// In es, this message translates to:
  /// **'Restaurar copia de seguridad'**
  String get backupRestoreTitle;

  /// No description provided for @backupRestoreIntro.
  ///
  /// In es, this message translates to:
  /// **'Selecciona el archivo JSON generado desde Ajustes → Exportar mis conciertos para recuperar todos tus conciertos.'**
  String get backupRestoreIntro;

  /// No description provided for @backupHowTo.
  ///
  /// In es, this message translates to:
  /// **'Para crear una copia de seguridad ve a Ajustes → \"Exportar mis conciertos\" y elige JSON. El archivo incluye todos los datos e imágenes.'**
  String get backupHowTo;

  /// No description provided for @backupPickFile.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar archivo JSON'**
  String get backupPickFile;

  /// No description provided for @backupInvalidFile.
  ///
  /// In es, this message translates to:
  /// **'Archivo no válido: {detail}'**
  String backupInvalidFile(String detail);

  /// No description provided for @backupFormatUnrecognized.
  ///
  /// In es, this message translates to:
  /// **'formato de copia de seguridad no reconocido'**
  String get backupFormatUnrecognized;

  /// No description provided for @backupOwnCount.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 concierto propio} other{{count} conciertos propios}}'**
  String backupOwnCount(int count);

  /// No description provided for @backupDeselectAll.
  ///
  /// In es, this message translates to:
  /// **'Deseleccionar todo'**
  String get backupDeselectAll;

  /// No description provided for @backupSelectAll.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar todo'**
  String get backupSelectAll;

  /// No description provided for @backupRestoreAll.
  ///
  /// In es, this message translates to:
  /// **'Restaurar todo'**
  String get backupRestoreAll;

  /// No description provided for @backupRestoreSelected.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{Restaurar 1 seleccionado} other{Restaurar {count} seleccionados}}'**
  String backupRestoreSelected(int count);

  /// No description provided for @backupSharedNotRestorable.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 compartido (no restaurable)} other{{count} compartidos (no restaurables)}}'**
  String backupSharedNotRestorable(int count);

  /// No description provided for @backupRestoredOk.
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 concierto restaurado correctamente ✅} other{{count} conciertos restaurados correctamente ✅}}'**
  String backupRestoredOk(int count);

  /// No description provided for @backupRestoredPartial.
  ///
  /// In es, this message translates to:
  /// **'{restored} restaurados · {failed} fallaron'**
  String backupRestoredPartial(int restored, int failed);

  /// No description provided for @backupFailedTitle.
  ///
  /// In es, this message translates to:
  /// **'Conciertos que fallaron:'**
  String get backupFailedTitle;

  /// No description provided for @backupRetryFailed.
  ///
  /// In es, this message translates to:
  /// **'Reintentar {count} fallidos'**
  String backupRetryFailed(int count);

  /// No description provided for @backupRestoring.
  ///
  /// In es, this message translates to:
  /// **'Restaurando...'**
  String get backupRestoring;

  /// No description provided for @sharedFromUser.
  ///
  /// In es, this message translates to:
  /// **'De: {name}'**
  String sharedFromUser(String name);

  /// No description provided for @spotifyConnect.
  ///
  /// In es, this message translates to:
  /// **'Conectar con Spotify'**
  String get spotifyConnect;

  /// No description provided for @spotifyConnecting.
  ///
  /// In es, this message translates to:
  /// **'Conectando…'**
  String get spotifyConnecting;

  /// No description provided for @spotifyDisconnect.
  ///
  /// In es, this message translates to:
  /// **'Desconectar Spotify'**
  String get spotifyDisconnect;

  /// No description provided for @spotifyConnectTitle.
  ///
  /// In es, this message translates to:
  /// **'Conecta tu cuenta de Spotify'**
  String get spotifyConnectTitle;

  /// No description provided for @spotifyImportConnectDesc.
  ///
  /// In es, this message translates to:
  /// **'Verás tus artistas más escuchados y podrás añadir conciertos con un toque.'**
  String get spotifyImportConnectDesc;

  /// No description provided for @spotifyYourFavoriteArtists.
  ///
  /// In es, this message translates to:
  /// **'Tus artistas favoritos'**
  String get spotifyYourFavoriteArtists;

  /// No description provided for @spotifyTapArtistHint.
  ///
  /// In es, this message translates to:
  /// **'Toca un artista para añadir un concierto'**
  String get spotifyTapArtistHint;

  /// No description provided for @spotifyConnectError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo conectar con Spotify'**
  String get spotifyConnectError;

  /// No description provided for @spotifyPlaylistTitle.
  ///
  /// In es, this message translates to:
  /// **'Tus canciones favoritas'**
  String get spotifyPlaylistTitle;

  /// No description provided for @spotifyPlaylistConnectDesc.
  ///
  /// In es, this message translates to:
  /// **'Vincula Spotify para ver aquí tu playlist de canciones favoritas.'**
  String get spotifyPlaylistConnectDesc;

  /// No description provided for @spotifyRelinkTitle.
  ///
  /// In es, this message translates to:
  /// **'Actualiza tu conexión con Spotify'**
  String get spotifyRelinkTitle;

  /// No description provided for @spotifyRelinkDesc.
  ///
  /// In es, this message translates to:
  /// **'Para ver tu playlist necesitamos un permiso adicional. Desconecta y vuelve a conectar tu cuenta de Spotify.'**
  String get spotifyRelinkDesc;

  /// No description provided for @spotifyRelinkButton.
  ///
  /// In es, this message translates to:
  /// **'Re-vincular Spotify'**
  String get spotifyRelinkButton;

  /// No description provided for @spotifyPlaylistLoadError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo cargar tu playlist'**
  String get spotifyPlaylistLoadError;

  /// No description provided for @spotifyAccessDenied.
  ///
  /// In es, this message translates to:
  /// **'Spotify rechazó el acceso a esta cuenta. Puede que la app esté en modo de desarrollo y esta cuenta no esté en la lista de usuarios permitidos.'**
  String get spotifyAccessDenied;

  /// No description provided for @spotifyLinkError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo vincular Spotify: {error}'**
  String spotifyLinkError(String error);

  /// No description provided for @spotifyTopTracksTitle.
  ///
  /// In es, this message translates to:
  /// **'Mis canciones favoritas'**
  String get spotifyTopTracksTitle;

  /// No description provided for @spotifyTopTracksConnectTitle.
  ///
  /// In es, this message translates to:
  /// **'Tus canciones más escuchadas'**
  String get spotifyTopTracksConnectTitle;

  /// No description provided for @spotifyTopTracksConnectDesc.
  ///
  /// In es, this message translates to:
  /// **'Conecta tu cuenta de Spotify para ver aquí tus canciones favoritas.'**
  String get spotifyTopTracksConnectDesc;

  /// No description provided for @spotifyTopTracksCount.
  ///
  /// In es, this message translates to:
  /// **'Tus {count} canciones más escuchadas'**
  String spotifyTopTracksCount(int count);

  /// No description provided for @spotifyDataFrom.
  ///
  /// In es, this message translates to:
  /// **'Datos de Spotify'**
  String get spotifyDataFrom;

  /// No description provided for @spotifyLoadError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo cargar'**
  String get spotifyLoadError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
