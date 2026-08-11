import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/color_themes.dart';
import '../../../../../app/theme_pack_provider.dart';
import '../../../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../../../../shared/widgets/pro_paywall_sheet.dart';

class ColorThemePickerPage extends ConsumerWidget {
  const ColorThemePickerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(themePackProvider);
    final cs = Theme.of(context).colorScheme;
    final isPro = AuthController.instance.user?.isPro ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('Paleta de color')),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Cambia el acento de color de toda la app. '
                'Las paletas Pro requieren suscripción activa.',
                style: TextStyle(
                  fontSize: 13,
                  color: cs.onSurface.withValues(alpha: .55),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.82,
              ),
              itemCount: ColorThemes.all.length,
              itemBuilder: (context, index) {
                final pack = ColorThemes.all[index];
                final isSelected = pack.id == current.id;
                final locked = pack.isPro && !isPro;

                return _ThemeCard(
                  pack: pack,
                  selected: isSelected,
                  locked: locked,
                  onTap: () async {
                    if (locked) {
                      // Muestra el paywall Pro — reutilizamos el sheet
                      await ProPaywallSheet.showPaywall(context);
                      return;
                    }
                    await ref.read(themePackProvider.notifier).setPack(pack);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tarjeta de preview
// ─────────────────────────────────────────────────────────────────────────────

class _ThemeCard extends StatelessWidget {
  final ThemePack pack;
  final bool selected;
  final bool locked;
  final VoidCallback onTap;

  const _ThemeCard({
    required this.pack,
    required this.selected,
    required this.locked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? pack.previewPrimary : cs.outline.withValues(alpha: .2),
            width: selected ? 2.5 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: pack.previewPrimary.withValues(alpha: .35),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Preview visual ───────────────────────────────────────────────
            Expanded(
              child: _MiniPreview(pack: pack, locked: locked),
            ),

            // ── Info ─────────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
              color: cs.surface,
              child: Row(
                children: [
                  Text(pack.emoji, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pack.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        if (pack.isPro && !selected)
                          const Text(
                            'Pro',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF9C27B0),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (selected)
                    Icon(
                      Icons.check_circle_rounded,
                      color: pack.previewPrimary,
                      size: 20,
                    )
                  else if (locked)
                    const Icon(
                      Icons.lock_rounded,
                      size: 16,
                      color: Color(0xFF9C27B0),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mini preview — simula la UI de la app con los colores del tema
// ─────────────────────────────────────────────────────────────────────────────

class _MiniPreview extends StatelessWidget {
  final ThemePack pack;
  final bool locked;

  const _MiniPreview({required this.pack, required this.locked});

  @override
  Widget build(BuildContext context) {
    final bg = pack.previewBg;
    final primary = pack.previewPrimary;
    final secondary = pack.previewSecondary;
    final textColor = bg.computeLuminance() > 0.3 ? Colors.black54 : Colors.white54;
    final textColorStrong = bg.computeLuminance() > 0.3 ? Colors.black87 : Colors.white;
    // Surface slightly lighter/darker than bg
    final surface = Color.lerp(bg, textColorStrong, 0.06) ?? bg;

    return Stack(
      children: [
        Container(
          color: bg,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App bar simulada
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 6,
                    decoration: BoxDecoration(
                      color: textColorStrong.withValues(alpha: .8),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Saludo
              Container(
                width: 80,
                height: 5,
                decoration: BoxDecoration(
                  color: textColorStrong.withValues(alpha: .6),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),

              const SizedBox(height: 3),
              Container(
                width: 55,
                height: 4,
                decoration: BoxDecoration(
                  color: textColor.withValues(alpha: .5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 10),

              // Quick actions (4 círculos)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (i) {
                  final color = i == 0
                      ? primary
                      : i == 1
                          ? secondary
                          : i == 2
                              ? primary.withValues(alpha: .6)
                              : secondary.withValues(alpha: .6);
                  return Column(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: .2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        width: 18,
                        height: 3,
                        decoration: BoxDecoration(
                          color: textColor.withValues(alpha: .4),
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      ),
                    ],
                  );
                }),
              ),

              const SizedBox(height: 10),

              // Card simulada
              Container(
                width: double.infinity,
                height: 38,
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: .25),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: textColorStrong.withValues(alpha: .6),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Container(
                            width: 40,
                            height: 3,
                            decoration: BoxDecoration(
                              color: textColor.withValues(alpha: .4),
                              borderRadius: BorderRadius.circular(1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Botón primario
              Container(
                width: double.infinity,
                height: 16,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Container(
                    width: 30,
                    height: 3,
                    decoration: BoxDecoration(
                      color: _contrastColor(primary).withValues(alpha: .7),
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Overlay bloqueado
        if (locked)
          Container(
            color: Colors.black.withValues(alpha: .45),
            child: const Center(
              child: Icon(Icons.lock_rounded, color: Colors.white, size: 28),
            ),
          ),
      ],
    );
  }

  static Color _contrastColor(Color color) =>
      color.computeLuminance() > 0.35 ? Colors.black : Colors.white;
}
