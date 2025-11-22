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
  });

  final ValueChanged<String> onPlanSelected;
  final Map<String, int> khetmehProgress;
  final Map<String, Map<String, int>> khetmehDailyReadingCounts;
  final Map<String, int> khetmehCompletionCounts;
  final Map<String, List<KhetmehCompletion>> khetmehCompletionHistory;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final plans = getKhetmehPlans(l);
    return ListView.separated(
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
          final startDate = DateTime.now(); // We'll get this from state later
          final todaySurahNumber = getSahabaKhetmehCurrentDaySurah(startDate);
          final todaySurahInfo = surahInfos.firstWhere((s) => s.number == todaySurahNumber);
          final locale = Localizations.localeOf(context);
          sahabaTodaySurah = locale.languageCode == 'ar' ? todaySurahInfo.nameAr : todaySurahInfo.nameEn;
        }


        // Calculate expected completion date
        DateTime? expectedCompletionDate;
        if (plan.durationInDays > 0 && remainingTotalPages > 0) {
          final daysRemaining = (remainingTotalPages / pagesPerDay).ceil();
          expectedCompletionDate = DateTime.now().add(Duration(days: daysRemaining));
        }

        return Card(
          child: GestureDetector(
            onTap: () => onPlanSelected(plan.id),
            child: ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text(plan.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plan.subtitle),
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
                  if (remainingPagesToday > 0 && plan.durationInDays > 0)
                    Text(l.pagesToReadToday(remainingPagesToday)),
                  if (expectedCompletionDate != null && plan.durationInDays > 0 && plan.id != 'plan4')
                    Text(l.expectedCompletionDate(
                        DateFormat.yMMMd().format(expectedCompletionDate))),
                  if (completions > 0)
                    Text(l.khetmehCompletions(completions)),
                ],
              ),
              trailing: completions > 0
                  ? IconButton(
                      icon: const Icon(Icons.history),
                      onPressed: () => _showCompletionHistory(context, plan),
                      tooltip: 'View completion history',
                    )
                  : null,
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: plans.length,
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
