import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toys_catalogue/resources/theme.dart';

class MyRewardsPage extends StatelessWidget {
  const MyRewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsClass.primaryTheme,
      appBar: AppBar(
        title: Text("My Rewards", style: TextStylesClass.h4.copyWith(color: ColorsClass.black)),
        centerTitle: true,
        backgroundColor: ColorsClass.primaryTheme,
        elevation: 0,
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: ColorsClass.themeBlueGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Available Points",
                      style: TextStylesClass.s2.copyWith(color: ColorsClass.white),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "2,500",
                      style: TextStylesClass.h2.copyWith(color: ColorsClass.white),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildPointsSummaryItem("Points Earned", "3,200"),
                        _buildPointsSummaryItem("Points Used", "700"),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                "Available Rewards",
                style: TextStylesClass.h5.copyWith(color: ColorsClass.black),
              ),
              SizedBox(height: 16.h),
              _buildRewardsList(),
              
              SizedBox(height: 24.h),

              Text(
                "Rewards History",
                style: TextStylesClass.h5.copyWith(color: ColorsClass.black),
              ),
              SizedBox(height: 16.h),
              _buildRewardsHistory(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPointsSummaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStylesClass.caption.copyWith(color: ColorsClass.white),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStylesClass.s1.copyWith(color: ColorsClass.white),
        ),
      ],
    );
  }

  Widget _buildRewardsList() {
    return Column(
      children: [
        _buildRewardCard(
          "₹500 Off",
          "2000 points",
          "Valid on orders above ₹2500",
          0.7,
        ),
        SizedBox(height: 12.h),
        _buildRewardCard(
          "Free Delivery",
          "1000 points",
          "Valid on orders above ₹1000",
          0.4,
        ),
        SizedBox(height: 12.h),
        _buildRewardCard(
          "10% Cashback",
          "3000 points",
          "Maximum cashback ₹750",
          0.2,
        ),
      ],
    );
  }

  Widget _buildRewardCard(String title, String points, String description, double progress) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsClass.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorsClass.lightmodeNeutral100),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStylesClass.s1.copyWith(color: ColorsClass.black),
              ),
              Text(
                points,
                style: TextStylesClass.p2.copyWith(color: ColorsClass.secondaryTheme),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            description,
            style: TextStylesClass.caption.copyWith(color: ColorsClass.textGrey),
          ),
          SizedBox(height: 12.h),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: ColorsClass.lightmodeNeutral100,
            valueColor: const AlwaysStoppedAnimation<Color>(ColorsClass.secondaryTheme),
          ),
          SizedBox(height: 12.h),
          ElevatedButton(
            onPressed: progress >= 1 ? () {} : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsClass.secondaryTheme,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: Size(double.infinity, 40.h),
            ),
            child: Text(
              "Redeem",
              style: TextStylesClass.ctaS.copyWith(color: ColorsClass.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsHistory() {
    return Column(
      children: [
        _buildHistoryItem(
          "₹500 Off Coupon",
          "Redeemed on 15 Feb 2024",
          "-2000 points",
        ),
        _buildHistoryItem(
          "Order #12345",
          "Earned on 10 Feb 2024",
          "+500 points",
        ),
        _buildHistoryItem(
          "Free Delivery Coupon",
          "Redeemed on 5 Feb 2024",
          "-1000 points",
        ),
      ],
    );
  }

  Widget _buildHistoryItem(String title, String date, String points) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ColorsClass.lightmodeNeutral100),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStylesClass.p1.copyWith(color: ColorsClass.black),
              ),
              SizedBox(height: 4.h),
              Text(
                date,
                style: TextStylesClass.caption.copyWith(color: ColorsClass.textGrey),
              ),
            ],
          ),
          Text(
            points,
            style: TextStylesClass.p2.copyWith(
              color: points.startsWith('+') 
                  ? ColorsClass.themeGreen 
                  : ColorsClass.secondaryTheme,
            ),
          ),
        ],
      ),
    );
  }
}