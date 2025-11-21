import 'package:flutter/material.dart';
import 'package:quran_sahaba/l10n/app_localizations.dart';

class StatsTab extends StatelessWidget {
  const StatsTab({
    super.key,
    required this.dailyReadingCounts,
    required this.weeklyAverage,
    required this.totalAverage,
  });

  final Map<String, int> dailyReadingCounts;
  final String weeklyAverage;
  final String totalAverage;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final entries = dailyReadingCounts.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            title: Text(l.statsPagesReadToday),
            trailing: Text(
              '${dailyReadingCounts[_todayKey] ?? 0}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
        Card(
          child: ListTile(
            title: Text(l.statsWeeklyAverage),
            trailing: Text(
              weeklyAverage,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
        Card(
          child: ListTile(
            title: Text(l.statsOverallAverage),
            trailing: Text(
              totalAverage,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(l.statsRecentActivity,
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        ...entries
            .take(14)
            .map(
              (entry) => Card(
                child: ListTile(
                  title: Text(entry.key),
                  trailing: Text(l.statsPages(entry.value)),
                ),
              ),
            ),
        if (entries.isEmpty)
          Text(
            l.statsNoActivity,
          ),
      ],
    );
  }

  String get _todayKey => DateTime.now().toIso8601String().split('T').first;
}
