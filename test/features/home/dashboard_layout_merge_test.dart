import 'package:conciertos_app/features/home/data/dashboard_layout_service.dart';
import 'package:conciertos_app/features/home/domain/dashboard_section.dart';
import 'package:flutter_test/flutter_test.dart';

List<DashboardSectionId> ids(List<DashboardSection> l) =>
    l.map((s) => s.id).toList();

void main() {
  group('DashboardLayoutService.merge', () {
    test('sin layout guardado, no Pro: defaults sin la colección', () {
      final r = DashboardLayoutService.merge(const [], isPro: false);
      expect(ids(r), isNot(contains(DashboardSectionId.records)));
      expect(r.length, DashboardLayoutService.defaults.length - 1);
    });

    test('sin layout guardado, Pro: defaults completos y en orden', () {
      final r = DashboardLayoutService.merge(const [], isPro: true);
      expect(ids(r), ids(DashboardLayoutService.defaults));
    });

    test('layout antiguo (sin records) y Pro: se inserta tras upcoming', () {
      const old = [
        DashboardSection(id: DashboardSectionId.stats, visible: true),
        DashboardSection(id: DashboardSectionId.upcoming, visible: false),
        DashboardSection(id: DashboardSectionId.favorites, visible: true),
      ];
      final r = DashboardLayoutService.merge(old, isPro: true);
      final i = ids(r).indexOf(DashboardSectionId.records);
      expect(ids(r)[i - 1], DashboardSectionId.upcoming);
      // respeta la visibilidad que ya tenía el usuario
      expect(
        r.firstWhere((s) => s.id == DashboardSectionId.upcoming).visible,
        false,
      );
    });

    test('layout con records y usuario no Pro: se descarta', () {
      const saved = [
        DashboardSection(id: DashboardSectionId.records, visible: true),
        DashboardSection(id: DashboardSectionId.stats, visible: true),
      ];
      final r = DashboardLayoutService.merge(saved, isPro: false);
      expect(ids(r), isNot(contains(DashboardSectionId.records)));
    });

    test('layout con records oculto y Pro: se conserva oculto', () {
      const saved = [
        DashboardSection(id: DashboardSectionId.records, visible: false),
      ];
      final r = DashboardLayoutService.merge(saved, isPro: true);
      expect(
        r.firstWhere((s) => s.id == DashboardSectionId.records).visible,
        false,
      );
    });

    test('elimina spotifyEmbed y no duplica secciones', () {
      const saved = [
        DashboardSection(id: DashboardSectionId.spotifyEmbed, visible: true),
        DashboardSection(id: DashboardSectionId.streak, visible: true),
      ];
      final r = DashboardLayoutService.merge(saved, isPro: true);
      expect(ids(r), isNot(contains(DashboardSectionId.spotifyEmbed)));
      expect(ids(r).toSet().length, r.length);
    });
  });
}
