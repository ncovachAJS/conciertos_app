import 'package:flutter/foundation.dart';

/// Se incrementa cada vez que se añaden recuerdos fuera de la pantalla de
/// Recuerdos (p. ej. desde un atajo del inicio), para que esta se recargue.
final ValueNotifier<int> memoriesChanged = ValueNotifier<int>(0);
