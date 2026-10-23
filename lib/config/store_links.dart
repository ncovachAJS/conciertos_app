import 'dart:io';

/// Enlaces para abrir la tienda desde un aviso de actualización.
class StoreLinks {
  StoreLinks._();

  static const String androidPackage = 'com.nico.lavidaendirecto';

  /// Poner a `true` cuando la app esté aprobada y publicada en Google Play.
  /// Hasta entonces Android abre el enlace de pruebas (testers).
  static const bool androidPublished = true;

  /// Enlace de pruebas internas de Google Play (Play Console → Pruebas →
  /// Pruebas internas → Testers).
  static const String androidTesterUrl =
      'https://play.google.com/apps/internaltest/4701661126429174511';

  /// ID numérico de la app en App Store Connect (Información de la app →
  /// "ID de Apple"). Mientras esté vacío, en iOS se abre la búsqueda por nombre.
  static const String iosAppId = '';

  static Uri get current {
    if (Platform.isIOS) {
      return iosAppId.isEmpty
          ? Uri.parse(
              'https://apps.apple.com/search?term=La%20Vida%20en%20Directo',
            )
          : Uri.parse('https://apps.apple.com/app/id$iosAppId');
    }
    return Uri.parse(
      androidPublished
          ? 'https://play.google.com/store/apps/details?id=$androidPackage'
          : androidTesterUrl,
    );
  }
}
