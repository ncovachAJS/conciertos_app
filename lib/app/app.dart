import 'package:flutter/material.dart';

import 'router.dart';
import 'theme.dart';

class ConcertsApp extends StatelessWidget {
  const ConcertsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'My Concerts',
      theme: AppTheme.dark,
      routerConfig: appRouter,
    );
  }
}
