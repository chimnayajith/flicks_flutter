import 'package:flutter/material.dart';
import 'package:toys_catalogue/resources/theme.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
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
      );
  }
}
