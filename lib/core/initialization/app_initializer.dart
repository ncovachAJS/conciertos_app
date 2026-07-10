import 'package:conciertos_app/features/home/presentation/controllers/dashboard_controller.dart';

class AppInitializer {
  final DashboardController dashboardController;

  AppInitializer(this.dashboardController);

  Future<void> initialize({
    required Function(String message, double progress) onProgress,
  }) async {
    final stopwatch = Stopwatch()..start();

    onProgress('🎸 Preparando escenario...', 0.10);
    await Future.delayed(const Duration(milliseconds: 700));

    onProgress('🔊 Probando sonido...', 0.25);
    await Future.delayed(const Duration(milliseconds: 700));

    onProgress('💡 Encendiendo las luces...', 0.40);
    await Future.delayed(const Duration(milliseconds: 700));

    onProgress('🎫 Cargando conciertos...', 0.55);

    await dashboardController.load();

    onProgress('📸 Organizando recuerdos...', 0.80);
    await Future.delayed(const Duration(milliseconds: 600));

    onProgress('🤘 ¡Que empiece el concierto!', 1);
    await Future.delayed(const Duration(milliseconds: 800));

    // La splash durará al menos 2,5 segundos.
    const minimumDuration = Duration(seconds: 8);

    final remaining = minimumDuration - stopwatch.elapsed;

    if (remaining > Duration.zero) {
      await Future.delayed(remaining);
    }
  }
}
