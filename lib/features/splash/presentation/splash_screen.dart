import 'package:flutter/material.dart';
import 'package:toys_catalogue/features/auth/data/auth_check_service.dart';
import 'package:toys_catalogue/resources/theme.dart';
import 'package:toys_catalogue/routes/route_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthCheckService _authCheckService = AuthCheckService();
  
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }
  
  Future<void> _checkAuthAndNavigate() async {
    // Simulate a delay for splash screen (optional)
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    // Check if user is logged in
    final isLoggedIn = await _authCheckService.isUserLoggedIn();
    
    if (!mounted) return;
    
    if (isLoggedIn) {
      // User is logged in, navigate to main page
      Navigator.pushReplacementNamed(context, RouteNames.mainPage);
    } else {
      // User is not logged in, navigate to login page
      Navigator.pushReplacementNamed(context, RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsClass.primaryTheme,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo or name
            Text(
              "FLICKS",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: ColorsClass.secondaryTheme,
              ),
            ),
            const SizedBox(height: 30),
            // Circular progress indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(ColorsClass.secondaryTheme),
            ),
          ],
        ),
      ),
    );
  }
}