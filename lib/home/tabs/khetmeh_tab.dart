import 'package:flutter/material.dart';
import 'package:quran_sahaba/l10n/app_localizations.dart';

import '../../models/quran_data.dart';

class KhetmehTab extends StatelessWidget {
  const KhetmehTab({super.key, required this.onPlanSelected});
  final ValueChanged<String> onPlanSelected;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final plans = getKhetmehPlans(l);
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final plan = plans[index];
        return Card(
          child: GestureDetector(
            onTap: () => onPlanSelected(plan.title),
            child: ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text(plan.title),
              subtitle: Text('${plan.subtitle}\n${plan.rangeDescription}'),
              isThreeLine: true,
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: plans.length,
    );
  }
}
