import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quran_sahaba/l10n/app_localizations.dart';

import '../../models/quran_data.dart';

class KhetmehTab extends StatelessWidget {
  const KhetmehTab(
      {super.key,
      required this.onPlanSelected,
      required this.khetmehProgress,
      required this.khetmehDailyReadingCounts,
      required this.khetmehCompletionCounts});
  final ValueChanged<String> onPlanSelected;
  final Map<String, int> khetmehProgress;
  final Map<String, Map<String, int>> khetmehDailyReadingCounts;
  final Map<String, int> khetmehCompletionCounts;

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
        if (plan.durationInDays > 0) { // For timed khetmehs
          remainingPagesToday = (pagesPerDay - pagesReadTodayForThisKhetmeh).ceil();
          if (remainingPagesToday < 0) remainingPagesToday = 0;
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
                  Text('Page $currentPage of ${plan.endPage}'), // Added current page / total pages
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: progress.isNaN || progress.isInfinite || progress.isNegative
                        ? 0
                        : progress,
                  ),
                  if (remainingPagesToday > 0 && plan.durationInDays > 0)
                    Text(l.pagesToReadToday(remainingPagesToday)),
                  if (expectedCompletionDate != null && plan.durationInDays > 0)
                    Text(l.expectedCompletionDate(
                        DateFormat.yMMMd().format(expectedCompletionDate))),
                  if (completions > 0)
                    Text(l.khetmehCompletions(completions)),
                ],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: plans.length,
    );
  }

  String get _todayKey => DateFormat('yyyy-MM-dd').format(DateTime.now());
}
