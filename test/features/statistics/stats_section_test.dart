import 'package:flutter_test/flutter_test.dart';

import 'package:conciertos_app/features/statistics/domain/stats_section.dart';

void main() {
  group('StatsSection', () {
    const section = StatsSection(
      id: StatsSectionId.summary,
      visible: true,
    );

    test('copyWith keeps values when no overrides', () {
      final copy = section.copyWith();
      expect(copy.id, StatsSectionId.summary);
      expect(copy.visible, true);
    });

    test('copyWith overrides visible', () {
      final hidden = section.copyWith(visible: false);
      expect(hidden.visible, false);
      expect(hidden.id, StatsSectionId.summary);
    });

    test('toJson serializes correctly', () {
      final json = section.toJson();
      expect(json['id'], 'summary');
      expect(json['visible'], true);
    });

    test('fromJson deserializes correctly', () {
      final s = StatsSection.fromJson({'id': 'topArtists', 'visible': false});
      expect(s.id, StatsSectionId.topArtists);
      expect(s.visible, false);
    });

    test('fromJson defaults visible to true when missing', () {
      final s = StatsSection.fromJson({'id': 'byYear'});
      expect(s.visible, true);
    });

    test('fromJson falls back to summary for unknown id', () {
      final s = StatsSection.fromJson({'id': 'unknownSection'});
      expect(s.id, StatsSectionId.summary);
    });

    test('roundtrip toJson/fromJson', () {
      const original = StatsSection(
        id: StatsSectionId.topRatedArtists,
        visible: false,
      );
      final roundtrip = StatsSection.fromJson(original.toJson());
      expect(roundtrip.id, original.id);
      expect(roundtrip.visible, original.visible);
    });

    test('all StatsSectionId values can round-trip', () {
      for (final id in StatsSectionId.values) {
        final s = StatsSection(id: id, visible: true);
        final json = s.toJson();
        final restored = StatsSection.fromJson(json);
        expect(restored.id, id, reason: 'Failed for id: $id');
      }
    });
  });
}
