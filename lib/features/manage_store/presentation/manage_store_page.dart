import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toys_catalogue/features/main/presentation/main_page.dart';
import 'package:toys_catalogue/features/manage_store/data/shop_service.dart';
import 'package:toys_catalogue/features/manage_store/domain/models/shop_model.dart';
import 'package:toys_catalogue/features/manage_store/presentation/widgets/banner.dart';
import 'package:toys_catalogue/features/manage_store/presentation/widgets/custom_card.dart';
import 'package:toys_catalogue/resources/theme.dart';
import 'package:toys_catalogue/routes/route_names.dart';

class ManageStorePage extends StatefulWidget {
  const ManageStorePage({super.key});

  @override
  State<ManageStorePage> createState() => _ManageStorePageState();
}

class _ManageStorePageState extends State<ManageStorePage> {
  final ShopService _shopService = ShopService();
  bool _isLoading = true;
  String? _errorMessage;
  Shop? _shop;

  @override
  void initState() {
    super.initState();
    _loadShopDetails();
  }

  Future<void> _loadShopDetails() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Use getMockShopDetails for testing, switch to getShopDetails for production
      final shop = await _shopService.getShopDetails();

      setState(() {
        _shop = shop;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load shop details: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsClass.primaryTheme,
      appBar: AppBar(
        title: Text(_shop?.name ?? "Manage Store", 
                style: TextStylesClass.h4.copyWith(color: ColorsClass.black)),
        centerTitle: true,
        backgroundColor: ColorsClass.primaryTheme,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: ColorsClass.secondaryTheme),
            )
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: _loadShopDetails,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsClass.secondaryTheme,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AdvertisementSpace(bannerUrl: _shop?.bannerUrl),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                CustomCard(
                                  title: "Staff Details",
                                  onTap: () {
                                    Navigator.pushNamed(context, RouteNames.myStaffPage);
                                  },
                                ),
                                CustomCard(
                                  title: "My Rewards",
                                  onTap: () {
                                    final mainPageState = context.findAncestorStateOfType<MainPageState>();
                                    if (mainPageState != null) {
                                      mainPageState.pageController.jumpToPage(2);
                                    }
                                  },
                                ),
                                CustomCard(
                                  title: "My Subscription",
                                  onTap: () {
                                    Navigator.pushNamed(context, RouteNames.subscriptionsPage);
                                  },
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 50.h),
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
                                        child: _shop?.subscription == null
                                            ? Center(
                                                child: Icon(
                                                  Icons.card_membership,
                                                  color: ColorsClass.secondaryTheme,
                                                  size: 40.w,
                                                ),
                                              )
                                            : null,
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
                                            _shop?.subscription?.daysRemaining.toString() ?? "0",
                                            style: TextStylesClass.h5.copyWith(color: ColorsClass.black),
                                          ),
                                          const SizedBox(height: 25),
                                          GestureDetector(
                                            onTap: () {
                                              // Navigate to subscription plans
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