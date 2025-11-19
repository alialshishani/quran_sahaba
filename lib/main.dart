import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.white,
        brightness: Brightness.light,
      ),
    );
    return MaterialApp(
      title: 'Quran Image Viewer',
      theme: baseTheme.copyWith(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: baseTheme.colorScheme.copyWith(
          primary: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
          inversePrimary: Colors.black87,
        ),
        appBarTheme: baseTheme.appBarTheme.copyWith(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

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
  int _selectedSurahNumber = 1;
  int _selectedJuzNumber = 1;
  int? _pendingPage;
  Map<String, int> _dailyReadingCounts = {};
  final List<_KhetmehPlan> _khetmehPlans = const [
    _KhetmehPlan(
      title: '30 Days',
      subtitle: '1 juz per day',
      rangeDescription: 'Pages 1-604',
    ),
    _KhetmehPlan(
      title: '15 Days',
      subtitle: '2 juz per day',
      rangeDescription: 'Pages 1-604 split in half',
    ),
    _KhetmehPlan(
      title: 'Weekly',
      subtitle: '~4 juz per day',
      rangeDescription: 'Finish every Friday',
    ),
    _KhetmehPlan(
      title: 'Weekend Focus',
      subtitle: 'Juz 1-15 Sat, 16-30 Sun',
      rangeDescription: 'Pages 1-302 then 303-604',
    ),
  ];
  static const List<_SurahInfo> _surahInfos = [
    _SurahInfo(number: 1, name: "Al-Fatiha", page: 1),
    _SurahInfo(number: 2, name: "Al-Baqara", page: 2),
    _SurahInfo(number: 3, name: "Aal-Imran", page: 45),
    _SurahInfo(number: 4, name: "An-Nisaa'", page: 69),
    _SurahInfo(number: 5, name: "Al-Ma'ida", page: 95),
    _SurahInfo(number: 6, name: "Al-An'am", page: 115),
    _SurahInfo(number: 7, name: "Al-A'raf", page: 136),
    _SurahInfo(number: 8, name: "Al-Anfal", page: 160),
    _SurahInfo(number: 9, name: "Al-Tawba", page: 169),
    _SurahInfo(number: 10, name: "Yunus", page: 187),
    _SurahInfo(number: 11, name: "Hud", page: 199),
    _SurahInfo(number: 12, name: "Yusuf", page: 212),
    _SurahInfo(number: 13, name: "Ar-Ra'd", page: 225),
    _SurahInfo(number: 14, name: "Ibrahim", page: 231),
    _SurahInfo(number: 15, name: "Al-Hijr", page: 237),
    _SurahInfo(number: 16, name: "An-Nahl", page: 242),
    _SurahInfo(number: 17, name: "Al-Israa", page: 255),
    _SurahInfo(number: 18, name: "Al-Kahf", page: 266),
    _SurahInfo(number: 19, name: "Maryam", page: 277),
    _SurahInfo(number: 20, name: "Ta-Ha", page: 284),
    _SurahInfo(number: 21, name: "Al-Anbiya", page: 294),
    _SurahInfo(number: 22, name: "Al-Hajj", page: 302),
    _SurahInfo(number: 23, name: "Al-Muminun", page: 311),
    _SurahInfo(number: 24, name: "An-Nur", page: 319),
    _SurahInfo(number: 25, name: "Al-Furqan", page: 329),
    _SurahInfo(number: 26, name: "Ash-Shuara", page: 335),
    _SurahInfo(number: 27, name: "An-Naml", page: 345),
    _SurahInfo(number: 28, name: "Al-Qasas", page: 354),
    _SurahInfo(number: 29, name: "Al-Ankabut", page: 364),
    _SurahInfo(number: 30, name: "Ar-Rum", page: 371),
    _SurahInfo(number: 31, name: "Luqman", page: 377),
    _SurahInfo(number: 32, name: "As-Sajdah", page: 381),
    _SurahInfo(number: 33, name: "Al-Ahzab", page: 383),
    _SurahInfo(number: 34, name: "Saba", page: 393),
    _SurahInfo(number: 35, name: "Fatir", page: 399),
    _SurahInfo(number: 36, name: "Yasin", page: 404),
    _SurahInfo(number: 37, name: "As-Saffat", page: 410),
    _SurahInfo(number: 38, name: "Sad", page: 417),
    _SurahInfo(number: 39, name: "Az-Zumar", page: 422),
    _SurahInfo(number: 40, name: "Ghafir", page: 431),
    _SurahInfo(number: 41, name: "Fussilat", page: 439),
    _SurahInfo(number: 42, name: "Ash-Shura", page: 445),
    _SurahInfo(number: 43, name: "Az-Zukhruf", page: 451),
    _SurahInfo(number: 44, name: "Ad-Dukhan", page: 457),
    _SurahInfo(number: 45, name: "Al-Jathiya", page: 460),
    _SurahInfo(number: 46, name: "Al-Ahqaf", page: 464),
    _SurahInfo(number: 47, name: "Muhammad", page: 468),
    _SurahInfo(number: 48, name: "Al-Fath", page: 472),
    _SurahInfo(number: 49, name: "Al-Hujurat", page: 477),
    _SurahInfo(number: 50, name: "Qaf", page: 479),
    _SurahInfo(number: 51, name: "Az-Zariyat", page: 482),
    _SurahInfo(number: 52, name: "At-Tur", page: 485),
    _SurahInfo(number: 53, name: "An-Najm", page: 487),
    _SurahInfo(number: 54, name: "Al-Qamar", page: 490),
    _SurahInfo(number: 55, name: "Ar-Rahman", page: 493),
    _SurahInfo(number: 56, name: "Al-Waqia", page: 496),
    _SurahInfo(number: 57, name: "Al-Hadid", page: 499),
    _SurahInfo(number: 58, name: "Al-Mujadilah", page: 504),
    _SurahInfo(number: 59, name: "Al-Hashr", page: 507),
    _SurahInfo(number: 60, name: "Al-Mumtahinah", page: 510),
    _SurahInfo(number: 61, name: "As-Saff", page: 513),
    _SurahInfo(number: 62, name: "Al-Jumu'ah", page: 515),
    _SurahInfo(number: 63, name: "Al-Munafiqun", page: 516),
    _SurahInfo(number: 64, name: "At-Taghabun", page: 518),
    _SurahInfo(number: 65, name: "At-Talaq", page: 520),
    _SurahInfo(number: 66, name: "At-Tahrim", page: 522),
    _SurahInfo(number: 67, name: "Al-Mulk", page: 524),
    _SurahInfo(number: 68, name: "Al-Qalam", page: 526),
    _SurahInfo(number: 69, name: "Al-Haqqah", page: 529),
    _SurahInfo(number: 70, name: "Al-Ma'arij", page: 531),
    _SurahInfo(number: 71, name: "Nuh", page: 533),
    _SurahInfo(number: 72, name: "Al-Jinn", page: 534),
    _SurahInfo(number: 73, name: "Al-Muzzammil", page: 537),
    _SurahInfo(number: 74, name: "Al-Muddaththir", page: 538),
    _SurahInfo(number: 75, name: "Al-Qiyamah", page: 540),
    _SurahInfo(number: 76, name: "Al-Insan", page: 542),
    _SurahInfo(number: 77, name: "Al-Mursalat", page: 544),
    _SurahInfo(number: 78, name: "An-Naba", page: 545),
    _SurahInfo(number: 79, name: "An-Naziat", page: 547),
    _SurahInfo(number: 80, name: "Abasa", page: 548),
    _SurahInfo(number: 81, name: "At-Takwir", page: 550),
    _SurahInfo(number: 82, name: "Al-Infitar", page: 551),
    _SurahInfo(number: 83, name: "Al-Mutaffifin", page: 552),
    _SurahInfo(number: 84, name: "Al-Inshiqaq", page: 553),
    _SurahInfo(number: 85, name: "Al-Buruj", page: 554),
    _SurahInfo(number: 86, name: "At-Tariq", page: 555),
    _SurahInfo(number: 87, name: "Al-Ala", page: 556),
    _SurahInfo(number: 88, name: "Al-Ghashiyah", page: 556),
    _SurahInfo(number: 89, name: "Al-Fajr", page: 557),
    _SurahInfo(number: 90, name: "Al-Balad", page: 559),
    _SurahInfo(number: 91, name: "Ash-Shams", page: 559),
    _SurahInfo(number: 92, name: "Al-Lail", page: 560),
    _SurahInfo(number: 93, name: "Ad-Duha", page: 561),
    _SurahInfo(number: 94, name: "Ash-Sharh", page: 561),
    _SurahInfo(number: 95, name: "At-Tin", page: 562),
    _SurahInfo(number: 96, name: "Al-Alaq", page: 562),
    _SurahInfo(number: 97, name: "Al-Qadr", page: 563),
    _SurahInfo(number: 98, name: "Al-Bayinah", page: 563),
    _SurahInfo(number: 99, name: "Az-Zalzalah", page: 564),
    _SurahInfo(number: 100, name: "Al-Adiyat", page: 564),
    _SurahInfo(number: 101, name: "Al-Qariah", page: 565),
    _SurahInfo(number: 102, name: "Al-Takathur", page: 565),
    _SurahInfo(number: 103, name: "Al-Asr", page: 566),
    _SurahInfo(number: 104, name: "Al-Humazah", page: 566),
    _SurahInfo(number: 105, name: "Al-Fil", page: 566),
    _SurahInfo(number: 106, name: "Quraish", page: 567),
    _SurahInfo(number: 107, name: "Al-Ma'un", page: 567),
    _SurahInfo(number: 108, name: "Al-Kauthar", page: 567),
    _SurahInfo(number: 109, name: "Al-Kafirun", page: 568),
    _SurahInfo(number: 110, name: "An-Nasr", page: 568),
    _SurahInfo(number: 111, name: "Al-Masad", page: 568),
    _SurahInfo(number: 112, name: "Al-Ikhlas", page: 569),
    _SurahInfo(number: 113, name: "Al-Falaq", page: 569),
    _SurahInfo(number: 114, name: "An-Nas", page: 569),
  ];
  static const List<_JuzInfo> _juzInfos = [
    _JuzInfo(number: 1, page: 1),
    _JuzInfo(number: 2, page: 22),
    _JuzInfo(number: 3, page: 42),
    _JuzInfo(number: 4, page: 62),
    _JuzInfo(number: 5, page: 82),
    _JuzInfo(number: 6, page: 102),
    _JuzInfo(number: 7, page: 121),
    _JuzInfo(number: 8, page: 142),
    _JuzInfo(number: 9, page: 162),
    _JuzInfo(number: 10, page: 182),
    _JuzInfo(number: 11, page: 201),
    _JuzInfo(number: 12, page: 222),
    _JuzInfo(number: 13, page: 242),
    _JuzInfo(number: 14, page: 262),
    _JuzInfo(number: 15, page: 282),
    _JuzInfo(number: 16, page: 302),
    _JuzInfo(number: 17, page: 322),
    _JuzInfo(number: 18, page: 342),
    _JuzInfo(number: 19, page: 362),
    _JuzInfo(number: 20, page: 382),
    _JuzInfo(number: 21, page: 402),
    _JuzInfo(number: 22, page: 422),
    _JuzInfo(number: 23, page: 442),
    _JuzInfo(number: 24, page: 462),
    _JuzInfo(number: 25, page: 482),
    _JuzInfo(number: 26, page: 502),
    _JuzInfo(number: 27, page: 522),
    _JuzInfo(number: 28, page: 542),
    _JuzInfo(number: 29, page: 562),
    _JuzInfo(number: 30, page: 582),
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // title: const Text('Quran PNG Viewer'),
      ),
      body: switch (_tabIndex) {
        0 => _buildReaderTab(),
        1 => _buildKhetmehTab(),
        2 => _buildStatsTab(),
        3 => _buildAboutTab(),
        _ => _buildNavigateTab(),
      },
      bottomNavigationBar: BottomNavigationBar(
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
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Reader'),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories),
            label: 'Khetmeh',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.query_stats),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'About',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.travel_explore),
            label: 'Navigate',
          ),
        ],
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
    return Column(
      children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 12.0),
        //   child: Text(
        //     'Page $_currentPage / $_totalPages',
        //     style: Theme.of(context).textTheme.titleMedium,
        //   ),
        // ),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            reverse: true, // right-to-left page order
            itemCount: _totalPages,
            onPageChanged: (index) {
              final updatedPage = index + 1;
              setState(() {
                _currentPage = updatedPage;
              });
              _pageJumpController.text = updatedPage.toString();
              _recordReadingActivity();
              _persistCurrentPage(updatedPage);
            },
            itemBuilder: (context, index) {
              final pageNumber = index + 1;
              return InteractiveViewer(
                child: Center(
                  child: Image.asset(
                    _pageAssetPath(pageNumber),
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => _goToPage(_currentPage + 1),
                icon: const Icon(Icons.arrow_back),
              ),
              Text(_currentPage.toString()),
              IconButton(
                onPressed: () => _goToPage(_currentPage - 1),
                icon: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          'Swipe through the Quran PNG pages using the Reader tab.\n'
          'Use the arrows or tabs at the bottom to navigate.',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildKhetmehTab() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final plan = _khetmehPlans[index];
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
      itemCount: _khetmehPlans.length,
    );
  }

  Widget _buildStatsTab() {
    final entries = _dailyReadingCounts.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));
    final weeklyAverage = _calculateWeeklyAverage().toStringAsFixed(1);
    final totalAverage = _calculateTotalAverage().toStringAsFixed(1);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            title: const Text('Pages read today'),
            trailing: Text(
              '${_dailyReadingCounts[_todayKey] ?? 0}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
        Card(
          child: ListTile(
            title: const Text('Average pages per day (last 7 days)'),
            trailing: Text(
              weeklyAverage,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
        Card(
          child: ListTile(
            title: const Text('Overall daily average'),
            trailing: Text(
              totalAverage,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('Recent activity', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        ...entries
            .take(14)
            .map(
              (entry) => Card(
                child: ListTile(
                  title: Text(entry.key),
                  trailing: Text('${entry.value} pages'),
                ),
              ),
            ),
        if (entries.isEmpty)
          const Text(
            'No reading activity recorded yet. Start reading to see stats!',
          ),
      ],
    );
  }

  Widget _buildNavigateTab() {
    final selectedSurah = _surahInfos.firstWhere(
      (surah) => surah.number == _selectedSurahNumber,
    );
    final selectedJuz = _juzInfos.firstWhere(
      (juz) => juz.number == _selectedJuzNumber,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _navigationCard(
          title: 'Navigate by Surah',
          children: [
            DropdownButton<int>(
              isExpanded: true,
              value: _selectedSurahNumber,
              items: _surahInfos
                  .map(
                    (surah) => DropdownMenuItem(
                      value: surah.number,
                      child: Text('${surah.number}. ${surah.name}'),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _selectedSurahNumber = value;
                });
              },
            ),
            Text('Starts on page ${selectedSurah.page}'),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => _navigateToSurah(selectedSurah.number),
                child: const Text('Go to Surah'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _navigationCard(
          title: 'Navigate by Juz',
          children: [
            DropdownButton<int>(
              isExpanded: true,
              value: _selectedJuzNumber,
              items: _juzInfos
                  .map(
                    (juz) => DropdownMenuItem(
                      value: juz.number,
                      child: Text('Juz ${juz.number} (page ${juz.page})'),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _selectedJuzNumber = value;
                });
              },
            ),
            Text('Starts on page ${selectedJuz.page}'),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => _navigateToJuz(selectedJuz.number),
                child: const Text('Go to Juz'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _navigationCard(
          title: 'Navigate by Page',
          children: [
            TextField(
              controller: _pageJumpController,
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
                  final value = int.tryParse(_pageJumpController.text.trim());
                  if (value == null || value < 1 || value > _totalPages) {
                    _showInvalidPageSnackBar(context);
                    return;
                  }
                  _navigateToPage(value);
                },
                child: const Text('Go to Page'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _navigationCard({
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

  void _navigateToSurah(int surahNumber) {
    final target = _surahInfos.firstWhere(
      (surah) => surah.number == surahNumber,
    );
    _navigateToPage(target.page);
  }

  void _navigateToJuz(int juzNumber) {
    final target = _juzInfos.firstWhere((juz) => juz.number == juzNumber);
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

  void _showInvalidPageSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please enter a valid page between 1 and $_totalPages.'),
      ),
    );
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

class _KhetmehPlan {
  final String title;
  final String subtitle;
  final String rangeDescription;

  const _KhetmehPlan({
    required this.title,
    required this.subtitle,
    required this.rangeDescription,
  });
}

class _SurahInfo {
  final int number;
  final String name;
  final int page;

  const _SurahInfo({
    required this.number,
    required this.name,
    required this.page,
  });
}

class _JuzInfo {
  final int number;
  final int page;

  const _JuzInfo({required this.number, required this.page});
}
