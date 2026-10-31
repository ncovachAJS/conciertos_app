import 'package:conciertos_app/features/home/data/quick_actions_service.dart';
import 'package:conciertos_app/features/home/domain/quick_action.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuickActionsService.merge', () {
    test('lista vacía → los cinco por defecto', () {
      expect(
        QuickActionsService.merge(const [], isPro: true),
        kDefaultQuickActions,
      );
    });

    test('respeta el orden guardado', () {
      final r = QuickActionsService.merge(
        const ['friends', 'add', 'calendar'],
        isPro: true,
      );
      expect(r, [QuickActionId.friends, QuickActionId.add, QuickActionId.calendar]);
    });

    test('descarta nombres desconocidos y duplicados', () {
      final r = QuickActionsService.merge(
        const ['add', 'inventado', 'add', 'stats'],
        isPro: true,
      );
      expect(r, [QuickActionId.add, QuickActionId.stats]);
    });

    test('recorta al máximo', () {
      final r = QuickActionsService.merge(
        const ['add', 'events', 'stats', 'import', 'friends', 'calendar', 'records'],
        isPro: true,
      );
      expect(r.length, kMaxQuickActions);
      expect(r.last, QuickActionId.friends);
    });

    test('atajo de discos: Pro lo conserva', () {
      final r = QuickActionsService.merge(const ['records', 'add'], isPro: true);
      expect(r, contains(QuickActionId.records));
    });

    test('atajo de discos: no Pro lo pierde', () {
      final r = QuickActionsService.merge(const ['records', 'add'], isPro: false);
      expect(r, [QuickActionId.add]);
    });

    test('solo atajos Pro y no Pro → defaults', () {
      final r = QuickActionsService.merge(const ['records'], isPro: false);
      expect(r, kDefaultQuickActions);
    });

    test('ids eliminados (favorites, map...) se descartan', () {
      final r = QuickActionsService.merge(
        const ['favorites', 'add', 'map', 'notifications', 'memories'],
        isPro: true,
      );
      expect(r, [QuickActionId.add]);
    });

    test('los por defecto no incluyen nada Pro', () {
      expect(
        kDefaultQuickActions.any(kProOnlyQuickActions.contains),
        isFalse,
      );
    });
  });
}
