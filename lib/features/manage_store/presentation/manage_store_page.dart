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
        title: Text(_shop?.name ?? "My Store", 
                style: TextStylesClass.h4.copyWith(color: ColorsClass.black)),
        centerTitle: true,
        backgroundColor: ColorsClass.primaryTheme,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: ColorsClass.secondaryTheme),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Edit store functionality coming soon'))
              );
            },
          ),
        ],
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
              : RefreshIndicator(
                  onRefresh: _loadShopDetails,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Store Banner
                        AdvertisementSpace(bannerUrl: _shop?.bannerUrl),
                        
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Store Information Card
                              _buildStoreInfoCard(),
                              
                              SizedBox(height: 24.h),
                              
                              // Management Options
                              Text(
                                "Management",
                                style: TextStylesClass.s1.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: ColorsClass.black,
                                ),
                              ),
                              
                              SizedBox(height: 16.h),
                              
                              // Staff Card
                              CustomCard(
                                title: "Staff Management",
                                subtitle: "Manage your store staff",
                                icon: Icons.people,
                                onTap: () {
                                  Navigator.pushNamed(context, RouteNames.myStaffPage);
                                },
                              ),
                              
                              SizedBox(height: 12.h),
                              
                              // Rewards Card
                              CustomCard(
                                title: "Rewards Program",
                                subtitle: "Manage customer loyalty",
                                icon: Icons.card_giftcard,
                                onTap: () {
                                  final mainPageState = context.findAncestorStateOfType<MainPageState>();
                                  if (mainPageState != null) {
                                    mainPageState.pageController.jumpToPage(2);
                                  }
                                },
                              ),
                              
                              SizedBox(height: 12.h),
                              
                              // Inventory Card
                              CustomCard(
                                title: "My Inventory",
                                subtitle: "Manage your products",
                                icon: Icons.inventory_2,
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Inventory management coming soon'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                              ),
                              
                              SizedBox(height: 24.h),
                              
                              // Subscription Section
                              _buildSubscriptionSection(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildStoreInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Store Information',
              style: TextStylesClass.s1.copyWith(
                fontWeight: FontWeight.bold,
                color: ColorsClass.black,
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // Owner Info
            if (_shop?.owner != null) ...[
              _buildInfoRow(
                Icons.person_outline,
                'Owner',
                _shop!.owner!.name ?? _shop!.owner!.username ?? '',
              ),
              SizedBox(height: 12.h),
            ],
            
            // Address
            _buildInfoRow(
              Icons.location_on_outlined,
              'Address',
              _shop?.address ?? 'No address provided',
            ),
            
            SizedBox(height: 12.h),
            
            // Phone
            _buildInfoRow(
              Icons.phone_outlined,
              'Phone',
              _shop?.phone ?? 'No phone provided',
            ),
            
            SizedBox(height: 12.h),
            
            // Email
            _buildInfoRow(
              Icons.email_outlined,
              'Email',
              _shop?.email ?? 'No email provided',
            ),
            
            // Description (if available)
            if (_shop?.description != null && _shop!.description!.isNotEmpty) ...[
              SizedBox(height: 16.h),
              Divider(),
              SizedBox(height: 16.h),
              Text(
                'About',
                style: TextStylesClass.p1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: ColorsClass.black,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                _shop!.description!,
                style: TextStylesClass.p2.copyWith(color: ColorsClass.textGrey),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Subscription",
          style: TextStylesClass.s1.copyWith(
            fontWeight: FontWeight.bold,
            color: ColorsClass.black,
          ),
        ),
        
        SizedBox(height: 16.h),
        
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 60.h,
                      width: 60.h,
                      decoration: BoxDecoration(
                        color: ColorsClass.secondaryTheme.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.card_membership,
                        color: ColorsClass.secondaryTheme,
                        size: 30.h,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Current Plan",
                            style: TextStylesClass.p2.copyWith(
                              color: ColorsClass.textGrey,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            _shop?.subscription?.plan ?? "Free Plan",
                            style: TextStylesClass.s1.copyWith(
                              color: ColorsClass.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 16.h),
                
                // Subscription details
                if (_shop?.subscription != null) ...[
                  Row(
                    children: [
                      _buildSubscriptionDetailItem(
                        "Days Remaining", 
                        "${_shop?.subscription?.daysRemaining ?? 0} days",
                      ),
                      SizedBox(width: 16.w),
                      _buildSubscriptionDetailItem(
                        "Expires On", 
                        _shop?.subscription?.expiryDate ?? "N/A",
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Subscription status indicator
                  if (_shop?.subscription?.daysRemaining != null) 
                    _buildExpiryProgressBar(_shop!.subscription!.daysRemaining!),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20.w,
          color: ColorsClass.secondaryTheme,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStylesClass.p2.copyWith(
                  color: ColorsClass.textGrey,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStylesClass.p1.copyWith(
                  color: ColorsClass.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionDetailItem(String label, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStylesClass.caption.copyWith(
                color: ColorsClass.textGrey,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: TextStylesClass.p1.copyWith(
                color: ColorsClass.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpiryProgressBar(int daysRemaining) {
    // Assuming total subscription days is 30 (monthly) or 365 (yearly)
    final int totalDays = 30; // Or get this from your subscription details
    double progress = daysRemaining / totalDays;
    progress = progress.clamp(0.0, 1.0); // Ensure it's between 0 and 1
    
    Color progressColor;
    if (progress > 0.5) {
      progressColor = Colors.green;
    } else if (progress > 0.25) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.red;
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Subscription Status",
          style: TextStylesClass.caption.copyWith(
            color: ColorsClass.textGrey,
          ),
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            minHeight: 8.h,
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              daysRemaining <= 7 ? "Renew soon" : "Active",
              style: TextStylesClass.caption.copyWith(
                color: progressColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "$daysRemaining of $totalDays days",
              style: TextStylesClass.caption.copyWith(
                color: ColorsClass.textGrey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}