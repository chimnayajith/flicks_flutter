import 'package:flutter/material.dart';
import 'package:toys_catalogue/features/flicks/presentation/flicks_page.dart';
import 'package:toys_catalogue/features/main/presentation/main_page.dart';
import 'package:toys_catalogue/resources/theme.dart';
import 'package:toys_catalogue/routes/route_names.dart';

class FlickCard extends StatelessWidget {
  final String imageUrl;
  final String? title;
  final String? id;
  final String? videoUrl;
  final String? source;
  final String? description;

  const FlickCard({
    Key? key,
    required this.imageUrl,
    this.title,
    this.id,
    this.videoUrl,
    this.source,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (id != null) {
          // Find MainPageState
          final mainPageState = context.findAncestorStateOfType<MainPageState>();
          
          // Save the arguments in a global variable or use a state management solution
          // For simplicity, we'll use a static variable in FlicksPage
          FlicksPage.pendingArgs = {
            'productId': id,
            'videoUrl': videoUrl,
            'source': source,
            'title': title,
            'imageUrl': imageUrl,
            'description': description,
            'enableSectionScroll': true,
          };
          
          if (mainPageState != null) {
            // If already in MainPage, jump to Flicks tab (index 3)
            mainPageState.pageController.jumpToPage(3);
          } else {
            // If not in MainPage, navigate to MainPage with Flicks tab selected
            Navigator.pushReplacementNamed(
              context,
              RouteNames.mainPage,
              arguments: {'initialIndex': 3},
            );
          }
        }
      },
      child: Stack(
        children: [
          // Image container
          Container(
            width: 200,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(imageUrl.isNotEmpty && imageUrl != 'null' 
                    ? imageUrl 
                    : 'https://via.placeholder.com/200x250'),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  print("Error loading image: $exception");
                },
              ),
              color: Colors.grey[200], // Fallback color if image fails to load
            ),
            child: imageUrl.isEmpty || imageUrl == 'null'
                ? Icon(Icons.toys, color: ColorsClass.secondaryTheme, size: 40)
                : null,
          ),
          
          // Title overlay
          if (title != null && title!.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Text(
                  title!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
        ],
      ),
    );
  }
}