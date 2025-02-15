import 'package:flutter/material.dart';
import 'package:toys_catalogue/resources/theme.dart';

class FeaturedBrandCard extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;

  const FeaturedBrandCard({
    super.key,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: ColorsClass.lightmodeNeutral100,
              child: Icon(
                Icons.image_not_supported,
                color: ColorsClass.lightmodeNeutral500,
              ),
            );
          },
        ),
      ),
    );
  }
}