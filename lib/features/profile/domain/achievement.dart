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
  static List<Achievement> compute(UserStats s) {
    final now = DateTime.now().year;
    final yearsSince = s.oldestYear > 0 ? now - s.oldestYear : 0;

    return [
      // ── Cantidad de conciertos ────────────────────────────────────────────
      _a('first_concert',   '🎵', 'Primer directo',
          'Asiste a tu primer concierto',                   s.totalConcerts >= 1),
      _a('five_concerts',   '🎶', 'Habitual',
          '5 conciertos en el cuerpo',                      s.totalConcerts >= 5),
      _a('twenty_five',     '🏆', 'Veterano',
          '25 conciertos no es para cualquiera',            s.totalConcerts >= 25),
      _a('fifty_concerts',  '🔥', 'Experto',
          '50 conciertos. Ya lo has visto todo',            s.totalConcerts >= 50),
      _a('hundred_concerts','👑', 'Leyenda',
          '100 conciertos. Eres una leyenda del directo',   s.totalConcerts >= 100),
      _a('two_hundred',     '🌠', 'Inmortal',
          '200 conciertos. A otro nivel',                   s.totalConcerts >= 200),

      // ── Géneros ───────────────────────────────────────────────────────────
      _a('rockero',         '🎸', 'Rockero',
          '3 conciertos de rock',                           s.rockConcerts >= 3),
      _a('rockero_pro',     '⚡', 'Rock Puro',
          '10 conciertos de rock',                          s.rockConcerts >= 10),
      _a('metalero',        '🤘', 'Metalero',
          '3 conciertos de metal o heavy',                  s.metalConcerts >= 3),
      _a('urbano',          '🎤', 'Urbano',
          '3 conciertos de hip-hop, rap o trap',            s.urbanConcerts >= 3),

      // ── Festivales ────────────────────────────────────────────────────────
      _a('first_festival',  '🎪', 'Festivalero',
          'Tu primer festival',                             s.uniqueFestivals >= 1),
      _a('five_festivals',  '🌈', 'Festival Addict',
          '5 festivales distintos',                         s.uniqueFestivals >= 5),
      _a('ten_festivals',   '🎠', 'Rey del Festival',
          '10 festivales distintos',                        s.uniqueFestivals >= 10),

      // ── Artistas ─────────────────────────────────────────────────────────
      _a('eclectico',       '🎨', 'Ecléctico',
          '10 artistas distintos',                          s.uniqueArtists >= 10),
      _a('explorador',      '🌍', 'Explorador',
          '25 artistas distintos',                          s.uniqueArtists >= 25),
      _a('coleccionista',   '🗂️', 'Coleccionista',
          '50 artistas distintos',                          s.uniqueArtists >= 50),

      // ── Superfan ──────────────────────────────────────────────────────────
      _a('superfan',        '💘', 'Superfan',
          'Viste al mismo artista 3 veces',                 s.maxSameArtist >= 3),
      _a('obsesionado',     '🔁', 'Obsesionado',
          'Viste al mismo artista 5 veces',                 s.maxSameArtist >= 5),

      // ── Ciudades ─────────────────────────────────────────────────────────
      _a('viajero',         '🗺️', 'Viajero',
          'Conciertos en 3 ciudades distintas',             s.uniqueCities >= 3),
      _a('turista',         '✈️', 'Turista Musical',
          'Conciertos en 10 ciudades distintas',            s.uniqueCities >= 10),

      // ── Crítico / valoraciones ────────────────────────────────────────────
      _a('critico',         '⭐', 'Crítico',
          'Valora tu primer concierto',                     s.totalRated >= 1),
      _a('gran_critico',    '🎯', 'Gran Crítico',
          'Valora 10 conciertos',                           s.totalRated >= 10),
      _a('analitico',       '📊', 'Analítico',
          'Valora 25 conciertos',                           s.totalRated >= 25),
      _a('perfeccionista',  '💯', 'Perfeccionista',
          'Da 5 estrellas a un concierto',                  s.fiveStarConcerts >= 1),

      // ── Favoritos ────────────────────────────────────────────────────────
      _a('apasionado',      '❤️', 'Apasionado',
          '10 conciertos en favoritos',                     s.totalFavorites >= 10),

      // ── Dinero ───────────────────────────────────────────────────────────
      _a('maniroto',        '💸', 'Maniroto',
          'Más de 500 € gastados en entradas',              s.totalSpent >= 500),

      // ── Antigüedad ────────────────────────────────────────────────────────
      _a('historico',       '📅', 'Fan Histórico',
          'Llevas más de 5 años yendo a conciertos',        yearsSince >= 5),
      _a('decada',          '🕰️', 'Una Década',
          'Más de 10 años en la brecha',                    yearsSince >= 10),
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
