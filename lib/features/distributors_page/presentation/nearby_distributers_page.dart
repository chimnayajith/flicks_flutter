import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toys_catalogue/features/distributors_page/domain/models/distributor.dart';
import 'package:toys_catalogue/features/distributors_page/presentation/widgets/distributor_card.dart';
import 'package:toys_catalogue/resources/screen_util.dart';
import 'package:toys_catalogue/resources/theme.dart';

class NearbyDistributorsPage extends StatefulWidget {
  const NearbyDistributorsPage({super.key});

  @override
  State<NearbyDistributorsPage> createState() => _NearbyDistributorsPageState();
}

class _NearbyDistributorsPageState extends State<NearbyDistributorsPage> {
  int _selectedFilterIndex = 0;
  final List<String> _filterOptions = ['Nearest', 'Rating', 'Popular'];

  List<Distributor> _getDistributors() {
    return List.generate(
      15,
      (index) => Distributor(
        name: 'Distributor ${index + 1}',
        location: 'Location ${index + 1}',
        imageUrl: 'placeholder_url',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final distributors = _getDistributors();

    return Scaffold(
      backgroundColor: ColorsClass.bg,
      appBar: AppBar(
        backgroundColor: ColorsClass.bg,
        elevation: 0,
        title: Text(
          'Nearby Distributors',
          style: TextStylesClass.h5.copyWith(
            color: ColorsClass.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: ColorsClass.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtils.w2(context),
            vertical: ScreenUtils.h2(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 48.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: ColorsClass.boxShadow,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search distributors',
                    hintStyle: TextStylesClass.p2.copyWith(
                      color: ColorsClass.lightTextGrey,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: ColorsClass.lightTextGrey,
                      size: 20.sp,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 14.h,
                      horizontal: 8.w,
                    ),
                  ),
                ),
              ),
              SizedBox(height: ScreenUtils.h2(context)),
              
              Row(
                children: [
                  Text(
                    'Filter by:',
                    style: TextStylesClass.p2.copyWith(
                      color: ColorsClass.textGrey1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          _filterOptions.length,
                          (index) => Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: _buildFilterChip(
                              _filterOptions[index],
                              index == _selectedFilterIndex,
                              () {
                                setState(() {
                                  _selectedFilterIndex = index;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ScreenUtils.h2(context)),
              
              Text(
                '${distributors.length} distributors found',
                style: TextStylesClass.p2.copyWith(
                  color: ColorsClass.textGrey2,
                ),
              ),
              SizedBox(height: ScreenUtils.h2(context)),
              Expanded(
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.h,
                      crossAxisSpacing: 16.w,
                      childAspectRatio: MediaQuery.of(context).size.width > 600 ? 1.0 : 0.75,
                    ),
                    itemCount: distributors.length,
                    itemBuilder: (context, index) {
                      return _buildDistributorCard(context, distributors[index]);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? ColorsClass.secondaryTheme : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? Colors.transparent : ColorsClass.lightmodeNeutral100,
          ),
        ),
        child: Text(
          label,
          style: TextStylesClass.p2.copyWith(
            color: isSelected ? Colors.white : ColorsClass.textGrey1,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDistributorCard(BuildContext context, Distributor distributor) {
    return Material(
      elevation: 2,
      shadowColor: ColorsClass.boxShadow,
      borderRadius: BorderRadius.circular(16.r),
      color: Colors.white,
      child: InkWell(
        onTap: () {
        },
        borderRadius: BorderRadius.circular(16.r),
        child: DistributorCard(distributor: distributor),
      ),
    );
  }
}