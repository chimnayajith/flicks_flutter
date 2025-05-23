import 'package:toys_catalogue/features/auth/presentation/login_page.dart';
import 'package:toys_catalogue/features/auth/presentation/register_shop_page.dart';
import 'package:toys_catalogue/features/flicks/presentation/flicks_page.dart';
import 'package:toys_catalogue/features/all_distributors/presentation/all_distributor_page.dart';
import 'package:toys_catalogue/features/brands/presentation/brands_page.dart';
import 'package:toys_catalogue/features/distributors_page/presentation/distributors_page.dart';
import 'package:toys_catalogue/features/distributors_page/presentation/nearby_distributers_page.dart';
import 'package:toys_catalogue/features/home/presentation/home_page.dart';
import 'package:toys_catalogue/features/home/presentation/search_page.dart';
import 'package:toys_catalogue/features/main/presentation/main_page.dart';
import 'package:toys_catalogue/features/my_staff/presentation/my_staff.dart';
import 'package:toys_catalogue/features/splash/presentation/splash_screen.dart';
import 'package:toys_catalogue/features/subscription/presentation/subscription_page.dart';
import 'package:toys_catalogue/features/manage_store/presentation/manage_store_page.dart';
import 'package:toys_catalogue/features/manage_store/presentation/my_inventory_page.dart';
import 'package:toys_catalogue/features/manage_store/presentation/my_rewards_page.dart';
import 'package:toys_catalogue/features/products/presentation/product_details_page.dart';
import 'package:toys_catalogue/routes/route_names.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case RouteNames.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case RouteNames.mainPage:
        return MaterialPageRoute(builder: (_) => MainPage());
      case RouteNames.homePage:
        return MaterialPageRoute(builder: (_) => HomePage());
      case RouteNames.flicksPage:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => FlicksPage(args: args),
        );
      case RouteNames.myStaffPage:
        return MaterialPageRoute(builder: (_) => MyStaffPage());
      case RouteNames.subscriptionsPage:
        return MaterialPageRoute(builder: (_) => SubscriptionPage());
      case RouteNames.brands:
        return MaterialPageRoute(builder: (_) => const BrandsPage());
      case RouteNames.distributorsPage:
        return MaterialPageRoute(builder: (_) => const DistributorsPage());
      case RouteNames.nearbyDistributorsPage:
        return MaterialPageRoute(
          builder: (_) => const NearbyDistributorsPage(),
        );
      case RouteNames.alldistributorsPage:
        return MaterialPageRoute(builder: (_) => const AllDistributorPage());
      case RouteNames.manageStorePage:
        return MaterialPageRoute(builder: (_) => const ManageStorePage());
      case RouteNames.productDetailsPage:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ProductDetailsPage(args: args),
        );
      case RouteNames.myRewardsPage:
        return MaterialPageRoute(builder: (_) => const MyRewardsPage());
      case RouteNames.myInventoryPage:
        return MaterialPageRoute(builder: (_) => const MyInventoryPage());
      case RouteNames.searchPage:
        return MaterialPageRoute(builder: (_) => const SearchPage());
      default:
        return MaterialPageRoute(
          builder: (_) {
            return const Scaffold(
              body: Center(child: Text("No Route Defined")),
            );
          },
        );
    }
  }
}
