import 'package:flutter/material.dart';
import 'package:toys_catalogue/resources/theme.dart';

class DistributorCard extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;

  const DistributorCard({
    super.key,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ColorsClass.secondaryTheme,
            width: 1,
          ),
        ),
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
      ),
    );
  }
}