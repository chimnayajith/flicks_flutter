import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toys_catalogue/features/auth/data/registration_service.dart';
import 'package:toys_catalogue/features/auth/presentation/widgets/auth_button.dart';
import 'package:toys_catalogue/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:toys_catalogue/resources/theme.dart';
import 'package:toys_catalogue/routes/route_names.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _registrationService = RegistrationService();
  
  // Controllers for shop details
  final _shopNameController = TextEditingController();
  final _shopAddressController = TextEditingController();
  final _shopPhoneController = TextEditingController();
  final _shopEmailController = TextEditingController();
  final _shopDescriptionController = TextEditingController();
  
  // Controllers for owner details
  final _ownerUsernameController = TextEditingController();
  final _ownerEmailController = TextEditingController();
  final _ownerPasswordController = TextEditingController();
  final _ownerConfirmPasswordController = TextEditingController();
  final _ownerFirstNameController = TextEditingController();
  final _ownerLastNameController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;
  File? _bannerImage;
  
  final _picker = ImagePicker();

  @override
  void dispose() {
    // Dispose shop controllers
    _shopNameController.dispose();
    _shopAddressController.dispose();
    _shopPhoneController.dispose();
    _shopEmailController.dispose();
    _shopDescriptionController.dispose();
    
    // Dispose owner controllers
    _ownerUsernameController.dispose();
    _ownerEmailController.dispose();
    _ownerPasswordController.dispose();
    _ownerConfirmPasswordController.dispose();
    _ownerFirstNameController.dispose();
    _ownerLastNameController.dispose();
    
    super.dispose();
  }

  Future<void> _pickBannerImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _bannerImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _handleRegistration() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Check if passwords match
      if (_ownerPasswordController.text != _ownerConfirmPasswordController.text) {
        setState(() {
          _errorMessage = "Passwords don't match";
        });
        return;
      }
      
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        await _registrationService.registerShopWithOwner(
          shopName: _shopNameController.text,
          shopAddress: _shopAddressController.text,
          shopPhone: _shopPhoneController.text,
          shopEmail: _shopEmailController.text,
          shopDescription: _shopDescriptionController.text,
          ownerUsername: _ownerUsernameController.text,
          ownerEmail: _ownerEmailController.text,
          ownerPassword: _ownerPasswordController.text,
          ownerFirstName: _ownerFirstNameController.text,
          ownerLastName: _ownerLastNameController.text,
          bannerImage: _bannerImage,
        );
        
        // Navigate to main page after successful registration
        if (mounted) {
          Navigator.pushReplacementNamed(context, RouteNames.mainPage);
        }
      } catch (e) {
        setState(() {
          _errorMessage = e.toString().contains('Failed to connect') 
              ? 'Network error. Please check your connection.' 
              : e.toString().replaceAll('Exception: ', '');
        });
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsClass.primaryTheme,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorsClass.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Register Shop",
          style: TextStylesClass.h4.copyWith(color: ColorsClass.text),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  
                  // Error Message
                  if (_errorMessage != null)
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: TextStylesClass.p2.copyWith(color: Colors.red),
                      ),
                    ),
                  
                  if (_errorMessage != null) SizedBox(height: 16.h),
                  
                  // Shop Details Section
                  Text(
                    "Shop Details",
                    style: TextStylesClass.h5.copyWith(
                      color: ColorsClass.text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Shop Name Field
                  AuthTextField(
                    controller: _shopNameController,
                    hintText: "Shop Name",
                    keyboardType: TextInputType.text,
                    prefixIcon: Icons.store,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your shop name";
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Shop Address Field
                  AuthTextField(
                    controller: _shopAddressController,
                    hintText: "Shop Address",
                    keyboardType: TextInputType.streetAddress,
                    prefixIcon: Icons.location_on,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your shop address";
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Shop Phone Field
                  AuthTextField(
                    controller: _shopPhoneController,
                    hintText: "Shop Phone",
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your shop phone number";
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Shop Email Field
                  AuthTextField(
                    controller: _shopEmailController,
                    hintText: "Shop Email",
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your shop email";
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Shop Description Field (Optional)
                  AuthTextField(
                    controller: _shopDescriptionController,
                    hintText: "Shop Description (Optional)",
                    keyboardType: TextInputType.multiline,
                    prefixIcon: Icons.description,
                    validator: null,
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Banner Image Selection
                  Text(
                    "Shop Banner (Optional)",
                    style: TextStylesClass.p1.copyWith(
                      color: ColorsClass.textGrey,
                    ),
                  ),
                  
                  SizedBox(height: 8.h),
                  
                  GestureDetector(
                    onTap: _pickBannerImage,
                    child: Container(
                      height: 120.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ColorsClass.secondaryTheme.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: ColorsClass.secondaryTheme,
                          width: 1,
                        ),
                        image: _bannerImage != null
                          ? DecorationImage(
                              image: FileImage(_bannerImage!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      ),
                      child: _bannerImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_upload,
                                size: 40.w,
                                color: ColorsClass.secondaryTheme,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "Tap to upload banner",
                                style: TextStylesClass.p2.copyWith(
                                  color: ColorsClass.textGrey,
                                ),
                              ),
                            ],
                          )
                        : null,
                    ),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Owner Details Section
                  Text(
                    "Owner Details",
                    style: TextStylesClass.h5.copyWith(
                      color: ColorsClass.text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Owner Username Field
                  AuthTextField(
                    controller: _ownerUsernameController,
                    hintText: "Username",
                    keyboardType: TextInputType.text,
                    prefixIcon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your username";
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Owner First Name Field
                  AuthTextField(
                    controller: _ownerFirstNameController,
                    hintText: "First Name",
                    keyboardType: TextInputType.name,
                    prefixIcon: Icons.badge,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your first name";
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Owner Last Name Field
                  AuthTextField(
                    controller: _ownerLastNameController,
                    hintText: "Last Name",
                    keyboardType: TextInputType.name,
                    prefixIcon: Icons.badge,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your last name";
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Owner Email Field
                  AuthTextField(
                    controller: _ownerEmailController,
                    hintText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Owner Password Field
                  AuthTextField(
                    controller: _ownerPasswordController,
                    hintText: "Password",
                    obscureText: _obscurePassword,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: ColorsClass.textGrey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Owner Confirm Password Field
                  AuthTextField(
                    controller: _ownerConfirmPasswordController,
                    hintText: "Confirm Password",
                    obscureText: _obscureConfirmPassword,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                        color: ColorsClass.textGrey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please confirm your password";
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  // Register Button
                  AuthButton(
                    text: "Register",
                    isLoading: _isLoading,
                    onPressed: _handleRegistration,
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Login Option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStylesClass.p2.copyWith(
                          color: ColorsClass.textGrey,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, RouteNames.login);
                        },
                        child: Text(
                          "Login",
                          style: TextStylesClass.p2.copyWith(
                            color: ColorsClass.secondaryTheme,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}