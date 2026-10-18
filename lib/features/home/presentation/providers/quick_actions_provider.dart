import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/quick_actions_service.dart';
import '../../domain/quick_action.dart';

class QuickActionsNotifier extends AsyncNotifier<List<QuickActionId>> {
  final _service = QuickActionsService();

  @override
  Future<List<QuickActionId>> build() => _service.load();

  List<QuickActionId> get _current =>
      state.asData?.value ?? List.of(kDefaultQuickActions);

  Future<void> _set(List<QuickActionId> actions) async {
    state = AsyncData(actions);
    await _service.save(actions);
  }

  Future<void> add(QuickActionId id) async {
    final cur = _current;
    if (cur.contains(id) || cur.length >= kMaxQuickActions) return;
    await _set([...cur, id]);
  }

  /// Siempre debe quedar al menos un atajo.
  Future<void> remove(QuickActionId id) async {
    final cur = _current;
    if (cur.length <= 1 || !cur.contains(id)) return;
    await _set(cur.where((a) => a != id).toList());
  }

  /// [newIndex] llega sin ajustar (convención de ReorderableListView).
  Future<void> reorder(int oldIndex, int newIndex) async {
    final updated = List.of(_current);
    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex > oldIndex ? newIndex - 1 : newIndex, item);
    await _set(updated);
  }

  Future<void> reset() async {
    await _service.clear();
    state = await AsyncValue.guard(_service.load);
  }
}

final quickActionsProvider =
    AsyncNotifierProvider<QuickActionsNotifier, List<QuickActionId>>(
  QuickActionsNotifier.new,
);
