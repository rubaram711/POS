import 'package:flutter/material.dart';


class TableTitle extends StatelessWidget {
  const TableTitle({super.key, required this.text, required this.width});
  final String text;
  final double width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Center(
        child: Text(text,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

