import 'package:flutter/material.dart';
import 'package:toys_catalogue/resources/screen_util.dart';
import 'package:toys_catalogue/resources/theme.dart';

class ExpandableSection extends StatefulWidget {
  final String title;
  final Widget content;

  const ExpandableSection({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  State<ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Padding(
            padding: EdgeInsets.all(ScreenUtils.w1(context)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStylesClass.h5,
                ),
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: ColorsClass.textGrey,
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtils.w1(context),
              vertical: ScreenUtils.h1(context),
            ),
            child: widget.content,
          ),
        const Divider(),
      ],
    );
  }
}