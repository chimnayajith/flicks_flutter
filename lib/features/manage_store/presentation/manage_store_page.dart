import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toys_catalogue/features/manage_store/presentation/widgets/banner.dart';
import 'package:toys_catalogue/features/manage_store/presentation/widgets/custom_card.dart';
import 'package:toys_catalogue/resources/theme.dart';
import 'package:toys_catalogue/routes/route_names.dart';

class ManageStorePage extends StatelessWidget {
  const ManageStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsClass.primaryTheme,
      appBar: AppBar(
        title: Text("Manage Store", style: TextStylesClass.h4.copyWith(color: ColorsClass.black)),
        centerTitle: true,
        backgroundColor: ColorsClass.primaryTheme,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column( 
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AdvertisementSpace(), 
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      CustomCard(
                        title: "My Inventory",
                        onTap: () {
                          Navigator.pushNamed(context, RouteNames.myInventoryPage);
                        },
                      ),
                      CustomCard(
                        title: "Staff Details",
                        onTap: () {
                          
                        },
                      ),
                      CustomCard(
                        title: "My Orders",
                        onTap: () {
                          
                        },
                      ),
                      CustomCard(
                        title: "My Rewards",
                        onTap: () {
                          Navigator.pushNamed(context, RouteNames.myRewardsPage);
                        },
                      ),
                      CustomCard(
                        title: "My Subscription",
                        onTap: () {
                          
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Active Plan",
                          style: TextStyle(color: ColorsClass.black, fontSize: 28),
                          
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Container(
                              height: 123.h,
                              width: 118.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: ColorsClass.secondaryTheme),
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Days Remaining",
                                    style: TextStylesClass.cta.copyWith(
                                      color: ColorsClass.secondaryTheme,
                                    ),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  "45", 
                                  style: TextStylesClass.h5
                                      .copyWith(color: ColorsClass.black),
                                ),
                                const SizedBox(height: 25,),
                                GestureDetector(
                                  onTap: () {
                                    
                                  },
                                  child: Text(
                                    "View All Plans",
                                    style: TextStylesClass.ctaLink.copyWith(
                                      color: ColorsClass.secondaryTheme,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}