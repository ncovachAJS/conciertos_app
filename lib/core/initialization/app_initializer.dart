/// Inicializador de la app durante la splash screen.
///
/// En lugar de depender de [DashboardController] (singleton manual),
/// recibe un callback [onLoadConcerts] que el caller inyecta.
/// Esto permite que la splash page use el provider de Riverpod.
class AppInitializer {
  final Future<void> Function() onLoadConcerts;

  AppInitializer({required this.onLoadConcerts});

  Future<void> initialize({
    required Function(String message, double progress) onProgress,
  }) async {
    final stopwatch = Stopwatch()..start();

    onProgress('🎸 Preparando escenario...', 0.10);
    await Future.delayed(const Duration(milliseconds: 1000));

    onProgress('🔊 Probando sonido...', 0.25);
    await Future.delayed(const Duration(milliseconds: 1000));

    onProgress('💡 Encendiendo las luces...', 0.40);
    await Future.delayed(const Duration(milliseconds: 1000));

    onProgress('🎫 Cargando conciertos...', 0.55);
    await onLoadConcerts();

    onProgress('📸 Organizando recuerdos...', 0.80);
    await Future.delayed(const Duration(milliseconds: 1000));

    onProgress('🤘 ¡Que empiece el concierto!', 1);
    await Future.delayed(const Duration(milliseconds: 1000));

    const minimumDuration = Duration(seconds: 5);
    final remaining = minimumDuration - stopwatch.elapsed;
    if (remaining > Duration.zero) {
      await Future.delayed(remaining);
    }
  }
}
