import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toys_catalogue/resources/theme.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CustomCard({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 17.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: ColorsClass.primaryTheme,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: ColorsClass.secondaryTheme),
            
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStylesClass.p1,
                
              ),
              const Icon(Icons.arrow_forward_ios_sharp, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
