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
  String get concertNameLabel => 'Tour name';

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
      other: 'On this exact day, $years years ago',
      one: 'On this exact day, 1 year ago',
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
  String onThisDaySeeMore(int count) {
    return 'See $count more';
  }

  @override
  String get onThisDaySeeLess => 'See less';

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
  String get friendsSearchPeople => 'Search people';

  @override
  String friendsTabFriends(int count) {
    return 'Friends ($count)';
  }

  @override
  String get friendsTabRequests => 'Requests';

  @override
  String friendsTabRequestsCount(int count) {
    return 'Requests ($count)';
  }

  @override
  String get friendsTypeToSearch => 'Type at least 2 characters';

  @override
  String get friendsNoUsersFound => 'No users found';

  @override
  String get friendAlreadyFriend => 'Friend ✓';

  @override
  String get friendRequestSent => 'Sent';

  @override
  String get friendAccept => 'Accept';

  @override
  String get friendReject => 'Decline';

  @override
  String get friendAdd => 'Add';

  @override
  String get friendsNoFriendsHere =>
      'No friends yet.\nSearch with the icon above.';

  @override
  String friendDeleteConfirm(String name) {
    return 'Are you sure you want to remove $name?';
  }

  @override
  String get friendsNoPendingRequests => 'No pending requests.';

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
      'No memories yet.\nTap the camera icon to add your first photos.';

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
  String get actionEvents => 'Events';

  @override
  String get actionStats => 'Stats';

  @override
  String get actionImport => 'Import';

  @override
  String get ticketWalletTitle => 'My ticket';

  @override
  String get ticketWalletEmptyDescription =>
      'Keep your ticket here (photo or PDF). It stays on this device only, never uploaded to our servers.';

  @override
  String get ticketWalletFestivalTitle => 'Festival ticket';

  @override
  String get ticketWalletFestivalEmptyDescription =>
      'Keep the festival pass here (photo or PDF). It\'s shared across all concerts from this festival and stays on this device only.';

  @override
  String get ticketWalletAddPhoto => 'Photo';

  @override
  String get ticketWalletAddPdf => 'PDF';

  @override
  String get ticketWalletView => 'View';

  @override
  String get ticketWalletDelete => 'Delete';

  @override
  String get ticketWalletLocalBadge => 'On this device only';

  @override
  String get ticketWalletConfirmDeleteTitle => 'Delete ticket?';

  @override
  String get ticketWalletConfirmDeleteBody =>
      'It will only be removed from this device.';

  @override
  String get ticketWalletPdfFile => 'PDF ticket';

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
  String get tutorialConcertsTitle => 'Your concert collection';

  @override
  String get tutorialConcertsDesc =>
      'Here are all the concerts you have logged. Use the search bar to filter by artist, city or festival.';

  @override
  String get tutorialConcertsViewTitle => 'Three ways to view them';

  @override
  String get tutorialConcertsViewDesc =>
      'Switch between list, grid or calendar with the icons at the top right. Each view has its moment.';

  @override
  String get tutorialConcertsCalTitle => 'Calendar view';

  @override
  String get tutorialConcertsCalDesc =>
      'In the calendar you can see your concerts by date and add a new one by tapping any day.';

  @override
  String get tutorialStatsOverviewTitle => 'Your musical history';

  @override
  String get tutorialStatsOverviewDesc =>
      'A summary of all your activity: concerts, unique artists, festivals and cities you have visited.';

  @override
  String get tutorialStatsChartTitle => 'Evolution by year';

  @override
  String get tutorialStatsChartDesc =>
      'The chart shows how many concerts you attended each year. Discover your most active periods.';

  @override
  String get tutorialStatsTopTitle => 'Your personal tops';

  @override
  String get tutorialStatsTopDesc =>
      'Rankings of most visited artists, cities and festivals. Is there a clear winner?';

  @override
  String get tutorialProfileOverviewTitle => 'Your profile';

  @override
  String get tutorialProfileOverviewDesc =>
      'Here you see your personal summary: concerts, photos, and access to settings. Tap your avatar to change it.';

  @override
  String get tutorialProfileAchTitle => 'Achievements and trophies';

  @override
  String get tutorialProfileAchDesc =>
      'Earn achievements by attending concerts. The list expands to show all. Tap one to see what it takes.';

  @override
  String get tutorialFriendsConnectTitle => 'Connect with friends';

  @override
  String get tutorialFriendsConnectDesc =>
      'Search for your friends by name and send them a request. That way you can see each other\'s concerts.';

  @override
  String get tutorialFriendsTabsTitle => 'Friends and requests';

  @override
  String get tutorialFriendsTabsDesc =>
      'The first tab shows your current friends. The second manages pending requests you have received.';

  @override
  String get tutorialFriendsActivityTitle => 'Friends\' activity';

  @override
  String get tutorialFriendsActivityDesc =>
      'When a friend adds a concert you will get a notification. You can also view their profile and concert list.';

  @override
  String get tutorialFeedPhotosTitle => 'Memories in photos';

  @override
  String get tutorialFeedPhotosDesc =>
      'Here are the photos from your concerts and your friends\'. A shared album of the live music world.';

  @override
  String get tutorialFeedViewTitle => 'Grid or timeline';

  @override
  String get tutorialFeedViewDesc =>
      'Toggle between the grid and the chronological view with the icon above. The timeline groups photos by concert.';

  @override
  String get tutorialRecsDiscoverTitle => 'Discover new concerts';

  @override
  String get tutorialRecsDiscoverDesc =>
      'Based on the artists you have already seen, we suggest upcoming concerts. Filter by country to narrow it down.';

  @override
  String get tutorialRecsWantTitle => 'Want to go';

  @override
  String get tutorialRecsWantDesc =>
      'Tap 🎟️ on any event to save it to your «Want to go» list. You will find it in the second tab.';

  @override
  String get tutorialImportSearchTitle => 'Import from Setlist.fm';

  @override
  String get tutorialImportSearchDesc =>
      'Type an artist name to see all their past concerts available on Setlist.fm.';

  @override
  String get tutorialImportSelectTitle => 'Select and import';

  @override
  String get tutorialImportSelectDesc =>
      'Check the concerts you attended and tap Import. The app will automatically find the image and genre.';

  @override
  String get tutorialSettingsSection => 'Help';

  @override
  String get tutorialSettingsLabel => 'Usage guides';

  @override
  String get tutorialSettingsSubtitle => 'Replay the tutorial for any screen';

  @override
  String get tutorialPickerTitle => 'What do you want to review?';

  @override
  String get tutorialPickerDashboard => 'Home';

  @override
  String get tutorialPickerConcerts => 'Concerts';

  @override
  String get tutorialPickerAddConcert => 'Add concert';

  @override
  String get tutorialPickerDetail => 'Concert detail';

  @override
  String get tutorialPickerStats => 'Statistics';

  @override
  String get tutorialPickerProfile => 'Profile';

  @override
  String get tutorialPickerFriends => 'Friends';

  @override
  String get tutorialPickerFeed => 'Memories';

  @override
  String get tutorialPickerRecs => 'Discover';

  @override
  String get tutorialPickerImport => 'Import';

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

  @override
  String get concertMapTitle => 'Concert map';

  @override
  String get concertMapDashboardSubtitle => 'All your venues on a map';

  @override
  String get concertMapLoading => 'Locating venues…';

  @override
  String concertMapProgress(int done, int total) {
    return '$done of $total venues';
  }

  @override
  String get concertMapNoData =>
      'Add concerts with a venue or city\nto see them on the map.';

  @override
  String get concertMapConcertsHere => 'Concerts here';

  @override
  String get concertMapOpenInMaps => 'Open in Maps';

  @override
  String profileAvatarUploadError(String error) {
    return 'Error uploading photo: $error';
  }

  @override
  String get fanLevelLegend => '🤘 LIVE MUSIC LEGEND';

  @override
  String get fanLevelHeadliner => '🥇 HEADLINER';

  @override
  String get fanLevelRoadie => '🥈 ROADIE';

  @override
  String get fanLevelRookie => '🥉 ROOKIE';

  @override
  String get fanSinceThisYear => 'Fan since this year';

  @override
  String fanSinceYear(int year) {
    return 'Fan since $year';
  }

  @override
  String get deleteAccountTitle => '⚠️ Delete account';

  @override
  String get deleteAccountWarning =>
      'This action is irreversible. All your concerts, photos, friends and account data will be deleted.';

  @override
  String get continueLabel => 'Continue';

  @override
  String get confirmPasswordTitle => 'Confirm your password';

  @override
  String get deleteAccountButton => 'Delete account';

  @override
  String genericErrorDetail(String error) {
    return 'Error: $error';
  }

  @override
  String get profileAccreditationTitle => 'Your credentials';

  @override
  String get profileAccreditationSubtitle => 'Your music history at a glance.';

  @override
  String get guestLabel => 'Guest';

  @override
  String get wrappedCardTitle => 'Your year in concerts';

  @override
  String get wrappedCardSubtitle => 'Yearly recap · shareable';

  @override
  String get pastYearsLabel => 'Previous years';

  @override
  String get toolsSectionTitle => 'Tools';

  @override
  String appFooterVersion(String version) {
    return 'Version $version';
  }

  @override
  String get uploadingAvatarLabel => 'Uploading photo...';

  @override
  String get annualGoalTitle => 'Annual concert goal';

  @override
  String get annualGoalQuestion =>
      'How many concerts do you want to see this year?';

  @override
  String get annualGoalNumberLabel => 'Number of concerts';

  @override
  String get removeGoal => 'Remove goal';

  @override
  String get changeEmailTitle => 'Change email';

  @override
  String get newEmailLabel => 'New email';

  @override
  String get emailUpdated => 'Email updated';

  @override
  String get noConcertsToExport => 'No concerts to export';

  @override
  String get exportCsvHeader =>
      'artist,name,date,venue,city,festival,genre,rating,favorite,price,notes';

  @override
  String get csvYes => 'yes';

  @override
  String get csvNo => 'no';

  @override
  String get exportShareSubject => 'My concerts — La Vida en Directo';

  @override
  String exportError(String error) {
    return 'Export error: $error';
  }

  @override
  String get exportDataTitle => 'Export my data';

  @override
  String get exportCsvLabel => 'CSV — Excel/Sheets';

  @override
  String get exportCsvDesc => 'Compatible with any spreadsheet';

  @override
  String get exportJsonLabel => 'JSON — backup';

  @override
  String get exportJsonDesc => 'Full format for importing in the future';

  @override
  String get noUpcomingConcertsToSync => 'You have no upcoming concerts to add';

  @override
  String get calendarNoEventsAdded => 'Could not add any event';

  @override
  String calendarEventsAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count concerts added to calendar',
      one: '1 concert added to calendar',
    );
    return '$_temp0';
  }

  @override
  String get cacheCleared => 'Image cache cleared';

  @override
  String get themeSystemDefault => 'System default';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get emailLabel => 'Email';

  @override
  String get friendActivityNotifTitle => 'Friends\' activity';

  @override
  String get friendActivityNotifDesc => 'When a friend adds a concert';

  @override
  String get recommendationsNotifTitle => 'Recommendations';

  @override
  String get recommendationsNotifDesc =>
      'Concerts suggested based on your taste';

  @override
  String get colorPaletteLabel => 'Color palette';

  @override
  String get splashSoundLabel => 'Startup sound';

  @override
  String get splashSoundDesc => 'Crowd ambience when opening the app';

  @override
  String get myDataSectionTitle => 'My data';

  @override
  String annualGoalSubtitleSet(int count) {
    return 'This year: $count concerts';
  }

  @override
  String get annualGoalSubtitleUnset => 'No goal set';

  @override
  String get exportConcertsLabel => 'Export my concerts';

  @override
  String get exportConcertsDesc => 'CSV or JSON — open it in Excel or save it';

  @override
  String get syncCalendarLabel => 'Sync with calendar';

  @override
  String get syncCalendarDesc =>
      'Add your upcoming concerts to your phone\'s calendar';

  @override
  String get clearCacheLabel => 'Clear image cache';

  @override
  String get clearCacheDesc => 'Free up storage space';

  @override
  String get supportSectionTitle => 'Support';

  @override
  String get reportIssueLabel => 'Report an issue';

  @override
  String get reportIssueDesc => 'Send a bug, suggestion or comment';

  @override
  String get jiraNotConfigured =>
      'Jira integration not configured — fill in the .env';

  @override
  String get exportingDialogTitle => 'Preparing export…';

  @override
  String get exportingDialogSubtitle => 'Loading photos for each concert';

  @override
  String get proBadgeLabel => 'Pro';

  @override
  String get mailtoSubject => 'La Vida en Directo - Contact';

  @override
  String get emailClientError => 'Could not open the email client';

  @override
  String get privacyPolicyBody =>
      'La Vida en Directo only collects the data necessary for the app to work: name, email and the concerts you add.\n\nYour data is stored securely and is never shared with third parties or used for advertising.\n\nYou can delete your account and all your data at any time from the app or by contacting us.';

  @override
  String get creditsDevelopedBy => 'Developed with ❤️ by Nico';

  @override
  String get creditFrontend => 'Mobile frontend';

  @override
  String get creditBackend => 'Backend API';

  @override
  String get creditDatabase => 'Database';

  @override
  String get creditImageStorage => 'Image storage';

  @override
  String get creditSetlistData => 'Setlist data';

  @override
  String get creditArtistData => 'Artist data';

  @override
  String get creditRecommendedEvents => 'Recommended events';

  @override
  String get aboutFooterTagline =>
      'Made with ❤️ for those who live for live music.';

  @override
  String get reportIssueIntroTitle => 'Is something not working as expected?';

  @override
  String get reportIssueIntroDesc =>
      'Tell us what happened and we\'ll look into it as soon as possible.';

  @override
  String get typeLabel => 'Type';

  @override
  String get titleLabel => 'Title';

  @override
  String get titleHint => 'Brief summary of the issue…';

  @override
  String get titleRequiredError => 'Write a title for the ticket';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get descBugHint =>
      'Describe the issue: what you did, what you expected and what happened…';

  @override
  String get descImprovementHint =>
      'Explain the improvement you\'d like to see…';

  @override
  String get descOtherHint => 'Write your comment or suggestion…';

  @override
  String get descRequiredError => 'Write a description before submitting';

  @override
  String get descTooShortError => 'The description is too short';

  @override
  String get autoInfoNote =>
      'The app version, platform and your email will be included automatically so we can contact you if needed.';

  @override
  String get issueSentTitle => 'Issue sent! 🎉';

  @override
  String ticketCreatedLabel(String key) {
    return 'Ticket created: $key';
  }

  @override
  String get sendingLabel => 'Sending…';

  @override
  String get sendIssueButton => 'Send issue';

  @override
  String get issueTypeBug => '🐛 Bug';

  @override
  String get issueTypeImprovement => '✨ Improvement';

  @override
  String get issueTypeOther => '💬 Other';

  @override
  String get achievementsSectionTitle => 'ACHIEVEMENTS';

  @override
  String achievementsSeeMoreCount(int count) {
    return 'See all achievements ($count more)';
  }

  @override
  String get achievementLocked => 'Locked';

  @override
  String get achievementUnlocked => 'Unlocked!';

  @override
  String get achievementUnlockedBanner => '🏆 Achievement unlocked';

  @override
  String get topArtistsTitle => 'My artists';

  @override
  String get topArtistsSubtitle => 'By concerts and rating';

  @override
  String get achvFirstConcertTitle => 'First show';

  @override
  String get achvFirstConcertDesc => 'Attend your first concert';

  @override
  String get achvFiveConcertsTitle => 'Regular';

  @override
  String get achvFiveConcertsDesc => '5 concerts under your belt';

  @override
  String get achvTwentyFiveTitle => 'Veteran';

  @override
  String get achvTwentyFiveDesc => '25 concerts isn\'t for everyone';

  @override
  String get achvFiftyConcertsTitle => 'Expert';

  @override
  String get achvFiftyConcertsDesc => '50 concerts. You\'ve seen it all';

  @override
  String get achvHundredConcertsTitle => 'Legend';

  @override
  String get achvHundredConcertsDesc =>
      '100 concerts. You\'re a live music legend';

  @override
  String get achvTwoHundredTitle => 'Immortal';

  @override
  String get achvTwoHundredDesc => '200 concerts. On another level';

  @override
  String get achvRockeroTitle => 'Rocker';

  @override
  String get achvRockeroDesc => '3 rock concerts';

  @override
  String get achvRockeroProTitle => 'Pure Rock';

  @override
  String get achvRockeroProDesc => '10 rock concerts';

  @override
  String get achvMetaleroTitle => 'Metalhead';

  @override
  String get achvMetaleroDesc => '3 metal or heavy concerts';

  @override
  String get achvUrbanoTitle => 'Urban';

  @override
  String get achvUrbanoDesc => '3 hip-hop, rap or trap concerts';

  @override
  String get achvFirstFestivalTitle => 'Festival Goer';

  @override
  String get achvFirstFestivalDesc => 'Your first festival';

  @override
  String get achvFiveFestivalsTitle => 'Festival Addict';

  @override
  String get achvFiveFestivalsDesc => '5 different festivals';

  @override
  String get achvTenFestivalsTitle => 'Festival King';

  @override
  String get achvTenFestivalsDesc => '10 different festivals';

  @override
  String get achvEclecticoTitle => 'Eclectic';

  @override
  String get achvEclecticoDesc => '10 different artists';

  @override
  String get achvExploradorTitle => 'Explorer';

  @override
  String get achvExploradorDesc => '25 different artists';

  @override
  String get achvColeccionistaTitle => 'Collector';

  @override
  String get achvColeccionistaDesc => '50 different artists';

  @override
  String get achvSuperfanTitle => 'Superfan';

  @override
  String get achvSuperfanDesc => 'Saw the same artist 3 times';

  @override
  String get achvObsesionadoTitle => 'Obsessed';

  @override
  String get achvObsesionadoDesc => 'Saw the same artist 5 times';

  @override
  String get achvViajeroTitle => 'Traveler';

  @override
  String get achvViajeroDesc => 'Concerts in 3 different cities';

  @override
  String get achvTuristaTitle => 'Music Tourist';

  @override
  String get achvTuristaDesc => 'Concerts in 10 different cities';

  @override
  String get achvCriticoTitle => 'Critic';

  @override
  String get achvCriticoDesc => 'Rate your first concert';

  @override
  String get achvGranCriticoTitle => 'Great Critic';

  @override
  String get achvGranCriticoDesc => 'Rate 10 concerts';

  @override
  String get achvAnaliticoTitle => 'Analytical';

  @override
  String get achvAnaliticoDesc => 'Rate 25 concerts';

  @override
  String get achvPerfeccionistaTitle => 'Perfectionist';

  @override
  String get achvPerfeccionistaDesc => 'Give 5 stars to a concert';

  @override
  String get achvApasionadoTitle => 'Passionate';

  @override
  String get achvApasionadoDesc => '10 concerts in favorites';

  @override
  String get achvManirotoTitle => 'Big Spender';

  @override
  String get achvManirotoDesc => 'Over €500 spent on tickets';

  @override
  String get achvHistoricoTitle => 'Historic Fan';

  @override
  String get achvHistoricoDesc => 'More than 5 years attending concerts';

  @override
  String get achvDecadaTitle => 'A Decade';

  @override
  String get achvDecadaDesc => 'More than 10 years in the game';

  @override
  String get compareStatsButton => 'Compare stats';

  @override
  String friendUpcomingTitle(String name) {
    return 'UPCOMING CONCERTS FOR $name';
  }

  @override
  String get friendNoUpcoming => 'No upcoming concerts';

  @override
  String get upcomingTogetherTitle => 'UPCOMING CONCERTS TOGETHER';

  @override
  String get numbersTogetherTitle => 'NUMBERS TOGETHER';

  @override
  String get emptySharedLine1 =>
      'You haven\'t been to any\nconcerts together yet.';

  @override
  String get emptySharedLine2 => 'Tag each other at your next shows!';

  @override
  String get youLabel => 'You';

  @override
  String compareStatsAppBarTitle(String me, String friend) {
    return '$me vs $friend';
  }

  @override
  String get commonArtistsTitle => 'COMMON ARTISTS';

  @override
  String get onlyYouSawTitle => 'ONLY YOU HAVE SEEN';

  @override
  String onlyFriendSawTitle(String name) {
    return 'ONLY $name HAS SEEN';
  }

  @override
  String get vsLabel => 'VS';

  @override
  String get compareTotalConcertsLabel => 'Total concerts';

  @override
  String get compareUniqueArtistsLabel => 'Unique artists';

  @override
  String get compareAvgRatingLabel => 'Avg rating';

  @override
  String get compareThisYearLabel => 'This year';

  @override
  String get compareTopArtistLabel => 'Top artist';

  @override
  String get tutorialSkip => 'Skip';

  @override
  String get tutorialNext => 'Next';

  @override
  String get tutorialStart => 'Let\'s go! 🎸';

  @override
  String tutorialStepsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count steps',
      one: '1 step',
    );
    return '$_temp0';
  }

  @override
  String get tutEntryDashboard => 'Home / Dashboard';

  @override
  String get tutEntryConcerts => 'My concerts';

  @override
  String get tutEntryAddConcert => 'Add / Edit concert';

  @override
  String get tutEntryDetail => 'Concert detail';

  @override
  String get tutEntryStats => 'Statistics';

  @override
  String get tutEntryProfile => 'My profile';

  @override
  String get tutEntryFriends => 'Friends';

  @override
  String get tutEntryFeed => 'Activity feed';

  @override
  String get tutEntryRecs => 'Recommendations';

  @override
  String get tutEntryImport => 'Import concerts';

  @override
  String get tutDash1Title => 'Welcome to La Vida en Directo!';

  @override
  String get tutDash1Desc =>
      'Your personal music diary. The dashboard shows your upcoming concerts, key stats, friends\' activity and much more at a glance.';

  @override
  String get tutDash2Title => 'Add a concert';

  @override
  String get tutDash2Desc =>
      'Tap the + button at any time to log a concert: artist, venue, date, price, photo and a detailed rating by criteria.';

  @override
  String get tutDash3Title => 'To rate';

  @override
  String get tutDash3Desc =>
      'The \"To rate\" widget lists past concerts that don\'t have a score yet. Swipe between them and tap one to rate it on 5 criteria.';

  @override
  String get tutDash4Title => 'Recommended concerts';

  @override
  String get tutDash4Desc =>
      'Discover upcoming events near you based on your artists. Tap one to see all its details.';

  @override
  String get tutDash5Title => 'Customize the dashboard';

  @override
  String get tutDash5Desc =>
      'Rearrange, show or hide the dashboard widgets by tapping the edit icon next to the greeting.';

  @override
  String get tutAdd1Title => 'Log the concert';

  @override
  String get tutAdd1Desc =>
      'Fill in artist, venue, city, date and price. The music genre is suggested automatically from Spotify as you type the artist\'s name.';

  @override
  String get tutAdd2Title => 'Concert photo';

  @override
  String get tutAdd2Desc =>
      'Add a photo from your gallery to bring the memory to life. You can change or remove it later from the edit screen.';

  @override
  String get tutAdd3Title => 'Rating by criteria';

  @override
  String get tutAdd3Desc =>
      'Rate 5 criteria with stars: Artist, Sound, Atmosphere, Setlist and Value for money. The overall score is calculated automatically as the average.';

  @override
  String get tutAdd4Title => 'Automatically calculated score';

  @override
  String get tutAdd4Desc =>
      'There is no manual score: the rating shown in your history and stats is always the average of your 5 criteria. Fairer and more detailed.';

  @override
  String get tutAdd5Title => 'Festival or single concert';

  @override
  String get tutAdd5Desc =>
      'Mark whether it was a festival so your stats can tell both formats apart and you can see the split in the \"Festival vs. individual\" section.';

  @override
  String get tutAdd6Title => 'Tag friends';

  @override
  String get tutAdd6Desc =>
      'Did you go with someone? Tag your friends so the concert also appears in their shared history and they can see it from their profile.';

  @override
  String get tutDetail1Title => 'Everything about the concert';

  @override
  String get tutDetail1Desc =>
      'Here you see the full info: date, venue, city, price, photo, your personal notes and the detailed rating by criteria with progress bars.';

  @override
  String get tutDetail2Title => 'Detailed rating';

  @override
  String get tutDetail2Desc =>
      'If you rated the concert, a card shows the score for each criterion: Artist, Sound, Atmosphere, Setlist and Value for money, plus the average.';

  @override
  String get tutDetail3Title => 'Edit anytime';

  @override
  String get tutDetail3Desc =>
      'Tap the edit button (pencil) to change any detail, add or modify the ratings, the photo or the notes whenever you want.';

  @override
  String get tutDetail4Title => 'Automatic setlist';

  @override
  String get tutDetail4Desc =>
      'The app looks up the concert\'s real setlist on Setlist.fm so you can relive, song by song, what they played that night.';

  @override
  String get tutDetail5Title => 'Artist on Spotify';

  @override
  String get tutDetail5Desc =>
      'The artist is linked automatically on Spotify: photo, genres, followers and the most popular songs with their popularity and duration.';

  @override
  String get tutDetail6Title => 'Photos and memories';

  @override
  String get tutDetail6Desc =>
      'Add photos of the concert and tag the people who were there. They are saved in your personal memories gallery.';

  @override
  String get tutDetail7Title => 'Venue and location';

  @override
  String get tutDetail7Desc =>
      'Tap the venue name to see all the concerts you have logged at that same place and explore its location on the map.';

  @override
  String get tutDetail8Title => 'Comments';

  @override
  String get tutDetail8Desc =>
      'Your friends can comment on the concert if you tagged them. Open the comments section to read or continue the conversation.';

  @override
  String get tutDetail9Title => 'Keep your ticket';

  @override
  String get tutDetail9Desc =>
      'Upload a photo or PDF of your ticket to always have it at hand. It is stored only on your device: it is never uploaded to any server.';

  @override
  String get tutConcerts1Title => 'Your music history';

  @override
  String get tutConcerts1Desc =>
      'All your concerts in one place. Past ones show the average rating of their criteria; future ones are marked as \"upcoming\".';

  @override
  String get tutConcerts2Title => 'Visible rating';

  @override
  String get tutConcerts2Desc =>
      'Each past concert shows its calculated score (average of criteria) or \"Not rated\" if you haven\'t scored it yet. Tap it to rate it.';

  @override
  String get tutConcerts3Title => 'Three available views';

  @override
  String get tutConcerts3Desc =>
      'Switch between list view, compact grid or calendar depending on how you prefer to explore your history.';

  @override
  String get tutConcerts4Title => 'Calendar view';

  @override
  String get tutConcerts4Desc =>
      'The calendar marks the days you had a concert. Tap any date to see the details or add a new one on that day.';

  @override
  String get tutConcerts5Title => 'Search and filter';

  @override
  String get tutConcerts5Desc =>
      'Use the search bar to find concerts by artist, venue or city, and filter by year to quickly browse your history.';

  @override
  String get tutConcerts6Title => 'Concert map';

  @override
  String get tutConcerts6Desc =>
      'Tap the map icon to see all your concerts on a map. Explore which cities and venues you\'ve been to and spot patterns.';

  @override
  String get tutConcerts7Title => 'Shared';

  @override
  String get tutConcerts7Desc =>
      'The \"Shared\" tab gathers the concerts your friends added and tagged you in, even if you didn\'t log them yourself.';

  @override
  String get tutStats1Title => 'Your music stats';

  @override
  String get tutStats1Desc =>
      'A complete analysis of your history: total concerts, unique artists, cities visited, favorite genres, total spending and much more.';

  @override
  String get tutStats2Title => 'Concerts per year and month';

  @override
  String get tutStats2Desc =>
      'Bar charts showing how your concerts are distributed over time. Discover your most active seasons.';

  @override
  String get tutStats3Title => 'Top artists, genres and venues';

  @override
  String get tutStats3Desc =>
      'Rankings of the most-seen artists, the genres you\'ve seen most live and the most-visited venues. With a Spotify photo when available.';

  @override
  String get tutStats4Title => 'Ratings and distribution';

  @override
  String get tutStats4Desc =>
      'Histogram of your scores, average rating per year and your top-rated artists. Only concerts scored with the criteria system are counted.';

  @override
  String get tutStats5Title => 'Festival vs. individual';

  @override
  String get tutStats5Desc =>
      'Pie chart showing the split between your festival concerts and individual ones, to get to know your profile as a concertgoer.';

  @override
  String get tutStats6Title => 'Yearly recap';

  @override
  String get tutStats6Desc =>
      'From the calendar icon you can open the Wrapped for any year: star artist, favorite city, average rating and the highlights.';

  @override
  String get tutStats7Title => 'Customize sections';

  @override
  String get tutStats7Desc =>
      'Choose which stats sections you want to see and reorder them as you like by tapping the edit icon.';

  @override
  String get tutProfile1Title => 'Your credentials';

  @override
  String get tutProfile1Desc =>
      'Your profile summarizes your whole music history: number of concerts, photos, favorites and your fan level based on how many shows you\'ve racked up.';

  @override
  String get tutProfile2Title => 'Unlockable achievements';

  @override
  String get tutProfile2Desc =>
      'You earn badges for musical milestones: 10 concerts, your first festival, seeing the same artist again, getting a perfect rating and much more.';

  @override
  String get tutProfile3Title => 'My artists';

  @override
  String get tutProfile3Desc =>
      'Ranking of your most-seen artists, enriched with Spotify data: photo, followers, how many times you\'ve seen them and your average rating of their shows.';

  @override
  String get tutProfile4Title => 'Yearly Wrapped';

  @override
  String get tutProfile4Desc =>
      'Open the animated recap of each year from your profile: artist of the year, favorite city, average rating and all your highlight concerts.';

  @override
  String get tutProfile5Title => 'Color theme';

  @override
  String get tutProfile5Desc =>
      'Customize the app\'s main color from the settings. Pick the one that best reflects your musical style.';

  @override
  String get tutFriends1Title => 'Connect with your people';

  @override
  String get tutFriends1Desc =>
      'Search for friends by name or email and send friend requests. Once they accept, you can see their concerts and compare histories.';

  @override
  String get tutFriends2Title => 'Friends and requests';

  @override
  String get tutFriends2Desc =>
      'The first tab lists your current friends. The second one manages the pending requests you\'ve received.';

  @override
  String get tutFriends3Title => 'Friend profile';

  @override
  String get tutFriends3Desc =>
      'Tap a friend to see their profile: their concerts, favorite artists and achievements. You can explore their history even if it\'s private, as long as you\'re friends.';

  @override
  String get tutFriends4Title => 'Compare stats';

  @override
  String get tutFriends4Desc =>
      'From a friend\'s profile tap \"Compare\" to see your stats head to head: total concerts, common artists and average rating.';

  @override
  String get tutFriends5Title => 'Activity notifications';

  @override
  String get tutFriends5Desc =>
      'You get a notification when a friend adds a concert or tags you in one. You can also comment on their activity from the feed.';

  @override
  String get tutFeed1Title => 'Friends feed';

  @override
  String get tutFeed1Desc =>
      'Follow your friends\' music activity in real time: which concerts they added, when and who they went with.';

  @override
  String get tutFeed2Title => 'Comment on concerts';

  @override
  String get tutFeed2Desc =>
      'Tap \"Comment\" on any activity to leave a message. Open the full thread to see the conversation and reply.';

  @override
  String get tutFeed3Title => 'Shared gallery';

  @override
  String get tutFeed3Desc =>
      'In the photos tab you see all the pictures you and your friends uploaded from your concerts, in chronological order.';

  @override
  String get tutRecs1Title => 'Concerts near you';

  @override
  String get tutRecs1Desc =>
      'Discover upcoming events based on your location and the artists you already follow in the app. Real-time data from Ticketmaster.';

  @override
  String get tutRecs2Title => 'Want to go';

  @override
  String get tutRecs2Desc =>
      'Mark an event as \"Want to go\" to save it to your list and find it quickly later.';

  @override
  String get tutRecs3Title => 'Add directly';

  @override
  String get tutRecs3Desc =>
      'If you already have a ticket for a recommended event, tap \"Add\" to log it in your history as an upcoming concert.';

  @override
  String get tutImport1Title => 'Search on Setlist.fm';

  @override
  String get tutImport1Desc =>
      'In the \"Setlist.fm\" tab, type an artist\'s name. The app will show their past concerts so you can pick the ones you attended.';

  @override
  String get tutImport2Title => 'Select and import';

  @override
  String get tutImport2Desc =>
      'Check the concerts in the list and tap \"Import\". They are added to your history automatically; afterwards you can edit each one to add a photo, price and rating.';

  @override
  String get tutImport3Title => 'Backup';

  @override
  String get tutImport3Desc =>
      'In the \"Backup\" tab you can export all your concerts to a file or restore them from a previous copy so you never lose anything.';

  @override
  String get tutSpotifyPlaylist1Title => 'Your Spotify playlist';

  @override
  String get tutSpotifyPlaylist1Desc =>
      'This screen shows the embedded Spotify player with your personal playlist. Each user sees their own thanks to OAuth access.';

  @override
  String get tutSpotifyPlaylist2Title => 'Link your account';

  @override
  String get tutSpotifyPlaylist2Desc =>
      'If you haven\'t linked Spotify yet, tap \"Connect with Spotify\" to authorize access. You only need to do it once.';

  @override
  String get tutSpotifyPlaylist3Title => 'Update permissions';

  @override
  String get tutSpotifyPlaylist3Desc =>
      'If you see the \"Re-link Spotify\" button, it means your session needs an additional permission to access playlists. Tap it to update it.';

  @override
  String get tutSpotifyImport1Title => 'Your Spotify artists';

  @override
  String get tutSpotifyImport1Desc =>
      'When you link your Spotify account, the app shows here the artists you listen to the most. Tap one to look up their past concerts on Setlist.fm.';

  @override
  String get tutSpotifyImport2Title => 'Import the artist\'s concerts';

  @override
  String get tutSpotifyImport2Desc =>
      'Tapping an artist opens the list of their past concerts. Select the ones you\'ve seen and they are added straight to your history.';

  @override
  String get tutSpotifyImport3Title => 'Disconnect Spotify';

  @override
  String get tutSpotifyImport3Desc =>
      'Tap the exit icon in the top-right corner to unlink your Spotify account at any time.';

  @override
  String get tutMap1Title => 'Your music map';

  @override
  String get tutMap1Desc =>
      'All your concerts geolocated on the map. Each pin represents a concert; the most-visited cities are highlighted with larger markers.';

  @override
  String get tutMap2Title => 'Explore concerts';

  @override
  String get tutMap2Desc =>
      'Tap any pin to see the artist name, the venue and the date. From there you can open the full concert detail.';

  @override
  String get usernameRequired => 'Enter your username';

  @override
  String get passwordLabel => 'Password';

  @override
  String get emailRequired => 'Enter your email';

  @override
  String get emailInvalid => 'Invalid email';

  @override
  String get passwordRequired => 'Enter your password';

  @override
  String get passwordMinLength => 'At least 6 characters';

  @override
  String get serverTimeout => 'The server took too long. Try again.';

  @override
  String get loginErrorGeneric => 'Couldn\'t sign in.';

  @override
  String get loginErrorInvalidCredentials => 'Incorrect email or password.';

  @override
  String get registerErrorGeneric => 'Something went wrong.';

  @override
  String get registerErrorInvalidEmail => 'Enter a valid email address.';

  @override
  String get registerErrorEmailTaken =>
      'An account with that email already exists.';

  @override
  String get registerErrorInvalidPassword => 'The password isn\'t valid.';

  @override
  String get forgotPasswordIntro =>
      'Enter your email and we\'ll send you a link to create a new password.';

  @override
  String get emailSentTitle => 'Email sent!';

  @override
  String get emailSentBody =>
      'If the email exists, you\'ll receive a link to reset your password.\n\nAlso check your spam folder.';

  @override
  String get themePickerTitle => 'How do you prefer\nto see the app?';

  @override
  String get themePickerHint => 'You can change it later in Settings.';

  @override
  String get themeSystemDesc => 'Follows your phone\'s setting';

  @override
  String get themeDarkDesc => 'Black background, ideal for concerts';

  @override
  String get themeLightDesc => 'White background, maximum legibility';

  @override
  String get getStartedLabel => 'Get started';

  @override
  String get useSystemThemeLabel => 'Use the system default';

  @override
  String get appErrorNoInternet => 'No internet connection';

  @override
  String get appErrorTimeout => 'The server took too long to respond';

  @override
  String get appErrorSessionExpired => 'Session expired. Please sign in again';

  @override
  String get appErrorForbidden => 'You don\'t have permission to view this';

  @override
  String get appErrorNotFound => 'Content not found';

  @override
  String get appErrorServer => 'Server error. Try again later';

  @override
  String get appErrorGeneric => 'Something went wrong. Try again';

  @override
  String get paywallTitle => 'Take your experience to the next level';

  @override
  String get paywallDesc =>
      'Go Pro to add unlimited concerts and unlock everything the app has to offer.';

  @override
  String get paywallBenefitConcerts => 'Unlimited concerts';

  @override
  String get paywallBenefitPhotos => 'Unlimited photos per concert';

  @override
  String get paywallBenefitPdf => 'Export stats to PDF';

  @override
  String get paywallBenefitCustom => 'Customizable dashboard and stats';

  @override
  String get paywallBenefitThemes => 'Exclusive color themes';

  @override
  String get paywallCta => 'Go Pro';

  @override
  String get paywallLater => 'Not now';

  @override
  String get dashEditTitle => 'Customize dashboard';

  @override
  String get layoutResetTitle => 'Reset order';

  @override
  String get dashEditResetConfirm => 'Restore the default dashboard layout?';

  @override
  String get statsEditResetConfirm => 'Restore the default layout?';

  @override
  String get resetLabel => 'Reset';

  @override
  String get layoutLoadError => 'Error loading the configuration';

  @override
  String get layoutEditHint =>
      'Drag   to reorder · turn each section on or off';

  @override
  String get hiddenLabel => 'Hidden';

  @override
  String get dashSectionStreak => 'Concert streak';

  @override
  String get dashSectionAnnualGoal => 'Annual goal';

  @override
  String get dashRatePendingTitle => 'To rate';

  @override
  String get dashSectionOnThisDay => 'On this day';

  @override
  String get dashSectionUpcoming => 'Upcoming concerts';

  @override
  String get dashSectionStats => 'Quick stats';

  @override
  String get dashSectionRecommended => 'Recommendations';

  @override
  String get dashSectionFavorites => 'Favorites';

  @override
  String get dashSectionRecent => 'Recently added';

  @override
  String get dashSectionSpotify => 'Favorite songs (Spotify)';

  @override
  String get dashCalendarAction => 'Calendar';

  @override
  String get dashLastConcertTitle => 'Your last concert';

  @override
  String annualGoalMyConcerts(int year) {
    return 'My $year concerts';
  }

  @override
  String annualGoalNoConcerts(int year) {
    return 'You haven\'t been to any concerts in $year yet';
  }

  @override
  String annualGoalDoneInYear(int count, int year) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count concerts in $year',
      one: '1 concert in $year',
    );
    return '$_temp0';
  }

  @override
  String get annualGoalConfigure => 'Set your goal in Settings';

  @override
  String annualGoalReached(int year) {
    return 'Goal reached in $year! 🎉';
  }

  @override
  String annualGoalProgressTitle(int year, int goal) {
    String _temp0 = intl.Intl.pluralLogic(
      goal,
      locale: localeName,
      other: '$goal concerts',
      one: '1 concert',
    );
    return '$year goal: $_temp0';
  }

  @override
  String annualGoalRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count concerts left to reach it',
      one: '1 concert left to reach it',
    );
    return '$_temp0';
  }

  @override
  String get statsCustomizeTooltip => 'Customize';

  @override
  String get statsByMonth => 'Concerts per month';

  @override
  String get statsByWeekday => 'Favorite day of the week';

  @override
  String get statsGenres => 'Music genres';

  @override
  String get statsVenues => 'Most visited venues';

  @override
  String get statsFestivalVsSingle => 'Festival vs. individual';

  @override
  String get statsAvgRatingByYear => 'Average rating per year';

  @override
  String get statsTopRatedArtists => 'Top-rated artists';

  @override
  String get statsTotalSpent => 'Total spent';

  @override
  String statsMonthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months',
      one: '1 month',
    );
    return '$_temp0';
  }

  @override
  String get statsLongestStreak => 'Longest streak';

  @override
  String statsDaysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get statsLongestGap => 'Longest gap';

  @override
  String get statsRepeatedArtists => 'Repeated artists';

  @override
  String get statsSingleConcerts => 'Individual';

  @override
  String get weekdayShortMon => 'Mon';

  @override
  String get weekdayShortTue => 'Tue';

  @override
  String get weekdayShortWed => 'Wed';

  @override
  String get weekdayShortThu => 'Thu';

  @override
  String get weekdayShortFri => 'Fri';

  @override
  String get weekdayShortSat => 'Sat';

  @override
  String get weekdayShortSun => 'Sun';

  @override
  String get statsEditTitle => 'Customize statistics';

  @override
  String get statsEditSummary => 'Summary (cards)';

  @override
  String get statsEditTopArtists => 'Top artists';

  @override
  String get statsEditTopFestivals => 'Top festivals';

  @override
  String wrappedShareText(int year) {
    return '🎸 My $year Wrapped | La Vida en Directo';
  }

  @override
  String get wrappedLoadError => 'Error loading concerts';

  @override
  String get wrappedIntroTitle => 'Your year\nin concerts';

  @override
  String get wrappedStart => 'Start';

  @override
  String get wrappedTotalLead => 'This year you went to';

  @override
  String wrappedConcertsWord(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'concerts',
      one: 'concert',
    );
    return '$_temp0';
  }

  @override
  String get wrappedTier50 => '🔥 Legendary year!';

  @override
  String get wrappedTier20 => '🎉 A great year of live music!';

  @override
  String get wrappedTier10 => '👏 A very good year';

  @override
  String get wrappedTier0 => '🎵 Starting strong';

  @override
  String get wrappedArtistTitle => 'Your artist of the year';

  @override
  String get wrappedSharedBadge => 'Shared concert';

  @override
  String wrappedSeenTimes(int times) {
    return 'You saw them $times times';
  }

  @override
  String get wrappedWasThere => 'You were there';

  @override
  String get wrappedWasSpecial => 'It was special';

  @override
  String get wrappedVarietyTitle => 'You never get tired';

  @override
  String wrappedArtistsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'different artists',
      one: 'different artist',
    );
    return '$_temp0';
  }

  @override
  String wrappedCitiesLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'different cities',
      one: 'city',
    );
    return '$_temp0';
  }

  @override
  String wrappedFestivalsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'festivals',
      one: 'festival',
    );
    return '$_temp0';
  }

  @override
  String get wrappedCityTitle => 'Your favorite city';

  @override
  String get wrappedMonthTitle => 'Your most active month';

  @override
  String get wrappedRatingTitle => 'Your average rating';

  @override
  String get wrappedOutOf5 => 'out of 5';

  @override
  String get wrappedPhotosTitle => 'Your memories';

  @override
  String wrappedMemoriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count memories this year',
      one: '1 memory this year',
    );
    return '$_temp0';
  }

  @override
  String get wrappedClosingTitle => 'Your summary';

  @override
  String get wrappedPreparing => 'Preparing...';

  @override
  String get wrappedShareButton => 'Share my Wrapped';

  @override
  String get wrappedFavArtist => 'Favorite artist';

  @override
  String get wrappedFavCity => 'Favorite city';

  @override
  String get wrappedActiveMonth => 'Most active month';

  @override
  String get wrappedMiniArtists => 'artists';

  @override
  String get wrappedMiniCities => 'cities';

  @override
  String get wrappedMiniRating => 'rating';

  @override
  String get wrappedTeaserPre => 'Your ';

  @override
  String wrappedTeaserYear(int year) {
    return 'for $year';
  }

  @override
  String get wrappedTeaserComing => 'arrives in December';

  @override
  String get wrappedTeaserProgress => 'YEAR PROGRESS';

  @override
  String wrappedTeaserMonthsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months until December',
      one: '1 month until December',
    );
    return '$_temp0';
  }

  @override
  String get wrappedTeaserStory => 'YOUR STORY THIS YEAR';

  @override
  String get addGenreLabel => '🎸 Music genre';

  @override
  String get addGenreHint => 'Rock, Pop, Metal, Jazz…';

  @override
  String get priceFestivalLabel => 'Festival price';

  @override
  String get priceTicketLabel => 'Ticket price';

  @override
  String get timeLabel => 'Time';

  @override
  String get optionalHint => 'Optional';

  @override
  String get ratingAutoNote =>
      'The overall rating is calculated as the average of the criteria.';

  @override
  String get ratingCriterionArtist => 'Artist';

  @override
  String get ratingCriterionSound => 'Sound';

  @override
  String get ratingCriterionAtmosphere => 'Atmosphere';

  @override
  String get ratingCriterionSetlist => 'Setlist';

  @override
  String get ratingCriterionValue => 'Value for money';

  @override
  String get notesDiaryLabel => '📝 Notes / diary';

  @override
  String get notesDiaryHint => 'What do you remember about this concert?';

  @override
  String get visibleToFriendsTitle => 'Visible to my friends';

  @override
  String get visibleToFriendsOn =>
      'Appears in your friends\' feed and in comparisons';

  @override
  String get visibleToFriendsOff =>
      'Only you will see it — hidden from your friends';

  @override
  String get genreLabel => 'Genre';

  @override
  String get detailHiddenTitle => 'Hidden from your friends';

  @override
  String get detailHiddenDesc => 'Only you can see this concert';

  @override
  String get detailLinkSpotifyTitle => 'Link Spotify artist';

  @override
  String get detailLinkSpotifyDesc => 'See popular songs and profile';

  @override
  String detailSpotifyNotFound(String query) {
    return 'Artist not found on Spotify: \"$query\"';
  }

  @override
  String detailSpotifySearchError(String error) {
    return 'Error searching Spotify: $error';
  }

  @override
  String get notesTitle => 'Notes';

  @override
  String get shareLabel => 'Share';

  @override
  String get preparingLabel => 'Preparing...';

  @override
  String get commentsTitle => 'Comments';

  @override
  String get commentsEmpty => 'Be the first to comment';

  @override
  String get commentHint => 'Write a comment…';

  @override
  String get timeNow => 'now';

  @override
  String timeMinutesAgo(int count) {
    return '$count min ago';
  }

  @override
  String timeHoursAgo(int count) {
    return '$count h ago';
  }

  @override
  String timeDaysAgo(int count) {
    return '$count d ago';
  }

  @override
  String get detailedRatingTitle => 'Detailed rating';

  @override
  String get deleteConcertsTitle => 'Delete concerts';

  @override
  String deleteConcertsConfirm(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'concerts',
      one: 'concert',
    );
    return 'Delete $count $_temp0?\nThis action cannot be undone.';
  }

  @override
  String concertsDeletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count concerts deleted',
      one: '1 concert deleted',
    );
    return '$_temp0';
  }

  @override
  String concertsSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selected',
      one: '1 selected',
    );
    return '$_temp0';
  }

  @override
  String get selectAllLabel => 'All';

  @override
  String get deleteSelectedTooltip => 'Delete selected';

  @override
  String get cancelSelectionTooltip => 'Cancel selection';

  @override
  String get selectTooltip => 'Select';

  @override
  String get filterLiked => 'Liked';

  @override
  String get clearLabel => 'Clear';

  @override
  String get viewList => 'List';

  @override
  String get viewGrid => 'Grid';

  @override
  String get viewCalendar => 'Calendar';

  @override
  String get emptyPastSubtitle => 'Your past concerts will appear here';

  @override
  String get emptyUpcomingSubtitle =>
      'Add an upcoming concert so you don\'t miss anything';

  @override
  String get emptySharedSubtitle =>
      'When your friends share concerts, you\'ll see them here';

  @override
  String get filterSheetTitle => 'Filter concerts';

  @override
  String get filterMinRating => 'Minimum rating';

  @override
  String get filterShowOnly => 'Show only';

  @override
  String get applyFilters => 'Apply filters';

  @override
  String venueArtistsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'artists',
      one: 'artist',
    );
    return '$_temp0';
  }

  @override
  String venueUpcomingLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'upcoming',
      one: 'upcoming',
    );
    return '$_temp0';
  }

  @override
  String venueFirstVisit(String date) {
    return 'First visit: $date';
  }

  @override
  String venueLastVisit(String date) {
    return 'Last: $date';
  }

  @override
  String get venueNoConcerts => 'No concerts at this venue';

  @override
  String get calendarWeekdayInitials => 'M,T,W,T,F,S,S';

  @override
  String calendarDayLabel(int day, String month) {
    return '$month $day';
  }

  @override
  String get calendarAddOnDate => 'Add a concert on this date';

  @override
  String get mapCenterTooltip => 'Center';

  @override
  String favoritesArtistCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count artists',
      one: '1 artist',
    );
    return '$_temp0';
  }

  @override
  String get favoritesEmptySubtitle =>
      'Mark concerts as favorites to see them here grouped by artist';

  @override
  String get refreshTooltip => 'Refresh';

  @override
  String get friendsActivityEmpty =>
      'Your friends haven\'t added\nany concerts yet';

  @override
  String get friendDefaultName => 'Friend';

  @override
  String get commentAction => 'Comment';

  @override
  String get userDefaultName => 'User';

  @override
  String get notificationsEmptyHint =>
      'Your alerts and friends\' activity will appear here';

  @override
  String get recsViewCardTooltip => 'Card view';

  @override
  String get recsViewCompactTooltip => 'Compact view';

  @override
  String get recsResultsTab => 'Results';

  @override
  String get wantToGoTab => 'Want to go';

  @override
  String get recsWantEmpty => 'You haven\'t marked any concert yet.';

  @override
  String get recsAttending => 'Going';

  @override
  String get recsRemoveFromList => 'Remove from my list';

  @override
  String get recsWantToAttend => 'I want to go';

  @override
  String get setlistDataFrom => 'Data from setlist.fm';

  @override
  String get colorPaletteIntro =>
      'Change the accent color across the whole app. Pro palettes require an active subscription.';

  @override
  String get themeNameEscenario => 'Stage';

  @override
  String get themeNameVinilo => 'Vinyl';

  @override
  String get themeNameFestival => 'Festival';

  @override
  String get themeNameNeonPunk => 'Neon Punk';

  @override
  String get themeNameAcustico => 'Acoustic';

  @override
  String get themeNameBackstage => 'Backstage';

  @override
  String get themeNameJazzClub => 'Jazz Club';

  @override
  String get concertNotFoundError => 'Concert not found';

  @override
  String get concertNotFoundTitle => 'Concert not found';

  @override
  String get concertNotFoundHint => 'You may no longer be part of this concert';

  @override
  String get backLabel => 'Back';

  @override
  String get importBackupTab => 'Backup';

  @override
  String get importFromSpotifyTitle => 'Import from Spotify';

  @override
  String get importFromSpotifyDesc =>
      'Connect your account and see your favorite artists';

  @override
  String get limitSheetTitle => 'Free concert limit';

  @override
  String limitSheetBody(int current, int max, int selected, int room) {
    String _temp0 = intl.Intl.pluralLogic(
      room,
      locale: localeName,
      other: ', but only $room more fit.',
      zero: ' and you\'ve already reached the limit.',
    );
    return 'You have $current concerts out of a maximum of $max on the free plan. You selected $selected concerts to import$_temp0';
  }

  @override
  String limitImportFirstTitle(int count) {
    return 'Import the first $count';
  }

  @override
  String limitImportFirstDesc(int count) {
    return 'The first $count selected concerts will be imported';
  }

  @override
  String get limitChooseTitle => 'Choose manually';

  @override
  String get limitChooseDesc =>
      'Go back to the list and select only the ones you want';

  @override
  String get limitProTitle => 'Go Pro';

  @override
  String get limitProDesc => 'No concert limit and more features';

  @override
  String get backupRestoreTitle => 'Restore backup';

  @override
  String get backupRestoreIntro =>
      'Select the JSON file generated from Settings → Export my concerts to recover all your concerts.';

  @override
  String get backupHowTo =>
      'To create a backup go to Settings → \"Export my concerts\" and choose JSON. The file includes all your data and images.';

  @override
  String get backupPickFile => 'Select JSON file';

  @override
  String backupInvalidFile(String detail) {
    return 'Invalid file: $detail';
  }

  @override
  String get backupFormatUnrecognized => 'unrecognized backup format';

  @override
  String backupOwnCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count own concerts',
      one: '1 own concert',
    );
    return '$_temp0';
  }

  @override
  String get backupDeselectAll => 'Deselect all';

  @override
  String get backupSelectAll => 'Select all';

  @override
  String get backupRestoreAll => 'Restore all';

  @override
  String backupRestoreSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Restore $count selected',
      one: 'Restore 1 selected',
    );
    return '$_temp0';
  }

  @override
  String backupSharedNotRestorable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count shared (can\'t be restored)',
      one: '1 shared (can\'t be restored)',
    );
    return '$_temp0';
  }

  @override
  String backupRestoredOk(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count concerts restored successfully ✅',
      one: '1 concert restored successfully ✅',
    );
    return '$_temp0';
  }

  @override
  String backupRestoredPartial(int restored, int failed) {
    return '$restored restored · $failed failed';
  }

  @override
  String get backupFailedTitle => 'Concerts that failed:';

  @override
  String backupRetryFailed(int count) {
    return 'Retry $count failed';
  }

  @override
  String get backupRestoring => 'Restoring...';

  @override
  String sharedFromUser(String name) {
    return 'From: $name';
  }

  @override
  String get spotifyConnect => 'Connect with Spotify';

  @override
  String get spotifyConnecting => 'Connecting…';

  @override
  String get spotifyDisconnect => 'Disconnect Spotify';

  @override
  String get spotifyConnectTitle => 'Connect your Spotify account';

  @override
  String get spotifyImportConnectDesc =>
      'You\'ll see your most listened artists and can add concerts with a tap.';

  @override
  String get spotifyYourFavoriteArtists => 'Your favorite artists';

  @override
  String get spotifyTapArtistHint => 'Tap an artist to add a concert';

  @override
  String get spotifyConnectError => 'Couldn\'t connect to Spotify';

  @override
  String get spotifyPlaylistTitle => 'Your favorite songs';

  @override
  String get spotifyPlaylistConnectDesc =>
      'Link Spotify to see your favorite songs playlist here.';

  @override
  String get spotifyRelinkTitle => 'Update your Spotify connection';

  @override
  String get spotifyRelinkDesc =>
      'To see your playlist we need an additional permission. Disconnect and reconnect your Spotify account.';

  @override
  String get spotifyRelinkButton => 'Re-link Spotify';

  @override
  String get spotifyPlaylistLoadError => 'Couldn\'t load your playlist';

  @override
  String get spotifyAccessDenied =>
      'Spotify denied access to this account. The app may be in development mode and this account may not be on the allowed users list.';

  @override
  String spotifyLinkError(String error) {
    return 'Couldn\'t link Spotify: $error';
  }

  @override
  String get spotifyTopTracksTitle => 'My favorite songs';

  @override
  String get spotifyTopTracksConnectTitle => 'Your most listened songs';

  @override
  String get spotifyTopTracksConnectDesc =>
      'Connect your Spotify account to see your favorite songs here.';

  @override
  String spotifyTopTracksCount(int count) {
    return 'Your $count most listened songs';
  }

  @override
  String get spotifyDataFrom => 'Data from Spotify';

  @override
  String get spotifyLoadError => 'Couldn\'t load';

  @override
  String get recordsTitle => 'My collection';

  @override
  String recordsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count records',
      one: '1 record',
    );
    return '$_temp0';
  }

  @override
  String get recordsEmpty => 'You have no records yet';

  @override
  String get recordsEmptyHint =>
      'Tap + to search for a vinyl or CD and add it to your collection.';

  @override
  String get recordsFormatAll => 'All';

  @override
  String get recordsFormatVinyl => 'Vinyl';

  @override
  String get recordsFormatCd => 'CD';

  @override
  String get recordsFormatOther => 'Other';

  @override
  String get recordsLoadError => 'Couldn\'t load your collection';

  @override
  String get recordsSearchTitle => 'Add record';

  @override
  String get recordsSearchHint => 'Artist, album or barcode';

  @override
  String get recordsSearchPrompt => 'Search by artist, title or barcode.';

  @override
  String get recordsSearchEmpty => 'No results';

  @override
  String get recordsSearchError => 'Search failed. Please try again.';

  @override
  String get recordsAdded => 'Record added';

  @override
  String get recordsAlreadyAdded => 'You already have this record';

  @override
  String get recordsAddError => 'Couldn\'t add the record';

  @override
  String get recordsAddManual => 'Add manually';

  @override
  String get recordsTitleLabel => 'Title';

  @override
  String get recordsArtistLabel => 'Artist';

  @override
  String get recordsDeleteTitle => 'Delete record';

  @override
  String recordsDeleteConfirm(String title) {
    return 'Remove “$title” from your collection?';
  }

  @override
  String get recordsNotes => 'My notes';

  @override
  String get recordsNotesHint => 'Edition, condition, where you bought it...';

  @override
  String get recordsNotesSaved => 'Notes saved';

  @override
  String get recordsTracklist => 'Tracklist';

  @override
  String get recordsNoTracklist => 'Discogs has no tracklist for this record';

  @override
  String get recordsDetailError => 'Couldn\'t load the record details';

  @override
  String get recordsOpenDiscogs => 'View on Discogs';

  @override
  String get recordsTabCollection => 'Collection';

  @override
  String get recordsTabWishlist => 'Wishlist';

  @override
  String get recordsWishlistEmpty => 'Your wishlist is empty';

  @override
  String get recordsWishlistEmptyHint =>
      'Tap + to save the records you\'d like to get.';

  @override
  String get recordsSearchWishlistTitle => 'Add to wishlist';

  @override
  String recordsSpent(String amount) {
    return '€$amount spent';
  }

  @override
  String get recordsMarkOwned => 'I have it now';

  @override
  String get recordsRating => 'Rating';

  @override
  String get recordsCondition => 'Condition';

  @override
  String get recordsPrice => 'Price paid';

  @override
  String get recordsPriceInvalid => 'Invalid price';

  @override
  String get recordsArtistRecords => 'Your records by this artist';

  @override
  String recordsVinylCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vinyls',
      one: '1 vinyl',
    );
    return '$_temp0';
  }

  @override
  String recordsCdCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count CDs',
      one: '1 CD',
    );
    return '$_temp0';
  }

  @override
  String recordsWishlistCount(int count) {
    return '$count on wishlist';
  }

  @override
  String get discogsTitle => 'Discogs account';

  @override
  String get discogsMenu => 'Link Discogs';

  @override
  String get discogsIntro =>
      'Link your Discogs account to bring your collection and wantlist into the app.';

  @override
  String get discogsConnect => 'Sign in to Discogs';

  @override
  String discogsConnectedAs(String username) {
    return 'Connected as $username';
  }

  @override
  String get discogsImport => 'Import my collection';

  @override
  String get discogsImporting => 'Importing…';

  @override
  String discogsImportDone(int collection, int wishlist) {
    return '$collection records and $wishlist wishlist items imported';
  }

  @override
  String discogsImportSkipped(int count) {
    return '$count were already in your collection';
  }

  @override
  String get discogsImportError => 'Couldn\'t import from Discogs';

  @override
  String get discogsDisconnect => 'Unlink account';

  @override
  String get discogsDisconnectConfirm =>
      'Unlink your Discogs account? Records already imported stay in the app.';

  @override
  String get discogsConnectError => 'Couldn\'t link your Discogs account';

  @override
  String get discogsDenied => 'You cancelled the Discogs authorization';

  @override
  String get discogsImportHint =>
      'Records you already have are not modified. Only new ones are added.';

  @override
  String get dashRecordsViewAll => 'See all';

  @override
  String get dashRecordsEmptyTitle => 'Start your collection';

  @override
  String get dashRecordsEmptyHint =>
      'Add your vinyl and CDs by searching Discogs.';

  @override
  String get quickActionsEditTitle => 'Quick actions';

  @override
  String get quickActionsEditTileSubtitle =>
      'Choose which shortcuts appear on the home screen';

  @override
  String quickActionsEditHint(int max) {
    return 'Pick up to $max shortcuts and drag to reorder them. You can also open this by long-pressing a shortcut on the home screen.';
  }

  @override
  String quickActionsYours(int count, int max) {
    return 'Your shortcuts ($count/$max)';
  }

  @override
  String get quickActionsAvailable => 'Available';

  @override
  String quickActionsMaxReached(int max) {
    return 'Maximum $max shortcuts. Remove one to add another.';
  }

  @override
  String get quickActionRecords => 'Records';

  @override
  String get memoryAdd => 'Add memory';

  @override
  String get quickActionMemory => 'Memory';

  @override
  String get memoryPickConcert => 'Which concert is it from?';

  @override
  String get memoryNoResults => 'No results';

  @override
  String get memoryNoConcerts =>
      'You have no concerts yet. Add one to link memories to it.';

  @override
  String memoryUploading(int done, int total) {
    return 'Uploading $done of $total…';
  }

  @override
  String memoryAddedTo(int count, String artist) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count memories added to $artist',
      one: 'Memory added to $artist',
    );
    return '$_temp0';
  }

  @override
  String memoryAddedPartial(int added, int failed) {
    return '$added added, $failed couldn\'t be uploaded';
  }

  @override
  String get memoryView => 'View concert';

  @override
  String get adminPanelTitle => 'Admin panel';

  @override
  String get adminPanelSubtitle => 'Stats, announcements and users';

  @override
  String get adminNoAccess => 'You don\'t have access to this section.';

  @override
  String get adminBack => 'Back';

  @override
  String get adminTabStats => 'Stats';

  @override
  String get adminTabBroadcast => 'Announcements';

  @override
  String get adminTabUsers => 'Users';

  @override
  String get adminLoadError => 'Couldn\'t load the data';

  @override
  String get adminRetry => 'Retry';

  @override
  String get adminNoData => 'No data yet';

  @override
  String get adminSectionUsers => 'Users';

  @override
  String get adminKpiTotalUsers => 'Total users';

  @override
  String get adminKpiPro => 'Pro users';

  @override
  String get adminKpiNew7d => 'Sign-ups (7 days)';

  @override
  String get adminKpiNew30d => 'Sign-ups (30 days)';

  @override
  String get adminKpiActive7d => 'Active (7 days)';

  @override
  String get adminKpiActive30d => 'Active (30 days)';

  @override
  String get adminKpiPushUsers => 'With notifications';

  @override
  String get adminKpiDevices => 'Devices';

  @override
  String get adminSectionActivity => 'Last 14 days';

  @override
  String get adminChartSignups => 'New users';

  @override
  String get adminChartConcerts => 'Concerts added';

  @override
  String get adminSectionFeatures => 'What people use most';

  @override
  String get adminFeatureConcerts => 'Concerts';

  @override
  String get adminFeaturePhotos => 'Photos';

  @override
  String get adminFeatureComments => 'Comments';

  @override
  String get adminFeatureWantToAttend => 'Want to attend';

  @override
  String get adminFeatureRecords => 'Record collection';

  @override
  String get adminFeatureDiscogs => 'Linked Discogs accounts';

  @override
  String adminFeatureMeta(int users, int last30) {
    String _temp0 = intl.Intl.pluralLogic(
      users,
      locale: localeName,
      other: '$users users',
      one: '1 user',
    );
    return '$_temp0 · $last30 in 30 days';
  }

  @override
  String get adminSectionContent => 'Content';

  @override
  String get adminKpiConcerts => 'Concerts';

  @override
  String get adminKpiFriendships => 'Friendships';

  @override
  String get adminKpiAvgRating => 'Average rating';

  @override
  String get adminTopArtists => 'Most logged artists';

  @override
  String get adminTopCities => 'Top cities';

  @override
  String get adminTopGenres => 'Top genres';

  @override
  String adminRankMeta(int count, int users) {
    String _temp0 = intl.Intl.pluralLogic(
      users,
      locale: localeName,
      other: '$users users',
      one: '1 user',
    );
    return '$count · $_temp0';
  }

  @override
  String get adminSectionHealth => 'Server status';

  @override
  String adminHealthDb(int ms) {
    return 'Database: $ms ms';
  }

  @override
  String adminHealthUptime(String hours) {
    return 'Up for $hours h';
  }

  @override
  String get adminBroadcastIntro =>
      'Send an announcement to users: it arrives as a push notification and, if you want, is saved in their inbox.';

  @override
  String get adminTemplateUpdate => 'Template: new update';

  @override
  String get adminTemplateUpdateTitle => 'New update available';

  @override
  String get adminTemplateUpdateBody =>
      'A new version of the app is available. Update to enjoy the latest improvements.';

  @override
  String get adminFieldTitle => 'Title';

  @override
  String get adminFieldBody => 'Message';

  @override
  String get adminAudienceLabel => 'Audience';

  @override
  String get adminAudienceAll => 'Everyone';

  @override
  String get adminAudiencePro => 'Pro only';

  @override
  String get adminAudienceFree => 'Free only';

  @override
  String get adminInAppSwitch => 'Save in inbox';

  @override
  String get adminInAppHint => 'Also shown in Notifications inside the app';

  @override
  String get adminSend => 'Send announcement';

  @override
  String get adminConfirmTitle => 'Send the announcement?';

  @override
  String adminConfirmBody(String audience, int recipients, int devices) {
    return 'It will be sent to: $audience ($recipients users, $devices devices). This can\'t be undone.';
  }

  @override
  String adminSentOk(int recipients, int devices) {
    return 'Announcement sent to $recipients users ($devices devices)';
  }

  @override
  String get adminSendError => 'Couldn\'t send the announcement';

  @override
  String get adminSearchHint => 'Search by name or email';

  @override
  String adminUsersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count users',
      one: '1 user',
    );
    return '$_temp0';
  }

  @override
  String get adminNoUsers => 'No users found';

  @override
  String get adminLoadMore => 'Load more';

  @override
  String adminUserMeta(int concerts, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      concerts,
      locale: localeName,
      other: '$concerts concerts',
      one: '1 concert',
    );
    return '$_temp0 · joined $date';
  }

  @override
  String get adminMakePro => 'Give Pro';

  @override
  String get adminRemovePro => 'Remove Pro';

  @override
  String adminMakeProConfirm(String name) {
    return 'Give $name the Pro plan?';
  }

  @override
  String adminRemoveProConfirm(String name) {
    return 'Remove the Pro plan from $name?';
  }

  @override
  String get adminConfirm => 'Confirm';

  @override
  String get adminProChanged => 'Plan updated';

  @override
  String get adminActionError => 'Couldn\'t complete the action';

  @override
  String get adminOnlyOutdatedSwitch => 'Only people who haven\'t updated';

  @override
  String get adminOnlyOutdatedHint =>
      'Devices on a version older than the one chosen, or that don\'t report their version yet';

  @override
  String get adminOutdatedBeforeLabel => 'Older than version';

  @override
  String adminVersionOption(String version, int build) {
    return '$version (build $build)';
  }

  @override
  String get adminNoVersionsYet =>
      'No devices report their version yet; they will show up once users open the updated app.';

  @override
  String adminPreviewReach(int recipients, int devices) {
    return 'Would reach $recipients users ($devices devices)';
  }

  @override
  String get adminPreviewLoading => 'Calculating recipients…';

  @override
  String get adminSectionVersions => 'Installed versions';

  @override
  String get adminVersionUnknown => 'No version reported';

  @override
  String adminVersionDevices(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count devices',
      one: '1 device',
    );
    return '$_temp0';
  }

  @override
  String get adminTargetLabel => 'When the announcement is tapped';

  @override
  String get adminTargetNone => 'Just open the app';

  @override
  String get adminTargetStore => 'Open the store (update)';

  @override
  String get adminTargetNotifications => 'Open Notifications';

  @override
  String get adminTargetFriends => 'Open Friends';

  @override
  String get adminTargetStatistics => 'Open Statistics';

  @override
  String get adminTargetRecords => 'Open My record collection';
}
