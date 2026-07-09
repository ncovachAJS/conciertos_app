class ApiConfig {
  ApiConfig._();

  static const String baseUrl = 'https://conciertos-backend.onrender.com';

  static const String concertsEndpoint = '$baseUrl/concerts';

  static const String uploadsEndpoint = '$baseUrl/uploads/image';

  static const String photosFeedEndpoint = '$baseUrl/photos/feed';

  /// Fotos de un concierto concreto: `/concerts/:id/photos`.
  static String concertPhotosEndpoint(String concertId) =>
      '$concertsEndpoint/$concertId/photos';

  /// Una foto concreta: `/photos/:id`.
  static String photoEndpoint(String photoId) => '$baseUrl/photos/$photoId';
}
