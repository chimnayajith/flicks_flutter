import 'package:flutter/material.dart';
import 'package:toys_catalogue/features/main/presentation/main_page.dart';
import 'package:toys_catalogue/resources/screen_util.dart';
import 'package:toys_catalogue/resources/theme.dart';
import 'package:toys_catalogue/routes/route_names.dart';

class StoreBanner extends StatelessWidget {
  final String imageUrl;

  const StoreBanner({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        final mainPageState = context.findAncestorStateOfType<MainPageState>();
        if (mainPageState != null) {
          mainPageState.pageController.jumpToPage(1);
        } else {
          Navigator.pushReplacementNamed(
            context, 
            RouteNames.mainPage, 
            arguments: {'initialIndex': 1},
          );
        }
      }, // Handles the shop now action
      child: Container(
        width: double.infinity,
        height: ScreenUtils.blockSizeVertical(context, 25),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
