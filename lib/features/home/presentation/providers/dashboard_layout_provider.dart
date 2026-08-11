import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/dashboard_layout_service.dart';
import '../../domain/dashboard_section.dart';

class DashboardLayoutNotifier
    extends AsyncNotifier<List<DashboardSection>> {
  final _service = DashboardLayoutService();

  @override
  Future<List<DashboardSection>> build() => _service.load();

  /// Mueve una sección de [oldIndex] a [newIndex].
  /// ReorderableListView ya ajusta newIndex internamente (newIndex > oldIndex → newIndex - 1),
  /// así que lo recibimos sin ajustar y hacemos la corrección aquí.
  Future<void> reorder(int oldIndex, int newIndex) async {
    final current = state.asData?.value;
    if (current == null) return;

    final updated = List<DashboardSection>.of(current);
    final item = updated.removeAt(oldIndex);
    // Flutter's ReorderableListView passes the raw newIndex before the removal,
    // so when moving down we compensate.
    final insertAt = newIndex > oldIndex ? newIndex - 1 : newIndex;
    updated.insert(insertAt, item);

    state = AsyncData(updated);
    await _service.save(updated);
  }

  /// Alterna la visibilidad de una sección sin cambiar su posición.
  Future<void> toggleVisibility(DashboardSectionId id) async {
    final current = state.asData?.value;
    if (current == null) return;

    final updated = current
        .map((s) => s.id == id ? s.copyWith(visible: !s.visible) : s)
        .toList();

    state = AsyncData(updated);
    await _service.save(updated);
  }

  /// Restaura el orden y visibilidad por defecto.
  Future<void> reset() async {
    await _service.clear();
    state = await AsyncValue.guard(() => _service.load());
  }
}

final dashboardLayoutProvider =
    AsyncNotifierProvider<DashboardLayoutNotifier, List<DashboardSection>>(
  DashboardLayoutNotifier.new,
);
