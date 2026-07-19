import 'package:go_router/go_router.dart';

import '../features/profile/presentation/pages/profile_page.dart';
import '../features/recommendations/presentation/pages/recommendations_page.dart';
import '../features/concerts/domain/entities/concert.dart';
import '../features/concerts/presentation/pages/concert_detail_page.dart';
import '../features/concerts/presentation/pages/concerts_page.dart';
import '../features/add_concert/presentation/pages/add_concert_page.dart';
import '../features/favorites/presentation/pages/favorites_page.dart';
import '../features/profile/presentation/pages/settings_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/setlist/presentation/pages/setlist_test_page.dart';
import '../features/import/presentation/pages/import_page.dart';
import '../features/photos/presentation/pages/feed_page.dart';
import '../features/splash/presentation/pages/splash_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/pages/session_gate_page.dart';
import '../features/statistics/presentation/pages/statistics_page.dart';

import '../features/home/artist/presentation/pages/artist_page.dart';
import 'app_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/gate',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/gate',
      builder: (context, state) => const SessionGatePage(),
    ),
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
          builder: (context, state) {
            final concert = state.extra as Concert?;
            return AddConcertPage(concert: concert);
          },
        ),
        GoRoute(path: '/feed', builder: (context, state) => const FeedPage()),
        GoRoute(
          path: '/favorites',
          builder: (context, state) => const FavoritesPage(),
        ),
        GoRoute(
          path: '/statistics',
          builder: (context, state) => const StatisticsPage(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: '/import',
          builder: (context, state) => const ImportPage(),
        ),
        GoRoute(
          path: '/setlist-test',
          builder: (context, state) => const SetlistTestPage(),
        ),
        GoRoute(
          path: '/recommendations',
          builder: (context, state) => const RecommendationsPage(),
        ),
        GoRoute(
          path: '/artist',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return ArtistPage(
              artist: extra['artist'] as String,
              concerts: extra['concerts'] as List<Concert>,
            );
          },
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfilePage(),
        ),
      ],
    ),
  ],
);
