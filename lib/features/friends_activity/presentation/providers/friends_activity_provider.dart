import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../concerts/domain/entities/concert.dart';
import '../../data/friends_activity_service.dart';

class FriendsActivityNotifier extends AsyncNotifier<List<Concert>> {
  final _service = FriendsActivityService();
  static const _pageSize = 100;

  int _page = 1;
  bool _hasMore = true;
  bool _loadingMore = false;

  bool get hasMore => _hasMore;
  bool get loadingMore => _loadingMore;

  @override
  Future<List<Concert>> build() async {
    final list = await _service.getActivity(page: 1, limit: _pageSize);
    _page = 1;
    _hasMore = list.length >= _pageSize;
    return list;
  }

  Future<void> loadMore() async {
    if (_loadingMore || !_hasMore) return;
    _loadingMore = true;
    try {
      _page++;
      final next = await _service.getActivity(page: _page, limit: _pageSize);
      _hasMore = next.length >= _pageSize;
      if (next.isNotEmpty) {
        final current = state.asData?.value ?? [];
        state = AsyncData([...current, ...next]);
      }
    } catch (_) {
      _page--;
    } finally {
      _loadingMore = false;
    }
  }

  Future<void> reload() async {
    _page = 1;
    _hasMore = true;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final list = await _service.getActivity(page: 1, limit: _pageSize);
      _hasMore = list.length >= _pageSize;
      return list;
    });
  }
}

final friendsActivityProvider =
    AsyncNotifierProvider<FriendsActivityNotifier, List<Concert>>(
  FriendsActivityNotifier.new,
);
