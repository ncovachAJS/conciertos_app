import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/concerts/presentation/providers/concerts_provider.dart';

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
import '../features/friends_activity/presentation/pages/friends_activity_page.dart';
import '../features/splash/presentation/pages/splash_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/pages/session_gate_page.dart';
import '../features/statistics/presentation/pages/statistics_page.dart';

import '../features/home/artist/presentation/pages/artist_page.dart';
import '../features/friends/domain/entities/friend.dart';
import '../features/friends/presentation/pages/friends_page.dart';
import '../features/friends/presentation/pages/friend_profile_page.dart';
import '../features/notifications/presentation/pages/notifications_page.dart';
import '../features/concerts/presentation/pages/concert_map_page.dart';
import '../features/concerts/presentation/pages/venue_page.dart';
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
          builder: (context, state) => ConcertsPage(
            openCalendar:
                state.uri.queryParameters['view'] == 'calendar',
          ),
        ),
        GoRoute(
          path: '/concert-detail',
          builder: (context, state) {
            final concert = state.extra as Concert;
            return ConcertDetailPage(concert: concert);
          },
        ),
        GoRoute(
          path: '/concert-detail-by-id/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return _ConcertDetailById(concertId: id);
          },
        ),
        GoRoute(
          path: '/add',
          builder: (context, state) {
            final extra = state.extra;
            if (extra is Concert) return AddConcertPage(concert: extra);
            if (extra is DateTime) return AddConcertPage(initialDate: extra);
            return const AddConcertPage();
          },
        ),
        GoRoute(path: '/feed', builder: (context, state) => const FeedPage()),
        GoRoute(
          path: '/friends-activity',
          builder: (context, state) => const FriendsActivityPage(),
        ),
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
          path: '/notifications',
          builder: (context, state) => const NotificationsPage(),
        ),
        GoRoute(
          path: '/friends',
          builder: (context, state) => const FriendsPage(),
        ),
        GoRoute(
          path: '/friend-profile',
          builder: (context, state) {
            final friend = state.extra as Friend;
            return FriendProfilePage(friend: friend);
          },
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
        GoRoute(
          path: '/concert-map',
          builder: (context, state) => const ConcertMapPage(),
        ),
        GoRoute(
          path: '/venue',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return VenuePage(
              venue: extra['venue'] as String,
              city: extra['city'] as String,
            );
          },
        ),
      ],
    ),
  ],
);

// Widget que busca el concierto por ID y abre el detalle
class _ConcertDetailById extends ConsumerWidget {
  final String concertId;
  const _ConcertDetailById({required this.concertId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final concertsAsync = ref.watch(concertsProvider);

    return concertsAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('No se encontró el concierto'),
              TextButton(
                onPressed: () => context.go('/'),
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      ),
      data: (concerts) {
        // Buscar primero por ID exacto
        var matches = concerts.where((c) => c.id == concertId).toList();

        // Si no hay coincidencia por ID, buscar en el backend directamente
        // mostrando el primero disponible con ese ID entre los participantes
        if (matches.isEmpty) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Concierto no encontrado'),
                  const SizedBox(height: 8),
                  const Text(
                    'Puede que ya no formes parte de este concierto',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.go('/'),
                    child: const Text('Volver'),
                  ),
                ],
              ),
            ),
          );
        }
        return ConcertDetailPage(concert: matches.first);
      },
    );
  }
}
