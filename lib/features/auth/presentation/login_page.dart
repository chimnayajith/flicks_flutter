import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toys_catalogue/features/auth/data/auth_service.dart';
import 'package:toys_catalogue/features/auth/presentation/widgets/auth_button.dart';
import 'package:toys_catalogue/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:toys_catalogue/resources/theme.dart';
import 'package:toys_catalogue/routes/route_names.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final response = await _authService.login(
          _usernameController.text, 
          _passwordController.text
        );
        
        // Save tokens
        await _authService.saveTokens(
          response['access'], 
          response['refresh'],
          response['role'],
        );
        
        // Navigate to main page
        Navigator.pushReplacementNamed(context, RouteNames.mainPage);
      } catch (e) {
        setState(() {
          _errorMessage = e.toString().contains('Failed to connect') 
              ? 'Network error. Please check your connection.' 
              : 'Invalid username or password';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsClass.primaryTheme,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40.h),
                  
                  // Logo or App name
                  Center(
                    child: Text(
                      "FLICKS",
                      style: TextStylesClass.h1.copyWith(
                        color: ColorsClass.secondaryTheme,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 60.h),
                  
                  // Login Title
                  Text(
                    "Login",
                    style: TextStylesClass.h3.copyWith(
                      color: ColorsClass.text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  
                  SizedBox(height: 8.h),
                  
                  Text(
                    "Please sign in to continue",
                    style: TextStylesClass.p1.copyWith(
                      color: ColorsClass.textGrey,
                    ),
                  ),
                  
                  SizedBox(height: 32.h),
                  
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
                  
                  // Username Field (changed from email)
                  AuthTextField(
                    controller: _usernameController,
                    hintText: "Username",
                    keyboardType: TextInputType.text,
                    prefixIcon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your username";
                      }
                      return null;
                    },
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Password Field
                  AuthTextField(
                    controller: _passwordController,
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
                      return null;
                    },
                  ),
                  
                  SizedBox(height: 12.h),
                  
                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to forgot password page
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStylesClass.p2.copyWith(
                          color: ColorsClass.secondaryTheme,
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 40.h),
                  
                  // Login Button
                  AuthButton(
                    text: "Login",
                    isLoading: _isLoading,
                    onPressed: _handleLogin,
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Sign Up Option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStylesClass.p2.copyWith(
                          color: ColorsClass.textGrey,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RouteNames.register);
                        },
                        child: Text(
                          "Sign Up",
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