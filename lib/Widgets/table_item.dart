import 'package:flutter/material.dart';

import '../const/colors.dart';
class TableItem extends StatelessWidget {
  const TableItem(
      {super.key,
        required this.text,
        required this.width,
        this.isDesktop = true});
  final String text;
  final double width;
  final bool isDesktop;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Center(
        child: Text(text,
            style: TextStyle(
              fontSize: isDesktop ? 14 : 12,
              color: TypographyColor.textTable,
            )),
      ),
    );
  }
}