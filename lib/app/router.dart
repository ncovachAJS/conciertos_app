import 'package:go_router/go_router.dart';

import '../features/concerts/domain/entities/concert.dart';
import '../features/concerts/presentation/pages/concert_detail_page.dart';
import '../features/concerts/presentation/pages/concerts_page.dart';
import '../features/add_concert/presentation/pages/add_concert_page.dart';
import '../features/favorites/presentation/pages/favorites_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import 'app_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return AppShell(child: child);
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomePage()),
        GoRoute(
          path: '/concerts',
          builder: (context, state) => const ConcertsPage(),
        ),
        GoRoute(
          path: '/concert-detail',
          builder: (context, state) {
            final concert = state.extra as Concert;

            return ConcertDetailPage(concert: concert);
          },
        ),
        GoRoute(
          path: '/add',
          builder: (context, state) => const AddConcertPage(),
        ),
        GoRoute(
          path: '/favorites',
          builder: (context, state) => const FavoritesPage(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    ),
  ],
);
