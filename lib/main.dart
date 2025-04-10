import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toys_catalogue/routes/route_names.dart';
import 'package:toys_catalogue/routes/routes.dart';
import 'package:toys_catalogue/utils/api/api_client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      builder: (_, child) {
        ApiClient().setGlobalContext(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false, 
          initialRoute: RouteNames.splash,
          onGenerateRoute: Routes.generateRoute,
        );
      },
    );
  }
}