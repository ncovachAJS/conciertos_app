import 'package:conciertos_app/l10n/generated/app_localizations.dart';

class Achievement {
  final String id;
  final String emoji;
  final String title;
  final String description;
  final bool unlocked;

  const Achievement({
    required this.id,
    required this.emoji,
    required this.title,
    required this.description,
    required this.unlocked,
  });
}

class UserStats {
  final int totalConcerts;
  final int uniqueArtists;
  final int uniqueFestivals;
  final int uniqueCities;
  final int totalRated;
  final int oldestYear;
  // Géneros
  final int rockConcerts;
  final int metalConcerts;
  final int jazzConcerts;
  final int urbanConcerts; // hip-hop, rap, trap, reggaeton
  // Calidad
  final int fiveStarConcerts;
  // Superfan
  final int maxSameArtist; // máximo de veces que fue al mismo artista
  // Dinero
  final double totalSpent;
  // Favoritos
  final int totalFavorites;

  const UserStats({
    this.totalConcerts = 0,
    this.uniqueArtists = 0,
    this.uniqueFestivals = 0,
    this.uniqueCities = 0,
    this.totalRated = 0,
    this.oldestYear = 0,
    this.rockConcerts = 0,
    this.metalConcerts = 0,
    this.jazzConcerts = 0,
    this.urbanConcerts = 0,
    this.fiveStarConcerts = 0,
    this.maxSameArtist = 0,
    this.totalSpent = 0,
    this.totalFavorites = 0,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) => UserStats(
        totalConcerts: json['totalConcerts'] ?? 0,
        uniqueArtists: json['uniqueArtists'] ?? 0,
        uniqueFestivals: json['uniqueFestivals'] ?? 0,
        uniqueCities: json['uniqueCities'] ?? 0,
        totalRated: json['totalRated'] ?? 0,
        oldestYear: json['oldestYear'] ?? 0,
        rockConcerts: json['rockConcerts'] ?? 0,
        metalConcerts: json['metalConcerts'] ?? 0,
        jazzConcerts: json['jazzConcerts'] ?? 0,
        urbanConcerts: json['urbanConcerts'] ?? 0,
        fiveStarConcerts: json['fiveStarConcerts'] ?? 0,
        maxSameArtist: json['maxSameArtist'] ?? 0,
        totalSpent: (json['totalSpent'] as num?)?.toDouble() ?? 0,
        totalFavorites: json['totalFavorites'] ?? 0,
      );
}

class AchievementsEngine {
  static List<Achievement> compute(AppLocalizations l, UserStats s) {
    final now = DateTime.now().year;
    final yearsSince = s.oldestYear > 0 ? now - s.oldestYear : 0;

    return [
      // ── Cantidad de conciertos ────────────────────────────────────────────
      _a('first_concert',   '🎵', l.achvFirstConcertTitle,
          l.achvFirstConcertDesc,                           s.totalConcerts >= 1),
      _a('five_concerts',   '🎶', l.achvFiveConcertsTitle,
          l.achvFiveConcertsDesc,                           s.totalConcerts >= 5),
      _a('twenty_five',     '🏆', l.achvTwentyFiveTitle,
          l.achvTwentyFiveDesc,                             s.totalConcerts >= 25),
      _a('fifty_concerts',  '🔥', l.achvFiftyConcertsTitle,
          l.achvFiftyConcertsDesc,                          s.totalConcerts >= 50),
      _a('hundred_concerts','👑', l.achvHundredConcertsTitle,
          l.achvHundredConcertsDesc,                        s.totalConcerts >= 100),
      _a('two_hundred',     '🌠', l.achvTwoHundredTitle,
          l.achvTwoHundredDesc,                             s.totalConcerts >= 200),

      // ── Géneros ───────────────────────────────────────────────────────────
      _a('rockero',         '🎸', l.achvRockeroTitle,
          l.achvRockeroDesc,                                s.rockConcerts >= 3),
      _a('rockero_pro',     '⚡', l.achvRockeroProTitle,
          l.achvRockeroProDesc,                              s.rockConcerts >= 10),
      _a('metalero',        '🤘', l.achvMetaleroTitle,
          l.achvMetaleroDesc,                                s.metalConcerts >= 3),
      _a('urbano',          '🎤', l.achvUrbanoTitle,
          l.achvUrbanoDesc,                                  s.urbanConcerts >= 3),

      // ── Festivales ────────────────────────────────────────────────────────
      _a('first_festival',  '🎪', l.achvFirstFestivalTitle,
          l.achvFirstFestivalDesc,                           s.uniqueFestivals >= 1),
      _a('five_festivals',  '🌈', l.achvFiveFestivalsTitle,
          l.achvFiveFestivalsDesc,                           s.uniqueFestivals >= 5),
      _a('ten_festivals',   '🎠', l.achvTenFestivalsTitle,
          l.achvTenFestivalsDesc,                            s.uniqueFestivals >= 10),

      // ── Artistas ─────────────────────────────────────────────────────────
      _a('eclectico',       '🎨', l.achvEclecticoTitle,
          l.achvEclecticoDesc,                               s.uniqueArtists >= 10),
      _a('explorador',      '🌍', l.achvExploradorTitle,
          l.achvExploradorDesc,                              s.uniqueArtists >= 25),
      _a('coleccionista',   '🗂️', l.achvColeccionistaTitle,
          l.achvColeccionistaDesc,                           s.uniqueArtists >= 50),

      // ── Superfan ──────────────────────────────────────────────────────────
      _a('superfan',        '💘', l.achvSuperfanTitle,
          l.achvSuperfanDesc,                                s.maxSameArtist >= 3),
      _a('obsesionado',     '🔁', l.achvObsesionadoTitle,
          l.achvObsesionadoDesc,                             s.maxSameArtist >= 5),

      // ── Ciudades ─────────────────────────────────────────────────────────
      _a('viajero',         '🗺️', l.achvViajeroTitle,
          l.achvViajeroDesc,                                 s.uniqueCities >= 3),
      _a('turista',         '✈️', l.achvTuristaTitle,
          l.achvTuristaDesc,                                 s.uniqueCities >= 10),

      // ── Crítico / valoraciones ────────────────────────────────────────────
      _a('critico',         '⭐', l.achvCriticoTitle,
          l.achvCriticoDesc,                                 s.totalRated >= 1),
      _a('gran_critico',    '🎯', l.achvGranCriticoTitle,
          l.achvGranCriticoDesc,                             s.totalRated >= 10),
      _a('analitico',       '📊', l.achvAnaliticoTitle,
          l.achvAnaliticoDesc,                               s.totalRated >= 25),
      _a('perfeccionista',  '💯', l.achvPerfeccionistaTitle,
          l.achvPerfeccionistaDesc,                          s.fiveStarConcerts >= 1),

      // ── Favoritos ────────────────────────────────────────────────────────
      _a('apasionado',      '❤️', l.achvApasionadoTitle,
          l.achvApasionadoDesc,                              s.totalFavorites >= 10),

      // ── Dinero ───────────────────────────────────────────────────────────
      _a('maniroto',        '💸', l.achvManirotoTitle,
          l.achvManirotoDesc,                                s.totalSpent >= 500),

      // ── Antigüedad ────────────────────────────────────────────────────────
      _a('historico',       '📅', l.achvHistoricoTitle,
          l.achvHistoricoDesc,                               yearsSince >= 5),
      _a('decada',          '🕰️', l.achvDecadaTitle,
          l.achvDecadaDesc,                                  yearsSince >= 10),
    ];
  }

  static Achievement _a(
          String id, String emoji, String title, String desc, bool unlocked) =>
      Achievement(
          id: id,
          emoji: emoji,
          title: title,
          description: desc,
          unlocked: unlocked);
}
