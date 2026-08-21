import 'package:flutter/material.dart';

/// Utilidades de diseño adaptativo.
///
/// El único punto de verdad para breakpoints: cualquier widget que necesite
/// saber si está en tablet importa solo este archivo.
abstract final class Responsive {
  /// Ancho mínimo para considerar la pantalla como tablet (iPad, etc.)
  static const double _tabletBreakpoint = 768;

  /// Ancho máximo del área de contenido en tablet.
  /// El contenido se centra dentro de este límite para no quedar
  /// excesivamente estirado en pantallas grandes.
  static const double maxContentWidth = 680;

  /// `true` cuando la pantalla mide ≥ 768 pt de ancho (iPad en portrait
  /// o landscape, iPad mini incluido).
  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= _tabletBreakpoint;

  /// Número de columnas para un GridView según el dispositivo.
  static int gridColumns(
    BuildContext context, {
    int phone = 2,
    int tablet = 3,
  }) =>
      isTablet(context) ? tablet : phone;
}
