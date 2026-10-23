import 'package:url_launcher/url_launcher.dart';

import '../../../app/router.dart';
import '../../../config/store_links.dart';

/// Destino al que lleva un aviso del administrador al tocarlo.
///
/// Los valores deben coincidir con `ANNOUNCEMENT_TARGETS` del backend. Un valor
/// desconocido (p. ej. de una versión futura) se ignora sin romper nada.
class NotificationTarget {
  NotificationTarget._();

  static const String store = 'store';

  static const Map<String, String> _routes = {
    'notifications': '/notifications',
    'friends': '/friends',
    'statistics': '/statistics',
    'records': '/records',
  };

  static bool isKnown(String? target) =>
      target == store || _routes.containsKey(target);

  /// Abre el destino. No hace nada si es nulo o no se conoce.
  static Future<void> open(String? target) async {
    if (target == store) {
      await launchUrl(StoreLinks.current, mode: LaunchMode.externalApplication);
      return;
    }
    final route = _routes[target];
    if (route != null) appRouter.push(route);
  }
}
