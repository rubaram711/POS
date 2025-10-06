import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/payment_controller.dart';
import '../../const/Sizes.dart';
import '../../const/colors.dart';

class ReusableCurrencyCard extends StatelessWidget {
  const ReusableCurrencyCard(
      {super.key, required this.onTapFunction, required this.text});
  final Function onTapFunction;
  final String text;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentController>(builder: (cont) {
      return InkWell(
          onTap: () {
            onTapFunction();
          },
          child: Container(
            height: Sizes.deviceHeight * 0.09,
            width: Sizes.deviceWidth * 0.06,
            decoration: BoxDecoration(
                color: cont.paymentCurrency == text
                    ? Primary.primary
                    : Colors.white,
                border: Border.all(
                  color: Others.divider,
                )),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                    color: cont.paymentCurrency == text
                        ? Colors.white
                        : Colors.black87),
              ),
            ),
          ));
    });
  }
}



class MobileReusableCurrencyCard extends StatelessWidget {
  const MobileReusableCurrencyCard(
      {super.key, required this.onTapFunction, required this.text});
  final Function onTapFunction;
  final String text;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentController>(builder: (cont) {
      return InkWell(
          onTap: () {
            onTapFunction();
          },
          child: Container(
            // height: Sizes.deviceHeight * 0.09,
            // width: Sizes.deviceWidth * 0.06,
            padding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
                color: cont.paymentCurrency == text
                    ? Primary.primary
                    : Colors.white,
                border: Border.all(
                  color: Others.divider,
                )),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                    color: cont.paymentCurrency == text
                        ? Colors.white
                        : Colors.black87),
              ),
            ),
          ));
    });
  }
}