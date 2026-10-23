class ApiConfig {
  ApiConfig._();

  /// Por defecto apunta a producción. Para desarrollo:
  ///   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://conciertos-backend.onrender.com',
  );

  static const String concertsEndpoint = '$baseUrl/concerts';
  static const String friendsActivityEndpoint = '$baseUrl/concerts/friends-activity';
  static const String loginEndpoint = '$baseUrl/auth/login';
  static const String registerEndpoint = '$baseUrl/auth/register';
  static const String uploadsEndpoint = '$baseUrl/uploads/image';
  static const String photosFeedEndpoint = '$baseUrl/photos/feed';
  static const String userAvatarEndpoint = '$baseUrl/users/avatar';

  // Amigos
  static const String friendsEndpoint = '$baseUrl/friends';
  static const String friendsSearchEndpoint = '$baseUrl/friends/search';
  static const String friendsPendingEndpoint = '$baseUrl/friends/pending';
  static String friendRequestEndpoint(String receiverId) =>
      '$baseUrl/friends/request/$receiverId';
  static String friendAcceptEndpoint(String friendshipId) =>
      '$baseUrl/friends/accept/$friendshipId';
  static String friendEndpoint(String friendshipId) =>
      '$baseUrl/friends/$friendshipId';
  static String friendUpcomingConcertsEndpoint(String friendId) =>
      '$baseUrl/friends/$friendId/upcoming-concerts';
  static String friendAllConcertsEndpoint(String friendId) =>
      '$baseUrl/friends/$friendId/concerts';
  static String friendStatsEndpoint(String friendId) =>
      '$baseUrl/friends/$friendId/stats';

  // Panel de administración (solo usuarios con isAdmin)
  static const String adminStatsEndpoint = '$baseUrl/admin/stats';
  static const String adminBroadcastEndpoint = '$baseUrl/admin/broadcast';
  static const String adminBroadcastPreviewEndpoint =
      '$baseUrl/admin/broadcast/preview';
  static const String adminVersionsEndpoint = '$baseUrl/admin/versions';
  static const String adminUsersEndpoint = '$baseUrl/admin/users';
  static String adminUserProEndpoint(String userId) =>
      '$baseUrl/admin/users/$userId/pro';

  // Quiero ir
  static const String wantToAttendEndpoint = '$baseUrl/want-to-attend';
  static const String wantToAttendToggleEndpoint = '$baseUrl/want-to-attend/toggle';

  // Etiquetado en conciertos
  static String concertTagEndpoint(String concertId, String friendId) =>
      '$concertsEndpoint/$concertId/tag/$friendId';

  // Recomendaciones (proxy Ticketmaster en backend)
  static const String recommendationsEndpoint = '$baseUrl/recommendations';

  // Spotify (proxy en backend — el secret vive solo en el servidor)
  static const String spotifyArtistEndpoint = '$baseUrl/spotify/artist';
  static const String spotifyArtistsSearchEndpoint = '$baseUrl/spotify/artists/search';
  static String spotifyTopTracksEndpoint(String artistId) =>
      '$baseUrl/spotify/artist/$artistId/top-tracks';

  // Setlist (proxy en backend — la API key vive solo en el servidor)
  static const String setlistSearchEndpoint = '$baseUrl/setlist/search';

  // Fotos
  static String concertPhotosEndpoint(String concertId) =>
      '$concertsEndpoint/$concertId/photos';
  static String photoEndpoint(String photoId) => '$baseUrl/photos/$photoId';
  static String photoTagEndpoint(String photoId, String friendId) =>
      '$baseUrl/photos/$photoId/tag/$friendId';

  // Colección de discos (proxy Discogs en backend)
  static const String recordsEndpoint = '$baseUrl/records';
  static const String recordsSearchEndpoint = '$baseUrl/records/search';
  static String recordEndpoint(String id) => '$baseUrl/records/$id';

  // Vinculación OAuth con Discogs
  static const String discogsStartEndpoint = '$baseUrl/discogs/connect/start';
  static const String discogsFinishEndpoint = '$baseUrl/discogs/connect/finish';
  static const String discogsStatusEndpoint = '$baseUrl/discogs/status';
  static const String discogsImportEndpoint = '$baseUrl/discogs/import';
  static const String discogsConnectionEndpoint = '$baseUrl/discogs/connection';
}
