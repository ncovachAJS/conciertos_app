import 'package:conciertos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/shimmer_box.dart';

import '../../data/models/friend_model.dart';
import '../../data/services/friends_api_service.dart';
import '../widgets/friend_avatar.dart';

class TagFriendsSelector extends StatefulWidget {
  final List<String> initialSelectedIds;
  final ValueChanged<List<String>> onChanged;
  final bool isPast;

  const TagFriendsSelector({
    super.key,
    this.initialSelectedIds = const [],
    required this.onChanged,
    this.isPast = true,
  });

  @override
  State<TagFriendsSelector> createState() => _TagFriendsSelectorState();
}

class _TagFriendsSelectorState extends State<TagFriendsSelector> {
  final FriendsApiService _api = FriendsApiService();
  List<FriendModel> _friends = [];
  late Set<String> _selected;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.initialSelectedIds);
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    try {
      _friends = await _api.getFriends();
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const red = Color(0xFFE53935);

    if (_loading) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List.generate(
          3,
          (i) => ShimmerBox(width: 80.0 + i * 20, height: 36, borderRadius: 20),
        ),
      );
    }

    final l = AppLocalizations.of(context);

    if (_friends.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          l.noFriendsYet,
          style: TextStyle(color: cs.onSurface.withOpacity(0.4), fontSize: 13),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.isPast ? l.whoElseWas : l.whoElseGoing,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: cs.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _friends.map((f) {
            final selected = _selected.contains(f.id);
            return FilterChip(
              avatar: FriendAvatar(
                name: f.name,
                avatarUrl: f.avatarUrl,
                radius: 12,
              ),
              label: Text(f.name),
              selected: selected,
              onSelected: (val) {
                setState(() {
                  if (val) {
                    _selected.add(f.id);
                  } else {
                    _selected.remove(f.id);
                  }
                });
                widget.onChanged(_selected.toList());
              },
              color: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return red.withOpacity(0.2);
                }
                return cs.surface;
              }),
              checkmarkColor: red,
              showCheckmark: true,
              labelStyle: TextStyle(
                color: selected ? red : cs.onSurface,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
              side: BorderSide(
                color: selected ? red : cs.onSurface.withOpacity(0.2),
                width: selected ? 1.5 : 1,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
