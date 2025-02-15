import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toys_catalogue/features/distributors_page/domain/models/distributor.dart';
import 'package:toys_catalogue/resources/theme.dart';

class DistributorCard extends StatelessWidget {
  final Distributor distributor;

  const DistributorCard({super.key, required this.distributor});

  @override
  Widget build(BuildContext context) {
    // Use actual network image URLs for each distributor
    final String imageUrl = _getDistributorImage(distributor.name);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Image.network(
            imageUrl,
            height: 120.h,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 120.h,
                color: ColorsClass.lightmodeNeutral100,
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    color: ColorsClass.secondaryTheme,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 120.h,
                color: ColorsClass.lightmodeNeutral100,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_not_supported,
                        color: ColorsClass.lightmodeNeutral500,
                        size: 24.sp,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Image not available',
                        style: TextStylesClass.p2.copyWith(
                          color: ColorsClass.lightmodeNeutral500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                distributor.name,
                style: TextStylesClass.s2.copyWith(
                  color: ColorsClass.textGrey1,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                distributor.location,
                style: TextStylesClass.p2.copyWith(
                  color: ColorsClass.textGrey2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  

  String _getDistributorImage(String distributorName) {
    final Map<String, String> imageUrls = {
      'Distributor 1': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcREEU4y6gYZWhE_myv2K2GoFVj4W4lrCHr_P0FHde6IbFAbi2LYZpyL2vSHkVAgPZt3qFc&usqp=CAU',
      'Distributor 2': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ5pzWCvVp7oDi79SOWhFSusZVMsEgqxVjcbnVhfCptst4VY12KUM9knlJuQkfdBF-DtXc&usqp=CAU',
      'Distributor 3': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKN1p0KSHoTxgof0zOT0t8nPY_8kKRikvhbne58Ltv5q2PzcbtWXx0pDns__oY3gA9Wug&usqp=CAU',
      'Distributor 4': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR0t085u_f4e6dtwBRZEo5nPK06CwW2eb0ORTTFbKdrEtDsGGWgrhZLtG1_MV9j_Q0bE-8&usqp=CAU',
      'Distributor 5': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTzndT0YH4pFuBSyMoOUTAXrkMlRu5rOEI7KFxwcyPxnQPw0IqR8_RSsDCozFSRpRnxmk&usqp=CAU',
    };
    
    return imageUrls[distributorName] ?? 
        'https://img.freepik.com/free-vector/hand-drawn-kids-toys-facebook-post_23-2149614434.jpg';
  }
}