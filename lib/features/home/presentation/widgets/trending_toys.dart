import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:toys_catalogue/resources/theme.dart';
import 'package:toys_catalogue/routes/route_names.dart';
import 'package:toys_catalogue/widgets/flick_card_widget.dart';

class TrendingToysSection extends StatefulWidget {
  final List<Map<String, String>> trendingToys;

  const TrendingToysSection({Key? key, required this.trendingToys}) : super(key: key);

  @override
  State<TrendingToysSection> createState() => _TrendingToysSectionState();
}

class _TrendingToysSectionState extends State<TrendingToysSection> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.4,
      initialPage: _currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding only for the heading
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Trending Toys',
                style: TextStyle(
                  fontSize: 24,
                  color: ColorsClass.text,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'View All',
                style: TextStyle(
                  fontSize: 16,
                  color: ColorsClass.secondaryTheme,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        widget.trendingToys.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('No trending toys available'),
              ),
            )
          : CarouselSlider(
              options: CarouselOptions(
                height: 250,
                viewportFraction: 0.45,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              items: widget.trendingToys.map((toy) {
                return GestureDetector(
                  onTap: () {
                    if (toy['id'] != null) {
                      Navigator.pushNamed(
                        context,
                        RouteNames.productDetailsPage,
                        arguments: {'productId': toy['id']},
                      );
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AspectRatio(
                        aspectRatio: 4/5,
                        child: SizedBox(
                          width: 250,
                          height: 250,
                          child: FlickCard(
                            imageUrl: toy['imageUrl'] ?? 'https://via.placeholder.com/250x300',
                            title: toy['title'],
                            id: toy['id'],
                            videoUrl: toy['videoUrl'],
                            source: toy['source'] ?? 'trending',
                            description: toy['description']
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}