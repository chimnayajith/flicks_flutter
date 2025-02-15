import 'package:flutter/material.dart';
import 'package:toys_catalogue/resources/theme.dart';

class MyStaffPage extends StatelessWidget {
  const MyStaffPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsClass.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Staff',
                    style: TextStylesClass.h4.copyWith(
                      color: ColorsClass.text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '3/3',
                    style: TextStylesClass.s1.copyWith(
                      color: ColorsClass.secondaryTheme,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // Staff Avatars Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStaffMember('John Doe'),
                  _buildStaffMember('Jane Smith'),
                  _buildStaffMember('Mike Johnson'),
                ],
              ),
              
              const Spacer(),
              
              // Action Buttons
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsClass.secondaryTheme,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Edit Staff',
                        style: TextStylesClass.p1.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: ColorsClass.secondaryTheme),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Store Details',
                        style: TextStylesClass.p1.copyWith(
                          color: ColorsClass.secondaryTheme,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStaffMember(String name) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: ColorsClass.secondaryTheme.withOpacity(0.1),
              child: Icon(
                Icons.person,
                size: 40,
                color: ColorsClass.secondaryTheme,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: ColorsClass.secondaryTheme,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: TextStylesClass.p2.copyWith(
            color: ColorsClass.text,
          ),
        ),
      ],
    );
  }
}