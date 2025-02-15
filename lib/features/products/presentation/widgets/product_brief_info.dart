import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toys_catalogue/features/products/domain/models/product_model.dart';
import 'package:toys_catalogue/resources/theme.dart';

class ProductBriefInfo extends StatelessWidget {
  final Product product;

  const ProductBriefInfo({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: TextStylesClass.customize(
              TextStylesClass.h4,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          // Row(
          //   children: [
          //     Container(
          //       padding: EdgeInsets.symmetric(
          //         horizontal: 8.w,
          //         vertical: 4.h,
          //       ),
          //       decoration: BoxDecoration(
          //         color: ColorsClass.themeGreen.withOpacity(0.1),
          //         borderRadius: BorderRadius.circular(6.r),
          //       ),
          //       child: Row(
          //         children: [
          //           Icon(
          //             Icons.star,
          //             size: 16.w,
          //             color: ColorsClass.themeGreen,
          //           ),
          //           SizedBox(width: 4.w),
          //           Text(
          //             '4.5',
          //             style: TextStylesClass.customize(
          //               TextStylesClass.p2,
          //               color: ColorsClass.themeGreen,
          //               fontWeight: FontWeight.w600,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //     SizedBox(width: 12.w),
          //     Text(
          //       '1,234 Reviews',
          //       style: TextStylesClass.customize(
          //         TextStylesClass.p2,
          //         color: ColorsClass.textGrey2,
          //       ),
          //     ),
          //   ],
          // ),
          Text(
            '₹${product.price.toStringAsFixed(2)}',
            style: TextStylesClass.customize(
              TextStylesClass.h6,
              color: ColorsClass.secondaryTheme,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(height: 16.h),
          Text(
            product.description,
            style: TextStylesClass.customize(
              TextStylesClass.p1,
              color: ColorsClass.textGrey1,
              
            ),
          ),
        ],
      ),
    );
  }
}