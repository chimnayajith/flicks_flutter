import 'package:toys_catalogue/features/home/presentation/home_page.dart';
import 'package:toys_catalogue/routes/route_names.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
        case RouteNames.pageView:
          return MaterialPageRoute(builder: (_) => MainPageView());
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
