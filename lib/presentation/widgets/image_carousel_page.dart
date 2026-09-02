import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:weeksalive/core/styles/margins.dart';
import 'package:weeksalive/core/styles/text_styles.dart';

class ImageCarouselPage extends StatefulWidget {
  const ImageCarouselPage({
    super.key,
    required this.imagePaths,
    this.initialIndex = 0,
  });

  final List<String> imagePaths;
  final int initialIndex;

  static Future<void> show(
    BuildContext context, {
    required List<String> imagePaths,
    int initialIndex = 0,
  }) {
    return Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => ImageCarouselPage(
          imagePaths: imagePaths,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  @override
  State<ImageCarouselPage> createState() => _ImageCarouselPageState();
}

class _ImageCarouselPageState extends State<ImageCarouselPage> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.imagePaths.length - 1);
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imagePaths.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              return Center(
                child: InteractiveViewer(
                  child: Image.file(
                    File(widget.imagePaths[index]),
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  MingCuteIcons.mgc_close_line,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          if (widget.imagePaths.length > 1)
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: Margins.spacingM),
                  child: Text(
                    '${_currentIndex + 1} / ${widget.imagePaths.length}',
                    style: TextStyles.primaryMediumMedium.copyWith(color: Colors.white70),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
