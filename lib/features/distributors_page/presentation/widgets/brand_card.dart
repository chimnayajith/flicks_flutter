import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toys_catalogue/resources/theme.dart';

class BrandCard extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;

  const BrandCard({super.key, required this.imageUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: ColorsClass.boxShadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            // border: Border.all(
            //   color: ColorsClass.secondaryTheme,
            //   width: 1,
            // ),
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [ColorsClass.white, ColorsClass.lightmodeNeutral100],
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: ColorsClass.lightmodeNeutral100,
                  child: Center(
                    child: Icon(
                      Icons.image,
                      color: ColorsClass.lightmodeNeutral500,
                      size: 24.sp,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
