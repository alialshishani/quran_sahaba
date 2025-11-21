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
  static const String _selectedKhetmehKey = 'selected_khetmeh';
  static const String _statsStorageKey = 'reading_stats';
  late final PageController _pageController;
  final TextEditingController _pageJumpController = TextEditingController();
  int _currentPage = 1;
  int _tabIndex = 0;
  int _selectedSurahNumber = surahInfos.first.number;
  int _selectedJuzNumber = juzInfos.first.number;
  int? _pendingPage;
  bool _isBottomBarVisible = true;
  Map<String, int> _dailyReadingCounts = {};
  Map<String, int> _khetmehProgress = {};
  String _selectedKhetmeh = '';

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage - 1);
    _pageJumpController.text = _currentPage.toString();
    _loadKhetmehProgress();
    _loadSelectedKhetmeh();
    _loadReadingStats();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pageJumpController.dispose();
    super.dispose();
  }

  String _pageAssetPath(int page) => 'Quran-PNG-master/$page.jpg';

  void _goToPage(int page) {
    final targetPage = page.clamp(1, _totalPages);
    if (_currentPage != targetPage) {
      setState(() {
        _currentPage = targetPage;
      });
      _pageJumpController.text = targetPage.toString();
      _persistKhetmehProgress();
    }
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        targetPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _pendingPage = null;
    } else {
      _pendingPage = targetPage;
      _schedulePendingPageApplication();
    }
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
    _khetmehProgress[_selectedKhetmeh] = _currentPage;
    await prefs.setString(_khetmehProgressKey, jsonEncode(_khetmehProgress));
  }

  Future<void> _loadSelectedKhetmeh() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedKhetmeh = prefs.getString(_selectedKhetmehKey);
    if (selectedKhetmeh != null) {
      setState(() {
        _selectedKhetmeh = selectedKhetmeh;
        _currentPage = _khetmehProgress[_selectedKhetmeh] ?? 1;
        _jumpToPageImmediately(_currentPage);
      });
    }
  }

  Future<void> _persistSelectedKhetmeh() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedKhetmehKey, _selectedKhetmeh);
  }

  Future<void> _loadReadingStats() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_statsStorageKey);
    if (data == null) return;
    final decoded = (jsonDecode(data) as Map<String, dynamic>).map(
      (key, value) => MapEntry(key, (value as num).toInt()),
    );
    setState(() {
      _dailyReadingCounts = decoded;
    });
  }

  Future<void> _persistReadingStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_statsStorageKey, jsonEncode(_dailyReadingCounts));
  }

  void _toggleChrome() {
    setState(() {
      _isBottomBarVisible = !_isBottomBarVisible;
    });
  }

  void _handlePageChanged(int index) {
    final updatedPage = index + 1;
    setState(() {
      _currentPage = updatedPage;
    });
    _pageJumpController.text = updatedPage.toString();
    _recordReadingActivity();
    _persistKhetmehProgress();
  }

  void _handlePlanSelected(String planTitle) {
    setState(() {
      _selectedKhetmeh = planTitle;
      _currentPage = _khetmehProgress[planTitle] ?? 1;
      _jumpToPageImmediately(_currentPage);
      _tabIndex = 0;
    });
    _persistSelectedKhetmeh();
  }

  @override
  Widget build(BuildContext context) {
    final bool showChrome = _tabIndex == 0 ? _isBottomBarVisible : true;

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
            ? Text(
                _tabIndex == 0
                    ? ' ${_currentSurahName ?? AppLocalizations.of(context)!.surah}'
                    : AppLocalizations.of(context)!.khetmeh,
                style: Theme.of(context).textTheme.headlineMedium,
              )
            : const SizedBox.shrink(),
        automaticallyImplyLeading: false,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _tabIndex == 0 ? _toggleChrome : null,
        child: switch (_tabIndex) {
          0 => _buildReaderTab(),
          1 => KhetmehTab(onPlanSelected: _handlePlanSelected),
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
            dailyReadingCounts: _dailyReadingCounts,
            weeklyAverage: _calculateWeeklyAverage().toStringAsFixed(1),
            totalAverage: _calculateTotalAverage().toStringAsFixed(1),
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
      _pageController.jumpToPage(page - 1);
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
    _pageController.jumpToPage(_pendingPage! - 1);
    _pendingPage = null;
  }

  void _recordReadingActivity() {
    final today = _todayKey;
    final updatedCount = (_dailyReadingCounts[today] ?? 0) + 1;
    setState(() {
      _dailyReadingCounts = {..._dailyReadingCounts, today: updatedCount};
    });
    _persistReadingStats();
  }

  String get _todayKey => DateTime.now().toIso8601String().split('T').first;

  double _calculateWeeklyAverage() {
    final today = DateTime.now();
    double total = 0;
    for (int i = 0; i < 7; i++) {
      final day = today.subtract(Duration(days: i));
      final key = day.toIso8601String().split('T').first;
      total += (_dailyReadingCounts[key] ?? 0);
    }
    return total / 7;
  }

  double _calculateTotalAverage() {
    if (_dailyReadingCounts.isEmpty) return 0;
    final totalPages = _dailyReadingCounts.values.fold<int>(
      0,
      (sum, value) => sum + value,
    );
    return totalPages / _dailyReadingCounts.length;
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
