import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toys_catalogue/resources/theme.dart';

class AdvertisementSpace extends StatelessWidget {
  final String? bannerUrl;

  const AdvertisementSpace({Key? key, this.bannerUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.h,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: ColorsClass.secondaryTheme.withOpacity(0.1),
        image: bannerUrl != null
            ? DecorationImage(
                image: NetworkImage(bannerUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: bannerUrl == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.store,
                    size: 40.w,
                    color: ColorsClass.secondaryTheme,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Your Shop",
                    style: TextStylesClass.s1.copyWith(
                      color: ColorsClass.secondaryTheme,
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}