import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/stats_layout_service.dart';
import '../../domain/stats_section.dart';

class StatsLayoutNotifier extends AsyncNotifier<List<StatsSection>> {
  final _service = StatsLayoutService();

  @override
  Future<List<StatsSection>> build() => _service.load();

  Future<void> reorder(int oldIndex, int newIndex) async {
    final current = state.asData?.value;
    if (current == null) return;
    final updated = List<StatsSection>.of(current);
    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex > oldIndex ? newIndex - 1 : newIndex, item);
    state = AsyncData(updated);
    await _service.save(updated);
  }

  Future<void> toggleVisibility(StatsSectionId id) async {
    final current = state.asData?.value;
    if (current == null) return;
    final updated = current
        .map((s) => s.id == id ? s.copyWith(visible: !s.visible) : s)
        .toList();
    state = AsyncData(updated);
    await _service.save(updated);
  }

  Future<void> reset() async {
    await _service.clear();
    state = await AsyncValue.guard(() => _service.load());
  }
}

final statsLayoutProvider =
    AsyncNotifierProvider<StatsLayoutNotifier, List<StatsSection>>(
  StatsLayoutNotifier.new,
);
