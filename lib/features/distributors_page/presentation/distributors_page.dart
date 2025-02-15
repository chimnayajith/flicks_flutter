import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toys_catalogue/features/distributors_page/domain/models/contact_info.dart';
import 'package:toys_catalogue/features/distributors_page/domain/models/distributor.dart';
import 'package:toys_catalogue/features/distributors_page/presentation/widgets/ad_banner.dart';
import 'package:toys_catalogue/features/distributors_page/presentation/widgets/brand_card.dart';
import 'package:toys_catalogue/features/distributors_page/presentation/widgets/contact_card.dart';
import 'package:toys_catalogue/features/distributors_page/presentation/widgets/distributor_carousel.dart';
import 'package:toys_catalogue/resources/screen_util.dart';
import 'package:toys_catalogue/resources/theme.dart';
import 'package:toys_catalogue/routes/route_names.dart';

class DistributorsPage extends StatelessWidget {
  const DistributorsPage({super.key});

List<Distributor> _getDistributors() {
  final List<String> locations = [
    'Mumbai, Maharashtra',
    'Delhi, NCR',
    'Bangalore, Karnataka',
    'Chennai, Tamil Nadu',
    'Kolkata, West Bengal',
  ];
  
  final List<String> imageUrls = [
    'https://indian-retailer.s3.ap-south-1.amazonaws.com/s3fs-public/inline-images/Funskool.jpg',
    'https://img.freepik.com/free-vector/hand-drawn-toy-store-logo-template_23-2148659250.jpg',
    'https://img.freepik.com/free-vector/detailed-baby-logo-template_23-2148840544.jpg',
    'https://img.freepik.com/free-vector/flat-design-toy-store-logo-template_23-2149337169.jpg',
    'https://img.freepik.com/free-vector/gradient-baby-shop-logo-template_23-2149691517.jpg',
  ];
  
  return List.generate(
    5,
    (index) => Distributor(
      name: 'Distributor ${index + 1}',
      location: locations[index],
      imageUrl: imageUrls[index],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final distributors = _getDistributors();

    return Scaffold(
      backgroundColor: ColorsClass.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AdvertisementSpace(),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtils.w2(context),
                  vertical: ScreenUtils.h2(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Brands Onboard',
                      style: TextStylesClass.h5.copyWith(
                        color: ColorsClass.black,
                      ),
                    ),
                    SizedBox(height: ScreenUtils.h2(context)),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 16.h,
                        crossAxisSpacing: 16.w,
                        childAspectRatio: 1,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return BrandCard(
                          imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqANgMCdqITK6oeKGFOes3TsmKXqc1onmepg&s',
                          onTap: () {},
                        );
                      },
                    ),
                    SizedBox(height: ScreenUtils.h3(context)),
                    Text(
                      'Contact Information',
                      style: TextStylesClass.h5.copyWith(
                        color: ColorsClass.black,
                      ),
                    ),
                    SizedBox(height: ScreenUtils.h2(context)),
                    ContactCard(
                      contactInfo: ContactInfo(
                        name: 'Mr. Alex Carter',
                        phoneNumber: '+1 (555) 123-4567',
                        email: 'alex.carter@funplaytoys.com',
                        address: '123 Playland Avenue, Toyville, NY 10001, USA',
                      ),
                    ),
                    SizedBox(height: ScreenUtils.h3(context)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Nearby Distributors',
                          style: TextStylesClass.h5.copyWith(
                            color: ColorsClass.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, RouteNames.nearbyDistributorsPage);
                          },
                          child: Text(
                            'View All',
                            style: TextStylesClass.ctaLink.copyWith(
                              decoration: TextDecoration.none,
                              color: ColorsClass.secondaryTheme,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtils.h2(context)),
                    DistributorCarousel(distributors: distributors),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
