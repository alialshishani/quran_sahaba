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
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              // Calculate actual page number with wrapping
              final actualIndex = index % totalPages;
              final pageNumber = actualIndex + 1;
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
                    _arrowWithUnderline(
                      context: context,
                      icon: Icons.arrow_back,
                      onPressed: onNext,
                      showUnderline: currentPage.isEven,
                    ),
                    Text(currentPage.toString()),
                    _arrowWithUnderline(
                      context: context,
                      icon: Icons.arrow_forward,
                      onPressed: onPrevious,
                      showUnderline: currentPage.isOdd,
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
