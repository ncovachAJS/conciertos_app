import 'package:flutter/material.dart';

class FriendSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const FriendSearchBar({super.key, required this.onChanged});

  @override
  State<FriendSearchBar> createState() => _FriendSearchBarState();
}

class _FriendSearchBarState extends State<FriendSearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: true,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: 'Buscar por nombre o email...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  _controller.clear();
                  widget.onChanged('');
                },
              )
            : null,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
