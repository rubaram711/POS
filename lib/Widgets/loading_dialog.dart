

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Controllers/products_controller.dart';
import 'package:pos_project/const/Sizes.dart';



class LoadingDialog extends StatefulWidget {
  const LoadingDialog({super.key});

  @override
  State<LoadingDialog> createState() =>
      _LoadingDialogState();
}

class _LoadingDialogState
    extends State<LoadingDialog> {
  ProductController productController = Get.find();
  @override
  Widget build(BuildContext context) {
    return  Container(
      color: Colors.white,
      width: 50,
      height: 100,
      // margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          gapH20,
          Text('wait'.tr),
        ],
      ),
    );
  }
}










