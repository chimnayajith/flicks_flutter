import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class MainPageView extends ConsumerWidget {
  final PageController pageController = PageController(initialPage: 0);

  MainPageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: const [
        ],
        onPageChanged: (index) {
          
        },
      ),
    );
  }
}
