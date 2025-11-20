import 'package:flutter/material.dart';

import '../../models/quran_data.dart';

class KhetmehTab extends StatelessWidget {
  const KhetmehTab({super.key, required this.plans});

  final List<KhetmehPlan> plans;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final plan = plans[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(plan.title),
            subtitle: Text('${plan.subtitle}\n${plan.rangeDescription}'),
            isThreeLine: true,
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: plans.length,
    );
  }
}
