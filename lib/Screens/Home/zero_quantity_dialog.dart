import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_project/Backend/ProductsBackend/check_if_can_sell_zero.dart';
import 'package:pos_project/Controllers/products_controller.dart';
import 'package:pos_project/Screens/Home/search_dialog.dart';
import 'package:pos_project/Widgets/reusable_btn.dart';
import '../../../const/Sizes.dart';
import '../../Controllers/payment_controller.dart';
import '../../Locale_Memory/save_user_info_locally.dart';
import '../../Widgets/custom_snak_bar.dart';
import '../../Widgets/loading_dialog.dart';
import 'home_content.dart';



class ZeroQuantityDialog extends StatefulWidget {
  const ZeroQuantityDialog({super.key, required this.product, required this.id, required this.isAlreadyAdded});
 final Map product;
 final String id;
 final bool isAlreadyAdded;
  @override
  State<ZeroQuantityDialog> createState() =>
      _ZeroQuantityDialogState();
}

class _ZeroQuantityDialogState extends State<ZeroQuantityDialog> {
  ProductController productController = Get.find();
  PaymentController paymentController = Get.find();

  @override
  Widget build(BuildContext context) {
    noteController.clear();
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.height * 0.25,
      // margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GetBuilder<ProductController>(builder: (proCont) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     InkWell(
            //       onTap: () {
            //         Get.back();
            //       },
            //       child: CircleAvatar(
            //         backgroundColor: Primary.primary,
            //         radius: 15,
            //         child: const Icon(
            //           Icons.close_rounded,
            //           color: Colors.white,
            //           size: 20,
            //         ),
            //       ),
            //     )
            //   ],
            // ),
            DialogTitle(text:'zero_quantity_message'.tr,),
            gapH32,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ReusableButtonWithColor(
                    btnText: 'continue'.tr,
                    radius: 9,
                    onTapFunction: () async {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => const AlertDialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(9)),
                                ),
                                elevation: 0,
                                content: LoadingDialog()));
                        var p = await checkIfCanSellZero();
                        Get.back();
                        if (p['success']==true) {
                          await saveIsAllowedToSellZeroLocally(true);
                          Get.back();
                          if(widget.isAlreadyAdded){
                            String id=widget.product['id'];
                            proCont.orderItemsList[id]['quantity'] =
                            '${double.parse(proCont.orderItemsList[id]['quantity']) + 1}';
                            proCont.orderItemsList[id]['final_price'] =
                                double.parse(proCont.orderItemsList[id]['price']) *
                                    double.parse(proCont.orderItemsList[id]['quantity']);
                        }else{
                            productController.addToOrderItemsList(
                                widget.id, widget.product);
                          }
                        productController.calculateSummary();
                          CommonWidgets.snackBar('success', p['message']);
                        } else {
                          await saveIsAllowedToSellZeroLocally(false);
                          await saveCantSellZeroMessageLocally(p['message']);
                          Get.back();
                          CommonWidgets.snackBar('error', p['message']);
                        }
                          proCont.setIsClickedPark(false);
                      // }
                    },
                    width: MediaQuery.of(context).size.width *0.08 ,
                    height: 50),
                ReusableButtonWithColor(
                    btnText: 'cancel'.tr,
                    radius: 9,
                    onTapFunction: () {
                      Get.back();
                    },
                    width: MediaQuery.of(context).size.width*0.08,
                    height: 50),
              ],
            ),
          ],
        );
      }),
    );
  }
}
