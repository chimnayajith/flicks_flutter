import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:toys_catalogue/resources/theme.dart';
import 'package:toys_catalogue/widgets/flick_card_widget.dart';

class TopProductsList extends StatefulWidget {
  final List<Map<String, String>> topProducts;

  const TopProductsList({Key? key, required this.topProducts}) : super(key: key);

  @override
  State<TopProductsList> createState() => _TopProductsListState();
}

class _TopProductsListState extends State<TopProductsList> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Top 10 products',
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
        CarouselSlider(
          options: CarouselOptions(
            height: 250,
            viewportFraction: 0.45,
            enlargeCenterPage: true,
            enlargeFactor: 0.2,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: widget.topProducts.map((toy) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 4/5,
                  child: SizedBox(
                    width: 250,
                    height: 250,
                    child: FlickCard(
                      imageUrl: toy['imageUrl']!,
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
}