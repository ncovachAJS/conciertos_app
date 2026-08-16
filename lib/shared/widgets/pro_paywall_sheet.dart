import 'package:flutter/material.dart';

import '../../core/config/pro_config.dart';

/// Muestra el bottom sheet de límite alcanzado y devuelve `true` si el usuario
/// tenía permiso para continuar (isPro o bajo el límite), `false` si se bloqueó.
///
/// Uso:
/// ```dart
/// final allowed = await ProPaywallSheet.checkLimit(context, concertsCount, isPro);
/// if (allowed) context.push('/add');
/// ```
class ProPaywallSheet {
  ProPaywallSheet._(); // coverage:ignore-line

  /// Muestra el paywall directamente, sin comprobar límite.
  static Future<void> showPaywall(BuildContext context) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const _ProPaywallSheet(),
      );

  /// Retorna `true` si se puede añadir el concierto, `false` si se mostró el paywall.
  static Future<bool> checkLimit(
    BuildContext context,
    int ownConcertsCount,
    bool isPro,
  ) async {
    if (isPro || ownConcertsCount < ProConfig.freeConcertLimit) return true;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ProPaywallSheet(),
    );
    return false;
  }
}

class _ProPaywallSheet extends StatelessWidget {
  const _ProPaywallSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        20,
        24,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(bottom: 28),
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Ícono
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF2D1F5E)
                  : const Color(0xFFEDE9FE),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.workspace_premium_rounded,
              size: 32,
              color: Color(0xFF7C3AED),
            ),
          ),
          const SizedBox(height: 20),

          // Título
          Text(
            'Límite de ${ProConfig.freeConcertLimit} conciertos alcanzado',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),

          // Descripción
          Text(
            'Con la versión gratuita puedes guardar hasta ${ProConfig.freeConcertLimit} conciertos.\n'
            'Pásate a Pro para añadir todos los que quieras.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),

          // Beneficios
          _Benefit(icon: Icons.all_inclusive_rounded, label: 'Conciertos ilimitados'),
          _Benefit(icon: Icons.photo_library_rounded, label: 'Fotos ilimitadas por concierto'),
          _Benefit(icon: Icons.picture_as_pdf_rounded, label: 'Exportar estadísticas a PDF'),
          _Benefit(icon: Icons.dashboard_customize_rounded, label: 'Dashboard personalizable'),
          _Benefit(icon: Icons.palette_rounded, label: 'Temas de color exclusivos'),
          const SizedBox(height: 28),

          // CTA
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: navegar a la pantalla de pago cuando esté integrado RevenueCat
              },
              child: const Text(
                'Hacerse Pro',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Cancelar
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Ahora no',
              style: TextStyle(color: theme.textTheme.bodySmall?.color),
            ),
          ),
        ],
      ),
    );
  }
}

class _Benefit extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Benefit({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF7C3AED)),
          const SizedBox(width: 12),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
