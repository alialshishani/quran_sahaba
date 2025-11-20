import 'package:flutter/material.dart';

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
    final entries = dailyReadingCounts.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            title: const Text('Pages read today'),
            trailing: Text(
              '${dailyReadingCounts[_todayKey] ?? 0}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
        Card(
          child: ListTile(
            title: const Text('Average pages per day (last 7 days)'),
            trailing: Text(
              weeklyAverage,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
        Card(
          child: ListTile(
            title: const Text('Overall daily average'),
            trailing: Text(
              totalAverage,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('Recent activity', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        ...entries
            .take(14)
            .map(
              (entry) => Card(
                child: ListTile(
                  title: Text(entry.key),
                  trailing: Text('${entry.value} pages'),
                ),
              ),
            ),
        if (entries.isEmpty)
          const Text(
            'No reading activity recorded yet. Start reading to see stats!',
          ),
      ],
    );
  }

  String get _todayKey => DateTime.now().toIso8601String().split('T').first;
}
