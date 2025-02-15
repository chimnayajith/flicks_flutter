import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toys_catalogue/resources/theme.dart';

class MyInventoryPage extends StatefulWidget {
  const MyInventoryPage({super.key});

  @override
  State<MyInventoryPage> createState() => _MyInventoryPageState();
}

class _MyInventoryPageState extends State<MyInventoryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsClass.primaryTheme,
      appBar: AppBar(
        title: Text("My Inventory", style: TextStylesClass.h4.copyWith(color: ColorsClass.black)),
        centerTitle: true,
        backgroundColor: ColorsClass.primaryTheme,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorsClass.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: ColorsClass.secondaryTheme),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          _buildTabs(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAllProductsTab(),
                _buildLowStockTab(),
                _buildOutOfStockTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsClass.secondaryTheme,
        onPressed: () {
        },
        child: const Icon(Icons.edit, color: ColorsClass.white),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: ColorsClass.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: ColorsClass.boxShadow.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: TextStylesClass.p2.copyWith(color: ColorsClass.lightTextGrey),
                prefixIcon: const Icon(Icons.search, color: ColorsClass.lightTextGrey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                'All',
                'Boys',
                'Girls',
              ].map((filter) => _buildFilterChip(filter)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filter) {
    final isSelected = _selectedFilter == filter;
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: ChoiceChip(
        label: Text(
          filter,
          style: TextStylesClass.p2.copyWith(
            color: isSelected ? ColorsClass.white : ColorsClass.textGrey,
          ),
        ),
        selected: isSelected,
        selectedColor: ColorsClass.secondaryTheme,
        backgroundColor: ColorsClass.white,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = filter;
          });
        },
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ColorsClass.lightmodeNeutral100),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: ColorsClass.secondaryTheme,
        unselectedLabelColor: ColorsClass.textGrey,
        indicatorColor: ColorsClass.secondaryTheme,
        labelStyle: TextStylesClass.p2,
        tabs: const [
          Tab(text: 'All Products'),
          Tab(text: 'Low Stock'),
          Tab(text: 'Out of Stock'),
        ],
      ),
    );
  }

  Widget _buildAllProductsTab() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: 10, 
      itemBuilder: (context, index) {
        return _buildProductCard();
      },
    );
  }

  Widget _buildLowStockTab() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _buildProductCard(isLowStock: true);
      },
    );
  }

  Widget _buildOutOfStockTab() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: 3, 
      itemBuilder: (context, index) {
        return _buildProductCard(isOutOfStock: true);
      },
    );
  }

  Widget _buildProductCard({bool isLowStock = false, bool isOutOfStock = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: ColorsClass.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorsClass.boxShadow.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: ColorsClass.lightmodeNeutral100,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.image,
                      size: 30.w,
                      color: ColorsClass.lightTextGrey,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product Name',
                        style: TextStylesClass.s2.copyWith(color: ColorsClass.black),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'SKU: PRD001',
                        style: TextStylesClass.caption.copyWith(color: ColorsClass.textGrey),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '₹999',
                            style: TextStylesClass.p1.copyWith(
                              color: ColorsClass.secondaryTheme,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _buildStockBadge(isLowStock, isOutOfStock),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  color: ColorsClass.textGrey,
                  onPressed: () {
                    _showProductOptions(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStockBadge(bool isLowStock, bool isOutOfStock) {
    Color backgroundColor;
    String text;
    if (isOutOfStock) {
      backgroundColor = ColorsClass.red.withOpacity(0.1);
      text = 'Out of Stock';
    } else if (isLowStock) {
      backgroundColor = ColorsClass.themeYellow.withOpacity(0.1);
      text = 'Low Stock';
    } else {
      backgroundColor = ColorsClass.themeGreen.withOpacity(0.1);
      text = 'In Stock';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStylesClass.caption.copyWith(
          color: isOutOfStock
              ? ColorsClass.red
              : isLowStock
                  ? ColorsClass.themeYellow
                  : ColorsClass.themeGreen,
        ),
      ),
    );
  }

  void _showProductOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildOptionItem(Icons.edit, 'Edit Product', () {
              Navigator.pop(context);

            }),
            _buildOptionItem(Icons.inventory, 'Update Stock', () {
              Navigator.pop(context);
            
            }),
            _buildOptionItem(Icons.delete_outline, 'Remove Product', () {
              Navigator.pop(context);
             
            }, isDestructive: true),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem(IconData icon, String label, VoidCallback onTap, {bool isDestructive = false}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? ColorsClass.red : ColorsClass.textGrey,
              size: 24.w,
            ),
            SizedBox(width: 16.w),
            Text(
              label,
              style: TextStylesClass.p1.copyWith(
                color: isDestructive ? ColorsClass.red : ColorsClass.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}