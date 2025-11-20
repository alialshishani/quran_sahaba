import 'package:flutter/material.dart';

class ReaderTab extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: PageView.builder(
            controller: pageController,
            reverse: true,
            itemCount: totalPages,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              final pageNumber = index + 1;
              return InteractiveViewer(
                child: Center(
                  child: invertColors
                      ? ColorFiltered(
                          colorFilter: const ColorFilter.matrix([
                            -1, 0, 0, 0, 255, //
                            0, -1, 0, 0, 255, //
                            0, 0, -1, 0, 255, //
                            0, 0, 0, 1, 0, //
                          ]),
                          child: Image.asset(
                            pageAssetPath(pageNumber),
                            fit: BoxFit.contain,
                          ),
                        )
                      : Image.asset(
                          pageAssetPath(pageNumber),
                          fit: BoxFit.contain,
                        ),
                ),
              );
            },
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Opacity(
            opacity: bottomBarVisible ? 1.0 : 0.0,
            child: IgnorePointer(
              ignoring: !bottomBarVisible,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: onNext,
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Text(currentPage.toString()),
                    IconButton(
                      onPressed: onPrevious,
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
