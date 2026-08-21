import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/responsive/responsive.dart';

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
    final tablet = Responsive.isTablet(context);

    // En tablet centramos el contenido y lo limitamos a maxContentWidth para
    // que no quede excesivamente estirado en la pantalla grande del iPad.
    Widget body = SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: tablet
            ? Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: Responsive.maxContentWidth,
                  ),
                  child: child,
                ),
              )
            : child,
      ),
    );

    return GestureDetector(
      // Oculta el teclado al tocar fuera de un input.
      // translucent: permite que los gestos lleguen a los widgets hijo (scroll, InkWell)
      behavior: HitTestBehavior.translucent,
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

        body: body,

        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
