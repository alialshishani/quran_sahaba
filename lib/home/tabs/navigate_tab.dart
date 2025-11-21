import 'package:flutter/material.dart';
import 'package:quran_sahaba/l10n/app_localizations.dart';

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
    final l = AppLocalizations.of(context)!;
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
          title: l.navigateBySurah,
          children: [
            DropdownButton<int>(
              isExpanded: true,
              value: selectedSurahNumber,
              items: surahInfos
                  .map(
                    (surah) => DropdownMenuItem(
                      value: surah.number,
                      child: Text(
                        '${surah.number}. ${Localizations.localeOf(context).languageCode == 'ar' ? surah.nameAr : surah.nameEn}',
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                onSurahChanged(value);
              },
            ),
            Text(l.startsOnPage(selectedSurah.page)),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => onGoToSurah(selectedSurah.number),
                child: Text(l.goToSurah),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _navigationCard(
          context: context,
          title: l.navigateByJuz,
          children: [
            DropdownButton<int>(
              isExpanded: true,
              value: selectedJuzNumber,
              items: juzInfos
                  .map(
                    (juz) => DropdownMenuItem(
                      value: juz.number,
                      child: Text('${l.juz} ${juz.number} (${l.pageNumber} ${juz.page})'),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                onJuzChanged(value);
              },
            ),
            Text(l.startsOnPage(selectedJuz.page)),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => onGoToJuz(selectedJuz.number),
                child: Text(l.goToJuz),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _navigationCard(
          context: context,
          title: l.navigateByPage,
          children: [
            TextField(
              controller: pageJumpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l.pageNumber,
                helperText: l.enterPageNumber,
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
                child: Text(l.goToPage),
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
        content: Text(AppLocalizations.of(context)!.invalidPageNumber(totalPages)),
      ),
    );
  }
}
