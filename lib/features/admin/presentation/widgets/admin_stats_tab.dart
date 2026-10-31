import 'package:conciertos_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/app_shell.dart';
import '../../data/services/admin_api_service.dart';

const _red = Color(0xFFE53935);

class AdminStatsTab extends StatefulWidget {
  const AdminStatsTab({super.key});

  @override
  State<AdminStatsTab> createState() => _AdminStatsTabState();
}

class _AdminStatsTabState extends State<AdminStatsTab>
    with AutomaticKeepAliveClientMixin {
  final _api = AdminApiService();
  late Future<AdminStats> _future = _api.getStats();

  @override
  bool get wantKeepAlive => true;

  Future<void> _reload() async {
    final next = _api.getStats();
    setState(() => _future = next);
    try {
      await next;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l = AppLocalizations.of(context);

    return FutureBuilder<AdminStats>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError || !snap.hasData) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l.adminLoadError),
                const SizedBox(height: 12),
                OutlinedButton(onPressed: _reload, child: Text(l.adminRetry)),
              ],
            ),
          );
        }
        final s = snap.data!;
        return RefreshIndicator(
          onRefresh: _reload,
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              16 + floatingNavBarClearance(context),
            ),
            children: [
              _SectionTitle(l.adminSectionUsers),
              _KpiGrid(items: [
                _Kpi(l.adminKpiTotalUsers, '${s.totalUsers}'),
                _Kpi(l.adminKpiPro, '${s.proUsers}'),
                _Kpi(l.adminKpiNew7d, '${s.new7d}'),
                _Kpi(l.adminKpiNew30d, '${s.new30d}'),
                _Kpi(l.adminKpiActive7d, '${s.active7d}'),
                _Kpi(l.adminKpiActive30d, '${s.active30d}'),
                _Kpi(l.adminKpiPushUsers, '${s.usersWithPush}'),
                _Kpi(l.adminKpiDevices, '${s.devices}'),
              ]),
              const SizedBox(height: 12),
              _VersionsCard(versions: s.versions),
              const SizedBox(height: 24),
              _SectionTitle(l.adminSectionActivity),
              _BarChart(title: l.adminChartSignups, data: s.signups),
              const SizedBox(height: 12),
              _BarChart(title: l.adminChartConcerts, data: s.concertsByDay),
              const SizedBox(height: 24),
              _SectionTitle(l.adminSectionFeatures),
              _FeatureList(features: s.features),
              const SizedBox(height: 24),
              _SectionTitle(l.adminSectionContent),
              _KpiGrid(items: [
                _Kpi(l.adminKpiConcerts, '${s.concerts}'),
                _Kpi(l.adminKpiFriendships, '${s.friendships}'),
                _Kpi(l.adminKpiAvgRating, s.avgRating.toStringAsFixed(1)),
              ]),
              const SizedBox(height: 24),
              _RankCard(title: l.adminTopArtists, entries: s.topArtists),
              const SizedBox(height: 12),
              _RankCard(title: l.adminTopCities, entries: s.topCities),
              const SizedBox(height: 12),
              _RankCard(title: l.adminTopGenres, entries: s.topGenres),
              const SizedBox(height: 24),
              _SectionTitle(l.adminSectionHealth),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.storage_rounded, color: _red),
                      title: Text(l.adminHealthDb(s.dbMs)),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.timer_outlined, color: _red),
                      title: Text(l.adminHealthUptime(
                        (s.uptimeSec / 3600).toStringAsFixed(1),
                      )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
}

class _Kpi {
  final String label;
  final String value;
  const _Kpi(this.label, this.value);
}

class _KpiGrid extends StatelessWidget {
  final List<_Kpi> items;
  const _KpiGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return LayoutBuilder(builder: (context, c) {
      final w = (c.maxWidth - 10) / 2;
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: items
            .map(
              (k) => SizedBox(
                width: w,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest.withValues(alpha: .5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        k.value,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        k.label,
                        style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      );
    });
  }
}

/// Gráfica de barras sencilla (14 días) sin dependencias externas.
class _BarChart extends StatelessWidget {
  final String title;
  final List<DayCount> data;
  const _BarChart({required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).languageCode;
    final maxV = data.fold<int>(0, (m, d) => d.count > m ? d.count : m);
    final total = data.fold<int>(0, (t, d) => t + d.count);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  '$total',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: data.map((d) {
                  final h = maxV == 0 ? 0.0 : d.count / maxV;
                  return Expanded(
                    child: Tooltip(
                      message:
                          '${DateFormat.MMMd(locale).format(d.day)}: ${d.count}',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: FractionallySizedBox(
                          heightFactor: h < 0.04 ? 0.04 : h,
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                              color: d.count == 0
                                  ? cs.outlineVariant
                                  : _red,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 6),
            if (data.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat.MMMd(locale).format(data.first.day),
                    style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
                  ),
                  Text(
                    DateFormat.MMMd(locale).format(data.last.day),
                    style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _VersionsCard extends StatelessWidget {
  final List<AppVersionCount> versions;
  const _VersionsCard({required this.versions});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.adminSectionVersions,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (versions.isEmpty)
              Text(l.adminNoData, style: TextStyle(color: cs.onSurfaceVariant)),
            for (final v in versions)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        v.build == null
                            ? l.adminVersionUnknown
                            : l.adminVersionOption(v.version ?? '?', v.build!),
                      ),
                    ),
                    Text(
                      l.adminVersionDevices(v.devices),
                      style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FeatureList extends StatelessWidget {
  final List<FeatureUsage> features;
  const _FeatureList({required this.features});

  String _name(AppLocalizations l, String key) => switch (key) {
        'concerts' => l.adminFeatureConcerts,
        'photos' => l.adminFeaturePhotos,
        'comments' => l.adminFeatureComments,
        'wantToAttend' => l.adminFeatureWantToAttend,
        'records' => l.adminFeatureRecords,
        'discogs' => l.adminFeatureDiscogs,
        _ => key,
      };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final sorted = [...features]..sort((a, b) => b.users.compareTo(a.users));
    final maxUsers = sorted.fold<int>(0, (m, f) => f.users > m ? f.users : m);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: sorted.map((f) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _name(l, f.key),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        '${f.total}',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: maxUsers == 0 ? 0 : f.users / maxUsers,
                      minHeight: 6,
                      color: _red,
                      backgroundColor: cs.outlineVariant.withValues(alpha: .4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l.adminFeatureMeta(f.users, f.last30),
                    style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _RankCard extends StatelessWidget {
  final String title;
  final List<RankEntry> entries;
  const _RankCard({required this.title, required this.entries});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (entries.isEmpty)
              Text(
                l.adminNoData,
                style: TextStyle(color: cs.onSurfaceVariant),
              ),
            for (var i = 0; i < entries.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entries[i].name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      l.adminRankMeta(entries[i].count, entries[i].users),
                      style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
