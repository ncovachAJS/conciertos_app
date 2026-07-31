/// Inicializador de la app durante la splash screen.
///
/// Recibe un callback [onLoadConcerts] que pre-calienta el provider de Riverpod
/// y opcionalmente una lista de [stepMessages] para mostrar texto localizado.
class AppInitializer {
  final Future<void> Function() onLoadConcerts;

  AppInitializer({required this.onLoadConcerts});

  static const _defaultMessages = [
    '🎸 Preparando escenario...',
    '🔊 Probando sonido...',
    '💡 Encendiendo las luces...',
    '🎫 Cargando conciertos...',
    '📸 Organizando recuerdos...',
    '🤘 ¡Que empiece el concierto!',
  ];

  Future<void> initialize({
    required Function(String message, double progress) onProgress,
    List<String>? stepMessages,
  }) async {
    final msgs = (stepMessages != null && stepMessages.length >= 6)
        ? stepMessages
        : _defaultMessages;

    final stopwatch = Stopwatch()..start();

    onProgress(msgs[0], 0.10);
    await Future.delayed(const Duration(milliseconds: 1000));

    onProgress(msgs[1], 0.25);
    await Future.delayed(const Duration(milliseconds: 1000));

    onProgress(msgs[2], 0.40);
    await Future.delayed(const Duration(milliseconds: 1000));

    onProgress(msgs[3], 0.55);
    await onLoadConcerts();

    onProgress(msgs[4], 0.80);
    await Future.delayed(const Duration(milliseconds: 1000));

    onProgress(msgs[5], 1);
    await Future.delayed(const Duration(milliseconds: 1000));

    const minimumDuration = Duration(seconds: 5);
    final remaining = minimumDuration - stopwatch.elapsed;
    if (remaining > Duration.zero) {
      await Future.delayed(remaining);
    }
  }
}
