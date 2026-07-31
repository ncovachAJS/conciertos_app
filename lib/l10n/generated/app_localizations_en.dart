// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get retry => 'Retry';

  @override
  String get close => 'Close';

  @override
  String get search => 'Search';

  @override
  String get add => 'Add';

  @override
  String get publish => 'Publish';

  @override
  String get done => 'Done';

  @override
  String get tag => 'Tag';

  @override
  String get all => 'All';

  @override
  String get understood => 'Got it';

  @override
  String get error => 'Error';

  @override
  String get loading => 'Loading...';

  @override
  String get importing => 'Importing...';

  @override
  String get deleting => 'Deleting...';

  @override
  String get year => 'Year';

  @override
  String get country => 'Country';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get registerTitle => 'Create account';

  @override
  String get forgotPasswordTitle => 'Recover password';

  @override
  String get forgotPasswordLink => 'Forgot your password?';

  @override
  String get noAccountSignUp => 'Don\'t have an account? Create one';

  @override
  String get sendLink => 'Send link';

  @override
  String get backToLogin => 'Back to login';

  @override
  String get connectionError => 'Connection error. Try again.';

  @override
  String get concertsTitle => 'Concerts';

  @override
  String get searchConcertsHint => 'Artist, festival, city, venue...';

  @override
  String get deleteConcert => 'Delete concert';

  @override
  String get sharedBadge => 'Shared';

  @override
  String get viewConcert => 'View concert';

  @override
  String get couldNotUpdateFavorite => 'Could not update favorite';

  @override
  String get couldNotUpdateLike => 'Could not update like';

  @override
  String get deletingConcert => 'Deleting...';

  @override
  String get searchArtistSpotify => 'Search artist on Spotify';

  @override
  String get artistNameHint => 'Artist name...';

  @override
  String get dateLabel => 'Date';

  @override
  String get venueLabel => 'Venue / Stadium';

  @override
  String get cityLabel => 'City';

  @override
  String get concertLabel => 'Concert';

  @override
  String get addConcertsForStats => 'Add concerts to see your statistics.';

  @override
  String get noConcerts => 'No concerts yet.';

  @override
  String get noConcertsYet => 'You have no concerts yet.';

  @override
  String get addConcertTitle => 'Add concert';

  @override
  String get editConcertTitle => 'Edit concert';

  @override
  String get artistLabel => 'Artist';

  @override
  String get festivalLabel => 'Festival';

  @override
  String get concertNameLabel => 'Concert name';

  @override
  String get concertNameHint => 'e.g. Iron Maiden - Future Past Tour';

  @override
  String get imageUploadedSuccess => '✅ Image uploaded successfully';

  @override
  String get imageUploadError => 'Could not upload image. Try again.';

  @override
  String get concertSaveError => 'Could not save concert. Try again.';

  @override
  String get onThisDay => 'ON THIS DAY';

  @override
  String get upcomingConcerts => 'UPCOMING CONCERTS';

  @override
  String get statisticsSection => 'STATISTICS';

  @override
  String get recommendedSection => 'RECOMMENDED';

  @override
  String get yourFavorites => 'YOUR FAVORITES';

  @override
  String get recentlyAdded => 'RECENTLY ADDED';

  @override
  String errorLoadingData(String error) {
    return 'Error loading: $error';
  }

  @override
  String get noConcertsUpcoming => 'No upcoming concerts 🎸';

  @override
  String get concertToday => '🎉 Concert today!';

  @override
  String get concertTomorrow => '🔥 Back live tomorrow';

  @override
  String daysLeft(int days) {
    return '⏳ $days days left';
  }

  @override
  String get today => 'Today';

  @override
  String get live => 'Live';

  @override
  String get noFavorites => 'No favorite concerts yet.';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get tagline => 'Every concert tells a story.';

  @override
  String get readyForNext => 'Ready for the next one.';

  @override
  String get defaultNickname => 'Rocker';

  @override
  String get epicMonth => 'Epic month!';

  @override
  String epicMonthDesc(int count) {
    return '$count concerts this month — you\'re on a roll';
  }

  @override
  String get goodMonth => 'Good month';

  @override
  String goodMonthDesc(int count) {
    return '$count concerts this month';
  }

  @override
  String get justGotOut => 'Just got back';

  @override
  String lastConcertDaysAgo(int days) {
    return 'Last concert $days days ago';
  }

  @override
  String get longTime => 'It\'s been a while';

  @override
  String longTimeDesc(int days) {
    return '$days days without concerts — time to go back!';
  }

  @override
  String howWasArtist(String artist) {
    return 'How was $artist?';
  }

  @override
  String get noRatingYet => 'You haven\'t rated this concert yet';

  @override
  String onThisDayYearsAgo(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years years ago',
      one: '1 year ago',
    );
    return '$_temp0';
  }

  @override
  String onThisDayInDays(int days, int years) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    String _temp1 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years years ago',
      one: '1 year ago',
    );
    return 'In $_temp0, $_temp1';
  }

  @override
  String onThisDayAgoDays(int days, int years) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days ago',
      one: '1 day ago',
    );
    String _temp1 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years years ago',
      one: '1 year ago',
    );
    return '$_temp0, $_temp1';
  }

  @override
  String get statisticsTitle => 'Statistics';

  @override
  String get totalConcertsLabel => 'Concerts';

  @override
  String get uniqueArtistsLabel => 'Artists';

  @override
  String get uniqueFestivalsLabel => 'Festivals';

  @override
  String get avgRatingLabel => 'Avg. rating';

  @override
  String get activeYearLabel => 'Active year';

  @override
  String get activeYearsLabel => 'Active years';

  @override
  String get favoriteMonthLabel => 'Favorite month';

  @override
  String get concertsByYear => 'Concerts per year';

  @override
  String get topArtists => 'Most seen artists';

  @override
  String get topFestivals => 'Most visited festivals';

  @override
  String get favoriteCities => 'Favorite cities';

  @override
  String get ratingDistribution => 'Rating distribution';

  @override
  String get noDataDash => '—';

  @override
  String get monthJanuary => 'January';

  @override
  String get monthFebruary => 'February';

  @override
  String get monthMarch => 'March';

  @override
  String get monthApril => 'April';

  @override
  String get monthMay => 'May';

  @override
  String get monthJune => 'June';

  @override
  String get monthJuly => 'July';

  @override
  String get monthAugust => 'August';

  @override
  String get monthSeptember => 'September';

  @override
  String get monthOctober => 'October';

  @override
  String get monthNovember => 'November';

  @override
  String get monthDecember => 'December';

  @override
  String get myProfile => 'My profile';

  @override
  String get signIn => 'Sign in';

  @override
  String get createAccount => 'Create account';

  @override
  String get signOut => 'Sign out';

  @override
  String get friendsTitle => 'Friends';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get aboutTitle => 'About';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get profilePhotoUpdated => 'Profile photo updated ✅';

  @override
  String get concertsStatLabel => 'Concerts';

  @override
  String get favoritesStatLabel => 'Favorites';

  @override
  String get memoriesStatLabel => 'Memories';

  @override
  String get likedLabel => 'Liked';

  @override
  String get accountSection => 'Account';

  @override
  String get changeName => 'Change name';

  @override
  String get usernameLabel => 'Username';

  @override
  String get changePassword => 'Change password';

  @override
  String get preferencesSection => 'Preferences';

  @override
  String get notificationsLabel => 'Notifications';

  @override
  String get upcomingConcertAlerts => 'Upcoming concert alerts';

  @override
  String get languageSection => 'Language';

  @override
  String get appearanceSection => 'Appearance';

  @override
  String get newNameLabel => 'New name';

  @override
  String get currentPasswordLabel => 'Current password';

  @override
  String get newPasswordLabel => 'New password';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get passwordsNoMatch => 'Passwords don\'t match';

  @override
  String get nameUpdated => 'Name updated ✅';

  @override
  String get passwordUpdated => 'Password updated ✅';

  @override
  String get changeNameTitle => 'Change name';

  @override
  String get changePasswordTitle => 'Change password';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageEnglish => 'English';

  @override
  String get changeLanguageTitle => 'Language';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get creditsLabel => 'Credits';

  @override
  String get technologiesUsed => 'Technologies used:';

  @override
  String get contact => 'Contact';

  @override
  String get deleteFriendTitle => 'Remove friend';

  @override
  String get friendRequestReceived => 'Wants to be your friend';

  @override
  String get searchFriendHint => 'Search by name or email...';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get markRead => 'Read';

  @override
  String get deleteAll => 'Delete all';

  @override
  String get deleteNotificationsTitle => 'Delete notifications';

  @override
  String get deleteNotificationsConfirm =>
      'Are you sure you want to delete all notifications?';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get favoritesError => 'Error loading favorites';

  @override
  String get searchArtistHint => 'Search artist...';

  @override
  String get noFavoritesMessage => 'No favorites yet.';

  @override
  String concertCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count concerts',
      one: '1 concert',
    );
    return '$_temp0';
  }

  @override
  String get memoriesTitle => 'Memories';

  @override
  String get deletePhotosTitle => 'Delete photos';

  @override
  String deletePhotosConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos',
      one: '1 photo',
    );
    return 'Are you sure you want to delete $_temp0?\nThis action cannot be undone.';
  }

  @override
  String get deletePhotoTitle => 'Delete photo';

  @override
  String get deletePhotoConfirm =>
      'Are you sure you want to delete this memory?';

  @override
  String get noMemories =>
      'No memories yet.\nAdd photos from a concert\'s detail.';

  @override
  String get noMemoriesShort => 'No memories yet. Add your concert photos!';

  @override
  String get deletingPhotos => 'Deleting photos...';

  @override
  String get tagPeople => 'Tag people';

  @override
  String get newMemory => 'New memory';

  @override
  String get captionHint => 'Caption (optional)';

  @override
  String photoUploadError(String error) {
    return 'Error uploading photo: $error';
  }

  @override
  String get gridView => 'Grid view';

  @override
  String get timelineView => 'Timeline view';

  @override
  String get noDate => 'No date';

  @override
  String get deleteSelection => 'Delete selection';

  @override
  String selectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selected',
      one: '1 selected',
    );
    return '$_temp0';
  }

  @override
  String uploadingPhotos(int current, int total) {
    return 'Uploading $current/$total...';
  }

  @override
  String get importTitle => 'Import concerts';

  @override
  String get importSearchArtist => 'Search for an artist';

  @override
  String get importFromSetlist => 'Import concerts from Setlist.fm';

  @override
  String get artistHint => 'Artist...';

  @override
  String importFoundCount(int count) {
    return '$count found';
  }

  @override
  String importSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get importSearchPrompt =>
      'Search for an artist\nto see their concerts';

  @override
  String get loadMore => 'Load more';

  @override
  String importButton(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Import $count concerts',
      one: 'Import 1 concert',
    );
    return '$_temp0';
  }

  @override
  String importSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count concerts imported 🎸',
      one: '1 concert imported 🎸',
    );
    return '$_temp0';
  }

  @override
  String get recommendedTitle => 'Recommended';

  @override
  String get noLikesForRecommendations =>
      'Like artists to get recommendations.';

  @override
  String becauseYouLike(String artist) {
    return 'Because you like $artist';
  }

  @override
  String get viewOnTicketmaster => 'View on Ticketmaster';

  @override
  String get noConcertsAddForRec => 'Add concerts to see recommendations.';

  @override
  String get noUpcomingEvents =>
      'No upcoming events found. Your most visited artists:';

  @override
  String get searchHintBar => 'Search artist or festival...';

  @override
  String get artistConcertSingular => 'concert';

  @override
  String get artistConcertPlural => 'concerts';

  @override
  String get artistAvgRating => 'avg. rating';

  @override
  String get artistCitySingular => 'city';

  @override
  String get artistCityPlural => 'cities';

  @override
  String get artistFirstConcert => 'First concert';

  @override
  String get artistBest => 'Best';

  @override
  String get artistUpcoming => 'UPCOMING';

  @override
  String get artistHistory => 'HISTORY';

  @override
  String get actionAdd => 'Add';

  @override
  String get actionTickets => 'Tickets';

  @override
  String get actionStats => 'Stats';

  @override
  String get actionImport => 'Import';

  @override
  String get tutorialWelcomeTitle => 'Welcome to La Vida en Directo!';

  @override
  String get tutorialWelcomeDesc =>
      'Your personal concert diary. Here you\'ll find everything you need to remember every live show.';

  @override
  String get tutorialAddTitle => 'Add your first concert';

  @override
  String get tutorialAddDesc =>
      'Tap the \"Add\" button to log a concert. You can add the date, venue, photos and rate it.';

  @override
  String get tutorialImportTitle => 'Import from Setlist.fm';

  @override
  String get tutorialImportDesc =>
      'Use the \"Import\" button to automatically bring concerts from Setlist.fm with a single tap.';

  @override
  String get tutorialFavoritesTitle => 'Save your favorites';

  @override
  String get tutorialFavoritesDesc =>
      'Mark your favorite artists. You\'ll find them grouped in the Favorites tab.';

  @override
  String get tutorialMemoriesTitle => 'Save your memories';

  @override
  String get tutorialMemoriesDesc =>
      'In the Memories tab you can see all your concert photos organized by year.';

  @override
  String get tutorialAddConcertTitle => 'Add a concert';

  @override
  String get tutorialAddConcertDesc =>
      'Fill in the artist name, date and venue. Everything else is optional.';

  @override
  String get tutorialAddImageTitle => 'Add an image';

  @override
  String get tutorialAddImageDesc =>
      'You can add a photo of the concert or the artist. It will be used as the cover in your collection.';

  @override
  String get tutorialRateTitle => 'Rate your experience';

  @override
  String get tutorialRateDesc =>
      'For past concerts you can add a rating from 1 to 5 stars. Tap the active star to remove it.';

  @override
  String get tutorialLikeTitle => 'Like and Favorite';

  @override
  String get tutorialLikeDesc =>
      '👍 \"Like\" marks concerts you enjoyed. ⭐ \"Favorite\" groups the artist in your favorites list.';

  @override
  String get tutorialDetailTitle => 'Concert detail';

  @override
  String get tutorialDetailDesc =>
      'Here you see all the concert info: date, venue, city and your photos.';

  @override
  String get tutorialEditTitle => 'Edit anytime';

  @override
  String get tutorialEditDesc =>
      'Tap the ✏️ icon at the top right to edit any detail or change the image.';

  @override
  String get tutorialSetlistTitle => 'Automatic setlist';

  @override
  String get tutorialSetlistDesc =>
      'If the concert is on Setlist.fm, you\'ll automatically see the songs they played that night.';

  @override
  String get tutorialPhotosTitle => 'Add your photos';

  @override
  String get tutorialPhotosDesc =>
      'In the Memories section you can add as many photos as you want from the concert. Multi-selection supported.';

  @override
  String get splashTagline => 'Every concert tells a story.';

  @override
  String get navHome => 'Home';

  @override
  String get navConcerts => 'Concerts';

  @override
  String get navMemories => 'Memories';

  @override
  String get navFavorites => 'Favorites';

  @override
  String get navStats => 'Stats';

  @override
  String get setlistTitle => 'Setlist';

  @override
  String setlistSongCount(int count) {
    return '$count songs';
  }

  @override
  String get setlistNotFound => 'No setlist found for this concert.';

  @override
  String get setlistShowLess => 'Show less';

  @override
  String setlistShowRemaining(int count) {
    return 'Show remaining $count songs';
  }

  @override
  String setlistCoverOf(String artist) {
    return 'Cover of $artist';
  }

  @override
  String setlistWith(String artist) {
    return 'with $artist';
  }

  @override
  String get notifMarkAllRead => 'Mark all as read';

  @override
  String get notifMemoriesToday => 'Memories from today';

  @override
  String notifYearsAgoArtist(int years, String artist) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years years',
      one: '1 year',
    );
    return '$_temp0 ago: $artist';
  }

  @override
  String get notifUpcomingSection => 'Upcoming concerts';

  @override
  String notifTodaySubtitle(String venue, String city) {
    return 'Today! · $venue, $city';
  }

  @override
  String notifTomorrowSubtitle(String venue, String city) {
    return 'Tomorrow! · $venue, $city';
  }

  @override
  String notifDaysSubtitle(int days, String venue, String city) {
    return '$days days left · $venue, $city';
  }

  @override
  String get notifRecommendationsSection => 'Recommendations';

  @override
  String get notifNoRecsHint =>
      'Mark artists as favorites to get recommendations.';

  @override
  String get notifEmpty =>
      'No notifications yet.\nAdd concerts to get started.';

  @override
  String get buyTickets => 'Buy tickets';

  @override
  String get appTitleLine1 => 'LIVE';

  @override
  String get appTitleLine2 => 'IN CONCERT';

  @override
  String memberNumber(String number) {
    return 'MEMBER #$number';
  }

  @override
  String deleteConcertConfirm(String name) {
    return 'Are you sure you want to delete \"$name\"?\nThis action cannot be undone.';
  }

  @override
  String concertDeleteError(String error) {
    return 'Could not delete: $error';
  }

  @override
  String artistNotFound(String error) {
    return 'Artist not found: $error';
  }

  @override
  String get setlistComingSoon =>
      'The setlist will be available\nafter the concert.';

  @override
  String spotifyFollowers(String count) {
    return '$count followers';
  }

  @override
  String get openInSpotify => 'Open in Spotify';

  @override
  String get participantsAlsoWere => 'Also attended';

  @override
  String get participantsAlsoGoing => 'Also going';

  @override
  String get artistRequired => 'Enter the artist name';

  @override
  String get dateRequired => 'Select a date';

  @override
  String get selectImage => 'Select image';

  @override
  String get ratingTitle => 'Rating';

  @override
  String get ratingNone => 'Not rated';

  @override
  String ratingStars(int rating) {
    return '$rating out of 5 stars';
  }

  @override
  String get howWasItTitle => 'What did you think?';

  @override
  String get likedYes => 'I liked it';

  @override
  String get likedNo => 'Did you like it?';

  @override
  String get addedToFavorites => 'Added to favorites';

  @override
  String get markAsFavorite => 'Mark as favorite?';

  @override
  String get savingLabel => 'Saving...';

  @override
  String get saveConcert => 'Save concert';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get noFriendsYet => 'No friends yet. Add them from your profile.';

  @override
  String get whoElseWas => 'Who else was there?';

  @override
  String get whoElseGoing => 'Who else is going?';

  @override
  String get splashLoading1 => '🎸 Setting up the stage...';

  @override
  String get splashLoading2 => '🔊 Testing the sound...';

  @override
  String get splashLoading3 => '💡 Turning on the lights...';

  @override
  String get splashLoading4 => '🎫 Loading concerts...';

  @override
  String get splashLoading5 => '📸 Organizing memories...';

  @override
  String get splashLoading6 => '🤘 Let the show begin!';

  @override
  String get tabPast => 'Past';

  @override
  String get tabUpcoming => 'Upcoming';

  @override
  String get tabShared => 'Shared';

  @override
  String get listViewTooltip => 'List view';

  @override
  String get cardViewTooltip => 'Card view';

  @override
  String concertDeleted(String name) {
    return '\"$name\" deleted';
  }

  @override
  String get concertDeleteFailed => 'Could not delete the concert';

  @override
  String get noPastConcerts => 'No past concerts yet.';

  @override
  String get noUpcomingConcertsAdd => 'No upcoming concerts.\nAdd one!';

  @override
  String get noSharedConcerts =>
      'No friends have shared concerts with you yet.';

  @override
  String get mapVenueLocation => 'Venue location';

  @override
  String get mapOpenIn => 'Open in maps';

  @override
  String get mapNotAvailable => 'Map not available';
}
