import 'package:flutter/material.dart';
import 'package:quran_sahaba/l10n/app_localizations.dart';
import 'package:quran_sahaba/models/quran_data.dart';

class TafseerLibraryScreen extends StatefulWidget {
  const TafseerLibraryScreen({
    super.key,
    required this.downloadedTafseers,
    required this.selectedTafseerId,
    required this.onDownloadTafseer,
    required this.onDeleteTafseer,
    required this.onSelectTafseer,
  });

  final List<String> downloadedTafseers;
  final String? selectedTafseerId;
  final Function(TafseerSource) onDownloadTafseer;
  final Function(String) onDeleteTafseer;
  final Function(String?) onSelectTafseer;

  @override
  State<TafseerLibraryScreen> createState() => _TafseerLibraryScreenState();
}

class _TafseerLibraryScreenState extends State<TafseerLibraryScreen> {
  Set<String> _downloading = {};

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final availableTafseers = getAvailableTafseers();
    final downloadedTafseers = availableTafseers
        .where((t) => widget.downloadedTafseers.contains(t.id))
        .toList();
    final notDownloadedTafseers = availableTafseers
        .where((t) => !widget.downloadedTafseers.contains(t.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l.tafseerLibrary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (downloadedTafseers.isNotEmpty) ...[
            Text(
              l.downloadedTafseers,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ...downloadedTafseers.map((tafseer) => _buildTafseerCard(
                  context,
                  l,
                  tafseer,
                  isDownloaded: true,
                )),
            const SizedBox(height: 24),
          ],
          Text(
            l.availableTafseers,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          if (notDownloadedTafseers.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'All tafseers downloaded!',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            )
          else
            ...notDownloadedTafseers.map((tafseer) => _buildTafseerCard(
                  context,
                  l,
                  tafseer,
                  isDownloaded: false,
                )),
        ],
      ),
    );
  }

  Widget _buildTafseerCard(
    BuildContext context,
    AppLocalizations l,
    TafseerSource tafseer, {
    required bool isDownloaded,
  }) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    final isDownloading = _downloading.contains(tafseer.id);
    final isSelected = widget.selectedTafseerId == tafseer.id;

    return Card(
      color: isSelected
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isDownloaded
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Icon(
            isDownloaded ? Icons.check : Icons.download,
            color: isDownloaded
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        title: Text(
          isArabic ? tafseer.nameAr : tafseer.nameEn,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${tafseer.author} • ${tafseer.language.toUpperCase()}'),
            Text(tafseer.description),
            Text(
              '${l.tafseerSize(tafseer.sizeInMB.toStringAsFixed(1))} MB',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  l.viewing,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        trailing: isDownloading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : isDownloaded
                ? PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete') {
                        _showDeleteConfirmation(context, l, tafseer);
                      } else if (value == 'select') {
                        widget.onSelectTafseer(tafseer.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${l.viewing} ${isArabic ? tafseer.nameAr : tafseer.nameEn}',
                            ),
                          ),
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      if (!isSelected)
                        PopupMenuItem(
                          value: 'select',
                          child: Row(
                            children: [
                              const Icon(Icons.visibility),
                              const SizedBox(width: 8),
                              Text(l.selectTafseer),
                            ],
                          ),
                        ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(Icons.delete),
                            const SizedBox(width: 8),
                            Text(l.delete),
                          ],
                        ),
                      ),
                    ],
                  )
                : IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () => _downloadTafseer(context, l, tafseer),
                  ),
        isThreeLine: true,
        onTap: isDownloaded && !isSelected
            ? () {
                widget.onSelectTafseer(tafseer.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${l.viewing} ${isArabic ? tafseer.nameAr : tafseer.nameEn}',
                    ),
                  ),
                );
              }
            : null,
      ),
    );
  }

  Future<void> _downloadTafseer(
    BuildContext context,
    AppLocalizations l,
    TafseerSource tafseer,
  ) async {
    setState(() {
      _downloading.add(tafseer.id);
    });

    try {
      await widget.onDownloadTafseer(tafseer);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.tafseerDownloaded)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error downloading tafseer: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _downloading.remove(tafseer.id);
        });
      }
    }
  }

  void _showDeleteConfirmation(
    BuildContext context,
    AppLocalizations l,
    TafseerSource tafseer,
  ) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.deleteTafseer),
        content: Text(
          'Delete ${isArabic ? tafseer.nameAr : tafseer.nameEn}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onDeleteTafseer(tafseer.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l.tafseerDeleted)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l.delete),
          ),
        ],
      ),
    );
  }
}
