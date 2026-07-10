import 'package:conciertos_app/features/home/presentation/controllers/dashboard_controller.dart';

class AppInitializer {
  final DashboardController dashboardController;

  AppInitializer(this.dashboardController);

  Future<void> initialize({
    required Function(String message, double progress) onProgress,
  }) async {
    final stopwatch = Stopwatch()..start();

    onProgress('🎫 Cargando conciertos...', 1);

    await dashboardController.load();

    onProgress('🤘 ¡Que empiece el concierto!', 2);

    // Garantizar una duración mínima de 5 segundos
    const minimumDuration = Duration(seconds: 5);

    final remaining = minimumDuration - stopwatch.elapsed;

    if (remaining > Duration.zero) {
      await Future.delayed(remaining);
    }
  }
}
