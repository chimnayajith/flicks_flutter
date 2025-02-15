import 'package:flutter/material.dart';
import 'package:toys_catalogue/features/home/presentation/widgets/promotion.dart';
import 'package:toys_catalogue/features/home/presentation/widgets/search_box.dart';
import 'package:toys_catalogue/features/home/presentation/widgets/sorting_options_widget.dart';
import 'package:toys_catalogue/features/home/presentation/widgets/top_products_widget.dart';
import 'package:toys_catalogue/features/home/presentation/widgets/trending_toys.dart';

import 'package:toys_catalogue/resources/theme.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // hardcoded value for trending toys
    final trendingToys = List.generate(
      10,
      (index) => {
        'imageUrl': 'https://placehold.co/200x250.png',
        'title': 'Toy $index',
      },
    );

    

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
              icon: const Icon(
                Icons.menu, 
                color: ColorsClass.text,
                size: 32,
                ),
              onPressed: () {
                 Scaffold.of(context).openDrawer();
              },
            ),
        ),
        backgroundColor: ColorsClass.secondaryTheme,
        title: Row(
          children: [
            Expanded(child: SearchBox()),
          ],
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: ColorsClass.secondaryTheme,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Drawer header
              DrawerHeader(
                decoration: BoxDecoration(
                  color: ColorsClass.secondaryTheme,
                ),
                child: const Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ),

              // Menu items
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      title: const Text('My Store', style: TextStyle(color: Colors.white, fontSize:20, fontWeight: FontWeight.w500)),
                      onTap: () {
                        // Handle My Store action
                      },
                    ),
                    ListTile(
                      title: const Text('Manage My Store', style: TextStyle(color: Colors.white, fontSize:20, fontWeight: FontWeight.w500)),
                      onTap: () {
                        // Handle Manage My Store action
                      },
                    ),
                    ListTile(
                      title: const Text('Distributors', style: TextStyle(color: Colors.white, fontSize:20, fontWeight: FontWeight.w500)),
                      onTap: () {
                        // Handle Distributors action
                      },
                    ),
                    ListTile(
                      title: const Text('Brands', style: TextStyle(color: Colors.white, fontSize:20, fontWeight: FontWeight.w500)),
                      onTap: () {
                        // Handle Brands action
                      },
                    ),
                  ],
                ),
              ),

              // Bottom menu items
              Column(
                children: [
                  ListTile(
                    title: const Text('My Subscription', style: TextStyle(color: Colors.white, fontSize:20, fontWeight: FontWeight.w500)),
                    onTap: () {
                      // Handle My Subscription action
                    },
                  ),
                  ListTile(
                    title: const Text('Contacts', style: TextStyle(color: Colors.white, fontSize:20, fontWeight: FontWeight.w500)),
                    onTap: () {
                      // Handle Contacts action
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PromotionBanner(
                imageUrl: 'https://s3-alpha-sig.figma.com/img/5965/a8b9/c637bd224a88ee5924a5a1cf3d632b6b?Expires=1740355200&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=So3OtE76YJYuKjDF8R0LTOZWgvUD4N6tSzynGDBLcJIuku9wVsNVYzewg~oiEpQ1ymrPXutOCFCN~m-5dTj-nfCvO6cZQmhfXe4thcXMQRsnAAYKScFhfdVVC0WkEbR6PjtKdt69dtjlOrIm1gU7wiRA07UCn8EkilEIzcdM724IqDxHktKLUK6UVEJo4q0M5pYz25pm8jTncYZxjSIDGLY9Qivb2IgPVM5oMh16tfk3doF~~tr~t-EsR5A66e-vwrT~4gHlk8nguo1tOWfsUp3G9d9ha9oI6nDp0uE0Eqly0nV4hfaevFyd38gII1egapf9tEFX9fRdxRB43mpntw__', // LEGO image URL
              ),

            // Trending Toys Section
           TrendingToysSection(trendingToys: trendingToys),
           TopProductsList(topProducts: trendingToys),

            // Sorting section
            SortingOptionsWidget(),

          ],
        ),
      ),
    );
  }
}
