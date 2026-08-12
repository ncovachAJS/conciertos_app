enum StatsSectionId {
  summary,
  byYear,
  byMonth,
  byDayOfWeek,
  topArtists,
  topGenres,
  topFestivals,
  topCities,
  topVenues,
  festivalSplit,
  ratingDist,
  avgRatingByYear,
  topRatedArtists,
}

class StatsSection {
  final StatsSectionId id;
  final bool visible;

  const StatsSection({required this.id, required this.visible});

  StatsSection copyWith({bool? visible}) =>
      StatsSection(id: id, visible: visible ?? this.visible);

  Map<String, dynamic> toJson() => {'id': id.name, 'visible': visible};

  factory StatsSection.fromJson(Map<String, dynamic> json) => StatsSection(
        id: StatsSectionId.values.firstWhere(
          (e) => e.name == json['id'],
          orElse: () => StatsSectionId.summary,
        ),
        visible: json['visible'] as bool? ?? true,
      );
}
