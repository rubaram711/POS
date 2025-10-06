import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Controllers/products_controller.dart';
import 'package:pos_project/Screens/Home/search_dialog.dart';
import '../../../const/Sizes.dart';
import '../../../const/colors.dart';
import '../../Widgets/reusable_btn.dart';
import '../../const/functions.dart';
import 'add_custom_discount_dialog.dart';

class AddDiscountToOrderItemDialog extends StatefulWidget {
  const AddDiscountToOrderItemDialog({super.key});

  @override
  State<AddDiscountToOrderItemDialog> createState() =>
      _AddDiscountToOrderItemDialogState();
}

class _AddDiscountToOrderItemDialogState
    extends State<AddDiscountToOrderItemDialog> {
  ProductController productController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GetBuilder<ProductController>(builder: (controller) {
        // print(controller.orderItemsList[controller.selectedOrderItemId]['discount']);
        // print(controller.isLineDiscountSelected);
        // print(controller.isLineDiscountSelected && double.parse('${controller.orderItemsList[controller.selectedOrderItemId]['discount']}')!=0.0);

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
            Expanded(
                child: ListView.builder(
                    itemCount: controller.discountTypesList.length,
                    itemBuilder: (context, index) =>
                        // !controller.isLineDiscountSelected &&
                        //         controller.discountTypesList[index]['type'] ==
                        //             'custom discount'
                        //     ? const SizedBox()
                        //     :
                        DiscountTypeCard(
                                info: controller.discountTypesList[index],
                              ))),
            gapH20,
            controller.totalDiscountAsPercent !=0 && !controller.isLineDiscountSelected?
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                gapH20,
                Center(
                  child: ReusableButtonWithColor(
                      btnText: 'clear_discount'.tr,
                      radius: 9,
                      onTapFunction: (){
                        controller.setSelectedDiscountTypeId('0');
                        controller.setTotalDiscountAsPercent(0);
                        controller.setTotalDiscount(0);
                        controller.calculateSummary();
                        Get.back();
                      },
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: 50),
                ),
              ],
            ):const SizedBox(),
            controller.isLineDiscountSelected && double.parse('${controller.orderItemsList[controller.selectedOrderItemId]['discount']}')!=0.0?
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                gapH20,
                Center(
                  child: ReusableButtonWithColor(
                      btnText: 'clear_discount'.tr,
                      radius: 9,
                      onTapFunction: (){
                        var discountValue= controller.orderItemsList[controller.selectedOrderItemId]['discount'];

                        controller.orderItemsList[controller.selectedOrderItemId]['price']
                        ='${double.parse('${
                            controller.orderItemsList[controller
                                .selectedOrderItemId]['price']}')+double.parse('$discountValue')}';

                        controller.orderItemsList[controller.selectedOrderItemId]['final_price'] =
                            double.parse('${controller.orderItemsList[controller.selectedOrderItemId]['price']}') *
                                double.parse('${controller.orderItemsList[controller.selectedOrderItemId]['quantity']}');

                        controller.orderItemsList[controller.selectedOrderItemId]['discount']=0;
                        controller.orderItemsList[controller.selectedOrderItemId]['discount_percent']=0;

                        controller.orderItemsList[controller.selectedOrderItemId]['price']=roundUp(controller.orderItemsList[controller.selectedOrderItemId]['price'], 2);
                        controller.orderItemsList[
                        controller.selectedOrderItemId]['final_price']=roundUp(controller.orderItemsList[
                        controller.selectedOrderItemId]['final_price'], 2);
                        controller.calculateSummary();
                        Get.back();
                      },
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: 50),
                ),
              ],
            ):const SizedBox()
          ],
        );
      }),
    );
  }
}

class DiscountTypeCard extends StatefulWidget {
  const DiscountTypeCard({super.key, required this.info});
  final Map info;

  @override
  State<DiscountTypeCard> createState() => _DiscountTypeCardState();
}

class _DiscountTypeCardState extends State<DiscountTypeCard> {
  ProductController productController = Get.find();
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (controller) {
      return InkWell(
          onHover: (val) {
            setState(() {
              isHovered = val;
            });
          },
          onTap: () {
            Get.back();
            // print('type ${widget.info['type']}');
            // print('type ${widget.info['type']== 'custom discount'}');
            // print('type ${controller.isLineDiscountSelected}');
            if (controller.isLineDiscountSelected) {
              controller.setSelectedLineDiscountTypeId('${widget.info['id']}');
              if (widget.info['type'] == 'custom discount') {
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => const AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(9)),
                        ),
                        elevation: 0,
                        content: AddCustomDiscountDialog()));
              }
              else{
                controller.orderItemsList[controller.selectedOrderItemId]['discount_percent']=widget.info['float_discount_value'];
                controller.orderItemsList[controller.selectedOrderItemId]['discount_type_id']='${widget.info['id']}';

                var discountValue=
                    double.parse('${controller.orderItemsList[controller.selectedOrderItemId]['price']}')
                    *(widget.info['float_discount_value']/100.0);
                controller.orderItemsList[controller.selectedOrderItemId]['discount']=discountValue;

                controller.orderItemsList[controller.selectedOrderItemId]['price']
                ='${double.parse('${
                  controller.orderItemsList[controller
                      .selectedOrderItemId]['price']}')-double.parse('$discountValue')}';

                controller.orderItemsList[controller.selectedOrderItemId]['final_price'] =
                    double.parse('${controller.orderItemsList[controller.selectedOrderItemId]['price']}') *
                        double.parse('${controller.orderItemsList[controller.selectedOrderItemId]['quantity']}');

                controller.calculateSummary();
                Get.back();
              }
            } else {
              if(controller.orderItemsList.isNotEmpty){
                controller.setSelectedDiscountTypeId('${widget.info['id']}');
                if (widget.info['type'] == 'custom discount') {
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => const AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(9)),
                          ),
                          elevation: 0,
                          content: AddCustomDiscountDialog()));
                }else{
                controller.setTotalDiscountAsPercent(
                    double.parse('${widget.info['float_discount_value']}'));
                controller.calculateSummary();
              Get.back();}
              }
            }

          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            padding: const EdgeInsets.symmetric( horizontal: 20),
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: isHovered ? Primary.primary : Colors.grey[500]),
            child: Center(
              child: Text(
                widget.info['type'],
                style: TextStyle(
                    color: isHovered ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ));
    });
  }
}
