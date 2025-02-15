import 'package:flutter/material.dart';
import 'package:toys_catalogue/widgets/flick_card_widget.dart';

class CuratedProductsGrid extends StatefulWidget {
  final List<Map<String, String>> allProducts; // You can pass data here
  final int itemsPerPage;
  final ScrollController scrollController;

  const CuratedProductsGrid({
    Key? key,
    required this.allProducts,
    required this.itemsPerPage,
    required this.scrollController,
  }) : super(key: key);

  @override
  _CuratedProductsGridState createState() => _CuratedProductsGridState();
}

class _CuratedProductsGridState extends State<CuratedProductsGrid> {
  int currentPage = 0;

  // Method to simulate loading products (you can replace it with real data)
  void _loadMoreProducts() {
    final newProducts = List.generate(widget.itemsPerPage, (index) {
      return {'imageUrl': 'https://placehold.co/200x250.png'};
    });

    setState(() {
      widget.allProducts.addAll(newProducts);
      currentPage++;
    });
  }

  @override
  void initState() {
    super.initState();
    // Add listener for scroll events
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels == widget.scrollController.position.maxScrollExtent) {
        _loadMoreProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: widget.scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 200 / 250,
      ),
      itemCount: widget.allProducts.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final toy = widget.allProducts[index];
        return FlickCard(
          imageUrl: toy['imageUrl']!,
        );
      },
    );
  }
}
