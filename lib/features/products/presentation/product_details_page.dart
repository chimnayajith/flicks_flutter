import 'package:flutter/material.dart';
import 'package:toys_catalogue/features/products/domain/models/product_model.dart';
import 'package:toys_catalogue/features/products/presentation/widgets/product_brief_info.dart';
import 'package:toys_catalogue/features/products/presentation/widgets/product_expandable_details.dart';
import 'package:toys_catalogue/features/products/presentation/widgets/product_image_carousel.dart';
import 'package:toys_catalogue/features/products/presentation/widgets/related_products.dart';
import 'package:toys_catalogue/resources/theme.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int currentImageIndex = 0;
  final product = Product.sampleProduct;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorsClass.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImageCarousel(
              images: product.images,
              currentIndex: currentImageIndex,
              onPageChanged: (index) {
                setState(() {
                  currentImageIndex = index;
                });
              },
            ),
            ProductBriefInfo(product: product),
            SizedBox(height: 15,),
            ProductExpandableDetails(product: product),
            SizedBox(height: 15,),
            RelatedProducts(products: Product.relatedProducts),
          ],
        ),
      ),
    );
  }
}