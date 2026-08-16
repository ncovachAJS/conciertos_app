import 'package:flutter/foundation.dart';

/// Singleton que mantiene la meta anual en memoria para que todos los
/// widgets suscritos se actualicen inmediatamente al cambiarla desde ajustes.
class AnnualGoalNotifier extends ValueNotifier<int?> {
  AnnualGoalNotifier._() : super(null);
  static final instance = AnnualGoalNotifier._();
}
