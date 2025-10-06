

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Controllers/products_controller.dart';
import 'package:pos_project/Screens/Home/search_dialog.dart';
import 'package:pos_project/Widgets/reusable_btn.dart';
import '../../../const/Sizes.dart';
import '../../../const/colors.dart';
import '../../Widgets/reusable_text_field.dart';
import '../../const/functions.dart';


TextEditingController discountController = TextEditingController();
class AddCustomDiscountDialog extends StatefulWidget {
  const AddCustomDiscountDialog({super.key});

  @override
  State<AddCustomDiscountDialog> createState() =>
      _AddCustomDiscountDialogState();
}

class _AddCustomDiscountDialogState
    extends State<AddCustomDiscountDialog> {
  // List discountTypesList=[
  //   'complete',
  //   'complete',
  //   'complete',
  // ];
  ProductController productController = Get.find();
  @override
  Widget build(BuildContext context) {
    return  Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.7,
      // margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GetBuilder<ProductController>(
          builder: (controller) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DialogTitle(text: 'add_discount'.tr),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: CircleAvatar(
                        backgroundColor: Primary.primary,
                        radius: 15,
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    )
                  ],
                ),
                gapH32,
                ReusableInputNumberField(
                  controller: discountController,
                  textFieldWidth: MediaQuery.of(context).size.width * 0.15,
                  rowWidth:  MediaQuery.of(context).size.width * 0.25,
                  onChangedFunc: (value){
                    discountController.text=value;
                  },
                  validationFunc: (value){},
                  text: 'discount_value'.tr,),
                gapH20,
                ReusableButtonWithColor(
                    btnText: 'apply'.tr,
                    radius: 9,
                    onTapFunction: (){
                      // Get.back();
                      if (controller.isLineDiscountSelected) {
                        controller.orderItemsList[controller
                            .selectedOrderItemId]['discount_percent'] =
                            double.parse(discountController.text);
                        controller.orderItemsList[controller
                            .selectedOrderItemId]['discount_type_id'] = '0';
                        // double disAsDouble=double.parse('${Decimal.parse(discountController.text)/Decimal.parse('100')}');
                        var discountValue =
                            double.parse('${
                                controller.orderItemsList[controller
                                    .selectedOrderItemId]['price']}')
                                *
                                (double.parse(discountController.text) / 100.0);

                        controller.orderItemsList[controller
                            .selectedOrderItemId]['discount'] = discountValue;

                        controller.orderItemsList[controller
                            .selectedOrderItemId]['price']
                        = '${double.parse('${
                            controller.orderItemsList[controller
                                .selectedOrderItemId]['price']}') -
                            double.parse('$discountValue')}';

                        controller.orderItemsList[controller
                            .selectedOrderItemId]['final_price'] =
                            double.parse('${controller.orderItemsList[controller
                                .selectedOrderItemId]['price']}') *
                                double.parse(
                                    '${controller.orderItemsList[controller
                                        .selectedOrderItemId]['quantity']}');
                        controller.orderItemsList[controller.selectedOrderItemId]['price']=roundUp(controller.orderItemsList[controller.selectedOrderItemId]['price'], 2);
                        controller.orderItemsList[
                        controller.selectedOrderItemId]['final_price']=roundUp(controller.orderItemsList[
                        controller.selectedOrderItemId]['final_price'], 2);
                      }else{
                        controller.setSelectedDiscountTypeId('-2');
                        controller.setTotalDiscountAsPercent(
                            double.parse(discountController.text));
                      }controller.calculateSummary();
                      Get.back();
                      Get.back();

                },
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: 50)
              ],
            );
          }
      ),
    );
  }
}










