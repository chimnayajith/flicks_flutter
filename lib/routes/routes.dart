import 'package:toys_catalogue/features/flicks/presentation/flicks_page.dart';
import 'package:toys_catalogue/features/home/presentation/home_page.dart';
import 'package:toys_catalogue/features/main/presentation/main_page.dart';
import 'package:toys_catalogue/features/my_staff/presentation/my_staff.dart';
import 'package:toys_catalogue/features/subscription/presentation/subscription_page.dart';
import 'package:toys_catalogue/routes/route_names.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
        case RouteNames.mainPage:
            return MaterialPageRoute(builder: (_) => MainPage());
        case RouteNames.homePage:
          return MaterialPageRoute(builder: (_) => HomePage());
        case RouteNames.flicksPage:
          return MaterialPageRoute(builder: (_) => FlicksPage());
        case RouteNames.myStaffPage:
          return MaterialPageRoute(builder: (_) => MyStaffPage());
        case RouteNames.subscriptionsPage:
          return MaterialPageRoute(builder: (_) => SubscriptionPage());
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
