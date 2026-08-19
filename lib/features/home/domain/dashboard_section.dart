/// Identificador de cada sección del dashboard.
enum DashboardSectionId {
  streak,
  annualGoal,
  ratePending,
  onThisDay,
  upcoming,
  stats,
  recommended,
  favorites,
  recent,
  spotifyEmbed,
}

/// Estado de una sección: posición (implícita por el orden en la lista)
/// y visibilidad.
class DashboardSection {
  final DashboardSectionId id;
  final bool visible;

  const DashboardSection({required this.id, required this.visible});

  DashboardSection copyWith({bool? visible}) =>
      DashboardSection(id: id, visible: visible ?? this.visible);

  Map<String, dynamic> toJson() => {'id': id.name, 'visible': visible};

  factory DashboardSection.fromJson(Map<String, dynamic> json) =>
      DashboardSection(
        id: DashboardSectionId.values.firstWhere(
          (e) => e.name == json['id'],
          orElse: () => DashboardSectionId.streak,
        ),
        visible: json['visible'] as bool? ?? true,
      );
}
