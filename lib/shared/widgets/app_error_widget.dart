import 'package:flutter/material.dart';

/// Widget de error reutilizable con ícono, mensaje y botón de reintentar.
/// Úsalo en cualquier pantalla en lugar de texto plano de error.
class AppErrorWidget extends StatelessWidget {
  final Object? error;
  final VoidCallback? onRetry;
  final String? customMessage;

  const AppErrorWidget({
    super.key,
    this.error,
    this.onRetry,
    this.customMessage,
  });

  String _message() {
    if (customMessage != null) return customMessage!;
    final err = error?.toString() ?? '';
    if (err.contains('SocketException') || err.contains('Failed host lookup')) {
      return 'Sin conexión a internet';
    }
    if (err.contains('TimeoutException')) {
      return 'El servidor tardó demasiado en responder';
    }
    if (err.contains('401')) return 'Sesión expirada. Volvé a iniciar sesión';
    if (err.contains('403')) return 'No tenés permiso para ver esto';
    if (err.contains('404')) return 'No se encontró el contenido';
    if (err.contains('500') || err.contains('503')) {
      return 'Error en el servidor. Intentá más tarde';
    }
    return 'Algo salió mal. Intentá de nuevo';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 56,
              color: cs.onSurface.withOpacity(0.25),
            ),
            const SizedBox(height: 16),
            Text(
              _message(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: cs.onSurface.withOpacity(0.55),
                fontSize: 15,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reintentar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
