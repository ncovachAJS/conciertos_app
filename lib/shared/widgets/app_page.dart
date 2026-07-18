import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppPage extends StatelessWidget {
  final String? title;
  final Widget child;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBackButton;

  const AppPage({
    super.key,
    this.title,
    required this.child,
    this.actions,
    this.floatingActionButton,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final showAppBar = title != null;

    return GestureDetector(
      // Oculta el teclado al tocar fuera de un input
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: showAppBar
            ? AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                leading: showBackButton
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new),
                        onPressed: () => context.pop(),
                      )
                    : null,
                title: Text(title!),
                actions: actions,
              )
            : null,

        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: child,
          ),
        ),

        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
