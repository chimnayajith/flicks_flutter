import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toys_catalogue/resources/theme.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback onTap;

  const CustomCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: ColorsClass.primaryTheme,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: ColorsClass.secondaryTheme),
            boxShadow: [
              BoxShadow(
                color: ColorsClass.boxShadow,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon if provided
              if (icon != null) ...[
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: ColorsClass.secondaryTheme.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    icon,
                    color: ColorsClass.secondaryTheme,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 16.w),
              ],
              
              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStylesClass.p1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        subtitle!,
                        style: TextStylesClass.p2.copyWith(
                          color: ColorsClass.textGrey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              
              // Arrow icon
              Icon(
                Icons.arrow_forward_ios_sharp, 
                size: 16.sp,
                color: ColorsClass.secondaryTheme,
              ),
            ],
          ),
        ),
      ),
    );
  }
}