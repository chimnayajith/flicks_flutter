import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toys_catalogue/features/products/domain/models/product_model.dart';
import 'package:toys_catalogue/features/products/presentation/widgets/expandable_section.dart';
import 'package:toys_catalogue/resources/theme.dart';

class ProductExpandableDetails extends StatelessWidget {
  final Product product;

  const ProductExpandableDetails({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        ExpandableSection(
          title: 'Top highlights',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: product.highlights.map((highlight) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: ColorsClass.themeGreen,
                      size: 16.w,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        highlight,
                        style: TextStylesClass.p1,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        ExpandableSection(
          title: 'Product specifications',
          content: Column(
            children: product.specifications.entries.map((spec) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        spec.key,
                        style: TextStylesClass.p2,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        spec.value,
                        style: TextStylesClass.p1,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        ExpandableSection(
          title: 'About the Brand',
          content: Text(
            product.brandDescription,
            style: TextStylesClass.p1,
          ),
        ),
        ExpandableSection(
          title: 'About the Distributer',
          content: Text(
            product.distributerDescription,
            style: TextStylesClass.p1,
          ),
        ),

      ],
    );
  }
}