import 'package:conciertos_app/features/home/presentation/controllers/dashboard_controller.dart';

class AppInitializer {
  final DashboardController dashboardController;

  AppInitializer(this.dashboardController);

  Future<void> initialize({
    required Function(String message, double progress) onProgress,
  }) async {
    final stopwatch = Stopwatch()..start();

    onProgress('🎸 Preparando escenario...', 0.15);
    await Future.delayed(const Duration(milliseconds: 350));

    onProgress('🔊 Probando sonido...', 0.30);
    await Future.delayed(const Duration(milliseconds: 350));

    onProgress('🎫 Cargando conciertos...', 0.45);

    await dashboardController.load();

    onProgress('📊 Preparando estadísticas...', 0.85);
    await Future.delayed(const Duration(milliseconds: 300));

    onProgress('🤘 ¡Que empiece el concierto!', 1);

    // La splash durará al menos 2,5 segundos.
    const minimumDuration = Duration(milliseconds: 2500);

    final remaining = minimumDuration - stopwatch.elapsed;

    if (remaining > Duration.zero) {
      await Future.delayed(remaining);
    }
  }
}
