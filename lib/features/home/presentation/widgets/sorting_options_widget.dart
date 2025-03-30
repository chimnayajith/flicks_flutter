import 'package:flutter/material.dart';
import 'package:toys_catalogue/features/home/data/product_service.dart';
import 'package:toys_catalogue/features/home/presentation/widgets/curated_products.dart';
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

  List<String> categoryOptions = [];
  bool _isLoadingCategories = true;
  String? _categoryError;

  // Gender options with image URLs
  final List<Map<String, String>> genderOptions = [
    {'label': 'All', 'imageUrl': 'https://flickscatalogue.s3.eu-north-1.amazonaws.com/assets/unisex.png'},
    {'label': 'Boys', 'imageUrl': 'https://flickscatalogue.s3.eu-north-1.amazonaws.com/assets/male.png'},
    {'label': 'Girls', 'imageUrl': 'https://flickscatalogue.s3.eu-north-1.amazonaws.com/assets/female.png'},
  ];

  final ProductService _productService = ProductService();

  final allProducts = List.generate(
    30, // Number of products to generate
    (index) => {
      'name': 'Product $index',
      'imageUrl': 'https://kidztribe.com/cdn/shop/files/${200 + index}.png', // Updated image URL
    },
  );

  @override
  void initState() {
    super.initState();
    _fetchCategories();
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

  Widget _buildGenderOption(String label, String imageUrl) {
    bool isSelected = selectedGender == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = label;
        });
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8), 
        decoration: BoxDecoration(
          color: isSelected 
            ? ColorsClass.secondaryTheme.withOpacity(0.2) 
            :Colors.transparent,
          borderRadius: BorderRadius.circular(15), // Larger border radius
          border: Border.all(
              color: ColorsClass.secondaryTheme,
              width: isSelected? 2: 1,
            ),
        ),
        child: Column(
          children: [
            Container(
              height: 60, // Slightly larger image container
              width: 60,
              decoration: BoxDecoration(
                color:Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Image.network(
                  imageUrl, 
                  fit: BoxFit.contain, 
                  height: 80, // Consistent image size
                  width: 80,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStylesClass.customize(
                TextStylesClass.s1,
                color: ColorsClass.secondaryTheme,
                fontWeight: isSelected 
                  ? FontWeight.bold 
                  : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildAgeOption(String ageRange, String unit) {
    bool isSelected = selectedAgeRange == ageRange;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAgeRange = ageRange;
        });
      },
      child: Container(
        width: 83,
        height: 54,
        decoration: BoxDecoration(
          border: Border.all(
            color: ColorsClass.secondaryTheme,
            width: isSelected? 2: 1,
          ),
          borderRadius: BorderRadius.circular(25),
          color: isSelected ? ColorsClass.secondaryTheme.withOpacity(0.2) : Colors.transparent,
        ),
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
          selectedCategory = category;
        });
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
              color: isSelected ? ColorsClass.secondaryTheme : Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 14
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gender Section
        _buildSectionHeader('Choose Gender'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: genderOptions.map((option) => 
              _buildGenderOption(option['label']!, option['imageUrl']!)
            ).toList(),
          ),
        ),

        // Age Section
        _buildSectionHeader('Choose Age'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 8,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildAgeOption('0-18', 'Months'),
              _buildAgeOption('18-36', 'Months'),
              _buildAgeOption('3-5', 'Years'),
              _buildAgeOption('5-7', 'Years'),
              _buildAgeOption('7-12', 'Years'),
              _buildAgeOption('12+', 'Years'),
            ],
          ),
        ),

        // Category Section
        _buildSectionHeader('Choose Category'),
        _buildCategorySection(),

        if (selectedGender != null || selectedAgeRange != null || selectedCategory != null)
          _buildSectionHeader('Curated Products'),
        if (selectedGender != null || selectedAgeRange != null || selectedCategory != null)
          CuratedProductsGrid(allProducts: allProducts, itemsPerPage: 10, scrollController: _scrollController)
      ],
    );
  }

  // Helper method to create section headers
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: TextStylesClass.h5,
      ),
    );
  }
}
