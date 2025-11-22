import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quran_sahaba/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quran_data.dart';
import 'tabs/settings_tab.dart';
import 'tabs/khetmeh_tab.dart';
import 'tabs/navigate_tab.dart';
import 'tabs/reader_tab.dart';
import 'tabs/stats_tab.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onToggleLocale,
    required this.locale,
    required this.onLocaleChanged,
  });

  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onToggleLocale;
  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const int _totalPages = 604;
  static const String _khetmehProgressKey = 'khetmeh_progress';
  static const String _selectedKhetmehKey = 'selected_khetmeh_id'; // Changed to id
  static const String _khetmehCompletionCountsKey = 'khetmeh_completion_counts';
  static const String _statsStorageKey = 'reading_stats_v2'; // Updated key
  late final PageController _pageController;
  final TextEditingController _pageJumpController = TextEditingController();
  int _currentPage = 1;
  int _tabIndex = 0;
  int _selectedSurahNumber = surahInfos.first.number;
  int _selectedJuzNumber = juzInfos.first.number;
  int? _pendingPage;
  bool _isBottomBarVisible = true;
  Map<String, Map<String, int>> _khetmehDailyReadingCounts = {}; // New data structure
  Map<String, int> _khetmehProgress = {};
  Map<String, int> _khetmehCompletionCounts = {};
  String _selectedKhetmehId = ''; // Changed to id
  late AppLocalizations _l;

  @override
  void initState() {
    super.initState();
    // Use a very large initial page to allow wrapping in both directions
    // We position ourselves at a multiple of totalPages to enable infinite scrolling
    final initialIndex = (_currentPage - 1) + (_totalPages * 1000);
    _pageController = PageController(initialPage: initialIndex);
    _pageJumpController.text = _currentPage.toString();
    _loadKhetmehProgress();
    _loadSelectedKhetmeh();
    _loadReadingStats();
    _loadKhetmehCompletionCounts();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pageJumpController.dispose();
    super.dispose();
  }

  String _pageAssetPath(int page) => 'Quran-PNG-master/$page.jpg';

  void _goToPage(int page) {
    if (_selectedKhetmehId.isNotEmpty && page > _totalPages) {
      _completeKhetmeh();
      return;
    }

    final targetPage = page.clamp(1, _totalPages);
    if (_currentPage != targetPage) {
      setState(() {
        _currentPage = targetPage;
      });
      _pageJumpController.text = targetPage.toString();
      _persistKhetmehProgress();
    }
    if (_pageController.hasClients) {
      // Calculate the target index in the infinite scroll
      // We want to maintain the current "cycle" to ensure smooth animation
      final currentIndex = _pageController.page?.round() ?? 0;
      final currentCycle = currentIndex ~/ _totalPages;
      final targetIndex = (currentCycle * _totalPages) + (targetPage - 1);

      _pageController.animateToPage(
        targetIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _pendingPage = null;
    } else {
      _pendingPage = targetPage;
      _schedulePendingPageApplication();
    }
  }

  void _completeKhetmeh() {
    final currentKhetmeh =
        getKhetmehPlans(_l).firstWhere((plan) => plan.id == _selectedKhetmehId);
    setState(() {
      _khetmehCompletionCounts[_selectedKhetmehId] =
          (_khetmehCompletionCounts[_selectedKhetmehId] ?? 0) + 1;
      _currentPage = currentKhetmeh.startPage;
    });
    _persistKhetmehCompletionCounts();
    _jumpToPageImmediately(_currentPage);
  }

  Future<void> _loadKhetmehProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final progress = prefs.getString(_khetmehProgressKey);
    if (progress != null) {
      setState(() {
        _khetmehProgress = (jsonDecode(progress) as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, (value as num).toInt()),
        );
      });
    }
  }

  Future<void> _persistKhetmehProgress() async {
    final prefs = await SharedPreferences.getInstance();
    _khetmehProgress[_selectedKhetmehId] = _currentPage;
    await prefs.setString(_khetmehProgressKey, jsonEncode(_khetmehProgress));
  }

  Future<void> _loadKhetmehCompletionCounts() async {
    final prefs = await SharedPreferences.getInstance();
    final counts = prefs.getString(_khetmehCompletionCountsKey);
    if (counts != null) {
      setState(() {
        _khetmehCompletionCounts =
            (jsonDecode(counts) as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, (value as num).toInt()),
        );
      });
    }
  }

  Future<void> _persistKhetmehCompletionCounts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _khetmehCompletionCountsKey, jsonEncode(_khetmehCompletionCounts));
  }

  Future<void> _loadSelectedKhetmeh() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedKhetmehId = prefs.getString(_selectedKhetmehKey);
    if (selectedKhetmehId != null) {
      setState(() {
        _selectedKhetmehId = selectedKhetmehId;
        _currentPage = _khetmehProgress[_selectedKhetmehId] ?? 1;
        _jumpToPageImmediately(_currentPage);
      });
    } else {
      setState(() {
        _selectedKhetmehId = 'plan5';
      });
    }
  }

  Future<void> _persistSelectedKhetmeh() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedKhetmehKey, _selectedKhetmehId);
  }

  Future<void> _loadReadingStats() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_statsStorageKey);
    if (data == null) return;
    // Decode the outer map
    final decodedOuter = jsonDecode(data) as Map<String, dynamic>;
    final Map<String, Map<String, int>> tempMap = {};
    decodedOuter.forEach((khetmehId, dailyCounts) {
      if (dailyCounts is Map) {
        tempMap[khetmehId] = (dailyCounts).map(
          (key, value) => MapEntry(key as String, (value as num).toInt()),
        );
      }
    });
    setState(() {
      _khetmehDailyReadingCounts = tempMap;
    });
  }

  Future<void> _persistReadingStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _statsStorageKey, jsonEncode(_khetmehDailyReadingCounts));
  }

  void _toggleChrome() {
    setState(() {
      _isBottomBarVisible = !_isBottomBarVisible;
    });
  }

  void _handlePageChanged(int index) {
    // Calculate actual page with wrapping
    final actualIndex = index % _totalPages;
    final updatedPage = actualIndex + 1;

    // Detect if we wrapped from page 604 to page 1 (moving forward)
    if (_currentPage == _totalPages && updatedPage == 1 && index > _currentPage - 1) {
      // User swiped forward from page 604 to page 1
      if (_selectedKhetmehId.isNotEmpty) {
        // Complete khetmeh if one is selected
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _completeKhetmeh();
        });
        return;
      }
    }

    setState(() {
      _currentPage = updatedPage;
    });
    _pageJumpController.text = updatedPage.toString();
    _recordReadingActivity();
    _persistKhetmehProgress();
  }

  void _handlePlanSelected(String planId) {
    setState(() {
      _selectedKhetmehId = planId;
      _currentPage = _khetmehProgress[planId] ?? 1;
      _jumpToPageImmediately(_currentPage);
      _tabIndex = 0;
    });
    _persistSelectedKhetmeh();
  }

  @override
  Widget build(BuildContext context) {
    _l = AppLocalizations.of(context)!;
    final bool showChrome = _tabIndex == 0 ? _isBottomBarVisible : true;
    final selectedKhetmehPlan = _selectedKhetmehId.isNotEmpty
        ? getKhetmehPlans(AppLocalizations.of(context)!)
            .firstWhere((plan) => plan.id == _selectedKhetmehId)
        : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: showChrome
            ? Theme.of(context).appBarTheme.backgroundColor
            : Colors.transparent,
        foregroundColor: showChrome
            ? Theme.of(context).appBarTheme.foregroundColor
            : Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: showChrome
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _tabIndex == 0
                        ? ' ${_currentSurahName ?? AppLocalizations.of(context)!.surah}'
                        : AppLocalizations.of(context)!.khetmeh,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  if (_tabIndex == 0 && selectedKhetmehPlan != null)
                    Text(
                      selectedKhetmehPlan.title,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.7),
                          ),
                    ),
                ],
              )
            : const SizedBox.shrink(),
        automaticallyImplyLeading: false,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _tabIndex == 0 ? _toggleChrome : null,
        child: switch (_tabIndex) {
          0 => _buildReaderTab(),
          1 => KhetmehTab(
              onPlanSelected: _handlePlanSelected,
              khetmehProgress: _khetmehProgress,
              khetmehDailyReadingCounts: _khetmehDailyReadingCounts,
              khetmehCompletionCounts: _khetmehCompletionCounts,
            ),
          2 => NavigateTab(
            selectedSurahNumber: _selectedSurahNumber,
            selectedJuzNumber: _selectedJuzNumber,
            onSurahChanged: (value) {
              setState(() => _selectedSurahNumber = value);
            },
            onJuzChanged: (value) {
              setState(() => _selectedJuzNumber = value);
            },
            onGoToSurah: _navigateToSurah,
            onGoToJuz: _navigateToJuz,
            onGoToPage: _navigateToPage,
            pageJumpController: _pageJumpController,
            totalPages: _totalPages,
          ),
          3 => StatsTab(
            dailyReadingCounts: _getDailyReadingCountsSum,
            weeklyAverage: _calculateWeeklyAverage().toStringAsFixed(1),
            totalAverage: _calculateTotalAverage().toStringAsFixed(1),
            allDailyReadingCounts: _khetmehDailyReadingCounts,
          ),
          _ => SettingsTab(
              onToggleLocale: widget.onToggleLocale,
              onToggleTheme: widget.onToggleTheme,
              isDarkMode: widget.isDarkMode,
              locale: widget.locale,
              onLocaleChanged: widget.onLocaleChanged,
            ),
        },
      ),
      bottomNavigationBar: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        removeTop: true,
        child: IgnorePointer(
          ignoring: !showChrome,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            offset: showChrome ? Offset.zero : const Offset(0, 1),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: showChrome ? 1.0 : 0.0,
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                selectedFontSize: 12,
                unselectedFontSize: 12,
                backgroundColor: Theme.of(context).colorScheme.surface,
                selectedItemColor: Theme.of(context).colorScheme.primary,
                unselectedItemColor: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
                currentIndex: _tabIndex,
                onTap: (index) {
                  if (index == _tabIndex) return;
                  setState(() {
                    _tabIndex = index;
                    if (_tabIndex != 0) {
                      _isBottomBarVisible = true;
                    }
                  });
                  if (index == 0) {
                    _jumpToPageImmediately(_currentPage);
                  }
                },
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.menu_book),
                    label: AppLocalizations.of(context)!.reader,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.auto_stories),
                    label: AppLocalizations.of(context)!.khetmeh,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.travel_explore),
                    label: AppLocalizations.of(context)!.navigate,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.query_stats),
                    label: AppLocalizations.of(context)!.statistics,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.settings_outlined),
                    label: AppLocalizations.of(context)!.settings,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReaderTab() {
    if (_pendingPage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _applyPendingPage();
      });
    }

    return ReaderTab(
      pageController: _pageController,
      totalPages: _totalPages,
      currentPage: _currentPage,
      pageAssetPath: _pageAssetPath,
      onPageChanged: _handlePageChanged,
      onNext: () => _goToPage(_currentPage + 1),
      onPrevious: () => _goToPage(_currentPage - 1),
      bottomBarVisible: _isBottomBarVisible,
      invertColors: widget.isDarkMode,
    );
  }

  void _navigateToSurah(int surahNumber) {
    final target = surahInfos.firstWhere(
      (surah) => surah.number == surahNumber,
    );
    _navigateToPage(target.page);
  }

  void _navigateToJuz(int juzNumber) {
    final target = juzInfos.firstWhere((juz) => juz.number == juzNumber);
    _navigateToPage(target.page);
  }

  void _navigateToPage(int page) {
    _goToPage(page);
    _switchToReaderTab();
  }

  void _switchToReaderTab() {
    if (_tabIndex == 0) return;
    setState(() {
      _tabIndex = 0;
    });
  }

  void _jumpToPageImmediately(int page) {
    if (_pageController.hasClients) {
      // Calculate the target index in the infinite scroll
      // We want to maintain the current "cycle" when jumping
      final currentIndex = _pageController.page?.round() ?? (_totalPages * 1000);
      final currentCycle = currentIndex ~/ _totalPages;
      final targetIndex = (currentCycle * _totalPages) + (page - 1);

      _pageController.jumpToPage(targetIndex);
      _pendingPage = null;
    } else {
      _pendingPage = page;
      _schedulePendingPageApplication();
    }
  }

  void _schedulePendingPageApplication() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _applyPendingPage();
    });
  }

  void _applyPendingPage() {
    if (_pendingPage == null || !_pageController.hasClients) {
      return;
    }
    // Calculate the target index in the infinite scroll
    final currentIndex = _pageController.page?.round() ?? (_totalPages * 1000);
    final currentCycle = currentIndex ~/ _totalPages;
    final targetIndex = (currentCycle * _totalPages) + (_pendingPage! - 1);

    _pageController.jumpToPage(targetIndex);
    _pendingPage = null;
  }

  void _recordReadingActivity() {
    if (_selectedKhetmehId.isEmpty) return; // Only record if a khetmeh is selected
    final today = _todayKey;
    _khetmehDailyReadingCounts.putIfAbsent(_selectedKhetmehId, () => {});
    final currentKhetmehTodayCounts =
        _khetmehDailyReadingCounts[_selectedKhetmehId]!;
    final updatedCount = (currentKhetmehTodayCounts[today] ?? 0) + 1;
    setState(() {
      currentKhetmehTodayCounts[today] = updatedCount;
    });
    _persistReadingStats();
  }

  String get _todayKey => DateTime.now().toIso8601String().split('T').first;

  int get _getDailyReadingCountsSum {
    final today = _todayKey;
    int total = 0;
    _khetmehDailyReadingCounts.forEach((khetmehTitle, dailyCounts) {
      total += (dailyCounts[today] ?? 0);
    });
    return total;
  }

  double _calculateWeeklyAverage() {
    if (_khetmehDailyReadingCounts.isEmpty) return 0;

    double total = 0;
    final today = DateTime.now();
    for (int i = 0; i < 7; i++) {
      final day = today.subtract(Duration(days: i));
      final key = day.toIso8601String().split('T').first;
      _khetmehDailyReadingCounts.forEach((khetmehTitle, dailyCounts) {
        total += (dailyCounts[key] ?? 0);
      });
    }
    return total / 7;
  }

  double _calculateTotalAverage() {
    if (_khetmehDailyReadingCounts.isEmpty) return 0;
    int totalPages = 0;
    int totalDays = 0;
    _khetmehDailyReadingCounts.forEach((khetmehTitle, dailyCounts) {
      dailyCounts.forEach((date, count) {
        totalPages += count;
        totalDays++;
      });
    });
    return totalDays > 0 ? totalPages / totalDays : 0;
  }

  String? get _currentSurahName {
    final locale = Localizations.localeOf(context);
    final match = surahInfos.lastWhere(
      (surah) => surah.page <= _currentPage,
      orElse: () => surahInfos.first,
    );
    return locale.languageCode == 'ar' ? match.nameAr : match.nameEn;
  }
}
