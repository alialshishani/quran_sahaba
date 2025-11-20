import 'package:flutter/material.dart';

import '../../models/quran_data.dart';

class NavigateTab extends StatelessWidget {
  const NavigateTab({
    super.key,
    required this.selectedSurahNumber,
    required this.selectedJuzNumber,
    required this.onSurahChanged,
    required this.onJuzChanged,
    required this.onGoToSurah,
    required this.onGoToJuz,
    required this.onGoToPage,
    required this.pageJumpController,
    required this.totalPages,
  });

  final int selectedSurahNumber;
  final int selectedJuzNumber;
  final ValueChanged<int> onSurahChanged;
  final ValueChanged<int> onJuzChanged;
  final ValueChanged<int> onGoToSurah;
  final ValueChanged<int> onGoToJuz;
  final ValueChanged<int> onGoToPage;
  final TextEditingController pageJumpController;
  final int totalPages;

  @override
  Widget build(BuildContext context) {
    final selectedSurah = surahInfos.firstWhere(
      (surah) => surah.number == selectedSurahNumber,
    );
    final selectedJuz = juzInfos.firstWhere(
      (juz) => juz.number == selectedJuzNumber,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _navigationCard(
          context: context,
          title: 'Navigate by Surah',
          children: [
            DropdownButton<int>(
              isExpanded: true,
              value: selectedSurahNumber,
              items: surahInfos
                  .map(
                    (surah) => DropdownMenuItem(
                      value: surah.number,
                      child: Text('${surah.number}. ${surah.name}'),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                onSurahChanged(value);
              },
            ),
            Text('Starts on page ${selectedSurah.page}'),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => onGoToSurah(selectedSurah.number),
                child: const Text('Go to Surah'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _navigationCard(
          context: context,
          title: 'Navigate by Juz',
          children: [
            DropdownButton<int>(
              isExpanded: true,
              value: selectedJuzNumber,
              items: juzInfos
                  .map(
                    (juz) => DropdownMenuItem(
                      value: juz.number,
                      child: Text('Juz ${juz.number} (page ${juz.page})'),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                onJuzChanged(value);
              },
            ),
            Text('Starts on page ${selectedJuz.page}'),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => onGoToJuz(selectedJuz.number),
                child: const Text('Go to Juz'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _navigationCard(
          context: context,
          title: 'Navigate by Page',
          children: [
            TextField(
              controller: pageJumpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Page number',
                helperText: 'Enter a page between 1 and 604',
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  final value =
                      int.tryParse(pageJumpController.text.trim());
                  if (value == null || value < 1 || value > totalPages) {
                    _showInvalidPageSnackBar(context);
                    return;
                  }
                  onGoToPage(value);
                },
                child: const Text('Go to Page'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Card _navigationCard({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  void _showInvalidPageSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please enter a valid page between 1 and $totalPages.'),
      ),
    );
  }
}
