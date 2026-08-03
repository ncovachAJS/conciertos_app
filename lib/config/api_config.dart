class ApiConfig {
  ApiConfig._();

  static const String baseUrl = 'https://conciertos-backend.onrender.com';

  static const String concertsEndpoint = '$baseUrl/concerts';
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
  static String friendStatsEndpoint(String friendId) =>
      '$baseUrl/friends/$friendId/stats';

  // Etiquetado en conciertos
  static String concertTagEndpoint(String concertId, String friendId) =>
      '$concertsEndpoint/$concertId/tag/$friendId';

  // Fotos
  static String concertPhotosEndpoint(String concertId) =>
      '$concertsEndpoint/$concertId/photos';
  static String photoEndpoint(String photoId) => '$baseUrl/photos/$photoId';
  static String photoTagEndpoint(String photoId, String friendId) =>
      '$baseUrl/photos/$photoId/tag/$friendId';
}
