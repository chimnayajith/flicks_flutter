import 'package:flutter/material.dart';
import 'package:toys_catalogue/features/home/data/product_service.dart';
import 'package:toys_catalogue/features/home/domain/models/product_model.dart';
import 'package:toys_catalogue/resources/theme.dart';
import 'package:toys_catalogue/routes/route_names.dart';
import 'dart:async'; 

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ProductService _productService = ProductService();
  List<Product> searchResults = [];
  bool isLoading = false;
  String? errorMessage;
  Timer? _debounce;
  

  static const int minSearchLength = 2; 
  static const int searchDelayMs = 500; 

  void _onSearchChanged(String query) {

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    if (query.length < minSearchLength) {
      setState(() {
        searchResults = [];
        errorMessage = null;
        isLoading = false;
      });
      return;
    }
    

    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    
    _debounce = Timer(Duration(milliseconds: searchDelayMs), () {
      _performSearch(query);
    });
  }

  void _performSearch(String query) async {
    if (query.isEmpty || query.length < minSearchLength) {
      setState(() {
        searchResults = [];
        errorMessage = null;
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final results = await _productService.searchProducts(query);
      setState(() {
        searchResults = results;
        isLoading = false;
      });
    } catch (e) {
      print('Search error: $e');
      setState(() {
        errorMessage = 'Failed to search products. Please try again.';
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsClass.primaryTheme,
      appBar: AppBar(
        backgroundColor: ColorsClass.secondaryTheme,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorsClass.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: TextStyle(color: ColorsClass.text),
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(color: ColorsClass.text.withOpacity(0.6)),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: ColorsClass.text),
              onPressed: () {
                _searchController.clear();
                _onSearchChanged('');
              },
            ),
          ),
          onChanged: _onSearchChanged, 
        ),
      ),
      body: Column(
        children: [
          if (_searchController.text.isNotEmpty && _searchController.text.length < minSearchLength)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Type at least $minSearchLength characters to search',
                style: TextStyle(color: ColorsClass.text.withOpacity(0.6)),
              ),
            ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                errorMessage!,
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          Expanded(
            child: searchResults.isEmpty
                ? Center(
                    child: Text(
                      _searchController.text.isEmpty
                          ? 'Search for products'
                          // : _searchController.text.length < minSearchLength
                          //     ? 'Type at least $minSearchLength characters to search'
                              : 'No results found',
                      style: TextStyle(color: ColorsClass.text),
                    ),
                  )
                : ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final product = searchResults[index];
                      return ListTile(
                        leading: product.imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  product.imageUrl!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 50,
                                      height: 50,
                                      color: Colors.grey[300],
                                      child: Icon(Icons.error),
                                    );
                                  },
                                ),
                              )
                            : Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey[300],
                              ),
                        title: Text(
                          product.title,
                          style: TextStyle(color: ColorsClass.text),
                        ),
                        subtitle: Text(
                          product.brand,
                          style: TextStyle(color: ColorsClass.text.withOpacity(0.7)),
                        ),
                        onTap: () {
                          // Navigate to product details page
                          Navigator.pushNamed(
                            context,
                            RouteNames.productDetailsPage,
                            arguments: {
                              'productId': product.id.toString(),
                              'source': 'search',
                              'heroTag': 'search_${product.id}',
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}