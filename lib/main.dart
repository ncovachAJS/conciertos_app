import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

import 'app/app.dart';

Future<void> main() async {
  await runZonedGuarded(_run, _onError);
}

Future<void> _run() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ── Crashlytics ────────────────────────────────────────────────────────────
  // En debug no enviamos crashes para no contaminar los reportes de producción.
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);

  // Capturamos errores de Flutter (widgets, rendering, etc.)
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Capturamos errores fuera del árbol de widgets (plataforma, isolates, etc.)
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  // ──────────────────────────────────────────────────────────────────────────

  runApp(const ProviderScope(child: ConcertsApp()));
}

void _onError(Object error, StackTrace stack) {
  // Errores sincrónicos fuera del zone de Flutter (muy raros).
  FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
}
