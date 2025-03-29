import 'package:flutter/material.dart';
import 'package:toys_catalogue/resources/screen_util.dart';
import 'package:toys_catalogue/resources/theme.dart';

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
        //redirect to store page
      }, // Handles the shop now action
      child: Container(
        width: double.infinity, // Full width of the screen
        height: ScreenUtils.blockSizeVertical(context, 25), // 25% of the screen height
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover, // Ensures the image covers the entire container
        ),
      ),
    );
  }
}
