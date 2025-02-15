import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toys_catalogue/resources/theme.dart';

class AdvertisementSpace extends StatelessWidget {
  const AdvertisementSpace({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180.h,
      decoration: BoxDecoration(
        color: ColorsClass.lightmodeNeutral100,
        boxShadow: [
          BoxShadow(
            color: ColorsClass.boxShadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Image.network(
        'https://sharonsree.wordpress.com/wp-content/uploads/2013/11/hamleys-logo-1-cmyk-300dpi.jpg?w=598',
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              color: ColorsClass.secondaryTheme,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported,
                  color: ColorsClass.lightmodeNeutral500,
                  size: 36,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Could not load banner image',
                  style: TextStylesClass.p1.copyWith(
                    color: ColorsClass.lightmodeNeutral500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}