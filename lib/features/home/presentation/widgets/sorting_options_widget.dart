import 'package:flutter/material.dart';
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
  // Gender options with image URLs
  final List<Map<String, String>> genderOptions = [
    {'label': 'All', 'imageUrl': 'https://s3-alpha-sig.figma.com/img/c105/0881/d29596eedd32fd9fe24f3d68d1acfd61?Expires=1738540800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=Ys-E27UTIO8WT5wR3mrrJXFEN2ZwA37cBuzxRrkdix9H6b0RgWLCXuXIVN7-jlvAx6VdBwrZsuIqeSTdgx1-UPpiYboHcl597x-6ON6tnSEtZhL6ykczkMTCdnkniJW39DCgDY7LqGjUJqP75U6-TGcfIL3tYPa-sdww1iDmOv58CcwRIwBQvwmSdEJ2bIbIKwjHS4ivTyHT8vwhr4EARyTvkZAdL5gkapJafoEEOXn7-WjMoAmxD-mKAxxK1eJm7YRlGhELTmEhFTe7lvZQrILrSHPmkrlHq4VcgzUKTclyY51a8UjDI5pV82aT2PMeVVfuRghh4UmH95BP27Fccw__'},
    {'label': 'Boys', 'imageUrl': 'https://s3-alpha-sig.figma.com/img/3c04/3bba/258ca3787a633a06d09d878e9acfe1f1?Expires=1738540800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=AYnAqF31Ix9ryFwIj3n8F10PSmk0HSu5jlPj3dqNUhE2SoVDU2IU81vKVaZtHvifh2cO-XE6LVv5~URaecADcEmENgc0WFqkmNMD78ZktIt-f0AGVw4qUh3mtQ0DEv81yTsCDnFnRxyDnqTMd0us7aGA-g3DnspwdPbqmxFeIGJ9eln3VLOegu2-UZE94hAMqxs8KUQxE2bz~rvds9KNEb5mzoK1YyEfJ1HYoblpCHW9Axp7ri-Y5st5cVODFfEH1qbnrJvi7lCerndYEamumXfs8J2M3OaF8S51CPA89DqTBvZTjlpmebHcIO6xks1wpI~kmbuOyPMPfrweifyZDQ__'},
    {'label': 'Girls', 'imageUrl': 'https://s3-alpha-sig.figma.com/img/3d87/d672/caf6c488657e63e224a14652ee178489?Expires=1738540800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=aB8RCkS9J-HVPdVFes9pUm9mClMTYCcsOda9-OCULjNPR4YH73ToZ0bmR73uZ7fGH4i21i4~zU88-f-5dRuyg0zLb0LfMNQj92qqfAjLa3tQr7ab-FaNS9XASFasAqIrlk50Gh3fPHqBG6CcvnOhxLe3js~nmBXFtZm3BSUNKqKba4HcsKOVhx2cSWVSlI6f-b3qqP6ALKCu5ECtnN910lHkn0SYuhPBigx8sJTG71ACNiheYcb7ehan~y-vpoSOC~ldA6yLF~Lmpu~WEu7m2emzx4W8RLjsCqvwY7UpHnjA426ZXF5JYBLfwCgg2hWH5MevePBePsZZYRnEEAbABA__'},
  ];

  // Category options
  final List<String> categoryOptions = [
    'Puzzle',
    'Educational',
    'Creative',
    'Action',
    'Soft Toys',
    'Board Games',
    'Action Figures'
  ];
  final allProducts = List.generate(
      30, // You can change this number based on how many products you want to generate
      (index) => {
        'name': 'Product $index',
        'imageUrl': 'https://placehold.co/200x250.png', // Placeholder image URL
      },
    );
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
            width: isSelected? 2: 1,
            ),
          borderRadius: BorderRadius.circular(25),
          color: isSelected ? ColorsClass.secondaryTheme.withOpacity(0.2) : Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? ColorsClass.secondaryTheme : Colors.black,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: categoryOptions.map((category) => 
              _buildCategoryOption(category)
            ).toList(),
          ),
        ),

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
