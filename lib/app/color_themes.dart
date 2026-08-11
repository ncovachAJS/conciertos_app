import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Modelo
// ─────────────────────────────────────────────────────────────────────────────

class ThemePack {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final bool isPro;

  /// Colores para la tarjeta de preview (no dependen de light/dark).
  final Color previewBg;
  final Color previewPrimary;
  final Color previewSecondary;

  final ThemeData light;
  final ThemeData dark;

  const ThemePack({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.isPro,
    required this.previewBg,
    required this.previewPrimary,
    required this.previewSecondary,
    required this.light,
    required this.dark,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Registro de temas
// ─────────────────────────────────────────────────────────────────────────────

class ColorThemes {
  ColorThemes._(); // coverage:ignore-line

  // ── Fábrica compartida ──────────────────────────────────────────────────────

  static ThemeData _build({
    required Brightness brightness,
    required Color primary,
    required Color secondary,
    required Color bg,
    required Color surface,
    required Color card,
  }) {
    final isDark = brightness == Brightness.dark;
    final onSurface = isDark ? Colors.white : const Color(0xFF1A1A1A);

    final colorScheme = isDark
        ? ColorScheme.dark(
            primary: primary,
            secondary: secondary,
            surface: surface,
            surfaceContainerHighest: card,
          )
        : ColorScheme.light(
            primary: primary,
            secondary: secondary,
            surface: surface,
            surfaceContainerHighest: card,
          );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: onSurface),
        titleTextStyle: TextStyle(
          color: onSurface,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primary, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: _contrastColor(primary),
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.bold,
          color: onSurface,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: onSurface,
        ),
        titleLarge: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        bodyLarge: const TextStyle(fontSize: 16),
        bodyMedium: TextStyle(
          color: isDark ? Colors.white70 : Colors.black54,
        ),
      ),
    );
  }

  /// Devuelve blanco u oscuro según la luminancia del color de fondo.
  static Color _contrastColor(Color bg) =>
      bg.computeLuminance() > 0.35 ? const Color(0xFF1A1A1A) : Colors.white;

  // ── Definiciones ────────────────────────────────────────────────────────────

  static final ThemePack escenario = ThemePack(
    id: 'escenario',
    name: 'Escenario',
    emoji: '🔴',
    description: 'El clásico. Rojo pasión sobre negro puro.',
    isPro: false,
    previewBg: const Color(0xFF121212),
    previewPrimary: const Color(0xFFE53935),
    previewSecondary: const Color(0xFFFFC107),
    dark: _build(
      brightness: Brightness.dark,
      primary: const Color(0xFFE53935),
      secondary: const Color(0xFFFFC107),
      bg: const Color(0xFF121212),
      surface: const Color(0xFF1E1E1E),
      card: const Color(0xFF252525),
    ),
    light: _build(
      brightness: Brightness.light,
      primary: const Color(0xFFE53935),
      secondary: const Color(0xFFFFC107),
      bg: const Color(0xFFF5F5F5),
      surface: Colors.white,
      card: Colors.white,
    ),
  );

  static final ThemePack vinilo = ThemePack(
    id: 'vinilo',
    name: 'Vinilo',
    emoji: '🟡',
    description: 'Oro sobre carbón. Lujo atemporal.',
    isPro: true,
    previewBg: const Color(0xFF1A1A1A),
    previewPrimary: const Color(0xFFD4AF37),
    previewSecondary: const Color(0xFF8B6914),
    dark: _build(
      brightness: Brightness.dark,
      primary: const Color(0xFFD4AF37),
      secondary: const Color(0xFFB8860B),
      bg: const Color(0xFF1A1A1A),
      surface: const Color(0xFF242424),
      card: const Color(0xFF2C2C2C),
    ),
    light: _build(
      brightness: Brightness.light,
      primary: const Color(0xFF9A7B00),
      secondary: const Color(0xFFB8860B),
      bg: const Color(0xFFF8F4E8),
      surface: const Color(0xFFFFFBF0),
      card: Colors.white,
    ),
  );

  static final ThemePack festival = ThemePack(
    id: 'festival',
    name: 'Festival',
    emoji: '🟢',
    description: 'Verde eléctrico. Energía de campo abierto.',
    isPro: true,
    previewBg: const Color(0xFF0A1200),
    previewPrimary: const Color(0xFFAEEA00),
    previewSecondary: const Color(0xFF69F0AE),
    dark: _build(
      brightness: Brightness.dark,
      primary: const Color(0xFFAEEA00),
      secondary: const Color(0xFF69F0AE),
      bg: const Color(0xFF0A1200),
      surface: const Color(0xFF131F00),
      card: const Color(0xFF1A2900),
    ),
    light: _build(
      brightness: Brightness.light,
      primary: const Color(0xFF33691E),
      secondary: const Color(0xFF1B5E20),
      bg: const Color(0xFFF1F8E9),
      surface: Colors.white,
      card: Colors.white,
    ),
  );

  static final ThemePack neonPunk = ThemePack(
    id: 'neon_punk',
    name: 'Neon Punk',
    emoji: '💜',
    description: 'Magenta y cian sobre púrpura profundo. Synthwave.',
    isPro: true,
    previewBg: const Color(0xFF110025),
    previewPrimary: const Color(0xFFE040FB),
    previewSecondary: const Color(0xFF00BCD4),
    dark: _build(
      brightness: Brightness.dark,
      primary: const Color(0xFFE040FB),
      secondary: const Color(0xFF00BCD4),
      bg: const Color(0xFF110025),   // midnight purple
      surface: const Color(0xFF2E006A), // violeta oscuro — lum. ~0.016
      card: const Color(0xFF3E0088),   // violeta más claro — lum. ~0.027
    ),
    light: _build(
      brightness: Brightness.light,
      primary: const Color(0xFF8E24AA),
      secondary: const Color(0xFF0097A7),
      bg: const Color(0xFFF3E5F5),
      surface: Colors.white,
      card: Colors.white,
    ),
  );

  static final ThemePack acustico = ThemePack(
    id: 'acustico',
    name: 'Acústico',
    emoji: '🟤',
    description: 'Tierra y madera. Para los amantes del folk.',
    isPro: true,
    previewBg: const Color(0xFFFAF7F0),
    previewPrimary: const Color(0xFF7B5E3A),
    previewSecondary: const Color(0xFFD4A056),
    dark: _build(
      brightness: Brightness.dark,
      primary: const Color(0xFFD4A056),
      secondary: const Color(0xFFA0522D),
      bg: const Color(0xFF1A1108),
      surface: const Color(0xFF26190A),
      card: const Color(0xFF2E1F0E),
    ),
    light: _build(
      brightness: Brightness.light,
      primary: const Color(0xFF7B5E3A),
      secondary: const Color(0xFF9E7B4E),
      bg: const Color(0xFFFAF7F0),
      surface: const Color(0xFFFFF8F0),
      card: Colors.white,
    ),
  );

  static final ThemePack backstage = ThemePack(
    id: 'backstage',
    name: 'Backstage',
    emoji: '🟠',
    description: 'Naranja neón sobre azul marino profundo.',
    isPro: true,
    previewBg: const Color(0xFF0D1B2A),
    previewPrimary: const Color(0xFFFF6D00),
    previewSecondary: const Color(0xFFFFA726),
    dark: _build(
      brightness: Brightness.dark,
      primary: const Color(0xFFFF6D00),
      secondary: const Color(0xFFFFA726),
      bg: const Color(0xFF0D1B2A),
      surface: const Color(0xFF142233),
      card: const Color(0xFF1A2C40),
    ),
    light: _build(
      brightness: Brightness.light,
      primary: const Color(0xFFE65100),
      secondary: const Color(0xFFFF8F00),
      bg: const Color(0xFFFFF3E0),
      surface: Colors.white,
      card: Colors.white,
    ),
  );

  static final ThemePack jazzClub = ThemePack(
    id: 'jazz_club',
    name: 'Jazz Club',
    emoji: '⚫',
    description: 'Oro sobre terciopelo púrpura. Sofisticación nocturna.',
    isPro: true,
    previewBg: const Color(0xFF0E0020),
    previewPrimary: const Color(0xFFFFD700),
    previewSecondary: const Color(0xFF9C27B0),
    dark: _build(
      brightness: Brightness.dark,
      primary: const Color(0xFFFFD700),
      secondary: const Color(0xFFCE93D8),
      bg: const Color(0xFF0E0020),   // negro con tinte violeta
      surface: const Color(0xFF27004E), // ciruela oscura — lum. ~0.010
      card: const Color(0xFF380070),   // ciruela — lum. ~0.020
    ),
    light: _build(
      brightness: Brightness.light,
      primary: const Color(0xFF6A1B9A),
      secondary: const Color(0xFFFFB300),
      bg: const Color(0xFFF3E5F5),
      surface: Colors.white,
      card: Colors.white,
    ),
  );

  // ── Lista completa (orden de presentación) ──────────────────────────────────

  static final List<ThemePack> all = [
    escenario,
    vinilo,
    festival,
    neonPunk,
    acustico,
    backstage,
    jazzClub,
  ];

  static ThemePack findById(String id) =>
      all.firstWhere((t) => t.id == id, orElse: () => escenario);
}
