/// Configuración de los límites de la versión gratuita.
class ProConfig {
  ProConfig._(); // coverage:ignore-line

  /// Máximo de conciertos propios en la versión gratuita.
  static const int freeConcertLimit = 50;

  /// Interruptor global: mientras sea `true`, todas las funciones Pro están
  /// desbloqueadas para todo el mundo (lanzamiento sin cobro). Cambiar a
  /// `false` cuando se integre el cobro (RevenueCat) para volver a aplicar
  /// los límites reales.
  static const bool allFeaturesFree = true;

  /// Resuelve si un usuario debe tratarse como Pro, teniendo en cuenta
  /// [allFeaturesFree]. Usar siempre este helper en vez de leer
  /// `user.isPro` directamente.
  static bool isUserPro(bool? rawIsPro) =>
      allFeaturesFree || (rawIsPro ?? false);
}
