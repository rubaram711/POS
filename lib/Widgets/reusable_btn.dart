
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../const/colors.dart';

class ReusableButtonWithNoColor extends StatelessWidget {
  const ReusableButtonWithNoColor(
      {super.key, required this.btnText, required this.onTapFunction});
  final String btnText;
  final Function onTapFunction;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTapFunction();
      },
      child: Container(
        // padding: EdgeInsets.all(5),
        width: 100,
        height: 35,
        decoration: BoxDecoration(
          border: Border.all(
            color: Primary.p0,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            btnText,
            style: TextStyle(fontSize: 14, color: Primary.p0),
          ),
        ),
      ),
    );
  }
}



class ReusableButtonWithColor extends StatelessWidget {
  const ReusableButtonWithColor(
      {super.key, required this.btnText, required this.onTapFunction, required this.width, required this.height,this.radius=18,
        this.isDisable=false});
  final String btnText;
  final Function onTapFunction;
  final double width;
  final double height;
  final double radius;
  final bool isDisable;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTapFunction();
      },
      child: Container(
        // padding: EdgeInsets.all(5),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Primary.primary,
          border: Border.all(
            color: Primary.p0,
          ),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Center(
          child: Text(
            btnText,
            style: TextStyle( color: Primary.p0),
          ),
        ),
      ),
    );
  }
}

class ReusableButtonWithIcon extends StatelessWidget {
  const ReusableButtonWithIcon(
      {super.key, required this.btnText, required this.onTapFunction, required this.width, required this.height,this.radius=18, required this.childWidget, required this.isClicked});
  final String btnText;
  final Function onTapFunction;
  final double width;
  final double height;
  final double radius;
  final Widget childWidget;
  final bool isClicked;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTapFunction();
      },
      child: Container(
        // padding: EdgeInsets.all(5),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color:isClicked? Primary.primary.withAlpha((0.2 * 255).toInt()):Others.btnColor,
          border: Border.all(
            color: Primary.p0,
          ),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Center(
          child: childWidget
        ),
      ),
    );
  }
}



class ReusableBackBtn extends StatelessWidget {
  const ReusableBackBtn({super.key, this.radius=5, required this.func, required this.title});
  final double radius;
  final Function func;
  final String title;
  @override
  Widget build(BuildContext context) {
    return  ElevatedButton.icon(
      icon: const Icon(
        Icons.keyboard_double_arrow_left,
      ),
      label:   Text(title),
      onPressed: () {
        func();
      },
      style: ElevatedButton.styleFrom(
        shape:  RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}




class ReusableBuildTabChipItem extends StatelessWidget {
  const ReusableBuildTabChipItem({
    super.key,
    required this.name,
    required this.index,
    required this.function,
    required this.isClicked,
    this.isMobile=false,
  });
  final String name;
  final int index;
  final Function function;
  final bool isClicked;
  final bool isMobile;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: ClipPath(
        clipper: const ShapeBorderClipper(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(9),
              topRight: Radius.circular(9),
            ),
          ),
        ),
        child: Container(
          // width: MediaQuery.of(context).size.width * 0.09,
          // height: MediaQuery.of(context).size.height * 0.07,
          padding:   EdgeInsets.symmetric(horizontal: isMobile?5:50, vertical: 10),
          decoration: BoxDecoration(
            color: isClicked ? Primary.p20 : Colors.white,
            border:
            isClicked
                ? Border(top: BorderSide(color: Primary.primary, width: 3))
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha((0.5 * 255).toInt()),
                spreadRadius: 9,
                blurRadius: 9,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              name.tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Primary.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
