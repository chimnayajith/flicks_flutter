import 'package:flutter/material.dart';
import 'package:toys_catalogue/resources/theme.dart';
import 'package:toys_catalogue/routes/route_names.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RouteNames.searchPage);
      },
      child: AbsorbPointer(
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(color: ColorsClass.text),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: ColorsClass.primaryTheme,
            suffixIcon: Icon(Icons.search, color: ColorsClass.text),
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          ),
        ),
      ),
    );
  }
}