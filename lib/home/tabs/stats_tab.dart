import 'package:flutter/material.dart';
import 'package:quran_sahaba/l10n/app_localizations.dart';
import 'package:quran_sahaba/models/quran_data.dart';

class StatsTab extends StatelessWidget {
  const StatsTab({
    super.key,
    required this.dailyReadingCounts,
    required this.weeklyAverage,
    required this.totalAverage,
    required this.allDailyReadingCounts,
    required this.readingSessions,
    required this.currentSessionDuration,
  });

  final int dailyReadingCounts;
  final String weeklyAverage;
  final String totalAverage;
  final Map<String, Map<String, int>> allDailyReadingCounts;
  final List<ReadingSession> readingSessions;
  final int currentSessionDuration;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    // Flatten allDailyReadingCounts into a single map for recent activity display
    final Map<String, int> flattenedDailyCounts = {};
    allDailyReadingCounts.forEach((khetmehTitle, dailyCounts) {
      dailyCounts.forEach((date, count) {
        flattenedDailyCounts.update(
          date,
          (value) => value + count,
          ifAbsent: () => count,
        );
      });
    });

    final entries = flattenedDailyCounts.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    // Calculate reading session statistics
    final totalReadingTime = readingSessions.fold<int>(
      0,
      (sum, session) => sum + session.durationInSeconds,
    ) + currentSessionDuration;

    final averageSessionTime = readingSessions.isEmpty
        ? 0
        : readingSessions.fold<int>(
              0,
              (sum, session) => sum + session.durationInSeconds,
            ) ~/
            readingSessions.length;

    final longestSession = readingSessions.isEmpty
        ? 0
        : readingSessions
            .map((s) => s.durationInSeconds)
            .reduce((a, b) => a > b ? a : b);

    // Get today's date for filtering
    final today = DateTime.now();
    final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final todaySessions = readingSessions.where((session) {
      final sessionDate = session.startTime;
      final sessionDateString = '${sessionDate.year}-${sessionDate.month.toString().padLeft(2, '0')}-${sessionDate.day.toString().padLeft(2, '0')}';
      return sessionDateString == todayString;
    }).toList();

    final todayReadingTime = todaySessions.fold<int>(
      0,
      (sum, session) => sum + session.durationInSeconds,
    ) + currentSessionDuration;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            title: Text(l.statsPagesReadToday),
            trailing: Text(
              '$dailyReadingCounts',
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
        Text(l.readingSessions,
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        if (currentSessionDuration > 0)
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: ListTile(
              leading: const Icon(Icons.timer),
              title: Text(l.currentSession),
              trailing: Text(
                _formatDuration(currentSessionDuration),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.access_time),
            title: Text(l.statsReadingTimeToday),
            trailing: Text(
              _formatDuration(todayReadingTime),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.schedule),
            title: Text(l.totalReadingTime),
            trailing: Text(
              _formatDuration(totalReadingTime),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.show_chart),
            title: Text(l.averageSessionTime),
            trailing: Text(
              _formatDuration(averageSessionTime),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.star),
            title: Text(l.longestSession),
            trailing: Text(
              _formatDuration(longestSession),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.event_note),
            title: Text(l.statsSessionsToday),
            trailing: Text(
              '${todaySessions.length}',
              style: Theme.of(context).textTheme.titleMedium,
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

  String _formatDuration(int seconds) {
    if (seconds < 60) {
      return '$seconds sec';
    }
    final minutes = seconds ~/ 60;
    if (minutes < 60) {
      return '$minutes min';
    }
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return '${hours}h ${remainingMinutes}m';
  }
}
