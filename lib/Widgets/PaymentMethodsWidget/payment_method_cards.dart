import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/payment_controller.dart';
import '../../Controllers/products_controller.dart';
import '../../const/Sizes.dart';
import '../../const/colors.dart';
import '../../const/functions.dart';

class PaymentMethodeCard extends StatefulWidget {
  const PaymentMethodeCard(
      {super.key, required this.onTapFunction, required this.methodInfo});
  final Function onTapFunction;
  final Map methodInfo;

  @override
  State<PaymentMethodeCard> createState() => _PaymentMethodeCardState();
}

class _PaymentMethodeCardState extends State<PaymentMethodeCard> {
  bool isHovered = false;
  // HomeController homeController=Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentController>(builder: (cont) {
      return InkWell(
        onTap: () {
          widget.onTapFunction();
        },
        // onHover: (val) {
        //   if (val) {
        //     setState(() {
        //       isHovered = true;
        //     });
        //   } else {
        //     setState(() {
        //       isHovered = false;
        //     });
        //   }
        // },
        child:Column(
          children: [
            Container(
              width: 100,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
              decoration:
              //     ? BoxDecoration(
              //   borderRadius: BorderRadius.circular(0),
              //   color: Primary.primary.withAlpha((0.2 * 255).toInt()),
              //     border: Border(
              //             bottom: BorderSide(
              //               color: Others.divider,
              //             ),
              // ))
              //     :   BoxDecoration(
              //   border: Border(
              //           bottom: BorderSide(
              //             color: Others.divider,
              //           ),)
              // ),
              BoxDecoration(
                  color: '${widget.methodInfo['id']}' ==
                      cont.clickedPaymentMethodeId
                      ? Primary.primary.withAlpha((0.2 * 255).toInt())
                      : Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: Others.divider,
                    ),
                  )),
              child: Center(child: Text(widget.methodInfo['title'])),
            ),
          ],
        ),
      );
    });
  }
}

class SelectedPaymentMethodeCard extends StatelessWidget {
  const SelectedPaymentMethodeCard(
      {super.key,
        required this.onTapFunction,
        required this.methodInfo,
        required this.onRemoveFunction});
  final Function onTapFunction;
  final Function onRemoveFunction;
  final Map methodInfo;
  @override
  Widget build(BuildContext context) {
    ProductController productController=Get.find();
    return GetBuilder<PaymentController>(builder: (cont) {
      return InkWell(
        // onTap: () {
        //   onTapFunction();
        // },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(0),
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Others.divider,
                ),
              )),
          // : const BoxDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(methodInfo['title']),
              Row(
                children: [
                  Text(methodInfo['currency'] == productController.primaryCurrency
                      ? numberWithComma(
                      double.parse(methodInfo['price']).toStringAsFixed(2))
                      : numberWithComma(double.parse(methodInfo['price'])
                      .toStringAsFixed(2))),
                  // numberWithComma(cont.selectedMethodsList['${methodInfo['id']}']['price'])),
                  Text(' ${methodInfo['currency']}'),
                  gapW20,
                  InkWell(
                    onTap: () {
                      onRemoveFunction();
                      cont.calculateRemAndChange();
                    },
                    child: CircleAvatar(
                      backgroundColor: Primary.primary,
                      radius: 10,
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}