import 'package:flutter/material.dart';
import 'package:toys_catalogue/features/home/presentation/home_page.dart';
import 'package:toys_catalogue/features/flicks/presentation/flicks_page.dart';
import 'package:toys_catalogue/features/manage_store/presentation/manage_store_page.dart';
import 'package:toys_catalogue/features/manage_store/presentation/my_rewards_page.dart';
import 'package:toys_catalogue/features/my_profile/presentation/my_profile_page.dart';
import 'package:toys_catalogue/resources/theme.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  final PageController pageController = PageController();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(), 
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        children: const [
          HomePage(),
          ManageStorePage(),
          MyRewardsPage(),
          FlicksPage(),
          UserProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          pageController.jumpToPage(index);
        },
        selectedItemColor: ColorsClass.secondaryTheme,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'My Store',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.military_tech),
            label: 'Rewards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle),
            label: 'Flicks Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My Profile',
          ),
        ],
      ),
    );
  }
}