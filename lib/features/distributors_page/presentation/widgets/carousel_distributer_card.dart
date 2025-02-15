import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toys_catalogue/features/distributors_page/domain/models/distributor.dart';
import 'package:toys_catalogue/features/distributors_page/presentation/widgets/distributor_card.dart';

class CarouselDistributorCard extends StatelessWidget {
  final Distributor distributor;
  final double scale;
  final double opacity;

  const CarouselDistributorCard({
    super.key,
    required this.distributor,
    required this.scale,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: 220.w,
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          child: DistributorCard(distributor: distributor),
        ),
      ),
    );
  }
}
