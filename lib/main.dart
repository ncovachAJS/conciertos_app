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

  // Cada paso de inicialización va envuelto en try/catch con timeout:
  // si dotenv, Firebase o Crashlytics fallan o se cuelgan (Play Services
  // lento/roto, .env corrupto, sin red, etc.) la app debe arrancar igual
  // en vez de quedarse en pantalla negra con el icono nativo para siempre.

  try {
    await dotenv.load(fileName: ".env").timeout(const Duration(seconds: 5));
  } catch (e, st) {
    debugPrint('⚠️ dotenv.load falló: $e');
    debugPrintStack(stackTrace: st);
  }

  var firebaseReady = false;
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
        .timeout(const Duration(seconds: 10));
    firebaseReady = true;
  } catch (e, st) {
    debugPrint('⚠️ Firebase.initializeApp falló: $e');
    debugPrintStack(stackTrace: st);
  }

  // ── Crashlytics ────────────────────────────────────────────────────────────
  // Crashlytics no está disponible en web; lo saltamos en esa plataforma.
  // Si Firebase no se inicializó, Crashlytics tampoco puede usarse.
  if (!kIsWeb && firebaseReady) {
    try {
      // En debug no enviamos crashes para no contaminar los reportes de producción.
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(!kDebugMode)
          .timeout(const Duration(seconds: 5));

      // Capturamos errores de Flutter (widgets, rendering, etc.)
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

      // Capturamos errores fuera del árbol de widgets (plataforma, isolates, etc.)
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    } catch (e, st) {
      debugPrint('⚠️ Crashlytics setup falló: $e');
      debugPrintStack(stackTrace: st);
    }
  }
  // ──────────────────────────────────────────────────────────────────────────

  runApp(const ProviderScope(child: ConcertsApp()));
}

void _onError(Object error, StackTrace stack) {
  // Errores sincrónicos fuera del zone de Flutter (muy raros).
  if (!kIsWeb) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  }
}
