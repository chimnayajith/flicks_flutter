import 'package:flutter/material.dart';
import 'package:toys_catalogue/features/home/data/product_service.dart';
import 'package:toys_catalogue/features/home/data/shop_service.dart';
import 'package:toys_catalogue/features/home/domain/models/product_model.dart';
import 'package:toys_catalogue/features/home/presentation/widgets/store_banner.dart';
import 'package:toys_catalogue/features/home/presentation/widgets/search_box.dart';
import 'package:toys_catalogue/features/home/presentation/widgets/sorting_options_widget.dart';
import 'package:toys_catalogue/features/home/presentation/widgets/top_products_widget.dart';
import 'package:toys_catalogue/features/home/presentation/widgets/trending_toys.dart';
import 'package:toys_catalogue/features/main/presentation/main_page.dart';
import 'package:toys_catalogue/resources/theme.dart';
import 'package:toys_catalogue/routes/route_names.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductService _productService = ProductService();
  final ShopService _shopService = ShopService();
  
  List<Product> trendingProducts = [];
  List<Product> topProducts = [];
  String? shopBannerUrl;
  String? shopName;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Fetch products and shop banner in parallel
      final results = await Future.wait([
        _productService.getTrendingProducts(),
        _productService.getTopProducts(),
        _shopService.getShopBanner(),
      ]);

      setState(() {
        trendingProducts = results[0] as List<Product>;
        topProducts = results[1] as List<Product>;
        
        // Handle shop banner
        final shopData = results[2] as Map<String, dynamic>;
        shopBannerUrl = shopData['banner_url'];
        shopName = shopData['shop_name'];
        
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load data. Please try again.';
        isLoading = false;
      });
    }
  }

  // Convert Product to the map format expected by widgets
  List<Map<String, String>> _convertProductsToMap(List<Product> products, String source) {
    print("Converting ${products.length} products to map for source: $source");
    
    return products.map((product) {
      final map = {
        'imageUrl': product.imageUrl ?? 'https://via.placeholder.com/100',
        'title': product.title,
        'id': product.id.toString(),
        'videoUrl': product.videoUrl ?? '',
        'source': source,
        'description': product.description ?? '',
      };
      print("Converted product: $map");
      return map;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
              icon: const Icon(
                Icons.menu, 
                color: ColorsClass.text,
                size: 32,
                ),
              onPressed: () {
                 Scaffold.of(context).openDrawer();
              },
            ),
        ),
        backgroundColor: ColorsClass.secondaryTheme,
        title: Row(
          children: [
            Expanded(child: SearchBox()),
          ],
        ),
      ),
      drawer: Drawer(
        // [Existing drawer code]
      ),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (shopBannerUrl != null)
                StoreBanner(imageUrl: shopBannerUrl!),
              
              if (shopBannerUrl == null)
                StoreBanner(
                  imageUrl: 'https://via.placeholder.com/1000x250?text=Welcome',
                ),

              // Loading state
              if (isLoading)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(
                      color: ColorsClass.secondaryTheme,
                    ),
                  ),
                ),

              // Error message
              if (errorMessage != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          errorMessage!,
                          style: TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _fetchData,
                          child: Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsClass.secondaryTheme,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Content when loaded
              if (!isLoading && errorMessage == null) ...[
                // Trending Toys Section
                TrendingToysSection(
                  trendingToys: _convertProductsToMap(trendingProducts,'trending'),
                ),
                
                // Top Products List
                TopProductsList(
                  topProducts: _convertProductsToMap(topProducts, 'top'),
                ),

                // Sorting section
                SortingOptionsWidget(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}