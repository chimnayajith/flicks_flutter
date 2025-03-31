import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toys_catalogue/features/main/presentation/main_page.dart';
import 'package:toys_catalogue/features/manage_store/domain/models/shop_model.dart';
import 'package:toys_catalogue/features/my_profile/data/profile_service.dart';
import 'package:toys_catalogue/resources/theme.dart';
import 'package:toys_catalogue/routes/route_names.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final ProfileService _shopService = ProfileService();
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _userProfile;
  Shop? _shop;
  String? _username;
  String? _role;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final prefs = await SharedPreferences.getInstance();
      _username = prefs.getString('username');
      _role = prefs.getString('role');

      final profileResponse = await _shopService.getUserProfile();
      
      final shop = await _shopService.getShopDetails();

      setState(() {
        _userProfile = profileResponse;
        _shop = shop;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load user profile: $e';
        print('Error loading profile: $e');
      });
    }
  }

  String _getRoleTitle(String? role) {
    if (role == null) return 'Staff Member';
    
    switch (role.toLowerCase()) {
      case 'owner':
        return 'Store Owner';
      case 'helper':
        return 'Sales Staff';
      default:
        return 'Sales Staff';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsClass.primaryTheme,
      appBar: AppBar(
        title: Text("My Profile", 
                style: TextStylesClass.s1.copyWith(color: ColorsClass.black)),
        centerTitle: true,
        backgroundColor: ColorsClass.primaryTheme,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: ColorsClass.secondaryTheme),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit profile functionality coming soon'))
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
                        style: TextStylesClass.p1.copyWith(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: _loadUserInfo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsClass.secondaryTheme,
                        ),
                        child: Text('Retry', style: TextStylesClass.ctaS),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20.h),
                      // Profile Avatar Section
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50.r,
                              backgroundColor: ColorsClass.secondaryTheme.withOpacity(0.2),
                              child: Text(
                                (_userProfile?['full_name'] ?? _username ?? 'User').substring(0, 1).toUpperCase(),
                                style: TextStyle(
                                  fontSize: 35.sp,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsClass.secondaryTheme,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 30.h,
                                width: 30.h,
                                decoration: BoxDecoration(
                                  color: ColorsClass.secondaryTheme,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: ColorsClass.primaryTheme,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 15.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15.h),
                      
                      // User Name and Role
                      Text(
                        (_userProfile?['first_name'] != null && _userProfile?['last_name'] != null) 
                          ? "${_userProfile?['first_name']} ${_userProfile?['last_name']}"
                          : _username ?? 'User',
                        style: TextStylesClass.s1.copyWith(
                          color: ColorsClass.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          color: ColorsClass.secondaryTheme.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          _getRoleTitle(_role),
                          style: TextStylesClass.p2.copyWith(
                            color: ColorsClass.secondaryTheme,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      
                      SizedBox(height: 30.h),
                      
                      // Store Information Card
                      if (_shop != null)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 40.w,
                                        height: 40.h,
                                        decoration: BoxDecoration(
                                          color: ColorsClass.secondaryTheme.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        child: Icon(
                                          Icons.store,
                                          color: ColorsClass.secondaryTheme,
                                          size: 22.sp,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Your Store',
                                              style: TextStylesClass.p2.copyWith(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              _shop?.name ?? 'Your Toy Store',
                                              style: TextStylesClass.s1.copyWith(
                                                color: ColorsClass.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          final mainPageState = context.findAncestorStateOfType<MainPageState>();
                                          if (mainPageState != null) {
                                            mainPageState.pageController.jumpToPage(1);
                                          } else {
                                            Navigator.pushNamed(context, RouteNames.manageStorePage);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorsClass.secondaryTheme,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.r),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 15.w,
                                            vertical: 8.h,
                                          ),
                                        ),
                                        child: Text(
                                          'Visit',
                                          style: TextStylesClass.ctaS.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      SizedBox(height: 20.h),
                      
                      // User Information Section
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Personal Information',
                              style: TextStylesClass.s1.copyWith(
                                color: ColorsClass.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 15.h),
                            _buildInfoTile(
                              icon: Icons.account_circle,
                              title: 'Username',
                              value: _username ?? _userProfile?['username'] ?? 'Not provided',
                            ),
                            _buildInfoTile(
                              icon: Icons.email,
                              title: 'Email',
                              value: _userProfile?['email'] ?? 'Not provided',
                            ),
                            _buildInfoTile(
                              icon: Icons.phone,
                              title: 'Phone',
                              value: _userProfile?['phone'] ?? 'Not provided',
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 30.h),
                      
                      // Actions Section
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Account Settings',
                              style: TextStylesClass.s1.copyWith(
                                color: ColorsClass.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 15.h),
                            _buildActionTile(
                              icon: Icons.lock,
                              title: 'Change Password',
                              onTap: () {
                                // Navigate to change password screen
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Change password functionality coming soon'))
                                );
                              },
                            ),
                            _buildActionTile(
                              icon: Icons.notifications,
                              title: 'Notification Settings',
                              onTap: () {
                                // Navigate to notification settings
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Notification settings coming soon'))
                                );
                              },
                            ),
                            _buildActionTile(
                              icon: Icons.language,
                              title: 'Language',
                              value: 'English',
                              onTap: () {
                                // Navigate to language settings
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Language settings coming soon'))
                                );
                              },
                            ),
                            _buildActionTile(
                              icon: Icons.help,
                              title: 'Help & Support',
                              onTap: () {
                                // Navigate to help & support
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Help & support coming soon'))
                                );
                              },
                            ),
                            _buildActionTile(
                              icon: Icons.exit_to_app,
                              title: 'Logout',
                              iconColor: Colors.red,
                              titleColor: Colors.red,
                              onTap: () async {
                                // Show confirmation dialog
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Logout', style: TextStylesClass.s1),
                                    content: Text('Are you sure you want to logout?', style: TextStylesClass.p1),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Cancel', style: TextStylesClass.ctaS),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          // Clear stored user data
                                          final prefs = await SharedPreferences.getInstance();
                                          await prefs.clear();
                                          
                                          // Navigate to login screen and clear all routes
                                          if (context.mounted) {
                                            Navigator.pushNamedAndRemoveUntil(
                                              context, 
                                              RouteNames.login, 
                                              (route) => false
                                            );
                                          }
                                        },
                                        child: Text('Logout', style: TextStylesClass.ctaS.copyWith(color: ColorsClass.secondaryTheme)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: ColorsClass.secondaryTheme.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              color: ColorsClass.secondaryTheme,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStylesClass.p2.copyWith(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 3.h),
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
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    String? value,
    required VoidCallback onTap,
    Color iconColor = ColorsClass.secondaryTheme,
    Color titleColor = ColorsClass.black,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Text(
                title,
                style: TextStylesClass.p1.copyWith(
                  color: titleColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (value != null)
              Text(
                value,
                style: TextStylesClass.p2.copyWith(
                  color: Colors.grey,
                ),
              ),
            if (value == null)
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
          ],
        ),
      ),
    );
  }
}