import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quran_sahaba/l10n/app_localizations.dart';

import '../../models/quran_data.dart';

class KhetmehTab extends StatelessWidget {
  const KhetmehTab({
    super.key,
    required this.onPlanSelected,
    required this.khetmehProgress,
    required this.khetmehDailyReadingCounts,
    required this.khetmehCompletionCounts,
    required this.khetmehCompletionHistory,
    required this.khetmehStartDates,
    required this.khetmehActiveStatus,
    required this.onStartKhetmeh,
    required this.onCompleteKhetmeh,
    required this.onEndKhetmeh,
  });

  final ValueChanged<String> onPlanSelected;
  final Map<String, int> khetmehProgress;
  final Map<String, Map<String, int>> khetmehDailyReadingCounts;
  final Map<String, int> khetmehCompletionCounts;
  final Map<String, List<KhetmehCompletion>> khetmehCompletionHistory;
  final Map<String, DateTime> khetmehStartDates;
  final Map<String, bool> khetmehActiveStatus;
  final ValueChanged<String> onStartKhetmeh;
  final ValueChanged<String> onCompleteKhetmeh;
  final ValueChanged<String> onEndKhetmeh;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final plans = getKhetmehPlans(l);

    // Calculate total completions across all khetmehs
    int totalCompletions = 0;
    khetmehCompletionCounts.forEach((_, count) {
      totalCompletions += count;
    });

    return Column(
      children: [
        // Total completions header
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primaryContainer,
                Theme.of(context).colorScheme.secondaryContainer,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                l.totalCompletions,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$totalCompletions',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
        // Khetmeh list
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
        final plan = plans[index];
        final currentPage = khetmehProgress[plan.id] ?? plan.startPage;
        final progress = (currentPage - plan.startPage) /
            (plan.endPage - plan.startPage);
        final remainingTotalPages = plan.endPage - currentPage;
        final completions = khetmehCompletionCounts[plan.id] ?? 0;

        // Calculate pages per day for this plan
        final pagesPerDay = plan.durationInDays > 0
            ? (plan.endPage - plan.startPage + 1) / plan.durationInDays
            : (plan.endPage - plan.startPage + 1); // For free roam or undefined duration

        // Get today's date key
        final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());

        // Get pages read today for this specific khetmeh
        final pagesReadTodayForThisKhetmeh =
            khetmehDailyReadingCounts[plan.id]?[todayKey] ?? 0;

        // Calculate remaining pages for today
        int remainingPagesToday = 0;
        if (plan.durationInDays > 0 && plan.id != 'plan4') { // For timed khetmehs (except Sahaba)
          remainingPagesToday = (pagesPerDay - pagesReadTodayForThisKhetmeh).ceil();
          if (remainingPagesToday < 0) remainingPagesToday = 0;
        }

        // For Sahaba Khetmeh, show today's surah
        String? sahabaTodaySurah;
        if (plan.id == 'plan4') {
          final startDate = khetmehStartDates[plan.id] ?? DateTime.now();
          final todaySurahNumber = getSahabaKhetmehCurrentDaySurah(startDate);
          final todaySurahInfo = surahInfos.firstWhere((s) => s.number == todaySurahNumber);
          final locale = Localizations.localeOf(context);
          sahabaTodaySurah = locale.languageCode == 'ar' ? todaySurahInfo.nameAr : todaySurahInfo.nameEn;
        }

        // Calculate schedule status (ahead, on track, or behind)
        String? scheduleStatus;
        Color? scheduleColor;
        IconData? scheduleIcon;

        if (plan.durationInDays > 0 && khetmehStartDates.containsKey(plan.id)) {
          final startDate = khetmehStartDates[plan.id]!;
          final daysSinceStart = DateTime.now().difference(startDate).inDays;

          // Calculate expected page based on days since start
          final expectedPage = plan.startPage + (daysSinceStart * pagesPerDay).round();
          final pageDifference = currentPage - expectedPage;

          if (pageDifference > 10) {
            scheduleStatus = 'Ahead of schedule';
            scheduleColor = Colors.green;
            scheduleIcon = Icons.trending_up;
          } else if (pageDifference < -10) {
            scheduleStatus = 'Behind schedule';
            scheduleColor = Colors.orange;
            scheduleIcon = Icons.trending_down;
          } else {
            scheduleStatus = 'On track';
            scheduleColor = Colors.blue;
            scheduleIcon = Icons.check_circle_outline;
          }
        }

        // Calculate expected completion date
        DateTime? expectedCompletionDate;
        if (plan.durationInDays > 0 && remainingTotalPages > 0) {
          final daysRemaining = (remainingTotalPages / pagesPerDay).ceil();
          expectedCompletionDate = DateTime.now().add(Duration(days: daysRemaining));
        }

        // Check if khetmeh is active (Free Roam is always active)
        final isActive = plan.id == 'plan5' ? true : (khetmehActiveStatus[plan.id] ?? true);

        return Card(
          color: isActive
              ? Theme.of(context).colorScheme.surface
              : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          child: GestureDetector(
            onTap: isActive ? () => onPlanSelected(plan.id) : null,
            child: ListTile(
              isThreeLine: true,
              leading: CircleAvatar(
                backgroundColor: isActive
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                foregroundColor: isActive
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                child: Text('${index + 1}'),
              ),
              title: Text(plan.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plan.subtitle),
                  // Only show details for active khetmehs
                  if (isActive) ...[
                    Text('Page $currentPage of ${plan.endPage}'),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: progress.isNaN || progress.isInfinite || progress.isNegative
                          ? 0
                          : progress,
                    ),
                    if (sahabaTodaySurah != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          "Today's surah: $sahabaTodaySurah",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    if (scheduleStatus != null && scheduleColor != null && scheduleIcon != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Icon(
                              scheduleIcon,
                              size: 16,
                              color: scheduleColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              scheduleStatus,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: scheduleColor,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (remainingPagesToday > 0 && plan.durationInDays > 0)
                      Text(l.pagesToReadToday(remainingPagesToday)),
                    if (expectedCompletionDate != null && plan.durationInDays > 0 && plan.id != 'plan4')
                      Text(l.expectedCompletionDate(
                          DateFormat.yMMMd().format(expectedCompletionDate))),
                  ],
                  if (completions > 0)
                    Text(l.khetmehCompletions(completions)),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (completions > 0)
                    IconButton(
                      icon: const Icon(Icons.history),
                      onPressed: () => _showCompletionHistory(context, plan),
                      tooltip: l.viewCompletionHistory,
                    ),
                  if (plan.id == 'plan5')
                    IconButton(
                      icon: const Icon(Icons.check_circle),
                      onPressed: () => onCompleteKhetmeh(plan.id),
                      tooltip: l.complete,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  if (plan.id != 'plan5' && !isActive)
                    IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () => onStartKhetmeh(plan.id),
                      tooltip: l.start,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  if (plan.id != 'plan5' && isActive) ...[
                    IconButton(
                      icon: const Icon(Icons.check_circle),
                      onPressed: () => onCompleteKhetmeh(plan.id),
                      tooltip: l.complete,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    IconButton(
                      icon: const Icon(Icons.stop),
                      onPressed: () => onEndKhetmeh(plan.id),
                      tooltip: l.end,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: plans.length,
          ),
        ),
      ],
    );
  }

  void _showCompletionHistory(BuildContext context, KhetmehPlan plan) {
    final completions = khetmehCompletionHistory[plan.id] ?? [];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${plan.title} - History'),
        content: SizedBox(
          width: double.maxFinite,
          child: completions.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No completion history yet.'),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: completions.length,
                  itemBuilder: (context, index) {
                    final completion = completions[completions.length - 1 - index]; // Reverse order
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text('${completions.length - index}'),
                        ),
                        title: Text(
                          'Completed in ${completion.daysToComplete} ${completion.daysToComplete == 1 ? 'day' : 'days'}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              'Started: ${DateFormat.yMMMd().format(completion.startDate)}',
                            ),
                            Text(
                              'Finished: ${DateFormat.yMMMd().format(completion.completionDate)}',
                            ),
                            if (plan.durationInDays > 0) ...[
                              const SizedBox(height: 4),
                              _buildComparisonChip(
                                completion.daysToComplete,
                                plan.durationInDays,
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonChip(int actualDays, int targetDays) {
    final difference = actualDays - targetDays;
    final isAhead = difference <= 0;
    final color = isAhead ? Colors.green : Colors.orange;
    final text = isAhead
        ? difference == 0
            ? 'On target!'
            : '${difference.abs()} ${difference.abs() == 1 ? 'day' : 'days'} ahead'
        : '$difference ${difference == 1 ? 'day' : 'days'} over';

    return Chip(
      label: Text(
        text,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
      backgroundColor: color.withValues(alpha: 0.15),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}
