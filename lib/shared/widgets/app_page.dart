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

    // En tablet añadimos más respiro horizontal; el contenido NO está limitado
    // en ancho — cada página usa el espacio con su propio layout (2 columnas, etc.)
    final horizontalPadding = tablet ? 24.0 : 8.0;
    final verticalPadding = tablet ? 20.0 : 16.0;

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

        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: child,
          ),
        ),

        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
