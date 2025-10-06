import 'package:flutter/material.dart';

class ReusableShowInfoCard extends StatelessWidget {
  const ReusableShowInfoCard({super.key, required this.text, required this.width});
  final String text;
  final double width;
  @override
  Widget build(BuildContext context) {
    return     Container(
      width: width,
      height: 47,
      decoration: BoxDecoration(
          border:
          Border.all(color: Colors.black.withAlpha((0.1 * 255).toInt()), width: 1),
          borderRadius: BorderRadius.circular(6)),
      child: Center(
          child: Text(
              text)),
    );
  }
}