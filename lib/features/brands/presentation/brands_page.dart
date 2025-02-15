import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toys_catalogue/features/brands/domain/models/brand.dart';
import 'package:toys_catalogue/features/brands/domain/models/category.dart';
import 'package:toys_catalogue/features/brands/presentation/widgets/featured_brand_card.dart';
import 'package:toys_catalogue/features/brands/presentation/widgets/category_card.dart';
import 'package:toys_catalogue/resources/screen_util.dart';
import 'package:toys_catalogue/resources/theme.dart';

class BrandsPage extends StatefulWidget {
  const BrandsPage({super.key});

  @override
  State<BrandsPage> createState() => _BrandsPageState();
}

class _BrandsPageState extends State<BrandsPage> {
  final List<Brand> featuredBrands = [
    Brand(name: 'Brand 1', imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR9CZ5lJcUOnOU5UxqNiOvT7tWqKxVGhNKE7hnfEC2Z6P8hPWGfFidhXGB6oxBMpdmU7VI&usqp=CAU'),
    Brand(name: 'Brand 2', imageUrl: 'https://images-platform.99static.com//2tjpS0uXMR9LCCQDU9ibgUTCfck=/470x214:1531x1275/fit-in/500x500/99designs-contests-attachments/69/69609/attachment_69609452'),
    Brand(name: 'Brand 3', imageUrl: 'https://img.freepik.com/premium-vector/toy-logo-illustration_848918-19101.jpg?semt=ais_hybrid'),
    Brand(name: 'Brand 4', imageUrl: 'https://i.pinimg.com/736x/b3/3f/8e/b33f8e76e39f9470bcf423208b09bb76.jpg'),
    Brand(name: 'Brand 5', imageUrl: 'https://www.designmantic.com/logo-images/167263.png?company=Company%20Name&keyword=toys&slogan=&verify=1'),
    Brand(name: 'Brand 6', imageUrl: 'https://t3.ftcdn.net/jpg/03/36/90/32/360_F_336903273_zr8CigGcpKsgKIdhFe12JYxWXoKmqNff.jpg'),
  ];

  final List<Category> categories = [
    Category(
      name: 'Action Figures',
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSwhat_f1tKGPcreqR-Fiv4W8xnKlf4xOc-eQ&s',
      productsCount: 120,
    ),
    Category(
      name: 'Building Blocks',
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6b5i0Wiq4ZZqMmCiQ1IYapO7olNq6fRTSDqCcXpzITiIuGWY2tOz-54TInLwQvKoVdgc&usqp=CAUvvvvvvvvvvvvvvvvvvvvvvvv',
      productsCount: 85,
    ),
    Category(
      name: 'Board Games',
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0ZnqdrOUjIxJlR3TvognAPbmlguYfxCRwkA&s',
      productsCount: 64,
    ),
    Category(
      name: 'Educational Toys',
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSh5muvqaJFd2AtegwT-USkrjhiExJ2Jw0d-VYgvAxicOBf1N0QgCLBt9tfsjRBr0ufEyk&usqp=CAU',
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
                  'Featured Brands',
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
                      'Categories',
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
