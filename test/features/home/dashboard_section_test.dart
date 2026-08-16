import 'package:flutter_test/flutter_test.dart';

import 'package:conciertos_app/features/home/domain/dashboard_section.dart';

void main() {
  group('DashboardSection', () {
    const section = DashboardSection(
      id: DashboardSectionId.streak,
      visible: true,
    );

    test('copyWith keeps values when no overrides', () {
      final copy = section.copyWith();
      expect(copy.id, DashboardSectionId.streak);
      expect(copy.visible, true);
    });

    test('copyWith overrides visible', () {
      final hidden = section.copyWith(visible: false);
      expect(hidden.visible, false);
      expect(hidden.id, DashboardSectionId.streak);
    });

    test('toJson serializes correctly', () {
      final json = section.toJson();
      expect(json['id'], 'streak');
      expect(json['visible'], true);
    });

    test('fromJson deserializes correctly', () {
      final s = DashboardSection.fromJson({'id': 'upcoming', 'visible': false});
      expect(s.id, DashboardSectionId.upcoming);
      expect(s.visible, false);
    });

    test('fromJson defaults visible to true when missing', () {
      final s = DashboardSection.fromJson({'id': 'stats'});
      expect(s.visible, true);
    });

    test('fromJson falls back to streak for unknown id', () {
      final s = DashboardSection.fromJson({'id': 'unknownSection'});
      expect(s.id, DashboardSectionId.streak);
    });

    test('roundtrip toJson/fromJson', () {
      const original = DashboardSection(
        id: DashboardSectionId.favorites,
        visible: false,
      );
      final roundtrip = DashboardSection.fromJson(original.toJson());
      expect(roundtrip.id, original.id);
      expect(roundtrip.visible, original.visible);
    });

    test('all DashboardSectionId values can round-trip', () {
      for (final id in DashboardSectionId.values) {
        final s = DashboardSection(id: id, visible: true);
        final json = s.toJson();
        final restored = DashboardSection.fromJson(json);
        expect(restored.id, id, reason: 'Failed for id: $id');
      }
    });
  });
}
