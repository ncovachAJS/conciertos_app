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

  const UserStats({
    this.totalConcerts = 0,
    this.uniqueArtists = 0,
    this.uniqueFestivals = 0,
    this.uniqueCities = 0,
    this.totalRated = 0,
    this.oldestYear = 0,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) => UserStats(
        totalConcerts: json['totalConcerts'] ?? 0,
        uniqueArtists: json['uniqueArtists'] ?? 0,
        uniqueFestivals: json['uniqueFestivals'] ?? 0,
        uniqueCities: json['uniqueCities'] ?? 0,
        totalRated: json['totalRated'] ?? 0,
        oldestYear: json['oldestYear'] ?? 0,
      );
}

class AchievementsEngine {
  static List<Achievement> compute(UserStats s) {
    final now = DateTime.now().year;
    final yearsSince = s.oldestYear > 0 ? now - s.oldestYear : 0;

    return [
      _a('first_concert', '🎵', 'Primer directo',
          'Asiste a tu primer concierto', s.totalConcerts >= 1),
      _a('five_concerts', '🎶', 'Habitual',
          '5 conciertos en el cuerpo', s.totalConcerts >= 5),
      _a('ten_concerts', '🎸', 'Rockero',
          '10 conciertos y contando', s.totalConcerts >= 10),
      _a('twenty_five', '🏆', 'Veterano',
          '25 conciertos no es para cualquiera', s.totalConcerts >= 25),
      _a('fifty_concerts', '🔥', 'Experto',
          '50 conciertos. Ya lo has visto todo', s.totalConcerts >= 50),
      _a('hundred_concerts', '👑', 'Leyenda',
          '100 conciertos. Eres una leyenda del directo', s.totalConcerts >= 100),
      _a('first_festival', '🎪', 'Festivalero',
          'Tu primer festival', s.uniqueFestivals >= 1),
      _a('five_festivals', '🌈', 'Festival Addict',
          '5 festivales distintos', s.uniqueFestivals >= 5),
      _a('eclectico', '🎤', 'Ecléctico',
          '10 artistas distintos', s.uniqueArtists >= 10),
      _a('explorador', '🌍', 'Explorador',
          '25 artistas distintos', s.uniqueArtists >= 25),
      _a('critico', '⭐', 'Crítico',
          'Valora tu primer concierto', s.totalRated >= 1),
      _a('gran_critico', '🎯', 'Gran Crítico',
          'Valora 10 conciertos', s.totalRated >= 10),
      _a('viajero', '🗺️', 'Viajero',
          'Conciertos en 3 ciudades distintas', s.uniqueCities >= 3),
      _a('turista', '✈️', 'Turista Musical',
          'Conciertos en 10 ciudades distintas', s.uniqueCities >= 10),
      _a('historico', '📅', 'Fan Histórico',
          'Llevas más de 5 años yendo a conciertos', yearsSince >= 5),
      _a('decada', '🕰️', 'Una Década',
          'Más de 10 años en la brecha', yearsSince >= 10),
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
