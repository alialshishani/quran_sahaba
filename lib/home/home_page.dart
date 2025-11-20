import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quran_data.dart';
import 'tabs/about_tab.dart';
import 'tabs/khetmeh_tab.dart';
import 'tabs/navigate_tab.dart';
import 'tabs/reader_tab.dart';
import 'tabs/stats_tab.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const int _totalPages = 604;
  static const String _storageKey = 'current_page';
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

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage - 1);
    _pageJumpController.text = _currentPage.toString();
    _loadCurrentPage();
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
      _persistCurrentPage(targetPage);
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

  Future<void> _loadCurrentPage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPage = prefs.getInt(_storageKey);
    if (savedPage != null && savedPage != _currentPage) {
      setState(() {
        _currentPage = savedPage;
      });
      _pageJumpController.text = savedPage.toString();
      _jumpToPageImmediately(savedPage);
    }
  }

  Future<void> _persistCurrentPage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_storageKey, page);
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

  void _handlePageChanged(int index) {
    final updatedPage = index + 1;
    setState(() {
      _currentPage = updatedPage;
    });
    _pageJumpController.text = updatedPage.toString();
    _recordReadingActivity();
    _persistCurrentPage(updatedPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          setState(() {
            _isBottomBarVisible = !_isBottomBarVisible;
          });
        },
        child: switch (_tabIndex) {
          0 => _buildReaderTab(),
          1 => KhetmehTab(plans: khetmehPlans),
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
          _ => const AboutTab(),
        },
      ),
      bottomNavigationBar: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        removeTop: true,
        child: IgnorePointer(
          ignoring: !_isBottomBarVisible,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            offset: _isBottomBarVisible ? Offset.zero : const Offset(0, 1),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _isBottomBarVisible ? 1.0 : 0.0,
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
                  });
                  if (index == 0) {
                    _jumpToPageImmediately(_currentPage);
                  }
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.menu_book),
                    label: 'Reader',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.auto_stories),
                    label: 'Khetmeh',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.travel_explore),
                    label: 'Navigate',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.query_stats),
                    label: 'Statistics',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.info_outline),
                    label: 'About',
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
}
