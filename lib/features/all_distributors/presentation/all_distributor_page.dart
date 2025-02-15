import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toys_catalogue/features/brands/domain/models/brand.dart';
import 'package:toys_catalogue/features/brands/domain/models/category.dart';
import 'package:toys_catalogue/features/brands/presentation/widgets/featured_brand_card.dart';
import 'package:toys_catalogue/features/brands/presentation/widgets/category_card.dart';
import 'package:toys_catalogue/resources/screen_util.dart';
import 'package:toys_catalogue/resources/theme.dart';

class AllDistributorPage extends StatefulWidget {
  const AllDistributorPage({super.key});

  @override
  State<AllDistributorPage> createState() => _AllDistributorPageState();
}

class _AllDistributorPageState extends State<AllDistributorPage> {
  final List<Brand> featuredBrands = [
    Brand(name: 'Brand 1', imageUrl: 'https://placeholder.com/150'),
    Brand(name: 'Brand 2', imageUrl: 'https://placeholder.com/150'),
    Brand(name: 'Brand 3', imageUrl: 'https://placeholder.com/150'),
    Brand(name: 'Brand 4', imageUrl: 'https://placeholder.com/150'),
    Brand(name: 'Brand 5', imageUrl: 'https://placeholder.com/150'),
    Brand(name: 'Brand 6', imageUrl: 'https://placeholder.com/150'),
  ];

  final List<Category> categories = [
    Category(
      name: 'Action Figures',
      imageUrl: 'https://cdn.pixelspray.io/v2/black-bread-289bfa/HrdP6X/original/hamleys-product/490086956/300/490086956-1.webp',
      productsCount: 120,
    ),
    Category(
      name: 'Building Blocks',
      imageUrl: 'https://cdn.pixelspray.io/v2/black-bread-289bfa/HrdP6X/original/hamleys-product/490886347/300/490886347-1.webp',
      productsCount: 85,
    ),
    Category(
      name: 'Board Games',
      imageUrl: 'https://cdn.pixelspray.io/v2/black-bread-289bfa/HrdP6X/original/hamleys-product/490086949/300/490086949-1.webp',
      productsCount: 64,
    ),
    Category(
      name: 'Educational Toys',
      imageUrl: 'https://cdn.pixelspray.io/v2/black-bread-289bfa/HrdP6X/original/hamleys-product/491185540/300/491185540.webp',
      productsCount: 92,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsClass.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtils.w2(context),
              vertical: ScreenUtils.h2(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location Based Distributors',
                  style: TextStylesClass.h5.copyWith(
                    color: ColorsClass.textGrey1,
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
                  itemCount: featuredBrands.length,
                  itemBuilder: (context, index) {
                    return FeaturedBrandCard(
                      imageUrl: featuredBrands[index].imageUrl,
                      onTap: () {
                      },
                    );
                  },
                ),
                SizedBox(height: ScreenUtils.h3(context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Brands',
                      style: TextStylesClass.h5.copyWith(
                        color: ColorsClass.textGrey1,
                      ),
                    ),
                    PopupMenuButton<String>(
                      child: Row(
                        children: [
                          Text(
                            'Sort By',
                            style: TextStylesClass.p2.copyWith(
                              color: ColorsClass.secondaryTheme,
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: ColorsClass.secondaryTheme,
                          ),
                        ],
                      ),
                      onSelected: (String value) {
                        setState(() {
                        });
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          'Name (A-Z)',
                          'Name (Z-A)',
                          'Products (High to Low)',
                          'Products (Low to High)',
                        ].map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
                  ],
                ),
                SizedBox(height: ScreenUtils.h2(context)),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.h,
                    crossAxisSpacing: 16.w,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return CategoryCard(
                      name: categories[index].name,
                      imageUrl: categories[index].imageUrl,
                      productsCount: categories[index].productsCount,
                      onTap: () {

                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
