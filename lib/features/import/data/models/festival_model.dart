/// Representa un festival agrupado a partir del listado plano de conciertos
/// (`assets/imports/festivals.json`). Cada concierto ya trae todos sus campos;
/// aquí solo se agrupan por festival + año para mostrarlos como una tarjeta.
class FestivalModel {
  final String id;
  final String title;
  final int year;
  final String? city;
  final String? venue;
  final List<Map<String, dynamic>> concerts;

  const FestivalModel({
    required this.id,
    required this.title,
    required this.year,
    this.city,
    this.venue,
    this.concerts = const [],
  });
}
