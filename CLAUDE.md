# CLAUDE.md

Este archivo proporciona orientación a Claude Code (claude.ai/code) cuando trabaja con el código de este repositorio.

## Comandos

Todos los comandos se ejecutan desde el directorio `conciertos_app/`.

```bash
# Ejecutar en dispositivo/emulador
flutter run

# Compilar
flutter build apk
flutter build ios

# Análisis estático (analysis_options.yaml usa flutter_lints)
flutter analyze

# Tests
flutter test                                          # suite completa
flutter test test/features/concerts/                 # subconjunto por feature
flutter test --name "Concert"                         # filtro por patrón
flutter test --coverage                               # con cobertura
flutter test -j 4                                     # en paralelo
flutter test test/core/ test/data/ test/design/       # solo tests unitarios
flutter test test/ui/ test/features/                  # solo tests de widgets

# Regenerar localizaciones (necesario tras modificar archivos .arb)
flutter gen-l10n
```

## Configuración del entorno

Copia `.env.example` como `.env` y rellena el valor:

```
SPOTIFY_CLIENT_ID=tu_spotify_client_id_aqui
```

El archivo `.env` se empaqueta como asset de Flutter (declarado en `pubspec.yaml`), no se inyecta en tiempo de compilación. El resto de secretos (clave API de Setlist.fm, Client Secret de Spotify, clave de Ticketmaster) residen exclusivamente en el backend.

## Arquitectura

### Estructura por capas (por feature)

```
lib/features/<feature>/
  domain/entities/      ← clases Dart puras, sin dependencias de Flutter
  data/models/          ← extiende la entidad, añade fromJson/toJson
  data/services/        ← llamadas HTTP usando los endpoints de ApiConfig
  data/repositories/    ← implementación del repositorio (opcional)
  presentation/
    providers/          ← notifiers y providers derivados de Riverpod
    controllers/        ← controladores Riverpod ligeros (auth, friends, notificaciones)
    pages/              ← widgets de pantalla completa con ruta propia
    widgets/            ← widgets reutilizables dentro del feature
```

Código transversal:
- `lib/core/` — tokens de tema, utilidades, tutorial service, límites de `ProConfig`, `AppInitializer`
- `lib/app/` — `app.dart`, `router.dart` (GoRouter), `app_shell.dart` (shell con barra inferior), providers de tema
- `lib/config/api_config.dart` — todas las constantes de endpoints (URL base del backend: `https://conciertos-backend.onrender.com`)
- `lib/shared/` — widgets reutilizables globales (skeletons, etc.)

### Gestión de estado

Se usa Riverpod en toda la app. El provider principal es `concertsProvider` (`AsyncNotifierProvider<ConcertsNotifier, List<Concert>>`), que:
1. Carga desde la caché local (SharedPreferences) de forma inmediata para una UI instantánea.
2. Lanza una actualización en segundo plano desde la API sin bloquear al usuario.
3. Todas las mutaciones (add, update, delete) usan **actualizaciones optimistas** con rollback automático en caso de error.

Los providers derivados (`upcomingConcertsProvider`, `favoriteConcertsProvider`, `concertStatsProvider`, etc.) se calculan a partir de `concertsProvider`. Añade nueva lógica derivada ahí en lugar de hacer peticiones adicionales.

### Enrutado

`go_router` con un único `ShellRoute` que envuelve el shell principal (barra de navegación inferior). Las rutas que pasan objetos complejos usan `state.extra` (con cast tipado); las que necesitan deep link usan parámetros de ruta o query. El punto de entrada es `/gate`, que comprueba el estado de autenticación.

### Autenticación

Auth JWT personalizada mediante `AuthController` (patrón singleton: `AuthController.instance`). `SessionGatePage` lee el estado de auth al arrancar y redirige a `/splash` o `/login`. El JWT se almacena en `flutter_secure_storage`.

### Límites versión gratuita / Pro

`ProConfig.freeConcertLimit = 50` es el único límite configurado. Protege las nuevas funciones de pago con una comprobación contra `ownConcertsCountProvider`.

### Integraciones externas

| Servicio | Cómo |
|---|---|
| Spotify | Flujo OAuth 2.0 PKCE (`flutter_web_auth_2` + `crypto`). El Client Secret vive solo en el proxy del backend. |
| Setlist.fm | Proxy en el backend — ninguna API key en la app. |
| Ticketmaster | Proxy en el backend en `/recommendations`. |
| Cloudinary | Subida de imágenes vía `upload_service.dart`; helpers de URL en `cloudinary_utils.dart`. |
| Firebase | `firebase_messaging` (notificaciones push) + `firebase_crashlytics`. |
| Mapas | `flutter_map` + `latlong2`. |

### Localización

Los archivos ARB generan las traducciones mediante `flutter_localizations` (`generate: true` en pubspec). Tras editar los `.arb`, ejecuta `flutter gen-l10n`.

## SonarQube (MCP)

Cuando el servidor MCP de SonarQube esté disponible:
- Desactiva el análisis automático con `toggle_automatic_analysis` antes de empezar a generar código.
- Al terminar, llama a `analyze_file_list` con los archivos modificados y vuelve a activar el análisis automático.
- Usa `search_my_sonarqube_projects` para obtener las project keys — nunca las adivines.
- Se requieren tokens de USUARIO; los tokens de proyecto devuelven 401.
