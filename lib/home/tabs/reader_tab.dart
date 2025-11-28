import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:quran_sahaba/l10n/app_localizations.dart';
import 'package:quran_sahaba/models/quran_data.dart';

class ReaderTab extends StatefulWidget {
  const ReaderTab({
    super.key,
    required this.pageController,
    required this.totalPages,
    required this.currentPage,
    required this.pageAssetPath,
    required this.onPageChanged,
    required this.onNext,
    required this.onPrevious,
    required this.bottomBarVisible,
    required this.invertColors,
    required this.bookmarks,
    required this.isCurrentPageBookmarked,
    required this.onAddBookmark,
    required this.onRemoveBookmark,
    required this.onUpdateBookmark,
    required this.onGoToBookmark,
    required this.showTasbih,
    required this.tafseerContent,
    required this.hasDownloadedTafseer,
    required this.onFetchTafseer,
    required this.selectedTafseerId,
    required this.onSelectTafseer,
  });

  final PageController pageController;
  final int totalPages;
  final int currentPage;
  final String Function(int) pageAssetPath;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final bool bottomBarVisible;
  final bool invertColors;
  final List<Bookmark> bookmarks;
  final bool isCurrentPageBookmarked;
  final Function({String? label, String? note}) onAddBookmark;
  final VoidCallback onRemoveBookmark;
  final Function(Bookmark) onUpdateBookmark;
  final Function(int) onGoToBookmark;
  final bool showTasbih;
  final TafseerContent? tafseerContent;
  final bool hasDownloadedTafseer;
  final Future<TafseerContent?> Function() onFetchTafseer;
  final String? selectedTafseerId;
  final Function(String?) onSelectTafseer;

  @override
  State<ReaderTab> createState() => _ReaderTabState();
}

class _ReaderTabState extends State<ReaderTab> {
  int _tasbihCount = 0;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    final l = AppLocalizations.of(context)!;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              controller: widget.pageController,
              reverse: !isArabic,
              onPageChanged: widget.onPageChanged,
              itemBuilder: (context, index) {
                // Calculate actual page number with wrapping
                final actualIndex = index % widget.totalPages;
                final pageNumber = actualIndex + 1;
                return InteractiveViewer(
                  child: Center(
                    child: widget.invertColors
                        ? ColorFiltered(
                            colorFilter: const ColorFilter.matrix([
                              -1, 0, 0, 0, 255, //
                              0, -1, 0, 0, 255, //
                              0, 0, -1, 0, 255, //
                              0, 0, 0, 1, 0, //
                            ]),
                            child: Image.asset(
                              widget.pageAssetPath(pageNumber),
                              fit: BoxFit.contain,
                            ),
                          )
                        : Image.asset(
                            widget.pageAssetPath(pageNumber),
                            fit: BoxFit.contain,
                          ),
                  ),
                );
              },
            ),
          ),
          // Bookmark and Tafseer buttons (top-right)
          Positioned(
            top: 16,
            right: 16,
            child: Opacity(
              opacity: widget.bottomBarVisible ? 1.0 : 0.0,
              child: IgnorePointer(
                ignoring: !widget.bottomBarVisible,
                child: Row(
                  children: [
                    // Tafseer button
                    if (widget.hasDownloadedTafseer)
                      Builder(
                        builder: (btnContext) => FloatingActionButton.small(
                          heroTag: 'tafseer_button',
                          onPressed: () async {
                            // If no tafseer is selected, show selection dialog
                            if (widget.selectedTafseerId == null) {
                              await _showTafseerSelectionDialog(btnContext, l);
                              // After selection, automatically fetch and show
                              if (widget.selectedTafseerId != null && mounted) {
                                await _viewTafseer(btnContext, l);
                              }
                              return;
                            }

                            // Tafseer is selected, fetch and show it
                            await _viewTafseer(btnContext, l);
                          },
                          backgroundColor: widget.tafseerContent != null
                              ? Theme.of(btnContext).colorScheme.primaryContainer
                              : Theme.of(btnContext).colorScheme.surface.withValues(alpha: 0.9),
                          child: Icon(
                            Icons.menu_book,
                            color: widget.tafseerContent != null
                                ? Theme.of(btnContext).colorScheme.onPrimaryContainer
                                : Theme.of(btnContext).colorScheme.primary,
                          ),
                        ),
                      ),
                    if (widget.hasDownloadedTafseer) const SizedBox(width: 8),
                    // Bookmarks list button
                    FloatingActionButton.small(
                      heroTag: 'bookmarks_list',
                      onPressed: () => _showBookmarksDialog(context, l),
                      backgroundColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                      child: Icon(
                        Icons.bookmarks,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Add/Remove bookmark button
                    FloatingActionButton.small(
                      heroTag: 'bookmark_toggle',
                      onPressed: () {
                        if (widget.isCurrentPageBookmarked) {
                          widget.onRemoveBookmark();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l.bookmarkRemoved)),
                          );
                        } else {
                          _showAddBookmarkDialog(context, l);
                        }
                      },
                      backgroundColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                      child: Icon(
                        widget.isCurrentPageBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Tasbih counter (left side)
          if (widget.showTasbih)
            Positioned(
              left: 16,
              bottom: 100,
              child: Opacity(
                opacity: widget.bottomBarVisible ? 1.0 : 0.0,
                child: IgnorePointer(
                  ignoring: !widget.bottomBarVisible,
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l.tasbihCounter,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$_tasbihCount',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.refresh, size: 20),
                                onPressed: () {
                                  setState(() => _tasbihCount = 0);
                                },
                                tooltip: l.reset,
                              ),
                              const SizedBox(width: 8),
                              FloatingActionButton.small(
                                heroTag: 'tasbih_add',
                                onPressed: () {
                                  setState(() => _tasbihCount++);
                                },
                                child: const Icon(Icons.add),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Opacity(
              opacity: widget.bottomBarVisible ? 1.0 : 0.0,
              child: IgnorePointer(
                ignoring: !widget.bottomBarVisible,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _arrowWithUnderline(
                        context: context,
                        icon: Icons.arrow_back,
                        onPressed: widget.onNext,
                        showUnderline: widget.currentPage.isEven,
                      ),
                      Text(widget.currentPage.toString()),
                      _arrowWithUnderline(
                        context: context,
                        icon: Icons.arrow_forward,
                        onPressed: widget.onPrevious,
                        showUnderline: widget.currentPage.isOdd,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddBookmarkDialog(BuildContext context, AppLocalizations l) {
    final labelController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.addBookmark),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${l.page} ${widget.currentPage}'),
            const SizedBox(height: 16),
            TextField(
              controller: labelController,
              decoration: InputDecoration(
                labelText: l.bookmarkLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: l.bookmarkNote,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onAddBookmark(
                label: labelController.text.isEmpty ? null : labelController.text,
                note: noteController.text.isEmpty ? null : noteController.text,
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l.bookmarkAdded)),
              );
            },
            child: Text(l.saveBookmark),
          ),
        ],
      ),
    );
  }

  void _showBookmarksDialog(BuildContext context, AppLocalizations l) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.bookmarks),
        content: SizedBox(
          width: double.maxFinite,
          child: widget.bookmarks.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(l.noBookmarks),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.bookmarks.length,
                  itemBuilder: (context, index) {
                    final bookmark = widget.bookmarks[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text('${bookmark.page}'),
                        ),
                        title: Text(
                          bookmark.label?.isNotEmpty == true
                              ? bookmark.label!
                              : '${l.page} ${bookmark.page}',
                        ),
                        subtitle: bookmark.note?.isNotEmpty == true
                            ? Text(bookmark.note!)
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                widget.onRemoveBookmark();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          widget.onGoToBookmark(bookmark.page);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.close),
          ),
        ],
      ),
    );
  }

  void _showTafseerDialog(BuildContext context, AppLocalizations l) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          child: Column(
            children: [
              AppBar(
                title: Text(l.tafseerForPage(widget.currentPage)),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              // Tafseer selector - non-intrusive at top
              if (widget.selectedTafseerId != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Builder(
                    builder: (chipContext) => InkWell(
                      onTap: () {
                        Navigator.of(chipContext).pop();
                        if (!mounted) return;

                        // Just show the tafseer selection dialog
                        // User can tap the tafseer button again to view
                        _showTafseerSelectionDialog(context, l);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(chipContext).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.swap_horiz,
                              size: 16,
                              color: Theme.of(chipContext).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                isArabic
                                    ? getAvailableTafseers().firstWhere((t) => t.id == widget.selectedTafseerId).nameAr
                                    : getAvailableTafseers().firstWhere((t) => t.id == widget.selectedTafseerId).nameEn,
                                style: Theme.of(chipContext).textTheme.labelMedium?.copyWith(
                                      color: Theme.of(chipContext).colorScheme.onSurfaceVariant,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: widget.tafseerContent == null
                    ? Center(child: Text(l.noTafseerAvailable))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: widget.tafseerContent!.ayahs.length,
                        itemBuilder: (listContext, index) {
                          final ayah = widget.tafseerContent!.ayahs[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        child: Text(
                                          '${ayah.ayahNumber}',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          '${l.surah} ${ayah.surahNumber} - ${l.ayah} ${ayah.ayahNumber}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    ayah.ayahText,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          height: 2,
                                          fontSize: 20,
                                        ),
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  const Divider(height: 24),
                                  Text(
                                    l.tafseer,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Html(
                                    data: ayah.tafseerText,
                                    style: {
                                      "body": Style(
                                        margin: Margins.zero,
                                        padding: HtmlPaddings.zero,
                                        fontSize: FontSize(Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0),
                                        lineHeight: const LineHeight(1.8),
                                      ),
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTafseerDialogWithContent(
    BuildContext context,
    AppLocalizations l,
    TafseerContent content,
  ) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          child: Column(
            children: [
              AppBar(
                title: Text(l.tafseerForPage(widget.currentPage)),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              // Tafseer selector - non-intrusive at top
              if (widget.selectedTafseerId != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Builder(
                    builder: (chipContext) => InkWell(
                      onTap: () {
                        Navigator.of(chipContext).pop();
                        if (!mounted) return;

                        // Just show the tafseer selection dialog
                        // User can tap the tafseer button again to view
                        _showTafseerSelectionDialog(context, l);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(chipContext).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.swap_horiz,
                              size: 16,
                              color: Theme.of(chipContext).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                isArabic
                                    ? getAvailableTafseers().firstWhere((t) => t.id == widget.selectedTafseerId).nameAr
                                    : getAvailableTafseers().firstWhere((t) => t.id == widget.selectedTafseerId).nameEn,
                                style: Theme.of(chipContext).textTheme.labelMedium?.copyWith(
                                      color: Theme.of(chipContext).colorScheme.onSurfaceVariant,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: content.ayahs.length,
                  itemBuilder: (context, index) {
                    final ayah = content.ayahs[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  child: Text(
                                    '${ayah.ayahNumber}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    '${l.surah} ${ayah.surahNumber} - ${l.ayah} ${ayah.ayahNumber}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              ayah.ayahText,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    height: 2,
                                    fontSize: 20,
                                  ),
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                            ),
                            const Divider(height: 24),
                            Text(
                              l.tafseer,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Html(
                              data: ayah.tafseerText,
                              style: {
                                "body": Style(
                                  margin: Margins.zero,
                                  padding: HtmlPaddings.zero,
                                  fontSize: FontSize(Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14.0),
                                  lineHeight: const LineHeight(1.8),
                                ),
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _viewTafseer(
    BuildContext context,
    AppLocalizations l,
  ) async {
    // Check if we have content for this page
    if (widget.tafseerContent != null) {
      print('Tafseer ayahs count: ${widget.tafseerContent!.ayahs.length}');
      _showTafseerDialog(context, l);
    } else {
      // Fetch on-demand
      print('Fetching tafseer on-demand for page ${widget.currentPage}');

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading tafseer...'),
                ],
              ),
            ),
          ),
        ),
      );

      try {
        final content = await widget.onFetchTafseer();

        if (mounted) {
          Navigator.pop(context); // Close loading dialog

          if (content != null) {
            // Tafseer fetched successfully, show it
            _showTafseerDialogWithContent(context, l, content);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l.noTafseerAvailable)),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          Navigator.pop(context); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading tafseer: $e')),
          );
        }
      }
    }
  }

  Future<void> _showTafseerSelectionDialog(
    BuildContext context,
    AppLocalizations l,
  ) async {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    final availableTafseers = getAvailableTafseers();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (!mounted) return;

    final selected = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.selectTafseer),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: availableTafseers.map((tafseer) {
              final isSelected = widget.selectedTafseerId == tafseer.id;
              return ListTile(
                selected: isSelected,
                leading: CircleAvatar(
                  backgroundColor: isSelected
                      ? Theme.of(dialogContext).colorScheme.primary
                      : Theme.of(dialogContext).colorScheme.surfaceContainerHighest,
                  child: Icon(
                    isSelected ? Icons.check : Icons.menu_book,
                    color: isSelected
                        ? Theme.of(dialogContext).colorScheme.onPrimary
                        : Theme.of(dialogContext).colorScheme.onSurface,
                    size: 20,
                  ),
                ),
                title: Text(
                  isArabic ? tafseer.nameAr : tafseer.nameEn,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: Text('${tafseer.author} • ${tafseer.language.toUpperCase()}'),
                onTap: () => Navigator.pop(dialogContext, tafseer.id),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l.cancel),
          ),
        ],
      ),
    );

    if (selected != null && mounted) {
      widget.onSelectTafseer(selected);

      // Show snackbar
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            '${l.viewing} ${isArabic ? availableTafseers.firstWhere((t) => t.id == selected).nameAr : availableTafseers.firstWhere((t) => t.id == selected).nameEn}',
          ),
        ),
      );
    }
  }

  Widget _arrowWithUnderline({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onPressed,
    required bool showUnderline,
  }) {
    final underlineColor =
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
        ),
        Container(
          width: 24,
          height: 2,
          decoration: BoxDecoration(
            color: showUnderline ? underlineColor : Colors.transparent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}
