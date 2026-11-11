import 'dart:io';

/// Enlaces para abrir la tienda desde un aviso de actualización.
class StoreLinks {
  StoreLinks._();

  static const String androidPackage = 'com.nico.lavidaendirecto';

  /// ID numérico de la app en App Store Connect.
  static const String iosAppId = '6816712349';

  static Uri get current {
    if (Platform.isIOS) {
      return Uri.parse('https://apps.apple.com/app/id$iosAppId');
    }
    return Uri.parse(
      'https://play.google.com/store/apps/details?id=$androidPackage',
    );
  }
}
