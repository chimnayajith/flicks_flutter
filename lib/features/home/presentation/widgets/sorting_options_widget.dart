import 'package:flutter/material.dart';
import 'package:toys_catalogue/features/home/data/product_service.dart';
import 'package:toys_catalogue/features/home/domain/models/product_model.dart';
import 'package:toys_catalogue/resources/theme.dart';
import 'package:toys_catalogue/widgets/flick_card_widget.dart';

class SortingOptionsWidget extends StatefulWidget {
  const SortingOptionsWidget({Key? key}) : super(key: key);

  @override
  _SortingOptionsWidgetState createState() => _SortingOptionsWidgetState();
}

class _SortingOptionsWidgetState extends State<SortingOptionsWidget> {
  // State variables to track selections
  String? selectedGender;
  String? selectedAgeRange;
  String? selectedCategory;
  final ScrollController _scrollController = ScrollController();
  
  // Category options and loading states
  List<String> categoryOptions = [];
  bool _isLoadingCategories = true;
  String? _categoryError;
  
  // Age group options and loading states
  List<String> ageGroupOptions = [];
  bool _isLoadingAgeGroups = true;
  String? _ageGroupError;
  
  // Filtered products
  List<Product> _filteredProducts = [];
  bool _isLoadingProducts = false;
  String? _productsError;
  bool _hasAppliedFilters = false;  // Track if filters have been applied

  // Gender options with image URLs
  final List<Map<String, String>> genderOptions = [
    {'label': 'All', 'imageUrl': 'https://flickscatalogue.s3.eu-north-1.amazonaws.com/assets/unisex.png'},
    {'label': 'Boys', 'imageUrl': 'https://flickscatalogue.s3.eu-north-1.amazonaws.com/assets/male.png'},
    {'label': 'Girls', 'imageUrl': 'https://flickscatalogue.s3.eu-north-1.amazonaws.com/assets/female.png'},
  ];

  final ProductService _productService = ProductService();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchAgeGroups();
  }

  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchCategories() async {
    try {
      setState(() {
        _isLoadingCategories = true;
        _categoryError = null;
      });
      
      final categories = await _productService.getProductCategories();
      
      setState(() {
        categoryOptions = categories;
        _isLoadingCategories = false;
      });
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() {
        _categoryError = 'Failed to load categories';
        _isLoadingCategories = false;
      });
    }
  }

  Future<void> _fetchAgeGroups() async {
    try {
      setState(() {
        _isLoadingAgeGroups = true;
        _ageGroupError = null;
      });
      
      final ageGroups = await _productService.getAgeGroups();
      
      setState(() {
        ageGroupOptions = ageGroups;
        _isLoadingAgeGroups = false;
      });
    } catch (e) {
      print('Error fetching age groups: $e');
      setState(() {
        _ageGroupError = 'Failed to load age groups';
        _isLoadingAgeGroups = false;
      });
    }
  }
  
  // Apply the current filters and fetch filtered products
  Future<void> _applyFilters() async {
    try {
      setState(() {
        _isLoadingProducts = true;
        _productsError = null;
        _hasAppliedFilters = true;
      });
      
      // Get age group string from selected range
      String? ageGroup;
      if (selectedAgeRange != null && ageGroupOptions.isNotEmpty) {
        for (var group in ageGroupOptions) {
          if (group.contains(selectedAgeRange!)) {
            ageGroup = group;
            break;
          }
        }
      }
      
      // Fetch filtered products
      final products = await _productService.getFilteredProducts(
        gender: selectedGender,
        ageGroup: ageGroup,
        category: selectedCategory,
      );
      
      setState(() {
        _filteredProducts = products;
        _isLoadingProducts = false;
      });
      
      // Scroll to results after a short delay to allow the widget to rebuild
      if (products.isNotEmpty) {
        Future.delayed(Duration(milliseconds: 300), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent * 0.5,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    } catch (e) {
      print('Error applying filters: $e');
      setState(() {
        _productsError = 'Failed to apply filters';
        _isLoadingProducts = false;
      });
    }
  }

  Widget _buildGenderOption(String label, String imageUrl) {
    bool isSelected = selectedGender == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = isSelected ? null : label;
        });
        _applyFilters();
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: ColorsClass.secondaryTheme,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? ColorsClass.secondaryTheme.withOpacity(0.2) : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              imageUrl,
              height: 50,
              width: 50,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.broken_image, size: 50, color: isSelected ? ColorsClass.secondaryTheme : Colors.grey);
              },
            ),
            SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? ColorsClass.secondaryTheme : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, String> _parseAgeGroup(String ageGroup) {  
    String range;
    String unit;
    
    if (ageGroup.contains("Months")) {
      unit = "Months";
      range = ageGroup.replaceAll(" Months", "");
    } else if (ageGroup.contains("Years")) {
      unit = "Years";
      range = ageGroup.replaceAll(" Years", "");
    } else {
      final parts = ageGroup.split(" ");
      if (parts.length > 1) {
        range = parts[0];
        unit = parts.sublist(1).join(" ");
      } else {
        range = ageGroup;
        unit = "";
      }
    }
    
    return {
      'range': range.trim(),
      'unit': unit.trim()
    };
  }

  Widget _buildAgeOption(String ageRange, String unit) {
    bool isSelected = selectedAgeRange == ageRange;
    return GestureDetector(
      onTap: () {
        setState(() {
          // Toggle selection
          selectedAgeRange = isSelected ? null : ageRange;
        });
        _applyFilters();
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: ColorsClass.secondaryTheme,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? ColorsClass.secondaryTheme.withOpacity(0.2) : Colors.transparent,
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ageRange,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? ColorsClass.secondaryTheme : Colors.black,
              ),
            ),
            Text(
              unit,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.normal,
                color: isSelected ? ColorsClass.secondaryTheme : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryOption(String category) {
    bool isSelected = selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          // Toggle selection
          selectedCategory = isSelected ? null : category;
        });
        _applyFilters(); // Apply filters automatically
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: ColorsClass.secondaryTheme,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(25),
          color: isSelected ? ColorsClass.secondaryTheme.withOpacity(0.2) : Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Center(
          child: Text(
            category,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 24, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22, // Increased from 18
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    if (_isLoadingCategories) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CircularProgressIndicator(color: ColorsClass.secondaryTheme),
        ),
      );
    }
    
    if (_categoryError != null) {
      return Center(
        child: Column(
          children: [
            Text(_categoryError!, style: TextStyle(color: Colors.red)),
            TextButton(
              onPressed: _fetchCategories,
              child: Text('Try Again'),
            ),
          ],
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
            child: categoryOptions.isEmpty 
                ? Center(child: Text('No categories available'))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: categoryOptions.length,
                    itemBuilder: (context, index) {
                      final category = categoryOptions[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: _buildCategoryOption(category),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgeSection() {
    if (_isLoadingAgeGroups) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CircularProgressIndicator(color: ColorsClass.secondaryTheme),
        ),
      );
    }
    
    if (_ageGroupError != null) {
      return Center(
        child: Column(
          children: [
            Text(_ageGroupError!, style: TextStyle(color: Colors.red)),
            TextButton(
              onPressed: _fetchAgeGroups,
              child: Text('Try Again'),
            ),
          ],
        ),
      );
    }
    
    // If we have less than 6 items, display them all in one row
    if (ageGroupOptions.length <= 3) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ageGroupOptions.map((ageGroup) {
            final parsed = _parseAgeGroup(ageGroup);
            return _buildAgeOption(parsed['range']!, parsed['unit']!);
          }).toList(),
        ),
      );
    }
    
    // Otherwise, use a grid
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 8,
          childAspectRatio: 1.1,
        ),
        itemCount: ageGroupOptions.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final ageGroup = ageGroupOptions[index];
          final parsed = _parseAgeGroup(ageGroup);
          return _buildAgeOption(parsed['range']!, parsed['unit']!);
        },
      ),
    );
  }
  
  // Build the product grid - only shown after filters are applied
  Widget _buildProductsGrid() {
    if (!_hasAppliedFilters) {
      return SizedBox.shrink();
    }
    
    if (_isLoadingProducts) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: CircularProgressIndicator(color: ColorsClass.secondaryTheme),
        ),
      );
    }
    
    if (_productsError != null) {
      return Center(
        child: Column(
          children: [
            Text(_productsError!, style: TextStyle(color: Colors.red)),
            TextButton(
              onPressed: _applyFilters,
              child: Text('Try Again'),
            ),
          ],
        ),
      );
    }
    
    if (_filteredProducts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(Icons.search_off, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No products match your filters',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results Header
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 24, bottom: 16),
          child: Text(
            'Results (${_filteredProducts.length})',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // Products Grid
        GridView.builder(
          padding: const EdgeInsets.all(16.0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _filteredProducts.length,
          itemBuilder: (context, index) {
            final product = _filteredProducts[index];
            return FlickCard(
              imageUrl: product.imageUrl ?? 'https://via.placeholder.com/150',
              title: product.title,
              id: product.id.toString(),
              videoUrl: product.videoUrl,
              source: 'filtered',
              description: product.description,
            );
          },
        ),
      ],
    );
  }
  
 @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gender Selection
          _buildSectionHeader('Choose Gender'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: genderOptions.map((option) => 
                _buildGenderOption(option['label']!, option['imageUrl']!)
              ).toList(),
            ),
          ),
          
          // Age Selection
          _buildSectionHeader('Choose Age'),
          _buildAgeSection(),
          
          // Category Selection
          _buildSectionHeader('Choose Category'),
          _buildCategorySection(),
          
          // No Apply button anymore
          SizedBox(height: 20),
          
          // Products Grid - shown when any filter is applied
          _buildProductsGrid(),
          
          SizedBox(height: 40),
        ],
      ),
    );
  }
}