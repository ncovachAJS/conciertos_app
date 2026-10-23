import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../config/api_config.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

int _int(Object? v) => (v as num?)?.toInt() ?? 0;

class RankEntry {
  final String name;
  final int count;
  final int users;
  const RankEntry({required this.name, required this.count, required this.users});

  factory RankEntry.fromJson(Map<String, dynamic> j) => RankEntry(
        name: j['name']?.toString() ?? '',
        count: _int(j['count']),
        users: _int(j['users']),
      );
}

class FeatureUsage {
  /// concerts | photos | comments | wantToAttend | records | discogs
  final String key;
  final int total;
  final int users;
  final int last30;
  const FeatureUsage({
    required this.key,
    required this.total,
    required this.users,
    required this.last30,
  });

  factory FeatureUsage.fromJson(Map<String, dynamic> j) => FeatureUsage(
        key: j['key']?.toString() ?? '',
        total: _int(j['total']),
        users: _int(j['users']),
        last30: _int(j['last30']),
      );
}

class DayCount {
  final DateTime day;
  final int count;
  const DayCount({required this.day, required this.count});

  factory DayCount.fromJson(Map<String, dynamic> j) => DayCount(
        day: DateTime.tryParse(j['day']?.toString() ?? '') ?? DateTime.now(),
        count: _int(j['count']),
      );
}

class AppVersionCount {
  /// null = dispositivos que aún no reportan versión.
  final String? version;
  final int? build;
  final int devices;
  const AppVersionCount({this.version, this.build, required this.devices});

  factory AppVersionCount.fromJson(Map<String, dynamic> j) => AppVersionCount(
        version: j['version']?.toString(),
        build: (j['build'] as num?)?.toInt(),
        devices: _int(j['devices']),
      );
}

class AdminStats {
  final int totalUsers;
  final int new7d;
  final int new30d;
  final int proUsers;
  final int active7d;
  final int active30d;
  final int usersWithPush;
  final int devices;
  final int concerts;
  final int friendships;
  final double avgRating;
  final List<FeatureUsage> features;
  final List<RankEntry> topArtists;
  final List<RankEntry> topCities;
  final List<RankEntry> topGenres;
  final List<DayCount> signups;
  final List<DayCount> concertsByDay;
  final List<AppVersionCount> versions;
  final int dbMs;
  final int uptimeSec;

  const AdminStats({
    required this.totalUsers,
    required this.new7d,
    required this.new30d,
    required this.proUsers,
    required this.active7d,
    required this.active30d,
    required this.usersWithPush,
    required this.devices,
    required this.concerts,
    required this.friendships,
    required this.avgRating,
    required this.features,
    required this.topArtists,
    required this.topCities,
    required this.topGenres,
    required this.signups,
    required this.concertsByDay,
    required this.versions,
    required this.dbMs,
    required this.uptimeSec,
  });

  static List<T> _list<T>(Object? v, T Function(Map<String, dynamic>) f) =>
      (v as List? ?? const [])
          .map((e) => f(e as Map<String, dynamic>))
          .toList();

  factory AdminStats.fromJson(Map<String, dynamic> j) {
    final users = j['users'] as Map<String, dynamic>? ?? const {};
    final push = j['push'] as Map<String, dynamic>? ?? const {};
    final content = j['content'] as Map<String, dynamic>? ?? const {};
    final activity = j['activity'] as Map<String, dynamic>? ?? const {};
    final health = j['health'] as Map<String, dynamic>? ?? const {};
    return AdminStats(
      totalUsers: _int(users['total']),
      new7d: _int(users['new7d']),
      new30d: _int(users['new30d']),
      proUsers: _int(users['pro']),
      active7d: _int(users['active7d']),
      active30d: _int(users['active30d']),
      usersWithPush: _int(push['usersWithPush']),
      devices: _int(push['devices']),
      concerts: _int(content['concerts']),
      friendships: _int(content['friendships']),
      avgRating: (content['avgRating'] as num?)?.toDouble() ?? 0,
      features: _list(j['features'], FeatureUsage.fromJson),
      topArtists: _list(j['topArtists'], RankEntry.fromJson),
      topCities: _list(j['topCities'], RankEntry.fromJson),
      topGenres: _list(j['topGenres'], RankEntry.fromJson),
      signups: _list(activity['signups'], DayCount.fromJson),
      concertsByDay: _list(activity['concerts'], DayCount.fromJson),
      versions: _list(j['versions'], AppVersionCount.fromJson),
      dbMs: _int(health['dbMs']),
      uptimeSec: _int(health['uptimeSec']),
    );
  }
}

class BroadcastResult {
  final int recipients;
  final int devices;
  const BroadcastResult({required this.recipients, required this.devices});
}

class AdminUser {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final bool isPro;
  final bool isAdmin;
  final DateTime createdAt;
  final int concertCount;

  const AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.isPro,
    required this.isAdmin,
    required this.createdAt,
    required this.concertCount,
  });

  factory AdminUser.fromJson(Map<String, dynamic> j) => AdminUser(
        id: j['id']?.toString() ?? '',
        name: j['name']?.toString() ?? '',
        email: j['email']?.toString() ?? '',
        avatarUrl: j['avatarUrl']?.toString(),
        isPro: j['isPro'] as bool? ?? false,
        isAdmin: j['isAdmin'] as bool? ?? false,
        createdAt:
            DateTime.tryParse(j['createdAt']?.toString() ?? '') ?? DateTime.now(),
        concertCount: _int(j['concertCount']),
      );

  AdminUser copyWith({bool? isPro}) => AdminUser(
        id: id,
        name: name,
        email: email,
        avatarUrl: avatarUrl,
        isPro: isPro ?? this.isPro,
        isAdmin: isAdmin,
        createdAt: createdAt,
        concertCount: concertCount,
      );
}

class AdminUsersPage {
  final int total;
  final List<AdminUser> items;
  const AdminUsersPage({required this.total, required this.items});
}

class AdminApiService {
  static const _timeout = Duration(seconds: 30);

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthController.instance.token}',
      };

  Map<String, dynamic> _decode(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Admin (${res.statusCode})');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<AdminStats> getStats() async {
    final res = await http
        .get(Uri.parse(ApiConfig.adminStatsEndpoint), headers: _headers)
        .timeout(_timeout);
    return AdminStats.fromJson(_decode(res));
  }

  Future<BroadcastResult> broadcast({
    required String title,
    required String body,
    required String audience,
    required bool inApp,
    int? maxBuild,
    String? target,
  }) async {
    final res = await http
        .post(
          Uri.parse(ApiConfig.adminBroadcastEndpoint),
          headers: _headers,
          body: jsonEncode({
            'title': title,
            'body': body,
            'audience': audience,
            'inApp': inApp,
            'maxBuild': ?maxBuild,
            'target': ?target,
          }),
        )
        .timeout(const Duration(seconds: 90));
    final json = _decode(res);
    return BroadcastResult(
      recipients: _int(json['recipients']),
      devices: _int(json['devices']),
    );
  }

  Future<List<AppVersionCount>> getVersions() async {
    final res = await http
        .get(Uri.parse(ApiConfig.adminVersionsEndpoint), headers: _headers)
        .timeout(_timeout);
    if (res.statusCode != 200) throw Exception('Admin (${res.statusCode})');
    return (jsonDecode(res.body) as List)
        .map((e) => AppVersionCount.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// A cuántos usuarios llegaría un aviso. No envía nada.
  Future<BroadcastResult> previewBroadcast({
    required String audience,
    int? maxBuild,
  }) async {
    final uri = Uri.parse(ApiConfig.adminBroadcastPreviewEndpoint).replace(
      queryParameters: {
        'audience': audience,
        'maxBuild': ?maxBuild?.toString(),
      },
    );
    final res = await http.get(uri, headers: _headers).timeout(_timeout);
    final json = _decode(res);
    return BroadcastResult(
      recipients: _int(json['recipients']),
      devices: _int(json['devices']),
    );
  }

  Future<AdminUsersPage> listUsers({String q = '', int skip = 0}) async {
    final uri = Uri.parse(ApiConfig.adminUsersEndpoint).replace(
      queryParameters: {
        if (q.trim().isNotEmpty) 'q': q.trim(),
        'skip': '$skip',
        'take': '20',
      },
    );
    final res = await http.get(uri, headers: _headers).timeout(_timeout);
    final json = _decode(res);
    return AdminUsersPage(
      total: _int(json['total']),
      items: (json['items'] as List? ?? const [])
          .map((e) => AdminUser.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<void> setPro(String userId, bool isPro) async {
    final res = await http
        .patch(
          Uri.parse(ApiConfig.adminUserProEndpoint(userId)),
          headers: _headers,
          body: jsonEncode({'isPro': isPro}),
        )
        .timeout(_timeout);
    _decode(res);
  }
}
