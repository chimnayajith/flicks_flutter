import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toys_catalogue/features/distributors_page/domain/models/distributor.dart';
import 'package:toys_catalogue/features/distributors_page/presentation/widgets/carousel_distributer_card.dart';
import 'package:toys_catalogue/resources/theme.dart';

class DistributorCarousel extends StatefulWidget {
  final List<Distributor> distributors;

  const DistributorCarousel({super.key, required this.distributors});

  @override
  State<DistributorCarousel> createState() => _DistributorCarouselState();
}

class _DistributorCarouselState extends State<DistributorCarousel> {
  late final PageController _pageController;
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.7, initialPage: 0);
    _pageController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _pageController.removeListener(_onScroll);
    _pageController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _currentPage = _pageController.page ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.distributors.length,
            itemBuilder: (context, index) {
              final double difference = index - _currentPage;
              final double scale = 1 - (difference.abs() * 0.1).clamp(0.0, 0.4);
              final double opacity =
                  1 - (difference.abs() * 0.5).clamp(0.0, 0.5);

              return CarouselDistributorCard(
                distributor: widget.distributors[index],
                scale: scale,
                opacity: opacity,
              );
            },
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.distributors.length,
            (index) => Container(
              width: 8.w,
              height: 8.h,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    index == _currentPage.round()
                        ? ColorsClass.secondaryTheme
                        : ColorsClass.textGrey1.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
