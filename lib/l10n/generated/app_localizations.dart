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
  /// **'Nombre del concierto'**
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
  /// **'Hace {years} {years, plural, =1{año} other{años}}'**
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

  /// No description provided for @actionTickets.
  ///
  /// In es, this message translates to:
  /// **'Entradas'**
  String get actionTickets;

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
