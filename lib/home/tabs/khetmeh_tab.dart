import 'package:flutter/material.dart';
import 'package:quran_sahaba/l10n/app_localizations.dart';

import '../../models/quran_data.dart';

class KhetmehTab extends StatelessWidget {
  const KhetmehTab(
      {super.key, required this.onPlanSelected, required this.khetmehProgress});
  final ValueChanged<String> onPlanSelected;
  final Map<String, int> khetmehProgress;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final plans = getKhetmehPlans(l);
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final plan = plans[index];
        final currentPage = khetmehProgress[plan.title] ?? 0;
        final progress = (currentPage - plan.startPage) /
            (plan.endPage - plan.startPage);
        return Card(
          child: GestureDetector(
            onTap: () => onPlanSelected(plan.title),
            child: ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text(plan.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plan.subtitle),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: progress.isNaN || progress.isInfinite
                        ? 0
                        : progress,
                  ),
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
}
