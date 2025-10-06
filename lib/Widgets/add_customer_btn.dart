import 'package:flutter/material.dart';

import '../const/Sizes.dart';


class AddCustomerBtn extends StatefulWidget {
  const AddCustomerBtn(
      {super.key,
        required this.onTapFunction,
        required this.text,
        required this.icon,
        required this.color,
        required this.textColor, required this.width});
  final Function onTapFunction;
  final String text;
  final IconData icon;
  final Color color;
  final Color textColor;
  final double width;
  @override
  State<AddCustomerBtn> createState() => _AddCustomerBtnState();
}

class _AddCustomerBtnState extends State<AddCustomerBtn> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTapFunction();
      },
      onHover: (val) {
        if (val) {
          setState(() {
            isHovered = true;
          });
        } else {
          setState(() {
            isHovered = false;
          });
        }
      },
      child: Container(
        width: widget.width,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
            color: widget.color,
            borderRadius: const BorderRadius.all(Radius.circular(20))
            // isHovered ? Primary.primary.withAlpha((0.2 * 255).toInt()) : Colors.white,
            // border: Border(
            //   bottom: BorderSide(
            //     color: Others.divider,
            //   ),
            // )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              // width: 20,
              child: Icon(widget.icon,size: 18,
                   color: widget.textColor // Colors.black87,
              ),
            ),
            gapW4,
            Flexible(
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: 13,
                  color: widget.textColor,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            )
          ],
        ),
      ),
    );
  }
}
