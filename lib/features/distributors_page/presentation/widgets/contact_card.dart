import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toys_catalogue/features/distributors_page/domain/models/contact_info.dart';
import 'package:toys_catalogue/resources/theme.dart';

class ContactCard extends StatelessWidget {
  final ContactInfo contactInfo;

  const ContactCard({super.key, required this.contactInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorsClass.secondaryTheme,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            contactInfo.name,
            style: TextStylesClass.s1.copyWith(color: ColorsClass.textGrey1),
          ),
          SizedBox(height: 8.h),
          Text(
            'Phone Number: ${contactInfo.phoneNumber}',
            style: TextStylesClass.p2.copyWith(color: ColorsClass.textGrey2),
          ),
          SizedBox(height: 4.h),
          Text(
            'Email: ${contactInfo.email}',
            style: TextStylesClass.p2.copyWith(color: ColorsClass.textGrey2),
          ),
          SizedBox(height: 4.h),
          Text(
            'Address: ${contactInfo.address}',
            style: TextStylesClass.p2.copyWith(color: ColorsClass.textGrey2),
          ),
        ],
      ),
    );
  }
}
