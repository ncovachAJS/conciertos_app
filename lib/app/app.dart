import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/concerts/presentation/providers/concerts_provider.dart';
import 'locale_provider.dart';
import 'router.dart';
import 'theme.dart';
import 'theme_provider.dart';

import '../l10n/generated/app_localizations.dart';

class ConcertsApp extends ConsumerStatefulWidget {
  const ConcertsApp({super.key});

  @override
  ConsumerState<ConcertsApp> createState() => _ConcertsAppState();
}

class _ConcertsAppState extends ConsumerState<ConcertsApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(concertsProvider.notifier).reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'La Vida en Directo',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es'), Locale('en')],
      routerConfig: appRouter,
    );
  }
}
