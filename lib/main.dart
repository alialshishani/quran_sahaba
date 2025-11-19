import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quran Image Viewer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 67, 9, 85),
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
  late final PageController _pageController;
  int _currentPage = 1;
  int _tabIndex = 0;
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

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage - 1);
    _loadCurrentPage();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _pageAssetPath(int page) => 'Quran-PNG-master/$page.jpg';

  void _goToPage(int page) {
    final targetPage = page.clamp(1, _totalPages);
    _pageController.animateToPage(
      targetPage - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _loadCurrentPage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPage = prefs.getInt(_storageKey);
    if (savedPage != null && savedPage != _currentPage) {
      setState(() {
        _currentPage = savedPage;
      });
      _pageController.jumpToPage(savedPage - 1);
    }
  }

  Future<void> _persistCurrentPage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_storageKey, page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Quran PNG Viewer'),
      ),
      body: switch (_tabIndex) {
        0 => _buildReaderTab(),
        1 => _buildKhetmehTab(),
        _ => _buildAboutTab(),
      },
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (index) {
          setState(() {
            _tabIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Reader'),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories),
            label: 'Khetmeh',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'About',
          ),
        ],
      ),
    );
  }

  Widget _buildReaderTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            'Page $_currentPage / $_totalPages',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            reverse: true, // right-to-left page order
            itemCount: _totalPages,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index + 1;
              });
              _persistCurrentPage(_currentPage);
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
            leading: CircleAvatar(
              child: Text('${index + 1}'),
            ),
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
